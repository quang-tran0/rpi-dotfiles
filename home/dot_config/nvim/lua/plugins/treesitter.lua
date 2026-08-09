return {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",

    dependencies = {
	"windwp/nvim-ts-autotag",
    },

    config = function()
	require("nvim-treesitter.configs").setup({
	    ensure_installed = {
		"lua",
		"html",
		"javascript",
		"typescript",
		"tsx",
		"php",
		"bash",
		"c",
		"cpp",
		"verilog",
	    },

	    auto_install = false,
	    highlight = { enable = true },
	    indent = { enable = true },
	    autotage = { enable = true }
	})

	require("nvim-ts-autotag").setup({
	    opts = {
		enable_close = true,
		enable_rename = true,
		enable_close_on_slash = false,
	    },
	})
    end,
}
