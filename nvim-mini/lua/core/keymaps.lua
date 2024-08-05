local utils = require "core.utils"
local map = utils.map

local M = {}

M.maps = function()
  map("n", "Q", "<nop>")
  map("n", "<esc>", ":noh<cr>")
  map("t", "jk", "<c-\\><c-n>")
  map("i", "jk", "<esc>")

  map("v", "P", [["_dP]])
  map({ "n", "x", "v" }, "x", [["_x]])
  map({ "n", "x", "v" }, "<leader>y", [["+y]])
  map({ "n", "x", "v" }, "<leader>p", [["+p]])
  map("n", "Y", "yg$")
  map("n", "J", "mzJ`z")

  map("v", "<leader>r", [["hy:%s/<c-r>h//g<left><left>]])

  map("n", "n", "nzz")
  map("n", "N", "Nzz")
  map("n", "*", "*zz")
  map("n", "#", "#zz")
  map("n", "g*", "g*zz")
  map("n", "g#", "g#zz")
  map("n", "<c-d>", "<c-d>zz")
  map("n", "<c-u>", "<c-u>zz")

  map("v", "<", "<gv")
  map("v", ">", ">gv")
  map("v", "J", ":m '>+1<cr>gv=gv")
  map("v", "K", ":m '<-2<cr>gv=gv")
  map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
  map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

  map("n", "<c-h>", "<c-w>h")
  map("n", "<c-j>", "<c-w>j")
  map("n", "<c-k>", "<c-w>k")
  map("n", "<c-l>", "<c-w>l")
  map("n", "<m-k>", ":resize +2<CR>")
  map("n", "<m-j>", ":resize -2<CR>")
  map("n", "<m-h>", ":vertical resize +2<CR>")
  map("n", "<m-l>", ":vertical resize -2<CR>")

  map("n", "]c", ":cnext<cr>zz")
  map("n", "[c", ":cprev<cr>zz")
  map("n", "<leader>C", function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
      if win["quickfix"] == 1 then
        qf_exists = true
        break
      end
    end
    if qf_exists == true then
      return vim.cmd "cclose"
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      return vim.cmd "copen"
    end
  end)
  local minipick = require "mini.pick"
  local miniextra = require "mini.extra"
  local minivisits = require "mini.visits"
  local builtin = minipick.builtin

  -- PICKER
  map("n", "<leader>ff", function()
    builtin.files()
  end, "find files")

  map("n", "<leader>fr", function()
    builtin.resume()
  end, "Resume finding")

  map("n", "<leader>fs", function()
    builtin.grep_live()
  end, "Grep live")

  map("n", "<leader>fo", function()
    local _ = require("mini.files").close() or require("mini.files").open()
  end, "Toggle minifiles")

  map("n", "Q", "<nop>")
  map("n", "<esc>", ":noh<cr>")
  map("t", "jk", "<c-\\><c-n>")
  map("i", "jk", "<esc>")

  map("v", "P", [["_dP]])
  map({ "n", "x", "v" }, "x", [["_x]])
  map({ "n", "x", "v" }, "<leader>y", [["+y]])
  map({ "n", "x", "v" }, "<leader>p", [["+p]])
  map("n", "Y", "yg$")
  map("n", "J", "mzJ`z")

  map("v", "<leader>r", [["hy:%s/<c-r>h//g<left><left>]])

  map("n", "n", "nzz")
  map("n", "N", "Nzz")
  map("n", "*", "*zz")
  map("n", "#", "#zz")
  map("n", "g*", "g*zz")
  map("n", "g#", "g#zz")
  map("n", "<c-d>", "<c-d>zz")
  map("n", "<c-u>", "<c-u>zz")

  map("v", "<", "<gv")
  map("v", ">", ">gv")
  map("v", "J", ":m '>+1<cr>gv=gv")
  map("v", "K", ":m '<-2<cr>gv=gv")
  map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
  map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

  map("n", "<c-h>", "<c-w>h")
  map("n", "<c-j>", "<c-w>j")
  map("n", "<c-k>", "<c-w>k")
  map("n", "<c-l>", "<c-w>l")
  map("n", "<m-k>", ":resize +2<CR>")
  map("n", "<m-j>", ":resize -2<CR>")
  map("n", "<m-h>", ":vertical resize +2<CR>")
  map("n", "<m-l>", ":vertical resize -2<CR>")

  map("n", "]c", ":cnext<cr>zz")
  map("n", "[c", ":cprev<cr>zz")
  map("n", "<leader>C", function()
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
      if win["quickfix"] == 1 then
        qf_exists = true
        break
      end
    end
    if qf_exists == true then
      return vim.cmd "cclose"
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
      return vim.cmd "copen"
    end
  end)
  map("n", "<m-s>", function()
    miniextra.pickers.visit_paths { filter = "todo" }
  end, "Add file to todolist")

  map("n", "<m-a>", function()
    minivisits.add_label "todo"
  end, "Remove file from todolist")

  map("n", "<m-A>", function()
    minivisits.remove_label()
  end, "Remove label from file")

  map("n", "<leader>gc", function()
    miniextra.pickers.git_commits()
  end, "Show git commits")

  map("n", "<leader>gh", function()
    miniextra.pickers.git_hunks()
  end, "Show git hunks")

  map("n", "<leader>dp", function()
    miniextra.pickers.diagnostic()
  end, "Diagnostic in picker")

  -- LSP
  -- map the following keys on lsp attach only
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

      -- Diagnostics mappings
      map("n", "[d", function()
        vim.diagnostic.goto_prev { float = false }
      end, "Diagnostics goto_prev")

      map("n", "]d", function()
        vim.diagnostic.goto_next { float = false }
      end, "Diagnostics goto_next")
      map("n", "<leader>sd", vim.diagnostic.setloclist)

      map("n", "<leader>hi", function()
        utils.toggle_inlay_hint() -- toggle inlay hint
      end, "Toggle inlay hint")

      map("n", "K", vim.lsp.buf.hover, "Open lsp hover")
      map("n", "<leader>df", function()
        vim.diagnostic.open_float()
      end, "Open diagnostics float ")
      map("n", "<leader>d", vim.lsp.buf.definition, "Goto lsp definition")
      map("n", "<leader>lh", vim.lsp.buf.declaration, "Goto lsp declaration")
      map(
        "n",
        "<leader>lt",
        vim.lsp.buf.type_definition,
        "Goto lsp type definition"
      )
      map(
        "n",
        "<leader>li",
        vim.lsp.buf.implementation,
        "Goto lsp implementation"
      )
      map("n", "<leader>lr", vim.lsp.buf.references, "Goto lsp reference")
      map(
        { "n", "v" },
        "<leader>la",
        vim.lsp.buf.code_action,
        "Open lsp code action"
      )
      map("n", "<leader>lf", function()
        vim.lsp.buf.format { async = true }
      end, "Lsp format")
      map("n", "<leader>lc", vim.lsp.buf.rename, "Lsp rename")
      map(
        { "i", "s" },
        "<c-space>",
        vim.lsp.buf.signature_help,
        "Lsp signature help"
      )
    end,
  })
end

return M
