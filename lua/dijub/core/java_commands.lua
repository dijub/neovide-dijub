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

local function javaMavenProject()
    local groupId = vim.fn.input("Group id: ")
    local artifactId = vim.fn.input("Artifact Id: ")
    local cmd = "mvn archetype:generate -DgroupId="
        .. groupId
        .. " "
        .. "-DartifactId="
        .. artifactId
        .. " "
        .. "-Dpackaging=jar -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false"

    local output = vim.fn.system(cmd)
    if vim.v.shell_error ~= 0 then
        print("Erro ao executar: " .. output)
    else
        vim.fn.chdir(artifactId)
        local subdir = groupId:gsub("%.", "/")
        local cmd2 = "src/main/java/" .. subdir .. "/App.java"
        vim.cmd("e " .. cmd2)
        vim.cmd(":NvimTreeFindFileToggl<CR>")
    end
end

local function javaMavenCompile()
    local output = vim.fn.system("mvn compile")
    if vim.v.shell_error ~= 0 then
        print("Erro ao executar: " .. output)
    else
        print(output)
    end
end

local function javaMavenRun()
    local pathJava = vim.fn.system("fd -I App.java")
    pathJava = pathJava:gsub("\n", "")
    local mainFile = pathJava:gsub("src/main/java/", "")
    mainFile = mainFile:gsub("%.java", "")
    mainFile = mainFile:gsub("/", ".")

    local output = vim.fn.system('mvn exec:java -Dexec.mainClass="' .. mainFile .. '"')
    if vim.v.shell_error ~= 0 then
        print("Erro ao executar: " .. output)
    else
        print(output)
    end
end

-- mvn exec:java -Dexec.mainClass="com.jpaproject.App"
local function javaMavenInstallDependencies()
    local command = "mvn clean install"
    vim.cmd("botright new")
    vim.fn.termopen(command, {
        on_exit = function()
            print("Project created successfully!")
        end,
    })
end

local function javaSpringRun()
    local command = "./mvnw spring-boot:run"
    vim.cmd("botright new")
    vim.fn.termopen(command, {
        on_exit = function()
            print("Project created successfully!")
        end,
    })
end

vim.api.nvim_create_user_command("JavaCreateProject", newJavaProject, {})
vim.api.nvim_create_user_command("JavaCompile", javaCompile, {})
vim.api.nvim_create_user_command("JavaRun", javaRun, {})
vim.api.nvim_create_user_command("JavaMavenCreateProject", javaMavenProject, {})
vim.api.nvim_create_user_command("JavaMavenCompile", javaMavenCompile, {})
vim.api.nvim_create_user_command("JavaMavenInstallDependencies", javaMavenInstallDependencies, {})
vim.api.nvim_create_user_command("JavaMavenRun", javaMavenRun, {})
vim.api.nvim_create_user_command("JavaSpringRun", javaSpringRun, {})
