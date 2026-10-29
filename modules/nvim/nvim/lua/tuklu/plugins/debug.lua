return {
  "rcarriga/nvim-dap-ui",
  lazy = false,
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

    dapui.setup({
      icons = {
        expanded = "v",
        collapsed = ">",
        current_frame = ">",
      },
    })

    dap.adapters.codelldb = {
      type = "executable",
      command = mason_bin .. "/codelldb",
    }

    dap.adapters.delve = {
      type = "server",
      port = "${port}",
      executable = {
        command = mason_bin .. "/dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    dap.adapters.python = {
      type = "executable",
      command = mason_bin .. "/debugpy-adapter",
    }

    local executable = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end

    local codelldb_config = {
      {
        name = "Launch executable",
        type = "codelldb",
        request = "launch",
        program = executable,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
      },
    }

    dap.configurations.c = codelldb_config
    dap.configurations.cpp = codelldb_config
    dap.configurations.rust = codelldb_config
    dap.configurations.go = {
      {
        name = "Debug package",
        type = "delve",
        request = "launch",
        mode = "debug",
        program = "${fileDirname}",
      },
    }
    dap.configurations.python = {
      {
        name = "Debug current file",
        type = "python",
        request = "launch",
        program = "${file}",
        python = function()
          local project_python = vim.fn.getcwd() .. "/.venv/bin/python"
          local python = vim.fn.executable(project_python) == 1 and project_python
            or vim.fn.exepath("python")
          return { python }
        end,
      },
    }

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapStopped", { text = ">", texthl = "DiagnosticWarn" })

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { desc = desc })
    end

    map("<F5>", dap.continue, "Debug: continue")
    map("<F10>", dap.step_over, "Debug: step over")
    map("<F11>", dap.step_into, "Debug: step into")
    map("<F12>", dap.step_out, "Debug: step out")
    map("<leader>db", dap.toggle_breakpoint, "Debug: toggle breakpoint")
    map("<leader>dB", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, "Debug: set conditional breakpoint")
    map("<leader>du", dapui.toggle, "Debug: toggle UI")
    map("<leader>dr", dap.repl.toggle, "Debug: toggle REPL")
    map("<leader>dx", dap.terminate, "Debug: terminate session")
    map("<leader>dl", dap.run_last, "Debug: rerun last session")
  end,
}
