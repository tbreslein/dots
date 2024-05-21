LAZY_PLUGIN_SPEC = {}
function spec(item)
  table.insert(LAZY_PLUGIN_SPEC, { import = "user.plugins." .. item })
end

kmap = vim.keymap.set
