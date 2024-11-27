return {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
        "neovim/nvim-lspconfig",
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python", --optional
        "mfussenegger/nvim-lint",
        { "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
    },
    lazy = false,
    branch = "regexp", -- This is the regexp branch, use this for the new version
    config = function()
        require("venv-selector").setup({
            settings = {
                options = {
                    on_venv_activate_callback = function()
                        local venv_path = require("venv-selector").venv()
                        if venv_path then
                            require("lint").linters.pylint.cmd = venv_path .. "/bin/pylint"
                        end
                    end,
                },
            },
        })
    end,
    keys = {
        { ",v", "<cmd>VenvSelect<cr>" },
    },
}
