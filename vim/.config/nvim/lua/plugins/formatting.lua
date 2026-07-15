local prettier_filetypes = {
  'css',
  'html',
  'javascript',
  'javascriptreact',
  'json',
  'jsonc',
  'markdown',
  'typescript',
  'typescriptreact',
  'yaml',
}

local formatters_by_ft = {
  ['*'] = { 'trim_whitespace', 'trim_newlines' },
}

for _, filetype in ipairs(prettier_filetypes) do
  formatters_by_ft[filetype] = { 'prettier' }
end

return {
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { 'williamboman/mason.nvim', version = '1.11.0' },
    },
    opts = {
      ensure_installed = { 'prettier' },
      run_on_start = true,
      start_delay = 1000,
      debounce_hours = 24,
    },
  },
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'ConformInfo',
    keys = {
      {
        '<leader>F',
        function()
          require('conform').format({ async = true, lsp_format = 'never' })
        end,
        mode = { 'n', 'x' },
        desc = 'Format buffer',
      },
    },
    opts = {
      formatters_by_ft = formatters_by_ft,
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return {
          timeout_ms = 3000,
          lsp_format = 'never',
        }
      end,
      notify_on_error = true,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
}
