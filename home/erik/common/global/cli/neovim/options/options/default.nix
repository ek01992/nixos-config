{
  programs.neovim.extraLuaConfig =
    /*
    lua
    */
    ''
      -- General
      vim.opt.undofile = true -- Enable persistent undo
      vim.opt.numberwidth = 4 -- Number of columns to use for the line number
      vim.opt.compatible = false -- Vi compatibility setting
      vim.opt.mouse = "nv" -- Disable mouse in command-line mode
      vim.opt.synmaxcol = 2500 -- Don't syntax highlight long lines
      vim.opt.history = 2000 -- Size of history to retain
      vim.opt.clipboard = "unnamedplus" -- Use unnamed clipboard
      vim.opt.splitbelow = true -- Always stplit to the bottom
      vim.opt.splitright = true -- Always split to the right
      vim.opt.switchbuf = "uselast" -- Jump to the last open window
      vim.opt.re = 0 -- Regex engine
      vim.opt.showcmd = false -- Show command in status line
      vim.opt.autoread = true -- Autoread on third party changes
      vim.opt.autowrite = true -- Save on buffer leave
      vim.opt.autowriteall = true -- Save on buffer leave
      vim.opt.modeline = false -- Disable modeline
      vim.opt.swapfile = false -- Disable swap file
      vim.opt.backup = false -- Don't create backup file
      vim.opt.writebackup = false -- Don't allow editing files open by other programs
      vim.opt.completeopt = { "menuone", "noselect" } -- Always show menu, even for one item

      -- Formatting
      vim.opt.iskeyword:append("-") -- Treat words with `-` as single words
      vim.opt.fillchars.eob = " " -- Show empty lines at the end of a buffer as ` ` {default `~`}
      vim.opt.fileencoding = "utf-8" -- File encoding
      vim.opt.wrap = false -- Disable text wrapping
      vim.opt.textwidth = 80 -- Set text width
      vim.opt.conceallevel = 0 -- So that `` is visible in markdown files
      vim.opt.linebreak = true -- Break long lines at 'breakat'
      vim.opt.formatoptions:remove({ "c", "r", "o" }) --
      -- vim.opt.formatoptions:append({ "t" }) -- Enable wrapping
      vim.opt.whichwrap:append("h,l,<,>,[,],~") --Move to following line on specified keys

      -- Searching
      vim.opt.ignorecase = true -- Search ignoring case
      vim.opt.smartcase = true -- Keep case when searching with *
      vim.opt.infercase = true -- Adjust case in insert completion mode
      vim.opt.incsearch = true -- Incremental search
      vim.opt.wrapscan = true -- Searches wrap around the end of the file

      -- Tabs & Indents
      vim.opt.expandtab = true -- Expand tabs to spaces
      vim.opt.tabstop = 4 -- The number of spaces a tab is
      vim.opt.shiftwidth = 4 -- Number of spaces to use in auto(indent)
      vim.opt.smarttab = true -- Tab insert blanks according to 'shiftwidth'
      vim.opt.autoindent = true -- Use same indenting on new lines
      vim.opt.smartindent = true -- Smart autoindenting on new lines
      vim.opt.shiftround = true -- Round indent to multiple of 'shiftwidth'
      vim.opt.foldenable = false -- Disable automatic folding
      vim.opt.foldmethod = "indent" -- Set folding method

      -- Timing
      vim.opt.timeout = true -- Configure timeouts
      vim.opt.ttimeout = true -- Configure timeouts
      vim.opt.timeoutlen = 300 -- Time out on mappings
      vim.opt.ttimeoutlen = 10 -- Time out on key codes
      vim.opt.updatetime = 200 -- Idle time to write swap and trigger CursorHold
      vim.opt.redrawtime = 1500 -- Time in milliseconds for stopping display redraw

      -- Editor UI
      vim.opt.termguicolors = true -- Enable terminal GUI colors
      vim.opt.cursorline = true -- Line highglight visibility
      vim.opt.cursorcolumn = false -- Column highlight visibility
      vim.opt.showmode = true -- Mode visibility
      vim.opt.shortmess:append("c") -- hide all the completion messages, e.g. "-- XXX completion (YYY)", "match 1 of 2", "The only match", "Pattern not found"
      vim.opt.scrolloff = 2 -- Keep at least 2 lines above/below
      vim.opt.sidescrolloff = 5 -- Keep at least 5 lines left/right
      vim.opt.ruler = false -- Disable default status ruler
      vim.opt.list = false -- Don't show hidden characters
      vim.opt.hlsearch = true -- Search highlight

      vim.opt.showtabline = 0 -- Tabline visibility
      vim.opt.helpheight = 12 -- Minimum help window height
      vim.opt.winwidth = 30 -- Minimum width for active window
      vim.opt.winminwidth = 10 -- Minimum width for inactive windows
      vim.opt.winheight = 1 -- Minimum height for active window
      vim.opt.winminheight = 1 -- Minimum height for inactive window

      vim.opt.showcmd = true -- Command visibility in status line
      vim.opt.cmdheight = 1 -- Command line height
      vim.opt.cmdwinheight = 5 -- Command line lines
      vim.opt.equalalways = false -- Don't resize windows on split or close
      vim.opt.laststatus = 3 -- Status line visibility
      vim.opt.signcolumn = "yes" -- Sign column visibility
      vim.opt.colorcolumn = "" -- Colur column width at textwidth limit
      vim.opt.pumheight = 15 -- Popup menu height

      vim.cmd([[ set nu rnu ]]) -- Relative line numbers
    '';
}
