return {
  {
    "stevearc/conform.nvim",
    opts = { -- will be merged with default options
      formatters_by_ft = {
        json = { "prettier" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        lua = { "stylua" },
        -- add more filetypes as needed
      },
      formatters = {
        prettier = {
          command = "prettier",
          prepend_args = { "--tab-width", "2", "--use-tabs", "false" },
        },
      },
      log_level = vim.log.levels.DEBUG,
    },
    event = "BufReadPost",
    config = function(_, opts)
      require("conform").setup(opts)
    end,
  },
}
