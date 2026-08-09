return {
    {
        "saghen/blink.cmp",
        version = "*",

        opts = {
            keymap = {
                preset = "enter",

                ["<CR>"] = {
                    "select_and_accept",
                    "fallback",
                },
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 300,
                },
            },

            sources = {
                default = {
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                },
            },
        },
    },
}
