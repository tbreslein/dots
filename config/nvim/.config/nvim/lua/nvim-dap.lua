local dap = require("dap")
local dappython = require("dap-python")
local dapui = require("dapui")
local jester = require("jester")

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end

dap.adapters = {
	lldb = {
		type = "executable",
		command = "lldb-vscode",
		name = "lldb",
	},
}

local lldb = {
	name = "Launch lldb",
	type = "lldb",
	request = "launch",
	-- program = function()
	-- 	return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
	-- 	-- return vim.fn.jobstart("cargo test")
	-- end,
	cwd = "${workspaceFolder}",
	stopOnEntry = false,
	args = { "cargo", "test" },
	runInTerminal = false,
}

dap.configurations.rust = {
	lldb,
}

dappython.setup("python")
dappython.test_runner = "pytest"

require("which-key").register({
	d = {
		name = "dap",
		u = { dapui.toggle, "toggle ui" },
		c = { dap.continue, "continue" },
		f = {
			name = "breakpoints",
			k = { dap.clear_breakpoints, "clear breakpoints" },
			j = { dap.toggle_breakpoint, "toggle breakpoint" },
			l = { dap.list_breakpoints, "list breakpoints" },
		},
		s = {
			name = "stepping",
			l = { dap.step_out, "step out" },
			k = { dap.step_over, "step over" },
			j = { dap.step_in, "step in" },
		},
		p = {
			name = "python",
			j = { dappython.test_method, "test method" },
			k = { dappython.test_class, "test class" },
		},
		j = {
			name = "jester",
			j = { jester.run, "run test" },
			J = { jester.run_file, "run file" },
			k = { jester.debug, "run file" },
			K = { jester.debug_file, "run file" },
		},
		x = { dap.terminate, "terminate" },
	},
}, {
	prefix = "<leader>",
})

require("rust-tools").setup({ tools = { inlay_hints = { only_current_line = true } } })
