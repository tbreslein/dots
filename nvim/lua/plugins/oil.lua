    require("oil").setup({
        keymaps = {
            ["<c-s>"] = false,
            ["<c-h>"] = false,
            ["<c-v>"] = "actions.select_vsplit",
            ["<c-x>"] = "actions.select_split",
        },
    })

require("which-key").register({
    ["<leader>fo"] = { "<cmd>Oil<cr>", "open oil"},
})
