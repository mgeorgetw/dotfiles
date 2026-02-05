-- In your lua settings file:
local function enable_ai()
  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      text = false,
      markdown = false,
      help = false,
      gitcommit = false,
      ["*"] = true,
    },
  })
  print("AI Powerhouse Active")
end

-- Create a user command you can run manually
vim.api.nvim_create_user_command("AIOn", enable_ai, {})
