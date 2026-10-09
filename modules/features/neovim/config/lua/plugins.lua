return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function() vim.cmd.colorscheme("tokyonight-night") end,
  },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Dashboard / UI
  { "mhinz/vim-startify", event = "VimEnter" },
  { "mbbill/undotree", cmd = "UndotreeToggle" },
  { "rcarriga/nvim-notify", config = function() vim.notify = require("notify") end },
  { "MunifTanjim/nui.nvim", lazy = true },
  {
    "folke/noice.nvim",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    config = function() require("noice").setup({}) end,
  },

  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("harpoon"):setup() end,
  },

  -- Git
  { "lewis6991/gitsigns.nvim", config = true },
  { "sindrets/diffview.nvim", cmd = { "DiffviewOpen", "DiffviewFileHistory" } },

  -- Typst
  {
    "chomosuke/typst-preview.nvim",
    ft = "typst",
    opts = {
      -- Use the Nix-provided binaries instead of letting the plugin download
      -- prebuilt ones, which do not run on NixOS.
      dependencies_bin = {
        tinymist = "tinymist",
        websocat = "websocat",
      },
      -- Open the preview in a dedicated Brave profile/app window. The nvim
      -- wrapper exports XDG_CONFIG_HOME=<read-only nvim store> to every child;
      -- Brave's crashpad can't write there and dies with a SIGTRAP, so unset
      -- it for the browser only.
      open_cmd = 'env -u XDG_CONFIG_HOME brave --app=%s --user-data-dir="'
        .. vim.fn.expand("~/.cache/typst-preview/brave")
        .. '"',
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-media-files.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Git files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Old files" },
      { "<leader>fm", "<cmd>Telescope media_files<cr>", desc = "Media files" },
    },
    config = function() require("telescope").load_extension("media_files") end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "onsails/lspkind.nvim",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      cmp.setup({
        snippet = { expand = function(args) luasnip.lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip", keyword_length = 2 },
          { name = "path" },
        }, {
          { name = "buffer", keyword_length = 3 },
        }),
        formatting = {
          format = require("lspkind").cmp_format({ mode = "symbol" }),
        },
      })
    end,
  },

  -- Editing
  { "numToStr/Comment.nvim", config = true },
  { "folke/todo-comments.nvim", dependencies = { "nvim-lua/plenary.nvim" }, config = true },

  -- Formatting / linting
  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.code_actions.statix,
          null_ls.builtins.diagnostics.statix,
          null_ls.builtins.diagnostics.deadnix,
          null_ls.builtins.diagnostics.pylint,
        },
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = { python = { "pylint" }, nix = { "statix" } }
      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function() require("lint").try_lint() end,
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          nix = { "alejandra" },
          python = { "black" },
          rust = { "rustfmt" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          json = { "prettier" },
        },
        format_on_save = { timeout_ms = 500, lsp_format = "fallback" },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local servers = {
        "pyright", "marksman", "nil_ls", "bashls", "yamlls", "html",
        "cssls", "ts_ls", "clangd", "rust_analyzer", "lua_ls", "jsonls",
        "taplo", "tinymist",
      }
      vim.lsp.config("*", { capabilities = capabilities })
      vim.lsp.config("lua_ls", {
        settings = { Lua = { telemetry = { enable = false } } },
      })
      for _, name in ipairs(servers) do
        vim.lsp.enable(name)
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        end,
      })
    end,
  },
  { "onsails/lspkind.nvim", lazy = true },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    config = true,
  },

  -- Treesitter + colorizer
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "html", "javascript", "json",
          "lua", "markdown", "nix", "python", "rust", "tsx",
          "typescript", "vim", "yaml",
        },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    "catgoose/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function() require("colorizer").setup({ user_default_options = { mode = "virtual" } }) end,
  },
}
