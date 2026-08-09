local themes = require("telescope.themes")
local conf = require("telescope.config").values

local function open_harpoon_in_telescope(harpoon_files)
    local file_paths = {}

    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    local opts = themes.get_ivy({
        prompt_title = "Harpoon Files",
    })

    require("telescope.pickers").new(opts, {
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer(opts),
        sorter = conf.generic_sorter(opts),
    }):find()
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",

    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },

    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()

        vim.keymap.set("n", "<leader>a", function()
            harpoon:list():add()
        end, {
            desc = "Add file to Harpoon",
        })

        vim.keymap.set("n", "<C-e>", function()
            harpoon.ui:toggle_quick_menu(harpoon:list())
        end, {
            desc = "Open Harpoon menu",
        })

        vim.keymap.set("n", "<leader>fl", function()
            open_harpoon_in_telescope(harpoon:list())
        end, {
            desc = "Open Harpoon list in Telescope",
        })

        vim.keymap.set("n", "<C-p>", function()
            harpoon:list():prev()
        end, {
            desc = "Previous Harpoon file",
        })

        vim.keymap.set("n", "<C-n>", function()
            harpoon:list():next()
        end, {
            desc = "Next Harpoon file",
        })
    end,
}
