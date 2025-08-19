require("config.lazy")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local dir = vim.fn.expand("<afile>:p:h")
    if vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
  end,
})

vim.api.nvim_create_augroup('NumberToggle', { clear = true })
vim.api.nvim_create_autocmd('InsertEnter', {
  group = 'NumberToggle',
  pattern = '*',
  command = 'set number',
})
vim.api.nvim_create_autocmd('InsertLeave', {
  group = 'NumberToggle',
  pattern = '*',
  command = 'set relativenumber',
})

