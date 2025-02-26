return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter"
  },
  {
    "williaamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "tailwindcss-language-server",
        "lua-language-server",
        "typescript-language-server",
      }
    }
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "gr",
            open = "<C-CR>",
          },
          layout = {
            position = "bottom", -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-]>",
            accept_word = "<C-Right>",
            accept_line = "<C-End>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-[>",
          },
        },
      }
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "copilot.lua" },
    event = { "InsertEnter", "LspAttach" },
    fix_pairs = true,
    config = function()
      require("copilot_cmp").setup()
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf ---@type number
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and (not "copilot" or client.name == "copilot") then
            return require("copilot_cmp")._on_insert_enter(client, buffer)
          end
        end,
      })
      local cmp = require "cmp"
      local current_sources = cmp.get_config().sources or {}
      table.insert(current_sources, {
        name = "copilot",
        priority = 100,
      })
      cmp.setup {
        sources = current_sources,
      }
    end,
  },


  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
