local options =
{
    on_init = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
    end,
    init_options = {
        cmd = {'ccls'},
        filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
        index = {
            threads = 4,
            initialBlacklist = {".cmake", "/jni/", "DerivedData"},
        },
        diagnostic = {
            onChange = 0,
        },
        completion = {
            caseSensitivity = 1,
        },
        cache = {
            retainInMemory = 0,
        },
        highlight = {
            rainbow = 10,
        },
    }

}
return options
