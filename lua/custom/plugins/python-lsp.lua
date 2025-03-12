return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "workspace",
                pythonPath = vim.fn.expand("~/Repos/github/python-devops/.venv/bin/python"),
                extraPaths = {
                  vim.fn.expand("~/Repos/github/python-devops/.venv/lib/python3.*/site-packages"),
                },
              },
            },
          },
        },
        pylsp = {
          settings = {
            pylsp = {
              python = {
                pythonPath = vim.fn.expand("~/Repos/github/python-devops/.venv/bin/python"),
                venvPath = vim.fn.expand("~/Repos/github/python-devops/.venv"),
              },
              plugins = {
                flake8 = { enabled = true },
                mypy = { enabled = true },
                pylint = { enabled = true },
                jedi = {
                  environment = vim.fn.expand("~/Repos/github/python-devops/.venv/bin/python"),
                },
              },
            },
          },
        },
      },
    },
  },
}