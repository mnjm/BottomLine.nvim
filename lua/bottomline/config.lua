--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline/config.lua
-- License - Refer github

local M = {}

-- default configurations
local default_config = {
    enable = true,
    enable_icons = false,
    seperators = { '', '' },              -- seperators icons
    -- seperators = { '',  '' },
    -- seperators = { '',  '' },
    enable_git = true,                    -- enable git section
    enable_lsp = true,                    -- enable lsp section
    display_buf_no = false,               -- add additional buf number section at the end of statusline
    center_file_path = true,              -- display file path in center
    git_symbols = {
        branch = "",
        added = "+",
        removed = "-",
        changed = "~",
    },
    lsp_symbols = {
        error = "E:",
        warn = "W:",
        info = "I:",
        hint = "H:",
    },
    -- bottomline highlights
    highlights = {
        -- Active Statusline
        BLMode          = {fg = "#000000", bg = "#5faf5f", bold = true},
        BLGitInfo       = {fg = "#000000", bg="#5f8787", bold = false},
        BLFill          = {fg = "#ffffff", bg="#282828", bold = false},
        BLFile          = {link = 'BLMode'},
        BLLspInfo       = {link = 'BLGitInfo'},
        BLFileType      = {fg = "#ffffff", bg = "#878787", bold = false},
        BLLine          = {fg = "#ffffff", bg="#585858", bold = false},
        BLBuf           = {link = 'BLMode'},
        -- Inactive statusline
        BLFileInactive  = {link = 'BLFileType'},
        BLBufInactive   = {link = 'BLFileInactive'},
    },
}

-- config validator
-- @param cfg config to validate
local validate_config = function(cfg)
    vim.validate({ enable = { cfg.enable, "boolean" } })
    vim.validate({ enable_icons = { cfg.enable_icons, "boolean" } })
    vim.validate({ highlights = { cfg.highlights, "table" } })
    vim.validate({ seperators = { cfg.seperators, "table" } })
    vim.validate({ git_symbols = { cfg.git_symbols, "table" } })
    vim.validate({ lsp_symbols = { cfg.lsp_symbols, "table" } })
    vim.validate({ enable_git = { cfg.enable_git, "boolean" } })
    vim.validate({ enable_lsp = { cfg.enable_lsp, "boolean" } })
    vim.validate({ display_buf_no = { cfg.display_buf_no, "boolean" } })
end

-- initialize config
-- @param cfg custom config from setup call
M.init_config = function(user_cfg)
    -- if not not passed create a empty table
    user_cfg = user_cfg or {}
    vim.validate({ cfg = { user_cfg, 'table' } })
    -- extend default_config and keep the changes from custom config (cfg)
    local config = vim.tbl_deep_extend("keep", user_cfg, default_config)
    -- clear out the default highlights if any that seeped through when (keep)expanded
    if user_cfg.highlights then
        for name, data in pairs(user_cfg.highlights) do
            config.highlights[name] = data
        end
    end
    validate_config(config)
    return config
end

return M
