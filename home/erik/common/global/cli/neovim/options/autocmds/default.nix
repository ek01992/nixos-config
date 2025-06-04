{
  programs.neovim.extraLuaConfig =
    /*
    lua
    */
    ''
      -- Use 'q' to quit from common plugins
      vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
          callback = function()
              vim.cmd([[
                  nnoremap <silent> <buffer> q :close<CR>
                  set nobuflisted
              ]])
          end,
      })

      -- Set wrap and spell in markdown and gitcommit
      vim.api.nvim_create_autocmd({ "FileType" }, {
          pattern = { "gitcommit", "markdown" },
          callback = function()
              vim.opt_local.textwidth = 72
              vim.opt_local.wrap = true
              vim.opt_local.spell = true
          end,
      })

      -- Automatically close tab/Vim when NvimTree is the last window
      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        nested = true,
        callback = function()
            if vim.fn.winnr("$") == 1 and vim.fn.bufname() == "NvimTree_" .. vim.fn.tabpagenr() then
                vim.cmd("quit")
            end
        end,
      })

      -- Show diagnostic tooltip automatically on CursorHold
      vim.api.nvim_create_autocmd("CursorHold", {
          pattern = "*",
          callback = function()
              vim.diagnostic.open_float(nil, { focusable = false })
          end,
      })

      -- Resize splits in all tabs
      vim.api.nvim_create_autocmd({ "VimResized" }, {
          callback = function()
              vim.cmd("tabdo wincmd =")
          end,
      })

      -- Highlight yanked text
      vim.api.nvim_create_autocmd({ "TextYankPost" }, {
          callback = function()
              vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
          end,
      })

      -- Disable Illuminate in large files
      vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
          callback = function()
              local line_count = vim.api.nvim_buf_line_count(0)
              if line_count >= 5000 then
                  vim.cmd("IlluminatePauseBuf")
              end
          end,
      })

      vim.api.nvim_create_autocmd({ "VimEnter" }, {
          callback = function()
              vim.cmd("hi link illuminatedWord LspReferenceText")
          end,
      })
    '';
}
