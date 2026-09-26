return {
  {
    'patstockwell/vim-monokai-tasty',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.vim_monokai_tasty_italic = 0
      vim.g.vim_monokai_tasty_machine_tint = 0
      vim.g.vim_monokai_tasty_highlight_active_window = 0
      vim.cmd.colorscheme('vim-monokai-tasty')
      vim.api.nvim_set_hl(0, 'SnacksPickerDir', { fg = '#8a8a8a' })
    end,
  },
}
