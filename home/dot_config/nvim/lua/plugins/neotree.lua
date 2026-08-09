return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        lazy = false,

        keys = {
            {
                "<leader>cd",
                function()
                    if vim.bo.filetype == "neo-tree" then
                        vim.cmd("Neotree filesystem close left")
                    else
                        vim.cmd("Neotree filesystem focus left")
                    end
                end,
                desc = "Focus or close Neo-tree",
            },
        },

        opts = {
            filesystem = {
                hijack_netrw_behavior = "open_default",
                filtered_items = {
                    visible = true,
                },
            },
        },

        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "nvim-tree/nvim-web-devicons",
        },
    },
}
