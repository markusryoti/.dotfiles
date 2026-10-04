-- Java buffer setup.
--
-- Unlike every other language in this config, jdtls is not started by
-- vim.lsp.enable() (see lua/plugins/lsp.lua): it needs its own -data workspace
-- per project, the Lombok javaagent, and extendedClientCapabilities. So
-- nvim-jdtls starts a client here instead, once per buffer.

-- Java convention is 4 spaces; the global default is 2 (lua/config/options.lua).
vim.bo.expandtab = true
vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.softtabstop = 4

local ok, jdtls = pcall(require, "jdtls")
if not ok then
  return
end

local mason = vim.fn.stdpath("data") .. "/mason"

-- Two-tier root resolution, matching nvim-lspconfig's own lsp/jdtls.lua.
-- vim.fs.root tries each marker in order and a marker may itself be a list, so
-- the first group wins outright: wrappers and settings files mark the top of a
-- multi-module build and must beat a nested module's own pom.xml. `.git` is the
-- last resort because in a multi-module Maven tree there is no reliable way to
-- tell a parent directory from a submodule one.
local root = vim.fs.root(0, {
  { "mvnw", "gradlew", "settings.gradle", "settings.gradle.kts", ".git" },
  { "pom.xml", "build.gradle", "build.gradle.kts", "build.xml" },
}) or vim.fs.dirname(vim.api.nvim_buf_get_name(0)) -- lone .java file, no project

-- One -data dir per project; sharing one mixes their indexes together. Projects
-- with the same directory name collide -- :JdtWipeDataAndRestart if that bites.
local workspace = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. vim.fn.fnamemodify(root, ":p:h:t")

-- A repo that builds with neither Maven nor Gradle -- an AOSP/Soong tree, Bazel,
-- a bare source dir -- gives jdtls no build descriptor to import, so it falls
-- back to an "invisible project" with an empty classpath and flags every import
-- as a missing symbol. Such a repo can drop a .jdtls.json at its root naming its
-- source roots, jars and output dir (java.project.sourcePaths /
-- referencedLibraries / outputPath); merging it over the defaults below lets the
-- project win key by key while leaving everything it does not mention alone.
local function with_project_settings(base)
  local file = root .. "/.jdtls.json"
  if vim.fn.filereadable(file) == 0 then
    return base
  end
  local ok, project = pcall(vim.json.decode, table.concat(vim.fn.readfile(file), "\n"))
  if not ok or type(project) ~= "table" then
    -- Degrade to the defaults rather than breaking every Java buffer in the repo.
    vim.notify("jdtls: ignoring " .. file .. ": " .. tostring(project), vim.log.levels.WARN)
    return base
  end
  return vim.tbl_deep_extend("force", base, project)
end

jdtls.start_or_attach({
  cmd = {
    mason .. "/bin/jdtls",
    "-data",
    workspace,
    -- Mason ships lombok.jar alongside jdtls. Without the agent, jdtls reports
    -- every Lombok-generated getter and setter as a missing symbol.
    "--jvm-arg=-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
    -- The launcher sets -Xms1G but leaves -Xmx at the JVM default (a quarter of
    -- physical RAM). Capping it keeps a big project's JDT index build from
    -- ballooning, and the throughput collector is what upstream recommends for
    -- jdtls's allocation pattern.
    "--jvm-arg=-Xmx2g",
    "--jvm-arg=-XX:+UseParallelGC",
    "--jvm-arg=-XX:GCTimeRatio=4",
    "--jvm-arg=-XX:AdaptiveSizePolicyWeight=90",
    "--jvm-arg=-Dsun.zip.disableMemoryMapping=true",
  },
  root_dir = root,
  -- The vim.lsp.config("*") block in lua/plugins/lsp.lua only reaches servers
  -- started by vim.lsp.enable(); nvim-jdtls calls vim.lsp.start directly, so
  -- blink's capabilities have to be passed by hand here. Neovim deep-merges
  -- make_client_capabilities() underneath this, so nothing is lost.
  capabilities = require("blink.cmp").get_lsp_capabilities(),
  init_options = {
    -- Unlocks the decompiler, progress reports, and the advanced extract /
    -- organize-imports actions. start_or_attach does not set this itself.
    extendedClientCapabilities = jdtls.extendedClientCapabilities,
  },
  settings = with_project_settings({
    java = {
      configuration = {
        updateBuildConfiguration = "interactive",
        -- Lets a project's pom/build.gradle target an older release instead of
        -- silently compiling against whichever JVM jdtls happens to run on.
        runtimes = {
          {
            name = "JavaSE-21",
            path = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home",
            default = true,
          },
          {
            name = "JavaSE-26",
            path = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home",
          },
        },
      },
      eclipse = { downloadSources = true },
      maven = { downloadSources = true },
      references = { includeDecompiledSources = true },
      signatureHelp = { enabled = true },
      format = { enabled = true }, -- conform's lsp_format = "fallback" routes here
      inlayHints = { parameterNames = { enabled = "all" } },
      completion = {
        importOrder = { "java", "javax", "com", "org" },
        favoriteStaticMembers = {
          "org.junit.jupiter.api.Assertions.*",
          "org.mockito.Mockito.*",
          "org.assertj.core.api.Assertions.*",
          "java.util.Objects.requireNonNull",
        },
      },
      -- Keep imports explicit; the default collapses to `import x.*` at 99.
      sources = { organizeImports = { starThreshold = 9999, staticStarThreshold = 9999 } },
      codeGeneration = { useBlocks = true, hashCodeEquals = { useJava7Objects = true } },
    },
  }),
})

-- Buffer-local, like the `gd` map in lua/config/autocmds.lua: these only exist
-- where jdtls is attached. Neovim 0.11 already provides grn/gra/grr/gri/K, and
-- <leader>c is which-key's "code" group (lua/plugins/ui.lua), where <leader>cf
-- already formats.
local map = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { buffer = 0, desc = desc })
end

map("n", "<leader>co", jdtls.organize_imports, "Organize imports")
map("n", "<leader>cv", jdtls.extract_variable, "Extract variable")
map("n", "<leader>cc", jdtls.extract_constant, "Extract constant")
map("n", "<leader>cs", jdtls.super_implementation, "Go to super implementation")
map("x", "<leader>cv", function()
  jdtls.extract_variable({ visual = true })
end, "Extract variable")
map("x", "<leader>cc", function()
  jdtls.extract_constant({ visual = true })
end, "Extract constant")
map("x", "<leader>cm", function()
  jdtls.extract_method({ visual = true })
end, "Extract method")
