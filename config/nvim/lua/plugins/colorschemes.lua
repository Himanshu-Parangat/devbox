return {
	{
		"lunarvim/colorschemes",
		priority = 999,
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",

				transparent_background = true,

				dim_inactive = {
					enabled = false, -- dims inactive window background
					shade = "dark",
					percentage = 0.15,
				},

				integrations = {
					telescope = true,
					-- harpoon = true,
					mason = true,
				},

				color_overrides = {
					all = {
						text = "#f9a8d4",
					},

					mocha = {
						yellow = "#DFFFD0",
						green = "#CAFFAF",
						-- lavender = "#f9a8d4",
					},
				},

        custom_highlights = function(colors)
          return {
            NormalFloat = {
              bg = "NONE",
              fg = "#f9a8d4",
            },

            FloatBorder = {
              bg = "NONE",
            },

            NotificationInfo = {
              bg = "NONE",
              fg = "#f9a8d4",
            },
          }
        end,


			})

			vim.cmd([[colorscheme catppuccin]])

		end,
	},
}
