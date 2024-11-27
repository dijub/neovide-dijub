return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 500
        local wk = require("which-key")
        wk.add({
            { "<leader>c", desc = "Actions" },
            { "<leader>e", desc = "Explorer" },
            { "<leader>f", desc = "Find" },
            { "<leader>h", desc = "Git" },
            { "<leader>m", desc = "Format" },
            { "<leader>n", desc = "Clear" },
            { "<leader>r", desc = "Rename" },
            { "<leader>s", desc = "Split" },
            { "<leader>t", desc = "Tab" },
            { "<leader>w", desc = "Session" },
            { "<leader>x", desc = "Trouble" },
            { "<leader>j", desc = "java" },
            { "<leader>J", desc = "Java" },
            { "<leader>p", desc = "python" },
        })
    end,
    opts = {
        -- leave empty to use default config
    },
}
