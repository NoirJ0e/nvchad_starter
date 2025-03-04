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
    event = "BufEnter",
  },
  {
    "williaamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "tailwindcss-language-server",
        "lua-language-server",
        "typescript-language-server",
      },
    },
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
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      provider = "gemini_2", -- Replace "openai" with your desired provider
      vendors = {
        openrouter = {
          __inherited_from = "openai",
          endpoint = "https://openrouter.ai/api/v1",
          api_key_name = "OPENROUTER_API_KEY",
          model = "anthropic/claude-3.7-sonnet",
        },
        gemini_2 = {
          __inherited_from = "gemini",
          endpoint = "https://generativelanguage.googleapis.com/v1beta/models",
          model = "gemini-2.0-flash",
          timeout = 30000, -- Timeout in milliseconds
          api_key_name = "GEMINI_API_KEY",
          temperature = 0,
          max_tokens = 8192,
        },
      },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- The below dependencies are optional,
      "echasnovski/mini.pick", -- for file_selector provider mini.pick
      "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
      "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
  {
    "sbdchd/neoformat",
    cmd = "Neoformat",
    config = function()
      -- Create the autocommand group and the BufWritePre autocommand
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
          vim.cmd "undojoin | Neoformat"
        end,
        group = vim.api.nvim_create_augroup("fmt", { clear = true }),
      })
    end,
  },
}

-- {
-- 	"nvim-treesitter/nvim-treesitter",
-- 	opts = {
-- 		ensure_installed = {
-- 			"vim", "lua", "vimdoc",
--      "html", "css"
-- 		},
-- 	},
-- },
