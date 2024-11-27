vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment Number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement Number" }) -- decrement

keymap.set("n", "<leader>T", function()
    local buf_name = vim.api.nvim_buf_get_name(0)
    local command = ""
    if buf_name:match("%.py$") then
        command = "source ./.venv/bin/activate"
    end

    -- Open a new terminal window at the bottom
    vim.cmd("botright split term://zsh")

    -- Get the buffer number of the new terminal
    local term_bufnr = vim.api.nvim_get_current_buf()

    -- Execute the command in the terminal if there is one
    if command ~= "" then
        vim.api.nvim_chan_send(vim.b.terminal_job_id, command .. "\n")
    end

    -- Optionally, you can set an autocommand to automatically enter insert mode
    vim.api.nvim_create_autocmd("TermOpen", {
        buffer = term_bufnr,
        command = "startinsert",
    })
end, { desc = "Open Terminal" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- Java Commands

keymap.set("n", "<leader>jc", "<cmd>JavaCompile<CR>", { desc = "Compile" })
keymap.set("n", "<leader>jm", "<cmd>JavaMavenCompile<CR>", { desc = "Maven Compile" })
keymap.set("n", "<leader>jr", "<cmd>JavaMavenRun<CR>", { desc = "Maven Run" })
keymap.set("n", "<leader>js", "<cmd>JavaSpringRun<CR>", { desc = "Spring Run" })
keymap.set("n", "<leader>ji", "<cmd>JavaMavenInstallDependencies<CR>", { desc = "Maven Install Dependencies" })
keymap.set("n", "<leader>jj", "<cmd>JavaRun<CR>", { desc = "Run" })

--
--
-- Python Commands

local function setVenvOnPath()
    local nvim_lsp = require("lspconfig")
    nvim_lsp.pyright.setup({
        on_attach = function(client, bufnr)
            -- Set the root directory of your project
            local root_dir = nvim_lsp.util.root_pattern(
                ".git",
                "setup.py",
                "setup.cfg",
                "pyproject.toml",
                "requirements.txt",
                "main.py",
                ".venv"
            )(vim.fn.expand("%:p:h")) or vim.loop.cwd()

            -- Change the pythonPath to the virtual environment interpreter
            client.config.settings.python.pythonPath = root_dir .. "/.venv/bin/python"

            -- Restart the LSP client to apply the new pythonPath
            client.notify("workspace/didChangeConfiguration")
        end,
    })
end

keymap.set("n", "<leader>pv", "<cmd>VenvSelect<cr>")

--
--
--
keymap.set("n", "<leader>go", function()
    if vim.bo.filetype == "java" then
        require("jdtls").organize_imports()
    end
end)

keymap.set("n", "<leader>gu", function()
    if vim.bo.filetype == "java" then
        require("jdtls").update_projects_config()
    end
end)

keymap.set("n", "<leader>tc", function()
    if vim.bo.filetype == "java" then
        require("jdtls").test_class()
    end
end, { desc = "run test class" })

keymap.set("n", "<leader>tm", function()
    if vim.bo.filetype == "java" then
        require("jdtls").test_nearest_method()
    end
end, { desc = "run test method" })
--
-- Debugging
keymap.set("n", "<leader>bb", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
keymap.set("n", "<leader>bc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>")
keymap.set("n", "<leader>bl", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>")
keymap.set("n", "<leader>br", "<cmd>lua require'dap'.clear_breakpoints()<cr>")
keymap.set("n", "<leader>ba", "<cmd>Telescope dap list_breakpoints<cr>")
keymap.set("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>")
keymap.set("n", "<leader>dj", "<cmd>lua require'dap'.step_over()<cr>")
keymap.set("n", "<leader>dk", "<cmd>lua require'dap'.step_into()<cr>")
keymap.set("n", "<leader>do", "<cmd>lua require'dap'.step_out()<cr>")
keymap.set("n", "<leader>dd", function()
    require("dap").disconnect()
    require("dapui").close()
end)
keymap.set("n", "<leader>dt", function()
    require("dap").terminate()
    require("dapui").close()
end)
keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>")
keymap.set("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>")
keymap.set("n", "<leader>di", function()
    require("dap.ui.widgets").hover()
end)
keymap.set("n", "<leader>d?", function()
    local widgets = require("dap.ui.widgets")
    widgets.centered_float(widgets.scopes)
end)
keymap.set("n", "<leader>df", "<cmd>Telescope dap frames<cr>")
keymap.set("n", "<leader>dh", "<cmd>Telescope dap commands<cr>")
keymap.set("n", "<leader>de", function()
    require("telescope.builtin").diagnostics({ default_text = ":E:" })
end)

-- LSP
keymap.set("n", "<leader>gg", "<cmd>lua vim.lsp.buf.hover()<CR>")
keymap.set("n", "<leader>gd", "<cmd>lua vim.lsp.buf.definition()<CR>")
keymap.set("n", "<leader>gD", "<cmd>lua vim.lsp.buf.declaration()<CR>")
keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>")
keymap.set("n", "<leader>gt", "<cmd>lua vim.lsp.buf.type_definition()<CR>")
keymap.set("n", "<leader>gr", "<cmd>lua vim.lsp.buf.references()<CR>")
keymap.set("n", "<leader>gs", "<cmd>lua vim.lsp.buf.signature_help()<CR>")
keymap.set("n", "<leader>rr", "<cmd>lua vim.lsp.buf.rename()<CR>")
keymap.set("n", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("v", "<leader>gf", "<cmd>lua vim.lsp.buf.format({async = true})<CR>")
keymap.set("n", "<leader>ga", "<cmd>lua vim.lsp.buf.code_action()<CR>")
keymap.set("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>")
keymap.set("n", "<leader>gp", "<cmd>lua vim.diagnostic.goto_prev()<CR>")
keymap.set("n", "<leader>gn", "<cmd>lua vim.diagnostic.goto_next()<CR>")
keymap.set("n", "<leader>tr", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
keymap.set("i", "<C-Space>", "<cmd>lua vim.lsp.buf.completion()<CR>")
