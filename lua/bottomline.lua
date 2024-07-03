--------------------------------------------------------------------------------------------------
--------------------------------- bottomline.nvim ------------------------------------------------
--------------------------------------------------------------------------------------------------
-- Author - mnjm - github.com/mnjm
-- Repo - github.com/mnjm/bottomline.nvim
-- File - lua/bottomline.lua
-- License - Refer github

local M = {}

-- import modules
local config = require('bottomline.config')
local utils = require('bottomline.utils')
local seperators = require('bottomline.seperators')

-- Gets the current mode
-- @return mode string with highlight
local function get_mode()
    local mode = utils.mode_lookup()
    return "%#BLMode#" .. string.format(" %s ", mode)
end

-- Gets current buf git info if available
-- @return git info string with highlights and seperator
local function get_gitinfo()
    -- if disabled in settings
    if not M.config.enable_git then return "" end

---@diagnostic disable-next-line: undefined-field
    local gitsigns = vim.b.gitsigns_status_dict
    local ret = ""
    -- if gitsigns not avail or not a git dir
    if (not gitsigns) or gitsigns.head == "" then return ret end
    local fmt  = {
        {gitsigns.added, M.config.git_symbols.added},
        {gitsigns.removed, M.config.git_symbols.removed},
        {gitsigns.changed, M.config.git_symbols.changed}
    }
    for _, v in ipairs(fmt) do
        if v[1] and v[1] ~= 0 then
            ret = string.format("%s %s%s", ret, v[2], v[1])
        end
    end
    ret = string.format("%%#BLGitInfo#%s %s %s ", ret, M.config.git_symbols.branch, gitsigns.head)
    return ret
end

-- Gets current buf lsp info if available
-- @return lspinfo string with hightlights and seperator
local function get_lspinfo()
    if not M.config.enable_lsp then
        return ""
    end
    local ret = ""
    local map = {
        {vim.diagnostic.severity.ERROR, M.config.lsp_symbols.error},
        {vim.diagnostic.severity.WARN, M.config.lsp_symbols.warn},
        {vim.diagnostic.severity.INFO, M.config.lsp_symbols.info},
        {vim.diagnostic.severity.HINT, M.config.lsp_symbols.hint},
    }
    for _, s in ipairs(map) do
        local count = #vim.diagnostic.get(0, {severity = s[1]})
        if count ~=0 then
            ret = string.format("%s %s%s ", ret, s[2], count)
        end
    end
    if not (ret == "") then
        ret = seperators.get_seperator("BLLspInfo", "BLFill", 2) .. "%#BLLspInfo#" .. ret
    end
    return ret
end

-- Gets filepath with flags(modified, readonly, helpfile, preview)
-- @param icon file icon from nvim-dev-icons
-- @param active_flag true if active stausline
-- @return filepath with highlights and seperators
local function get_filepath(icon, active_flag)
    local hl = active_flag and "BLFile" or "BLFileInactive"
    local left_sep = M.config.center_file_path and seperators.get_seperator(hl, "BLFill", 2) or ""
    local right_sep = seperators.get_seperator(hl, "BLFill", 1)
    local filepath = "%<%f%m%r%h%w"
    return string.format("%s%%#%s# %s %s %s", left_sep, hl, icon, filepath, right_sep)
end

-- Gets filetype
-- @param icon file icon from nvim-dev-icons
-- @return filetype string with icon, highlight and seperators
local function get_filetype(icon)
    local ftype = vim.bo.filetype
    if ftype == '' then return '' end
    return "%#BLFileType#" .. string.format(' %s %s ', icon, ftype):lower()
end

-- Get column, linenumber and percent of document
-- @return lineinfo string with its highlight and seperators
local function get_lineinfo()
  if vim.bo.filetype == "alpha" then return "" end
  return seperators.get_seperator("BLLine", "BLFileType", 2) .. "%#BLLine# [%l:%c](%p%%) "
