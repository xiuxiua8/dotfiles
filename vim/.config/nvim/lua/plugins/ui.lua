local colors = {
  bg = '#262626',
  text = '#bcbcbc',
  muted = '#8a8a8a',
  yellow = '#E7DC6D',
  green = '#A4E400',
  purple = '#AC7CFF',
  pink = '#FC1A70',
  cyan = '#62D8F1',
}

local mode_accents = {
  normal = colors.green,
  insert = colors.cyan,
  visual = colors.purple,
  replace = colors.pink,
  command = colors.yellow,
  terminal = colors.cyan,
  inactive = colors.muted,
}

local mode_backgrounds = {
  normal = '#30351F',
  insert = '#20343A',
  visual = '#31283D',
  replace = '#3A2330',
  command = '#38351F',
  terminal = '#20343A',
  inactive = '#2C2C2C',
}

return {
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    opts = function()
      local function mode(accent, background)
        return {
          a = { fg = accent, bg = background, gui = 'bold' },
          b = { fg = colors.text, bg = background },
          c = { fg = colors.text, bg = background },
          x = { fg = colors.text, bg = background },
          y = { fg = colors.text, bg = background },
          z = { fg = colors.text, bg = background },
        }
      end

      local function window_width()
        return vim.fn.winwidth(0)
      end

      local function at_least(minimum)
        return function()
          return window_width() >= minimum
        end
      end

      local function below(maximum)
        return function()
          return window_width() < maximum
        end
      end

      local function adaptive_mode(name)
        return window_width() < 52 and name:sub(1, 1) or name
      end

      local function workspace()
        return vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
      end

      local function formatter_status()
        local conform = package.loaded.conform
        if not conform then
          return ''
        end

        local names = {}
        for _, formatter in ipairs(conform.list_formatters(0)) do
          if formatter.available then
            names[#names + 1] = formatter.name
          end
        end
        return table.concat(names, ',')
      end

      local function file_format()
        local encoding = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
        return encoding:upper() .. ' · ' .. vim.bo.fileformat:upper()
      end

      return {
        options = {
          theme = {
            normal = mode(mode_accents.normal, mode_backgrounds.normal),
            insert = mode(mode_accents.insert, mode_backgrounds.insert),
            visual = mode(mode_accents.visual, mode_backgrounds.visual),
            replace = mode(mode_accents.replace, mode_backgrounds.replace),
            command = mode(mode_accents.command, mode_backgrounds.command),
            terminal = mode(mode_accents.terminal, mode_backgrounds.terminal),
            inactive = mode(mode_accents.inactive, mode_backgrounds.inactive),
          },
          icons_enabled = true,
          component_separators = { left = '│', right = '│' },
          section_separators = { left = '', right = '' },
          globalstatus = false,
          refresh = {
            events = {
              'WinEnter',
              'BufEnter',
              'BufWritePost',
              'SessionLoadPost',
              'FileChangedShellPost',
              'VimResized',
              'WinResized',
              'Filetype',
              'CursorMoved',
              'CursorMovedI',
              'ModeChanged',
            },
          },
        },
        sections = {
          lualine_a = {
            {
              'mode',
              component_name = 'adaptive_mode',
              icon = '▊',
              fmt = adaptive_mode,
            },
          },
          lualine_b = {
            {
              workspace,
              component_name = 'adaptive_workspace',
              cond = at_least(160),
              color = { fg = colors.purple },
            },
            {
              'branch',
              component_name = 'adaptive_branch',
              cond = at_least(68),
              color = { fg = colors.yellow },
            },
            {
              'diff',
              component_name = 'adaptive_diff',
              cond = at_least(98),
              symbols = { added = '+', modified = '~', removed = '-' },
            },
          },
          lualine_c = {
            {
              'filename',
              component_name = 'adaptive_filename_short',
              cond = below(106),
              path = 0,
              shorting_target = 24,
              symbols = { modified = '●', readonly = '[-]' },
            },
            {
              'filename',
              component_name = 'adaptive_filename_path',
              cond = at_least(106),
              path = 1,
              shorting_target = 80,
              symbols = { modified = '●', readonly = '[-]' },
            },
          },
          lualine_x = {
            {
              'diagnostics',
              component_name = 'adaptive_errors',
              cond = at_least(56),
              sections = { 'error' },
              symbols = { error = 'E' },
            },
            {
              'diagnostics',
              component_name = 'adaptive_warnings',
              cond = at_least(62),
              sections = { 'warn' },
              symbols = { warn = 'W' },
            },
            {
              'lsp_status',
              component_name = 'adaptive_lsp',
              cond = at_least(116),
              icon = '󰒋',
              color = { fg = colors.cyan },
            },
            {
              formatter_status,
              component_name = 'adaptive_formatter',
              cond = at_least(132),
              icon = '✓',
              color = { fg = colors.green },
            },
            {
              'filetype',
              component_name = 'adaptive_filetype',
              cond = at_least(144),
              colored = false,
            },
            {
              file_format,
              component_name = 'adaptive_file_format',
              cond = at_least(170),
              color = { fg = colors.muted },
            },
          },
          lualine_y = {
            {
              'progress',
              component_name = 'adaptive_progress',
              cond = at_least(84),
              color = { fg = colors.purple },
            },
          },
          lualine_z = {
            {
              'location',
              component_name = 'adaptive_location',
              color = { fg = colors.purple },
            },
          },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { 'filename', path = 0, symbols = { modified = '●', readonly = '[-]' } },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
      }
    end,
  },
  {
    'folke/which-key.nvim',
    lazy = false,
    opts = {},
  },
}
