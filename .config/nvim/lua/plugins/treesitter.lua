-- The `main` branch is a full rewrite of nvim-treesitter and requires
-- Neovim 0.12+. It does not support lazy-loading, and it no longer takes an
-- `ensure_installed` / `highlight` options table -- parsers are installed with
-- install(), and highlighting is started by the FileType autocmd in
-- lua/config/autocmds.lua.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup()

    require("nvim-treesitter").install({
      -- editor / config
      "lua",
      "luadoc",
      "vim",
      "vimdoc",
      "query",
      -- go
      "go",
      "gomod",
      "gosum",
      "gowork",
      "gotmpl",
      -- python
      "python",
      -- web / typescript
      "typescript",
      "javascript",
      "tsx",
      "html",
      "css",
      -- rust
      "rust",
      -- c / c++
      "c",
      "cpp",
      "cmake", -- CMakeLists.txt
      "make", -- Makefile
      -- java
      "java",
      "xml", -- pom.xml
      "properties", -- application.properties
      -- elixir
      "elixir",
      "heex",
      "eex",
      -- data / infra
      "yaml",
      "json", -- also used for the jsonc filetype
      "toml",
      "dockerfile",
      "bash",
      "helm",
      "terraform",
      "hcl",
      -- misc
      "markdown",
      "markdown_inline",
      "diff",
      "git_config",
      "gitcommit",
      "gitignore",
    })
  end,
}
