return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "ast_grep",
                    "fortls",
                    "pylsp",
                    "lua_ls",
                    "yamlls",
                    "julials"
                },
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.bashls.setup({})
            lspconfig.ast_grep.setup({})
            lspconfig.fortls.setup({})
            lspconfig.pylsp.setup({})
            lspconfig.lua_ls.setup({})
            lspconfig.yamlls.setup({})
            lspconfig.julials.setup({})
        end
    }
}

