# Quite Nvim
![Screenshot of me looking at the init.lua in Quite-Nvim](https://i.ibb.co/swNCpKk/Screen-Shot-2024-12-13-at-18-37-43.png)

A [<100 loc](./init-stripped.lua), 100% lua configuration for neovim packed with comments to help newcomers hit the ground running.

> If you are actually completely new to Vim/Neovim, then you should probably take the tutorial first. To do so just run
`nvim +Tutor` in your terminal. It'll give you a solid base to work with.

# Installation
## Requirements
- git
- neovim (version 0.11 and up)
- a terminal with truecolor support using a [NerdFont](https://www.nerdfonts.com/) 
## Macos/Linux
1. Clone the repo from the terminal:
```bash
test -e ~/.config || mkdir ~/.config 
git clone https://github.com/serialized-kirin/quite-nvim/ ~/.config/nvim/
```
2. Install the plugins through lazy
```bash
nvim --headless "+Lazy! sync" +qa
```
3. Open the configuration and read! :)
```bash
nvim ~/.config/nvim/init.lua
```
