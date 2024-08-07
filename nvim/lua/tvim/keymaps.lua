map("n", "Q", "<nop>", "")
map("n", "<esc>", ":noh<cr>", "")
map("t", "jk", "<c-\\><c-n>", "")
map("i", "jk", "<esc>", "")

map("v", "P", [["_dP]], "")
map({ "n", "x", "v" }, "x", [["_x]], "")
map("n", "Y", "yg$", "")
map("n", "J", "mzJ`z", "")

map("v", "<leader>r", [["hy:%s/<c-r>h//g<left><left>]], "search/replace")

map("n", "n", "nzz", "")
map("n", "N", "Nzz", "")
map("n", "*", "*zz", "")
map("n", "#", "#zz", "")
map("n", "g*", "g*zz", "")
map("n", "g#", "g#zz", "")
map("n", "<c-d>", "<c-d>zz", "")
map("n", "<c-u>", "<c-u>zz", "")

map("v", "<", "<gv", "")
map("v", ">", ">gv", "")
map("v", "J", ":m '>+1<cr>gv=gv", "")
map("v", "K", ":m '<-2<cr>gv=gv", "")
map("n", "j", "v:count == 0 ? 'gj' : 'j'", "", { expr = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", "", { expr = true })

map("n", "<c-h>", "<c-w>h", "")
map("n", "<c-j>", "<c-w>j", "")
map("n", "<c-k>", "<c-w>k", "")
map("n", "<c-l>", "<c-w>l", "")
-- map("n", "<m-h>", "<c-w><", "")
map("n", "<m-j>", "<c-w>-", "")
map("n", "<m-k>", "<c-w>+", "")
-- map("n", "<m-l>", "<c-w>>", "")

map("n", "]c", ":cnext<cr>zz", "quicklist next")
map("n", "[c", ":cprev<cr>zz", "quicklist prev")
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
end, "quicklist toggle")
