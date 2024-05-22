return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        local wk = require("which-key")
        wk.register({
            ["<leader>"] = {
                c = {
                    "Actions",
                },
                e = {
                    "Explorer",
                },
                f = {
                    "Find",
                },
                h = {
                    "Git",
                },
                m = {
                    "Format",
                },
                n = {
                    "Clear",
                },
                r = { "Rename" },
                s = {
                    "Split",
                },
                t = {
                    "Tab",
                },
                w = {
                    "Session",
                },
                x = {
                    "Trouble",
                },
            },
        })
    end,
    opts = {
        -- leave empty to use default config
    },
}
