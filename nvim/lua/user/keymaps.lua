kmap("n", "Q", "<nop>")
kmap("n", "<esc>", ":noh<cr>")
kmap("t", "jk", "<c-\\><c-n>")

kmap("v", "P", [["_dP]])
kmap({ "n", "x", "v" }, "x", [["_x]])
kmap({ "n", "x", "v" }, "<leader>y", [["+y]])
kmap({ "n", "x", "v" }, "<leader>p", [["+p]])
kmap("n", "Y", "yg$")
kmap("n", "J", "mzJ`z")

kmap("n", "<leader>w", ":w<cr>")
kmap("n", "<leader>W", ":wq<cr>")
kmap("v", "<leader>r", [["hy:%s/<c-r>h//g<left><left>]])

kmap("n", "n", "nzz")
kmap("n", "N", "Nzz")
kmap("n", "*", "*zz")
kmap("n", "#", "#zz")
kmap("n", "g*", "g*zz")
kmap("n", "g#", "g#zz")
kmap("n", "<c-d>", "<c-d>zz")
kmap("n", "<c-u>", "<c-u>zz")

kmap("v", "<", "<gv")
kmap("v", ">", ">gv")
kmap("v", "J", ":m '>+1<cr>gv=gv")
kmap("v", "K", ":m '<-2<cr>gv=gv")
kmap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })
kmap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })

kmap("n", "]c", ":cnext<cr>zz")
kmap("n", "[c", ":cprev<cr>zz")
kmap("n", "<leader>C", function()
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
