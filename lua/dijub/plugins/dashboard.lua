local dijub2 = {
    "",
    "██████╗ ██╗     ██╗██╗   ██╗██████╗ ",
    "██╔══██╗██║     ██║██║   ██║██╔══██╗",
    "██║  ██║██║     ██║██║   ██║██████╔╝",
    "██║  ██║██║██   ██║██║   ██║██╔══██╗",
    "██████╔╝██║╚█████╔╝╚██████╔╝██████╔╝",
    "╚═════╝ ╚═╝ ╚════╝  ╚═════╝ ╚═════╝ ",
    "",
    "         ▄███████████▄.▐█▄▄█▌       ",
    "         █████████████▌▀▀██▀        ",
    "         ████▄█████████▄▄█▌         ",
    "          ▄▄▄▄▄██████████▀          ",
    "",
    "",
}

local dijub = {
    "██████╗ ██╗     ██╗██╗   ██╗██████╗ ",
    "██╔══██╗██║     ██║██║   ██║██╔══██╗",
    "██║  ██║██║     ██║██║   ██║██████╔╝",
    "██║  ██║██║██   ██║██║   ██║██╔══██╗",
    "██████╔╝██║╚█████╔╝╚██████╔╝██████╔╝",
    "╚═════╝ ╚═╝ ╚════╝  ╚═════╝ ╚═════╝ ",
    "",
    "         ▄███████████▄.▐█▄▄█▌",
    "         █████████████▌▀▀██▀ ",
    "         ████▄█████████▄▄█▌  ",
    "          ▄▄▄▄▄██████████▀    ",
    "",
    "",
    "",
}

local colors = {
    lightBlue = "#add8e6",
}

vim.api.nvim_set_hl(0, "AlphaHeader", { fg = colors.lightBlue })

local icons = {
    Python = "󰌠",
    Java = "󰬷",
    AWS = "󰸏",
    CSS = "",
    HTML = "",
    Javascript = "",
    SQL = "",
    Git = "",
    SEP = "",
    Docker = "󰡨",
}

local skills = {

    BACKEND = {
        Python = { tools = { "Pandas", "Numpy", "Flask", "Sql Alchemy", "OOP", "Gunicorn" }, level = "Expert" },
        Java = { tools = { "Spring Boot", "OOP" }, level = "Intermediate" },
        SQL = { tools = { "Postgresql", "MySQL", "SQLite" }, level = "Intermediate" },
        Docker = { tools = { "Docker-Compose" }, level = "Intermediate" },
    },
    FRONTEND = {
        Javascript = { tools = { "JQuery", "Socket-IO" }, level = "Intermediate" },
        HTML = { tools = {}, level = "Intermediate" },
        CSS = { tools = {}, level = "Intermediate" },
    },
    VERSION = {
        Git = { tools = { "Github", "Bitbucket" }, level = "Intermediate" },
    },
    CLOUD = {
        AWS = { tools = { "Lambda", "API Gateway", "S3", "Cloudfront", "IAM", "ECR", "EC2" }, level = "Intermediate" },
    },
}

local languages = {
    English = "Advanced",
    Portuguese = "Native",
}

local function sortListsInSkills(inSkills)
    for _, category in pairs(inSkills) do
        if type(category) == "table" then
            for _, details in pairs(category) do
                if type(details) == "table" and details["tools"] then
                    table.sort(details["tools"])
                end
            end
        end
    end
end

-- Ordenar as listas de ferramentas em skills
sortListsInSkills(skills)

-- Função para obter chaves ordenadas
local function getSortedKeys(t)
    local keys = {}
    for k in pairs(t) do
        table.insert(keys, k)
    end
    table.sort(keys)
    return keys
end

local resume = {}

-- Processar categorias de skills
local sortedCategories = getSortedKeys(skills)
for _, category in ipairs(sortedCategories) do
    local value = skills[category]
    local header = string.format("%-20s", category)
    table.insert(resume, header)
    for skill, details in pairs(value) do
        local level = details["level"]
        local skillLine = string.format("  %s %-30s %-20s", icons[skill], skill, level)
        table.insert(resume, skillLine)

        for _, tool in ipairs(details["tools"]) do
            local toolLine = string.format("    %s %s", icons.SEP, tool)
            table.insert(resume, toolLine)
        end
        table.insert(resume, "")
    end
end

-- Processar Languages separadamente
local header = string.format("%-20s", "LANGUAGES")
table.insert(resume, header)

for language, level in pairs(languages) do
    local languageLine = string.format("  %s %-30s %-18s", icons.SEP, language, level)
    table.insert(resume, languageLine)
    table.insert(resume, "")
end

local alphaDashboard = {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        local dashboardButtonsMain = {
            dashboard.button("SPC jn", "  -> New Java Project", "<cmd>JavaCreateProject<CR>"),
            dashboard.button("SPC pn", "󰌠  -> New Python Project", "<cmd>PythonCreateProject<CR>"),
            dashboard.button("SPC ee", "  -> Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
            dashboard.button("SPC ff", "󰱼  -> Find File", "<cmd>Telescope find_files<CR>"),
            dashboard.button("SPC fs", "  -> Find Word", "<cmd>Telescope live_grep<CR>"),
            dashboard.button("SPC wr", "󰁯  -> Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
            dashboard.button("q", "  > Quit NVIM", "<cmd>qa<CR>"),
        }
        -- Set header
        dashboard.section.header.val = dijub
        dashboard.section.header.opts.position = "center"
        dashboard.section.header.opts.hl = "AlphaHeader"

        -- Set footer
        -- dashboard.section.footer.val =
        -- "  Brazil    +55 43 996773410    @dijub    @diego-insaurralde  󰇮  diego_insaurralde@live.com"
        dashboard.section.footer.opts.position = "center"
        --
        -- Set menu
        dashboard.section.buttons.val = dashboardButtonsMain

        local linkDijub = {
            type = "text",
            val = resume,
            opts = {
                position = "center",
            },
        }
        -- dashboard.section.links = linkDijub

        local layoutSetting = {
            { type = "padding", val = 1 },
            dashboard.section.header,
            { type = "padding", val = 1 },
            dashboard.section.links,
            { type = "padding", val = 1 },
            dashboard.section.footer,
        }
        -- dashboard.config.layout = layoutSetting
        alpha.setup(dashboard.opts)

        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
    end,
}

local dashboard = {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
        local shortcut = {
            {
                icon = icons.Python,
                desc = " ",
                action = "Lazy update",
                key = "Py",
            },
            {
                icon = icons.Java,
                desc = " ",
                key = "Java",
            },
            {
                icon = icons.AWS,
                desc = " ",
                key = "AWS",
            },
            {
                icon = icons.Javascript,
                desc = " ",
                key = "JS",
            },
            {
                icon = icons.Docker,
                desc = " ",
                key = "Docker",
            },
            {
                icon = icons.Git,
                desc = " ",
                key = "Git",
            },
        }
        require("dashboard").setup({
            theme = "hyper",
            config = {
                header = dijub2,
                shortcut = shortcut,
            },
        })
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
}

return alphaDashboard
