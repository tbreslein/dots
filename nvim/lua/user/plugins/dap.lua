local M = {
  "rcarriga/nvim-dap-ui",
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "theHamsta/nvim-dap-virtual-text",
    "mfussenegger/nvim-dap-python",
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
