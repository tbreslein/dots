local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
    -- "mrcjkb/rustaceanvim",
  },
}

function M.config()
  local dap, dapui = require "dap", require "dapui"
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
  -- local dap = require('dap')
  dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
      -- CHANGE THIS to your path!
      command = "codelldb",
      args = { "--port", "${port}" },

      -- On windows you may have to uncomment this:
      -- detached = false,
    },
  }
  dap.configurations.cpp = {
    {
      name = "Launch file",
      type = "codelldb",
      request = "launch",
      program = function()
        return vim.fn.input(
          "Path to executable: ",
          vim.fn.getcwd() .. "/",
          "file"
        )
      end,
      cwd = "${workspaceFolder}",
      stopOnEntry = false,
    },
  }
  dap.configurations.c = dap.configurations.cpp
  dap.configurations.rust = dap.configurations.cpp

  -- dap.adapters.codelldb = {
  --   type = "server",
  --   port = "13000",
  --   host = "127.0.0.1",
  --   executable = {
  --     -- command = "$HOME/.local/share/nvim/mason/bin/codelldb",
  --     command = "codelldb",
  --     args = { "--port", "13000" },
  --   },
  -- }
  -- dap.configurations.rust = {
  --   {
  --     name = "Launch",
  --     type = "codelldb",
  --     request = "launch",
  --     program = function()
  --       return vim.fn.input(
  --         "Path to executable: ",
  --         vim.fn.getcwd() .. "/target/debug/",
  --         "file"
  --       )
  --     end,
  --     cwd = "${workspaceFolder}",
  --     stopOnEntry = false,
  --   },
  -- }
  require("nvim-dap-virtual-text").setup()

  kmap("n", "<leader>b", dap.toggle_breakpoint)
  kmap("n", "<leader>gb", dap.run_to_cursor)
  kmap("n", "<F1>", dap.continue)
  kmap("n", "<F2>", dap.step_into)
  kmap("n", "<F3>", dap.step_over)
  kmap("n", "<F4>", dap.step_out)
  kmap("n", "<F5>", dap.step_back)
  kmap("n", "<F6>", dap.restart)
end

return M
