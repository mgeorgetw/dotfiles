-- Lazy load Copilot on InsertEnter event
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
    })
  end,
})

