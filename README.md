<h1 align="center">
Welcome to SysMon!
</h1>

<p align="center">
SysMon is a very basic system monitor plugin for my favourite text editor and IDE <a href="github.com/Lunarvim/LunarVim">LunarVim</a>.
</p>

## Features

SysMon periodically fetches CPU and memory Usage, as well as CPU temperature and displays them on the status bar down
below.

## Installation

You can install this plugin using [Lazy.nvim](https://github.com/folke/lazy.nvim).

Simply add this line to your LunarVim config file at `~/.config/lvim/config.lua`:

```Lua
lvim.plugins = {
    {
        "git@github.com:BytePaws/sysmon.nvim",
        config = function()
            require('sysmon')
        end,
    },
}
```

After installation your system resources should be displayed as text in the status bar on the bottom of the screen.
It will refresh every 2 seconds.

> [!Note]
> While this plugin was developed specifically with and for LunarVim, it should be compatible with any NeoVim configuration
> using the [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) statusbar.
>
> If you want, please share you experience with me in the discussion section so I can build a collection of supported configurations. Thank you :)

## Configuration

SysMon allows you to choose the interval in which it should fetch your system information.

The default is **2 seconds**. To change this, add this to your `~/.config/lvim/config.lua` when including the plugin.

```Lua
lvim.plugins = {
    {
        "git@github.com:BytePaws/sysmon.nvim",
        config = function()
            local sysmon = require('sysmon')
            sysmon.setup({ update_interval = 5000 }) -- Example: 5 seconds interval. Change this to the value you want.
        end,
    },
}
```

To use icons instead of the simple text lables for the fields enable the `use_icon` option.

```Lua
lvim.plugins = {
    {
        "git@github.com:BytePaws/sysmon.nvim",
        config = function()
            local sysmon = require('sysmon')
            sysmon.setup({
                update_interval = 5000, -- Example: 5 seconds interval. Change this to the value you want.
                use_icons = true,
            })
        end,
    },
}
```

> [!Note]
> This setting was tested using both `kitty` and `konsole` with NerdFonts installed.

## Requirements

- NeoVim 0.5 or higher
- LunarVim v1.4 or newer (tested with 1.4, older versions might work, but I do not guarantee it)
- `top` needs to be installed to fetch cpu usage
- `free` needs to be installed to fetch memory usage
- `lm-sensors` package needs to be installed to fetch temperature

> [!Note]
> This Plugin will **only work on Linux systems**.
> I do not plan on porting to any other platform at the moment as I only use Linux.
>
> But I do welcome contributions to fix this predicament.

## Todos

- [ ] Implement Unittests
- [x] Experiment with icons instead of Text labels
- [x] Fix content not refreshing when cursor is still
- [ ] Support other status bar plugins
- [ ] Support other neovim setups besides LunarVim

## License

This project is under the MIT license - see the [LICENSE](./LICENSE) file for details.
