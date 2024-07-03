# [BottomLine.nvim](https://github.com/mnjm/bottomline.nvim)
**Yet another neovim statusline**

A minimal statusline plugin that supports gitsigns and LSP

![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss.png?raw=true)

**My other plugins**
- [TopLine.nvim](https://github.com/mnjm/topline.nvim) - Tabline plugin
- [WinLine.nvim](https://github.com/mnjm/winline.nvim) - Winbar plugin
***
## Installation

Optional Dependencies
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)

```vim
Plug 'mnjm/winline.nvim'
" Option dependency - gitsigns
Plug 'lewis6991/gitsigns.nvim'
" Optional dependency for icons
Plug 'nvim-tree/nvim-web-devicons'
```
### packer.nvim
```lua
use {
    'mnjm/winline.nvim',
    -- optional dependency for icons
    requires = {  { 'lewis6991/gitsigns.nvim', opt = true },
        {'nvim-tree/nvim-web-devicons', opt = true } }
}
```
### lazy.nvim
```lua
{
    'mnjm/winline.nvim'
    dependencies = {  'lewis6991/gitsigns.nvim', 'nvim-tree/nvim-web-devicons' }
}
```
***
## Setup
To start BottomLine, add below line in your neovim config
```lua
require('bottomline').setup()
```
### Customization
You can pass custom config to override default configs to setup call, for ex
```lua
require('bottomline').setup({
    enable = true,
    enable_icons = true,
    highlights = {
        BLMode = { fg="#282c34", bg="#98c379", bold=true },
        BLLine = { link="BLMode" },
    },
    -- seperators = { '',  '' },
    -- seperators = { '',  '' },
    seperators = { '',  '' },
    git_symbols = { branch = "" },
    lsp_symbols = {
        error = " ",
        warn = " ",
        info = " ",
        hint = " ",
    },
})
```
Available default configuration options
```lua
require('bottomline').setup({
    enable = true,
    enable_icons = false,
    seperators = { '', '' },              -- seperators icons
    enable_git = true,                    -- enable git section
    enable_lsp = true,                    -- enable lsp section
    display_buf_no = false,               -- add additional buf number section at the end of statusline
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
})
```
***
## Addendum
This work is derived from
- https://nuxsh.is-a.dev/blog/custom-nvim-statusline.html
- https://elianiva.my.id/post/neovim-lua-statusline
- and [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)

***
![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss1.png?raw=true)
![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss2.png?raw=true)
![Demo image](https://github.com/mnjm/github-media-repo/blob/main/bottomline.nvim/ss3.png?raw=true)
***
**Licence** MIT
