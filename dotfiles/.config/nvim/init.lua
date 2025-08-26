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

--------------------------------------------------
-- number and relative number
--------------------------------------------------
local NumberToggle = vim.api.nvim_create_augroup("NumberToggle", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter", "BufReadPost", "BufNewFile" }, {
  group = NumberToggle,
  pattern = "*",
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})
vim.api.nvim_create_autocmd("InsertEnter", {
  group = NumberToggle,
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = false
    vim.wo.number = true
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = NumberToggle,
  pattern = "*",
  callback = function()
    vim.wo.relativenumber = true
  end,
})

--------------------------------------------------
-- vim-commentary
--------------------------------------------------
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.envrc.local", "*.envrc" },
  command = "setfiletype sh",
})

--------------------------------------------------
-- conform formatter
--------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function(args)
    require("conform").format({ bufnr = args.buf, verbose = true })
  end,
})
vim.keymap.set("n", "<leader>f", function()
  -- `bufnr = vim.api.nvim_get_current_buf()` is the same value you passed in the autocmd
  require("conform").format({ bufnr = vim.api.nvim_get_current_buf() })
end, { desc = "Format buffer with Prettier" })
