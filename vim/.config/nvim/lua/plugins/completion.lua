return {
  {
    'saghen/blink.cmp',
    version = '1.*',
    opts = {
      keymap = { preset = 'default' },
      appearance = { nerd_font_variant = 'mono' },
      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true },
    },
    config = function(_, opts)
      local validate = vim.validate
      local supports_predicates = pcall(validate, 'blink_predicate', true, function(value)
        return value == true
      end)

      if vim.fn.has('nvim-0.11') == 1 and not supports_predicates then
        require('blink.cmp.config.utils')._validate = function(spec)
          return validate(spec)
        end
      end

      require('blink.cmp').setup(opts)
    end,
    opts_extend = { 'sources.default' },
  },
}
