return {
  "nvim-lua/plenary.nvim",

  {
    "nvchad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },

  {
    "nvchad/ui",
    lazy = false,
    config = function()
      require "nvchad"
    end,
  },

  "nvzone/volt",
  "nvzone/menu",
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },

  {
    "nvim-tree/nvim-web-devicons",
    opts = function()
      dofile(vim.g.base46_cache .. "devicons")
      return { override = require "nvchad.icons.devicons" }
    end,
  },

  {
    "lukas-reineke/indent-blankline.nvim",
    event = "User FilePost",
    opts = {
      indent = { char = "│", highlight = "IblChar" },
      scope = { char = "│", highlight = "IblScopeChar" },
    },
    config = function(_, opts)
      dofile(vim.g.base46_cache .. "blankline")

      local hooks = require "ibl.hooks"
      hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
      require("ibl").setup(opts)

      dofile(vim.g.base46_cache .. "blankline")
    end,
  },

  -- file managing , picker etc
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "nvchad.configs.nvimtree"
    end,
  },

  {
    "Cassin01/wf.nvim",
    version = "*",
    lazy = false,
    config = function() 
      require("wf").setup()
      require "nvchad.configs.wf"
    end
  },

  -- formatting!
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = { 
        lua = { "stylua" }, 
        python = { "isort", "black" } 
      },
    },
  },

  -- git stuff
  {
    "lewis6991/gitsigns.nvim",
    event = "User FilePost",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
  },

  -- lsp stuff
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
    },
    opts = function()
      return require "nvchad.configs.mason"
    end,
    config = function(_, opts)
      require "mason".setup()
      require "mason-lspconfig".setup {    
        ensure_installed = {
          "lua_ls",
          "pyright",
          "bashls",
          "jsonls",
          "html",
          "cssls",
        }
      }
    end,
  },

  -- load luasnips + cmp related in insert mode only
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      {
        -- snippet plugin
        "L3MON4D3/LuaSnip",
        dependencies = "rafamadriz/friendly-snippets",
        opts = { history = true, updateevents = "TextChanged,TextChangedI" },
        config = function(_, opts)
          require("luasnip").config.set_config(opts)
          require "nvchad.configs.luasnip"
        end,
      },

      -- autopairing of (){}[] etc
      {
        "windwp/nvim-autopairs",
        opts = {
          fast_wrap = {},
          disable_filetype = { "TelescopePrompt", "vim" },
        },
        config = function(_, opts)
          require("nvim-autopairs").setup(opts)

          -- setup cmp for autopairs
          local cmp_autopairs = require "nvim-autopairs.completion.cmp"
          require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
      },

      -- cmp sources plugins
      {
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-nvim-lua",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
      },
    },
    opts = function()
      return require "nvchad.configs.cmp"
    end,
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Telescope",
    opts = function()
      return require "nvchad.configs.telescope"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = function()
      return require "nvchad.configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      {
        "nvim-neotest/nvim-nio",
        "mfussenegger/nvim-dap",
        dependencies = {
          { "mfussenegger/nvim-dap-python" },
        },
        config = function(_, opts)
          require("dap-python").setup("~/.local/venv/debugpy/bin/python", { test_runner = "unittest" })
          require "nvchad.configs.dap"
        end,
      },

    },
    config = function(_, opts)
      require("dapui").setup(opts)
    end,
  },

  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",

    opts = {
      symbol_in_winbar = { enable = false }
    },
    config = function(_, opts)
      require("lspsaga").setup(opts)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neoconf.nvim",

      dependecies =  {
        "folke/neodev.nvim",
        opts = {
          library = {
            plugins = { "nvim-dap-ui", "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
            types = true,
          },
        },
        config = function(_, opts)
          require("neodev").setup(opts)
        end,
      },
    },
    init = function()
      vim.opt.expandtab = true
      vim.opt.shiftwidth = 4
      vim.opt.smartindent = true
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
    end,
    event = "User FilePost",
    config = function()
      require("neoconf").setup()

      local lspconfig = require("nvchad.configs.lspconfig")
      lspconfig.setup_default()
      lspconfig.setup_servers()
      lspconfig.setup_dap()
    end,
  },
}
