-- Automatically run formatter on save
local function setup_format_on_save()
  local format_group = vim.api.nvim_create_augroup('FormatAutogroup', { clear = true })
  vim.api.nvim_create_autocmd('BufWritePost', {
    group = format_group,
    pattern = '*',
    command = 'FormatWrite'
  })
end

return {
  'mhartington/formatter.nvim',
  config = function()
    -- Keymaps
    vim.keymap.set('n', '<leader>f', function() vim.cmd('Format') end, { desc = '[F]ormat' })

    -- Initialize format on save
    setup_format_on_save()

    -- Utilities for creating configurations
    local util = require "formatter.util"

    -- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
    require("formatter").setup {
      -- Enable or disable logging
      logging = true,
      -- Set the log level
      log_level = vim.log.levels.WARN,
      -- All formatter configurations are opt-in
      filetype = {
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        lua = {
          -- "formatter.filetypes.lua" defines default configurations for the
          -- "lua" filetype
          require("formatter.filetypes.lua").stylua,

          -- You can also define your own configuration
          function()
            -- Supports conditional formatting
            if util.get_current_buffer_file_name() == "special.lua" then
              return nil
            end

            -- Full specification of configurations is down below and in Vim help
            -- files
            return {
              exe = "stylua",
              args = {
                "--search-parent-directories",
                "--stdin-filepath",
                util.escape_path(util.get_current_buffer_file_path()),
                "--",
                "-",
              },
              stdin = true,
            }
          end
        },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
          -- "formatter.filetypes.any" defines default configurations for any
          -- filetype
          require("formatter.filetypes.any").remove_trailing_whitespace
        }
      }
    }
  end
}
