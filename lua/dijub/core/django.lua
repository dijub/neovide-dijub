local function is_not_in_list(letter, list)
    local lower_letter = string.lower(letter) -- Converte a letra para minúscula
    for _, item in ipairs(list) do
        if string.lower(item) == lower_letter then
            return false -- Está presente na lista
        end
    end
    return true -- Não está presente na lista
end

local function djangoStartProject()
    local project_name = vim.fn.input("Enter project name: ", "myproject")
    vim.fn.mkdir(project_name)
    vim.fn.chdir(project_name)
    vim.fn.system("python -m venv .venv")

    local cmd1 = "source ./.venv/bin/activate"
    local cmd2 = "pip install pylint django"
    local cmd3 = "django-admin startproject " .. project_name .. " ."

    local cmd = cmd1 .. " && " .. cmd2 .. " && " .. cmd3

    vim.cmd("botright new")
    vim.fn.termopen(cmd, {
        on_exit = function()
            print("Project created successfully!")
            vim.cmd("e manage.py")
            vim.cmd(":NvimTreeFindFileToggl<CR>")
        end,
    })

    vim.cmd(":q")
end

local function newPythonProject()
    local framework_list = { "D", "F" }
    local libraries_default_dev = {
        "pytest",
        "pytest-cov",
        "ruff",
        "taskipy",
    }
    local libraries_default_doc = {
        "mkdocs-material",
        "mkdocstrings",
        "mkdocstrings-python",
    }

    local projectName = vim.fn.input("Project Name: ")
    local folderName = string.gsub(projectName, "-", "_")
    local framework = ""
    local exclude_cmd = ""
    local run_cmd = "python main.py"

    print("\nCreating Project ..\n")
    vim.fn.system("poetry new " .. projectName)
    vim.fn.chdir(projectName)

    local is_web = vim.fn.input("Web application?[Y/n]: ", "y")
    if string.lower(is_web) == "y" then
        framework = vim.fn.input("Select Framework [D]jango | [F]astAPI: ")

        if is_not_in_list(string.upper(framework), framework_list) then
            print("Framework is invalid!!")
            return
        end

        print("\nInstalling web dependencies ..")
        if string.upper(framework) == "D" then
            run_cmd = "python manage.py runserver"
            vim.fn.system("poetry add django")
            vim.fn.system("rm " .. folderName .. "/__init__.py")
            vim.fn.system("poetry run django-admin startproject " .. folderName .. " .")
            vim.cmd("e " .. "manage.py")
        end

        if string.upper(framework) == "F" then
            run_cmd = "fastapi dev " .. folderName .. "/main.py"
            exclude_cmd = "migrations"
            vim.fn.system("poetry add 'fastapi[standard]'")
            vim.fn.system("poetry add 'pydantic'")
            vim.fn.system("poetry add 'sqlalchemy'")
            vim.fn.system("poetry add 'alembic'")
            vim.fn.system("poetry add 'pydantic-settings'")
            vim.fn.system("touch " .. folderName .. "/main.py")
            vim.cmd("e " .. folderName .. "/main.py")
        end
    else
        vim.fn.system("touch " .. "main.py")
        vim.cmd("e " .. "main.py")
    end

    print("\nInstalling dev dependencies ..")

    for i, lib in pairs(libraries_default_dev) do
        vim.fn.system("poetry add --group dev " .. lib)
    end

    print("Installing doc dependencies ..")

    for i, lib in pairs(libraries_default_doc) do
        vim.fn.system("poetry add --group doc " .. lib)
    end

    print("Setting config..")

    local config = {
        "",
        "[tool.pytest.ini_options]",
        'pythonpath = "."',
        'addopts = "-p no:warnings"',
        "",
        "[tool.ruff]",
        'extend-exclude = ["' .. exclude_cmd .. '"]',
        "line-length = 79",
        "",
        "[tool.ruff.lint]",
        "preview = true",
        'select = ["I", "F", "E", "W", "PL", "PT"]',
        "",
        "[tool.ruff.format]",
        "preview = true",
        'quote-style= "single"',
        "",
        "[tool.taskipy.tasks]",
        'docs = "mkdocs serve"',
        'lint = "ruff check .; ruff check . --diff"',
        'format = "ruff check . --fix; ruff format ."',
        'run = "' .. run_cmd .. '"',
        'pre_test = "task lint"',
        'test = "pytest -s -x  --cov=' .. folderName .. ' -vv"',
        'post_test = "coverage html"',
    }
    local config_str = table.concat(config, "\n")

    vim.fn.system("echo '" .. config_str .. "' >> pyproject.toml")

    vim.fn.system("ignr -p python > .gitignore")
    vim.fn.system("git init")
    vim.fn.system("poetry shell")

    vim.cmd(":NvimTreeFindFileToggl")
    local python_path = vim.fn.trim(vim.fn.system("poetry run which python"))
    require("venv-selector").activate_from_path(python_path)
end

vim.api.nvim_create_user_command("PythonCreateProject", newPythonProject, {})

vim.api.nvim_create_user_command("DjangoStartProject", djangoStartProject, {})
