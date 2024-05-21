local dap, dapui = require("dap"), require("dapui")
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
dap.setup()

require("nvim-dap-virtual-text").setup()

require("which-key").register({
    ["<leader>d"] = {
        name = "+dap",
        t = { dap.toggle_breakpoint, "toggle breakpoint" },
        r = { dap.run_to_cursor, "run to cursor" },
    },
    ["<F1>"] = { dap.continue, "dap continue" },
    ["<F2>"] = { dap.step_into, "dap step into" },
    ["<F3>"] = { dap.step_over, "dap step over" },
    ["<F4>"] = { dap.step_out, "dap step out" },
    ["<F5>"] = { dap.step_back, "dap step back" },
    ["<F6>"] = { dap.restart, "dap restart" },
})
