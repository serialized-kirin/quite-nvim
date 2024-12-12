# Quite Nvim
A [<100 loc](./init-stripped.lua), 100% lua configuration for neovim packed with comments to help newcomers hit the ground running.

# Installation
## Requirements
- git
- neovim (version 0.11 and up)
- a terminal with truecolor support using a [NerdFont](https://www.nerdfonts.com/) 
## Macos/Linux
1. Clone the repo from the terminal:
```bash
mkdir ~/.config 
git clone https://github.com/serialized-kirin/quite-nvim/ ~/.config/nvim/
```
2. Install the plugins through lazy
```bash
nvim --headless "+Lazy! sync" +qa
```
3. Open the configuration and read! :)
```bash
nvim ~/config/nvim/init.lua
```
