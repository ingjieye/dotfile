require("neotest").setup({
    adapters = {
        require("neotest-gtest").setup({
            debug_adapter = "lldb",
        })
    },
    discovery = {
        -- Drastically improve performance in ginormous projects by
        -- only AST-parsing the currently opened buffer.
        enabled = false,
        -- Number of workers to parse files concurrently.
        -- A value of 0 automatically assigns number based on CPU.
        -- Set to 1 if experiencing lag.
        concurrent = 1,
    },
    running = {
        -- Run tests concurrently when an adapter provides multiple commands to run.
        concurrent = true,
    },
    summary = {
        -- Enable/disable animation of icons.
        animated = false,
    },
    icons = {
        passed = "✅",
        running = "⏳",
        failed = "❌",
        skipped = "⏭️",
        unknown = "❓",
    },
    highlights = {
        passed = "@character",
        running = "@bollean",
    }
})
