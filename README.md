<h1 align="center">
Welcome to SysMon!
</h1>

<p align="center">
`SysMon` is a very basic system monitor plugin for my favourite text editor and IDE [LunarVim](https://github.com/LunarVim/LunarVim).
</p>

## Features

SysMon periodically fetches CPU and memory Usage, as well as CPU temperature and displays them on the status bar down
below.

## Installation

You can install this plugin using [Lazy.nvim](https://github.com/folke/lazry.nvim).

Simply add this line to your LunarVim config file at `~/.config/lvim/config.lua`:

```Lua
lvim.plugins = {
  {
    "git@github.com:TiaraNivani/sysmon.nvim",
    config = function()
      require('sysmon')
    end,
  },
}
```

After installation your system resources should be displayed as text in the status bar on the bottom of the screen.
It will refresh every 5 seconds.

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
- [ ] Experiment with icons instead of Text labels
- [ ] Fix content not refreshing when cursor is still
- [ ] Support other status bar plugins
- [ ] Support other neovim setups besides LunarVim

## License

This project is under the MIT license - see the [LICENSE](./LICENSE) file for details.
