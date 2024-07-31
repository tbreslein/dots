if vim.loader then
  vim.loader.enable()
end

require("core.opts").initial()
require("core.utils").bootstrap()
require "plugins"
