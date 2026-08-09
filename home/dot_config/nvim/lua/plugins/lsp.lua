local uname = (vim.uv or vim.loop).os_uname()
local is_linux_arm = uname.sysname == "Linux"
    and (uname.machine == "aarch64" or uname.machine:match("^arm") ~= nil)

local mason_servers = {
    "lua_ls",
    "html",
    "cssls",
    "ts_ls",
    "pyright",
    "intelephense",
}

if not is_linux_arm then
    table.insert(mason_servers, "clangd")
end

return {
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    {
        "neovim/nvim-lspconfig",

        config = function()
            vim.lsp.config("lua_ls", {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = {
                                "vim",
                                "hl",
                            },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                },
            })

            if is_linux_arm and vim.fn.executable("clangd") == 1 then
                vim.lsp.enable("clangd")
            end
        end,
    },

    {
        "mason-org/mason-lspconfig.nvim",

        dependencies = {
            "mason-org/mason.nvim",
            "neovim/nvim-lspconfig",
        },

        opts = {
            ensure_installed = mason_servers,
        },
    },
}
