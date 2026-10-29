# image-minify.yazi

English | [中文](./README_ZH.md)

A [Yazi](https://github.com/sxyazi/yazi) plugin for compressing and resizing images.

## Dependencies

- [ImageMagick](https://imagemagick.org/)

## Features

- Compress the currently selected image.
- Compress all images in the current directory.
- Resize the selected image to a specified percentage (50%, 60%, 70%, 80%, 90%).

## Installation

```sh
ya pkg add hughfenghen/image-minify
```

## Configuration

Add the following to your `keymap.toml` file:

```toml
[[mgr.prepend_keymap]]
on = [ "i", "i" ] 
run = "plugin image-minify -- compress_current" 
desc = "Compress image" 

[[mgr.prepend_keymap]]
on = [ "i", "d" ] 
run = "plugin image-minify -- compress_directory" 
desc = "Compress all images in the current directory" 

[[mgr.prepend_keymap]]
on = [ "i", "r", "5" ] 
run = "plugin image-minify -- resize 5" 
desc = "Resize image to 50%"

[[mgr.prepend_keymap]]
on = [ "i", "r", "6" ] 
run = "plugin image-minify -- resize 6" 
desc = "Resize image to 60%"

[[mgr.prepend_keymap]]
on = [ "i", "r", "7" ] 
run = "plugin image-minify -- resize 7" 
desc = "Resize image to 70%"

[[mgr.prepend_keymap]]
on = [ "i", "r", "8" ] 
run = "plugin image-minify -- resize 8" 
desc = "Resize image to 80%" 

[[mgr.prepend_keymap]]
on = [ "i", "r", "9" ] 
run = "plugin image-minify -- resize 9" 
desc = "Resize image to 90%"
```
