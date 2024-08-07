add {
  source = "rcarriga/nvim-dap-ui",
  depends = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
    "leoluz/nvim-dap-go",
  },
}
local dap, dapui = require "dap", require "dapui"

dapui.setup {
  layouts = {
    {
      elements = {
        {
          id = "scopes",
          size = 0.5,
        },
        {
          id = "breakpoints",
          size = 0.5,
        },
        {
          id = "stacks",
          size = 0.5,
        },
        {
          id = "watches",
          size = 0.5,
        },
      },
      position = "left",
      size = 40,
    },
    {
      elements = {
        {
          id = "repl",
          size = 0.5,
        },
        {
          id = "console",
          size = 0.5,
        },
      },
      position = "bottom",
      size = 10,
    },
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

require("dap-python").setup "python"
require("dap-go").setup {}

map("n", "<leader>dt", dapui.toggle, "dapui toggle")
map("n", "<leader>db", dap.toggle_breakpoint, "dap toggle breakpoint")
map("n", "<leader>dl", dap.continue, "dap continue")
map("n", "<leader>dj", dap.step_into, "dap step into")
map("n", "<leader>dk", dap.step_over, "dap step over")

map("n", "<leader>dt", function()
  local ft = vim.bo.filetype
  if vim.bo.filetype == "python" then
    require("dap-python").test_method()
  elseif vim.bo.filetype == "go" then
    require("dap-go").debug_test()
  end
end, "dap run test")

dap.adapters.lldb = {
  type = "server",
  port = "13000",
  executable = {
    command = vim.fn.expand "$HOME/Downloads/extension/adapter/codelldb",
    args = { "--port", "13000" },
  },
}
dap.configurations.rust = {
  {
    name = "main",
    type = "lldb",
    request = "launch",
    program = function()
      local function endswith(str, ending)
        return ending == "" or str:sub(-#ending) == ending
      end

      if vim.bo.filetype ~= "rust" then
        return "not a rust file"
      end

      local curdir = vim.fn.expand "%:p"

      while endswith(curdir, "/src") ~= false do
        curdir = vim.fn.fnamemodify(curdir, ":h")
      end
      curdir = vim.fn.fnamemodify(curdir, ":h:h")
      local proj_name = vim.fn.fnamemodify(curdir, ":t")
      os.execute("cd " .. curdir .. " && cargo build >/dev/null 2>&1")
      return curdir .. "/target/debug/" .. proj_name
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}
dap.set_log_level "TRACE"
