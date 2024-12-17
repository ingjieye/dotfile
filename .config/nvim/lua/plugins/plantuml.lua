-- PlantUML settings
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'plantuml',
    callback = function()
        local cmd = "cat `which plantuml` | grep plantuml.jar"
        local output = vim.fn.system(cmd)
        local jar_path = vim.fn.matchlist(output, [[\v.*\s['"]?(\S+plantuml\.jar).*]])[2]
        vim.b.plantuml_previewer_plantuml_jar_path = jar_path
    end
}) 