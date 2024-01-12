if has('nvim')
lua <<EOF
local status, null_ls = pcall(require, "null-ls")
if (not status) then return end

null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint_d.with({
      diagnostics_format = '[eslint] #{m}\n(#{c})'
    }),
    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.completion.luasnip,
    null_ls.builtins.code_actions.gitsigns,

    -- python
    null_ls.builtins.formatting.black.with({
      extra_args = { "--line-length=120" }
    }),
    null_ls.builtins.formatting.isort,
  }
})
EOF
endif
