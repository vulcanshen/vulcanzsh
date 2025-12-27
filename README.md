# vulcanzsh

```
              __                            __  
 _   ____  __/ /________ _____  ____  _____/ /_ 
| | / / / / / / ___/ __ `/ __ \/_  / / ___/ __ \
| |/ / /_/ / / /__/ /_/ / / / / / /_(__  ) / / /
|___/\__,_/_/\___/\__,_/_/ /_/ /___/____/_/ /_/ 
                                                
                Personal Zsh Settings
```

> 🛠️ Personal Zsh keybindings, functions, and LazyVim optimizations.  
> 專為個人開發習慣設計的 Zsh 與 Neovim 體驗優化。

## 🚀 Quick Start / 快速安裝

Run the following command in your terminal to install. This will create a directory at `~/.config/vulcanzsh` and inject a loading script into your `~/.zshrc`.

只需在終端機執行以下指令即可完成安裝。此腳本會建立 `~/.config/vulcanzsh` 目錄，並將載入邏輯注入到您的 `~/.zshrc`。

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/install.zsh | zsh
```


## ⚠️ Prerequisites (Required)

Before installing, ensure you have the following environment setup

The installation script will **abort** if these are not found:

1. **zsh** & **Oh My Zsh** `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
2. **zsh-autosuggestions** plugin  
   `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
   *Note: Remember to add `zsh-autosuggestions` to your `plugins` list in `~/.zshrc`.*


## ✨ Features / 功能亮點

1. Zsh Keybindings & Functions
  - Vim-like History Search: Use `Ctrl + k / Ctrl + j` to search through history.
  - Fast Navigation: `Ctrl + h / Ctrl + l` for word-level jumping.
  - Accept autosuggestions: `Ctrl + o`
  - The `v()` Function:
    - v: Open nvim . in current directory.
    - v <path>: Smart open. Auto-creates directories/files if they don't exist.
2. Neovim (LazyVim) Optimizations

I use LazyVim. Below are the recommended configurations to be placed in `~/.config/nvim/lua/plugins/.`

**blink.lua**

```lua
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
    completion = {
      list = {
        selection = {
          auto_insert = false,
        },
      },
    },
  },
}
```

**indent-blankline.lua**

Adds color to indentation guides for better visibility.

```lua
return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = function(_, opts)
      local highlight = {
        "RainbowRed",
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
      }

      local hooks = require("ibl.hooks")
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
        vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
        vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
        vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
        vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
        vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
        vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
      end)

      opts.indent = opts.indent or {}
      opts.indent.highlight = highlight

      return opts
    end,
  },
}
```


## 🗑 Uninstallation / 移除方式

1. Remove the config directory: `rm -rf ~/.config/vulcanzsh`
2. Open `~/.zshrc` and delete the lines between the #` --- vulcanzsh Config --- markers.`


## 🛠️ Neovim / LazyVim Setup (Optional)

I use [LazyVim](https://www.lazyvim.org/) as my editor. To mirror my experience, follow these steps:

### 1. Enable Indent Extra
My indentation config depends on the `ui.indent` extra.
* Open Neovim and run `:LazyExtras`
* Find and enable **`ui.indent-blankline`**

### 2. Install Plugin Configs
Run these commands to download my curated settings for **blink.cmp** (no-newline completion) and **indent-blankline** (rainbow indent):


```zsh
# Download blink.cmp config
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/blink.lua -o ~/.config/nvim/lua/plugins/blink.lua
```

```zsh
# Download indent-blankline config
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/indent-blankline.lua -o ~/.config/nvim/lua/plugins/indent-blankline.lua
```


## 🔍 Advanced Functions / 進階功能

> [!TIP] Note: These functions are modular. If you don't need them, simply remove the corresponding files (*.zsh, *.toml) from the config directory.

> [!TIP] 備註：這些功能為模組化設計。如果不需要，只需從設定目錄中移除相對應的 .zsh 檔案即可。

### spfz (spf + fzf)

A powerful wrapper that combines fzf (fuzzy finder) with spf (superfile). It allows you to search for any file or directory and instantly open the correct context in spf.

#### ⚠️ Prerequisites (Required) / 前置條件

Ensure you have the following installed:

1. [fzf](https://github.com/junegunn/fzf)
2. [spf (Super File)](https://superfile.dev/)

#### 🛠️ Implementation / 程式碼實作

Add this to your configuration to enable spfz:

```zsh
spfz() {
  local target
  # Search with preview (ls for directories, cat for files)
  target=$(fzf --preview '[[ -d {} ]] && ls -F {} || cat {}')

  if [ -n "$target" ]; then
    if [ -d "$target" ]; then
      # If directory, open directly
      spf "$target"
    else
      # If file, open its parent directory
      spf "$(dirname "$target")"
    fi
  fi
}
```

---

### llv (Tree View List)

A optimized shortcut to visualize your directory structure. It uses the ${1:-1} syntax to handle optional arguments gracefully.

#### ⚠️ Prerequisites (Required) / 前置條件

Ensure you have the following installed:

1. [eza](https://github.com/eza-community/eza)

#### 🛠️ Implementation / 程式碼實作

```zsh
# List with tree depth using eza (Optimized version)
llv() {
  local level="${1:-1}"
  eza --tree --level="$level" --icons --group-directories-first --classify=always
}
```

---

### Starship Prompt Customization

This repository includes a custom **Starship** configuration that provides a minimal, fast, and informative prompt. It is optimized for the **Catppuccin Mocha** palette and features a clean layout with Git status and directory tracking.

**Starship** 是一個極快且可高度自定義的命令提示字元。本倉庫提供的設定檔優化了路徑顯示邏輯，並採用 **Catppuccin Mocha** 配色，確保美觀與實用兼具。

#### ⚠️ Prerequisites / 前置條件

- [Starship](https://starship.rs/) (`brew install starship`)

#### 🛠️ Configuration / 設定方式

Run the following command to backup your current config (if any) and download the new one:

```zsh
# Create directory if it doesn't exist
mkdir -p ~/.config

# Backup existing config if it exists
[ -f ~/.config/starship.toml ] && mv ~/.config/starship.toml ~/.config/starship.toml.bak

# Download the new starship config
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/starship/starship.toml -o ~/.config/starship.toml
```