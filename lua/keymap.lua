-- filetree
vim.keymap.set('n', '<leader>cd', vim.cmd.Ex)

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- search results in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- join line
vim.keymap.set("n", "<C-j>", "J")

-- visual mode
-- vim.keymap.set("v", "q", "<Esc>") -> maybe complications with other maps
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("v", "/", "\"ay/<C-r>a<CR>")

-- greatest remap ever ('theprimeagen')
vim.keymap.set("x", "<leader>p", "\"_dP")

-- yank into system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- delete into void
vim.keymap.set("n", "<leader>d", "\"_d")
vim.keymap.set("v", "<leader>d", "\"_d")

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- open signature help
vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help)
vim.keymap.set('n', '<C-s>', vim.lsp.buf.signature_help)

-- quicknote
vim.keymap.set('n', '<leader>nc',
  function()
    require('quicknote').NewNoteAtCurrentLine()
  end,
  { desc = 'Creates a new node at the current line and enables the sign' }
)
vim.keymap.set('n', '<leader>no',
  function()
    require('quicknote').OpenNoteAtCurrentLine()
  end,
  { desc = 'Opens the note of the current line' }
)
vim.keymap.set('n', '<leader>nd',
  function()
    require('quicknote').DeleteNoteAtCurrentLine()
  end,
  { desc = 'Deletes the note of the current line' }
)
vim.keymap.set('n', '<leader>nl',
  function()
    require('quicknote').ListNotesForCurrentBuffer()
  end,
  { desc = 'Lists the notes for the current buffer' }
)
vim.keymap.set('n', '<leader>nt',
  function()
    require('quicknote').ToggleNoteSigns()
  end,
  { desc = 'Toggles the visibility of the note signs' }
)