end

-- Display current buffer number
-- @param active_flag true if active statusline
-- @return buffnumber string with highlights and seperator
local function get_buffernumber(active_flag)
    local sep, hl = nil, nil
    if active_flag then
        sep = seperators.get_seperator("BLBuf", "BLLine", 2)
        hl = "%#BLBuf#"
    else
        sep = seperators.get_seperator("BLBufInactive", "BLFill", 2)
        hl = "%#BLBufInactive#"
    end
    return sep .. hl .. " B:%n "
end

-- get icon
-- @param file path
-- @return icon from nvim-dev-icons
local function get_icon(fpath)
    if M.config.enable_icons then return utils.get_icon(fpath)
    else return "" end
end

-- active statusline generator
-- @return active statusline string
M.active = function()
    local mode = get_mode()
    local gitinfo = get_gitinfo()
    local to_fill_or_file = M.config.center_file_path and "BLFill" or "BLFile"
    local mode_sep = seperators.get_seperator("BLMode", gitinfo == "" and to_fill_or_file or "BLGitInfo", 1)
    local gitinfo_sep = gitinfo == "" and "" or seperators.get_seperator("BLGitInfo", to_fill_or_file, 1)
    local icon = get_icon(vim.fn.expand("%p"))
    local lspinfo = get_lspinfo()
    local ft_sep = seperators.get_seperator("BLFileType", lspinfo == "" and "BLFill" or "BLLspInfo", 2)
    local ret = table.concat {
        mode, mode_sep,                                                     -- mode
        gitinfo, gitinfo_sep,                                               -- git info
        M.config.center_file_path and "%#BLFill#%=" or "",                  -- filler
        get_filepath(icon, true),                                           -- filepath
        "%#BLFill#%=",                                                      -- filler
        lspinfo,
        ft_sep, get_filetype(icon),
        get_lineinfo(),
    }
    if M.config.display_buf_no then
        ret = ret .. table.concat {
            "%#BLBuf#", get_buffernumber(true),
        }
    end
    -- vim.print(ret)
    return ret
end

-- inactive statusline generator
-- @return inactive statusline string
M.inactive = function()
    local icon = get_icon(vim.fn.expand("%p"))
    return table.concat {
        M.config.center_file_path and "%#BLFill#%=" or "",                  -- filler,
        get_filepath(icon, false),
        "%#BLFill#%=",                  -- filler
        get_buffernumber(false) and M.config.display_buf_no or "",
    }
end

-- create statusline aucmds
local setup_statusline = function()
    -- set the statusline
    vim.opt.statusline='%!v:lua._bottomline.active()'
    local _au = vim.api.nvim_create_augroup('BottomLine statusline', { clear = true })
    local refresh_events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
    }
    -- refresh aucmd
    vim.api.nvim_create_autocmd(refresh_events, {
        pattern = "*",
        command = 'setlocal statusline=%!v:lua._bottomline.active()',
        group = _au,
        desc = "Setup active statusline",
    })
    -- leave aucmd
    vim.api.nvim_create_autocmd({'WinLeave', 'BufLeave'}, {
        pattern = "*",
        command = 'setlocal statusline=%!v:lua._bottomline.inactive()',
        group = _au,
        desc = "Setup inactive statusline",
    })
end

-- initialize bottomline plugin
local init_bottomline = function()
    -- Exposing plugin
    _G._bottomline = M
    -- Create highlights
    utils.setup_highlights(M.config.highlights)
    -- Initialize seperator module
    seperators.init_seperators(M.config.seperators, utils.setup_highlights)
end

-- bottomline setup call
-- @param cfg custom configurations for bottomline.nvim
function M.setup(cfg)
    -- Config
    M.config = config.init_config(cfg)
    -- return if not enabled in config
    if not M.config.enable then return end
    -- init
    init_bottomline()
    -- Create statusline autocommands
    setup_statusline()
end

return M
