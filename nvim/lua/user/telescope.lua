local M = {
        "nvim-telescope/telescope.nvim", dependencies = {
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
            "debugloop/telescope-undo.nvim",
            "nvim-lua/plenary.nvim",
        }
}

M.config = function()
    local t = require("telescope")
    t.setup()
    t.load_extension("fzf")
    t.load_extension("undo")
end

return M
