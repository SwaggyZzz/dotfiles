return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = "ConformInfo",
    dependencies = { "mason.nvim" },
    config = require("configs.conform"),
  },
}
