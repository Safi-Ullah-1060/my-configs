return {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
        -- nvim-treesitter.configs is the correct module —
        -- this is what registers highlight, indent and other modules
        require('nvim-treesitter').setup {
            -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
            install_dir = vim.fn.stdpath('data') .. '/site',
        }
        require('nvim-treesitter').install { 'c', 'cpp', 'python', 'bash', 'lua', 'regex' }
        vim.api.nvim_create_autocmd('FileType', {
            pattern = { 'cpp', 'c', 'py', 'sh', '.gitignore' },
            callback = function()
                vim.treesitter.start()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
