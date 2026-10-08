-- lua/plugins/treesitter.lua
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    require("nvim-treesitter").install({
      -- Web
      "html", "css", "javascript", "typescript", "tsx",

      -- Systems
      "c", "cpp", "rust", "go", "gomod", "gosum",

      -- Scripting
      "python", "ruby", "bash",

      -- Config / Data
      "json",  "yaml", "toml", "sql",

      -- Docs
      "markdown", "markdown_inline",

      -- Neovim
      "lua", "vim", "vimdoc",
    })

    vim.api.nvim_create_autocmd("FileType", {
      pattern = {
        -- Web
        "html", "css", "javascript", "typescript", "typescriptreact", "javascriptreact",

        -- Systems
        "c", "cpp", "rust", "go",

        -- Scripting
        "python", "ruby", "bash", "sh",

        -- Config / Data
        "json", "yaml", "toml", "sql",

        -- Docs
        "markdown",

        -- Neovim
        "lua", "vim",
      },
      callback = function()
        vim.treesitter.start()
      end,
    })
  end,
}
