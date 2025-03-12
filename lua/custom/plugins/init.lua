return {
  {
    "custom/commit-template",
    event = "VimEnter",
    dir = vim.fn.stdpath("config") .. "/lua/custom/plugins",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "github/copilot.vim",
    },
    config = function()
      require("custom.plugins.copilot_commit").setup()
    end,
  },
}
