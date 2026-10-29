-- @since 25.4.8
-- Image compression plugin for Yazi
-- Provides compression and resizing functionality using ImageMagick

-- Supported image formats
local SUPPORTED_FORMATS = {
	jpg = true,
	jpeg = true,
	png = true,
	bmp = true,
	tiff = true,
	webp = true,
}

local get_target_files = ya.sync(function()
	local tab = cx.active
	local files = {}
	if #tab.selected > 0 then
		ya.dbg("get_target_files: processing " .. #tab.selected .. " selected files")
		for _, u in pairs(tab.selected) do
			local path = tostring(u)
			local name = path:match("([^/]+)$")
			ya.dbg("get_target_files: selected file url: " .. path .. ", name: " .. name)
			table.insert(files, { url = path, name = name })
		end
	elseif tab.current.hovered then
		local path = tostring(tab.current.hovered.url)
		local name = tab.current.hovered.name
		ya.dbg("get_target_files: processing hovered file: " .. path .. ", name: " .. name)
		table.insert(files, {
			url = path,
			name = name,
		})
	end
	return files
end)

-- Check if the file is a supported image format
function is_image_file(filename)
	local ext = filename:match("%.([^%.]+)$")
	if ext then
		return SUPPORTED_FORMATS[ext:lower()]
	end
	return false
end

-- Get all image files
function get_image_files(dir_url)
	ya.dbg("get_image_files: Scanning directory: ", tostring(dir_url))
	local images = {}
	local files, err = fs.read_dir(dir_url, {})

	if err then
		ya.err("get_image_files: Error reading directory: " .. tostring(err))
		ya.notify({ title = "Error", content = "Failed to read directory contents.", timeout = 3, level = "error" })
		return images -- Return empty table
	end

	if files then
		for _, item in ipairs(files) do
			if not item.is_dir and is_image_file(item.name) then
				ya.dbg("get_image_files: Found image: ", tostring(item.url))
				table.insert(images, tostring(item.url))
			end
		end
	end

	ya.dbg("get_image_files: Found total ", #images, " images.")
	return images
end

-- Losslessly compress a single file
function compress_file(filepath)
	ya.dbg("compress_file: Starting for ", filepath)
	local ext = filepath:match("%.([^%.]+)$"):lower()
	local cmd

	if ext == "png" then
		ya.dbg("compress_file: PNG detected")
		cmd = Command("magick"):arg(filepath):arg("-strip"):arg("-define"):arg("png:compression-level=9"):arg(filepath)
	else
		ya.dbg("compress_file: Other image detected")
		cmd = Command("magick")
			:arg(filepath)
			:arg("-strip")
			:arg("-quality")
			:arg("90")
			:arg("-define")
			:arg("jpeg:optimize-coding=true")
			:arg(filepath)
	end

	ya.dbg("compress_file: Executing command")
	local output = cmd:output()

	if not output or not output.status then
		ya.err("compress_file: Command failed to produce output or status.")
		return false
	end

	ya.dbg("compress_file: Command finished. Exit code: ", output.status.code)
	if output.stdout and #output.stdout > 0 then
		ya.dbg("compress_file: stdout: ", output.stdout)
	end
	if output.stderr and #output.stderr > 0 then
		ya.err("compress_file: stderr: ", output.stderr)
	end

	return output.status.success
end

-- Adjust image resolution
function resize_file(filepath, ratio)
	ya.dbg("resize_file: Starting for ", filepath, " with ratio ", ratio)
	local percentage = ratio * 100
	local cmd = Command("magick")
		:arg(filepath)
		:arg("-filter")
		:arg("Lanczos")
		:arg("-resize")
		:arg(percentage .. "%%")
		:arg("-unsharp")
		:arg("0x0.75+0.75+0.008")
		:arg(filepath)

	ya.dbg("resize_file: Executing command")
	local output = cmd:output()

	if not output or not output.status then
		ya.err("resize_file: Command failed to produce output or status.")
		return false
	end

	ya.dbg("resize_file: Command finished. Exit code: ", output.status.code)
	if output.stdout and #output.stdout > 0 then
		ya.dbg("resize_file: stdout: ", output.stdout)
	end
	if output.stderr and #output.stderr > 0 then
		ya.err("resize_file: stderr: ", output.stderr)
	end

	return output.status.success
end

-- Compress currently selected files
function compress_current()
	ya.dbg("compress_current: Function called")
	local files = get_target_files()

	if #files == 0 then
		ya.err("compress_current: No files selected")
		ya.notify({ title = "Image Compress", content = "No file selected", timeout = 3, level = "warn" })
		return
	end

	ya.notify({
		title = "Image Compress",
		content = string.format("Start compressing %d image files...", #files),
		timeout = 2,
	})

	local success_count = 0
	local failed_count = 0
	local non_image_count = 0

	for _, file in ipairs(files) do
		local filepath = file.url
		local filename = file.name
		ya.dbg("compress_current: Processing file: ", filepath)

		if is_image_file(filename) then
			if compress_file(filepath) then
				success_count = success_count + 1
			else
				failed_count = failed_count + 1
			end
		else
			ya.err("compress_current: Not a supported image file: ", filename)
			non_image_count = non_image_count + 1
		end
	end

	local content
	if success_count > 0 and failed_count == 0 and non_image_count == 0 then
		content = string.format("Successfully compressed %d files", success_count)
	else
		content = string.format(
			"Compression finished: %d successful, %d failed, %d non-images",
			success_count,
			failed_count,
			non_image_count
		)
	end

	ya.dbg(
		"compress_current: Finished. Success: ",
		success_count,
		", Failed: ",
		failed_count,
		", Non-image: ",
		non_image_count
	)
	ya.notify({
		title = "Image Compress",
		content = content,
		timeout = 5,
		level = success_count > 0 and "info" or "warn",
	})

	if success_count > 0 then
		ya.manager_emit("refresh", {})
	end
end

local get_current_dir = ya.sync(function()
	return cx.active.current.cwd
end)

-- Compress all images in the current directory
function compress_directory()
	ya.dbg("compress_directory: Function called")
	local dir_url = get_current_dir()

	if not dir_url then
		ya.err("compress_directory: Cannot get current tab")
		ya.notify({
			title = "Image Compress",
			content = "Unable to get current directory",
			timeout = 3,
			level = "warn",
		})
		return
	end

	ya.dbg("compress_directory: Directory: ", tostring(dir_url))
	local images = get_image_files(dir_url)

	if #images == 0 then
		ya.err("compress_directory: No supported images found in the directory")
		ya.notify({
			title = "Image Compress",
			content = "No supported image files in the current directory",
			timeout = 3,
			level = "warn",
		})
		return
	end

	ya.notify({
		title = "Image Compress",
		content = string.format("Start compressing %d image files...", #images),
		timeout = 2,
	})

	local success_count = 0
	local failed_count = 0

	for i, filepath in ipairs(images) do
		ya.dbg("compress_directory: Compressing file ", i, "/", #images, ": ", filepath)
		if compress_file(filepath) then
			success_count = success_count + 1
		else
			failed_count = failed_count + 1
		end
	end

	ya.dbg("compress_directory: Finished. Success: ", success_count, ", Failed: ", failed_count)
	ya.notify({
		title = "Image Compress",
		content = string.format("Compression finished: %d successful, %d failed", success_count, failed_count),
		timeout = 5,
		level = success_count > 0 and "info" or "error",
	})

	-- Refresh the current directory
	ya.manager_emit("refresh", {})
end

-- Adjust image resolution - show selection menu
function resize_images()
	ya.dbg("resize_images: Function called")
	local choice, event = ya.input({
		title = "Select scaling ratio (1:30%, 2:50%, 3:75%, 4:80%, 5:90%):",
		value = "",
		position = { "center", w = 60 },
		cursor = "end",
	})

	if event == 1 then -- Enter pressed
		ya.dbg("resize_images: User entered: ", choice)
		local num = tonumber(choice)
		local ratios = { 0.3, 0.5, 0.75, 0.8, 0.9 }
		local labels = { "30%", "50%", "75%", "80%", "90%" }

		if num and num >= 1 and num <= 5 then
			ya.dbg("resize_images: Applying ratio: ", ratios[num])
			ya.notify({
				title = "Image Resize",
				content = "Selected scaling ratio: " .. labels[num],
				timeout = 2,
			})
			apply_resize(ratios[num])
		else
			ya.err("resize_images: Invalid choice: ", choice)
			ya.notify({
				title = "Image Resize",
				content = "Invalid selection, please enter a number from 1-5",
				timeout = 3,
				level = "warn",
			})
		end
	else
		ya.dbg("resize_images: Input cancelled")
	end
end

-- Apply scaling
function apply_resize(ratio)
	ya.dbg("apply_resize: Function called with ratio: ", ratio)
	local files = get_target_files()

	if #files == 0 then
		ya.err("apply_resize: No files selected")
		ya.notify({ title = "Image Resize", content = "No file selected", timeout = 3, level = "warn" })
		return
	end

	ya.notify({
		title = "Image Resize",
		content = string.format("Start resizing %d images (%.0f%%)...", #files, ratio * 100),
		timeout = 2,
	})

	local success_count = 0
	local failed_count = 0
	local non_image_count = 0

	for _, file in ipairs(files) do
		local filepath = file.url
		local filename = file.name
		ya.dbg("apply_resize: Resizing file: ", filepath)

		if is_image_file(filename) then
			if resize_file(filepath, ratio) then
				success_count = success_count + 1
			else
				failed_count = failed_count + 1
			end
		else
			ya.err("apply_resize: Not a supported image file: ", filename)
			non_image_count = non_image_count + 1
		end
	end

	local content
	if success_count > 0 and failed_count == 0 and non_image_count == 0 then
		content = string.format("Successfully resized %d files", success_count)
	else
		content = string.format(
			"Resizing finished: %d successful, %d failed, %d non-images",
			success_count,
			failed_count,
			non_image_count
		)
	end

	ya.dbg(
		"apply_resize: Finished. Success: ",
		success_count,
		", Failed: ",
		failed_count,
		", Non-image: ",
		non_image_count
	)
	ya.notify({
		title = "Image Resize",
		content = content,
		timeout = 5,
		level = success_count > 0 and "info" or "warn",
	})

	if success_count > 0 then
		ya.manager_emit("refresh", {})
	end
end

-- Plugin entry
return {
	entry = function(self, job)
		local args = job.args
		-- ya = yazi
		local method = args[1] or "compress_current"
		ya.dbg("Plugin entry: method=", tostring(method))

		if method == "compress_current" then
			compress_current()
		elseif method == "compress_directory" then
			compress_directory()
		elseif method == "resize_images" then
			resize_images()
		elseif method == "resize" then
			local choice = tonumber(args[2])
			if choice and choice >= 1 and choice <= 9 then
				local ratio = choice / 10.0
				ya.dbg("Plugin entry: resize with ratio=", tostring(ratio))
				apply_resize(ratio)
			else
				ya.err("resize: Invalid ratio provided. Must be 1-9. Got: ", tostring(choice))
				ya.notify({
					title = "Image Resize",
					content = "Invalid scaling ratio, please provide a number from 1-9",
					timeout = 3,
					level = "warn",
				})
			end
		elseif method == "apply_resize" then
			local ratio = tonumber(args[2]) or 0.5
			ya.dbg("Plugin entry: apply_resize with ratio=", tostring(ratio))
			apply_resize(ratio)
		end
	end,
}
