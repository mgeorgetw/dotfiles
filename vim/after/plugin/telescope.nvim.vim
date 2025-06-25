if has('nvim')
lua <<EOF
 -- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
local status, telescope = pcall(require, "telescope")
if (not status) then return end

local builtin = require("telescope.builtin")

local function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    
    file_browser = {
      theme = "ivy",
      hijack_netrw = true,
    },

    ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }
    }
  }
})

telescope.load_extension('fzf')
telescope.load_extension('file_browser')
telescope.load_extension('ui-select')

-- keymaps
vim.keymap.set('n', ' ff',
  function()
    builtin.find_files({
      no_ignore = false,
      hidden = true
    })
  end)
vim.keymap.set('n', ' fg', function()
  builtin.live_grep()
end)
vim.keymap.set('n', ' fb', function()
  builtin.buffers()
end)
vim.keymap.set('n', ' fh', function()
  builtin.help_tags()
end)
vim.keymap.set('n', ' fe', function()
  builtin.diagnostics()
end)
vim.keymap.set("n", "<c-e>", function()
	require("telescope").extensions.file_browser.file_browser()
end)
EOF

" Using Lua functions
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
endif
