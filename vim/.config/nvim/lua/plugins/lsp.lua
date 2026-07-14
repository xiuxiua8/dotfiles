local servers = {
  'bashls',
  'clangd',
  'cssls',
  'eslint',
  'gopls',
  'html',
  'jsonls',
  'lemminx',
  'lua_ls',
  'pyright',
  'rust_analyzer',
  'stylelint_lsp',
  'ts_ls',
  'vimls',
  'yamlls',
}

local function configure_lsp_keymaps()
  local group = vim.api.nvim_create_augroup('native_lsp_keymaps', { clear = true })
  vim.api.nvim_create_autocmd('LspAttach', {
    group = group,
    callback = function(event)
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
      end

      map('n', 'gr', vim.lsp.buf.references, 'References')
      map('n', 'gi', vim.lsp.buf.implementation, 'Go to implementation')
      map('n', 'K', vim.lsp.buf.hover, 'Hover documentation')
      map('n', '<leader>rn', vim.lsp.buf.rename, 'Rename symbol')
      map({ 'n', 'x' }, '<leader>ca', vim.lsp.buf.code_action, 'Code action')
    end,
  })
end

return {
  {
    'williamboman/mason-lspconfig.nvim',
    version = '1.32.0',
    dependencies = {
      { 'williamboman/mason.nvim', version = '1.11.0', opts = {} },
      { 'neovim/nvim-lspconfig', version = '1.8.0' },
      'saghen/blink.cmp',
    },
    config = function()
      -- This machine reports 0.11 but predates the finalized 0.11 Lua APIs.
      if not vim.lsp.config then
        require('mason-core.platform').cached_features['nvim-0.11'] = 0
      end

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      local lspconfig = require('lspconfig')

      require('mason-lspconfig').setup({
        ensure_installed = servers,
        automatic_installation = true,
      })

      for _, server in ipairs(servers) do
        local options = { capabilities = capabilities }
        if server == 'lua_ls' then
          options.settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              runtime = { version = 'LuaJIT' },
              telemetry = { enable = false },
            },
          }
        end
        lspconfig[server].setup(options)
      end

      configure_lsp_keymaps()
    end,
  },
}
