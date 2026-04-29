-- Built-in treesitter highlight + folding (no nvim-treesitter plugin).
-- Parsers (.so) and queries (highlights.scm, etc.) are loaded from
-- ~/.local/share/nvim/site/{parser,queries}/ which are part of the standard
-- runtimepath, so this works without any plugin.
--
-- To add a new language: drop its parser into ~/.local/share/nvim/site/parser/
-- and its queries into ~/.local/share/nvim/site/queries/<lang>/.

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('builtin_treesitter', { clear = true }),
    callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang or not pcall(vim.treesitter.start, buf, lang) then
            return
        end
        vim.wo.foldmethod = 'expr'
        vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        vim.wo.foldenable = false
    end,
})
