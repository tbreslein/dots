local heirline = require "heirline"
local heirline_components = require "heirline-components.all"

-- Setup
heirline_components.init.subscribe_to_events()
heirline.load_colors(heirline_components.hl.get_colors())
heirline.setup({
    statusline = {
        hl = { fg = "fg", bg = "bg" },
        heirline_components.component.mode(),
        heirline_components.component.git_branch(),
        heirline_components.component.file_info({filetype = false, filename = {}, file_modified = false}),
        heirline_components.component.git_diff(),
        heirline_components.component.diagnostics(),
        heirline_components.component.fill(),
        heirline_components.component.cmd_info(),
        heirline_components.component.fill(),
        heirline_components.component.lsp({ lsp_client_names = false }),
        heirline_components.component.compiler_state(),
        heirline_components.component.virtual_env(),
        heirline_components.component.nav(),
        heirline_components.component.mode { surround = { separator = "right" } },
    },
})
