local function getPackageJava(javaClass)
    local javaClassName = javaClass .. ".class"
    local pathJavaClass = vim.fn.system("fd -I " .. javaClassName)
    pathJavaClass = pathJavaClass:gsub("bin/", "")
    pathJavaClass = pathJavaClass:gsub(".class", "")
    local packageName = pathJavaClass:gsub("/", ".")

    return packageName
end

local function isFolderExists(path)
    local cmd = string.format("ls '%s'", path)
    local status = os.execute(cmd)
    return status and status == 0
end

local function isFolderEmpty(path)
    local cmd = string.format("ls -A '%s'", path)
    local files = vim.fn.system(cmd)
    return string.len(files) == 0
end

local function newJavaProject()
    local folderName = vim.fn.input("Project Name: ")
    vim.fn.mkdir(folderName .. "/src/application", "p")
    vim.fn.mkdir(folderName .. "/bin", "p")
    vim.fn.mkdir(folderName .. "/libraries", "p")
    vim.fn.system("touch " .. folderName .. "/src/application/Program.java")

    vim.fn.chdir(folderName)
    vim.cmd("e src/application/Program.java")
    vim.cmd(":NvimTreeFindFileToggl<CR>")
end

local function javaCompile()
    local file = vim.fn.expand("%:p")
    local jar_path = '"libraries/*"' -- Inclui todos os JARs na pasta

    local compile_cmd = ""
    if isFolderExists("libraries") and not isFolderEmpty("libraries") then
        compile_cmd = "javac -d bin -cp " .. jar_path .. " --source-path src " .. file
    else
        compile_cmd = "javac -d bin --source-path src " .. file
    end

    local output = vim.fn.system(compile_cmd)
    if vim.v.shell_error ~= 0 then
        print("Compile Error: " .. output)
    else
        print("Compile Successfull " .. file)
    end
end

local function javaRun()
    local fileClean = vim.fn.expand("%:t:r")
    local file = getPackageJava(fileClean)

    local jar_path = "libraries/*"
    local run_cmd = ""
    if isFolderExists("libraries") and not isFolderEmpty("libraries") then
        run_cmd = "java -cp " .. '"' .. jar_path .. ':bin" ' .. file
        print(run_cmd)
    else
        run_cmd = "java -cp bin " .. file
    end

    local output = vim.fn.system(run_cmd)
    if vim.v.shell_error ~= 0 then
        print("Erro ao executar: " .. output)
    else
        print(output)
    end
end

vim.api.nvim_create_user_command("JavaCreateProject", newJavaProject, {})
vim.api.nvim_create_user_command("JavaCompile", javaCompile, {})
vim.api.nvim_create_user_command("JavaRun", javaRun, {})
