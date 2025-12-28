# vulcanzsh

```
              __                            __  
 _   ____  __/ /________ _____  ____  _____/ /_ 
| | / / / / / / ___/ __ `/ __ \/_  / / ___/ __ \
| |/ / /_/ / / /__/ /_/ / / / / / /_(__  ) / / /
|___/\__,_/_/\___/\__,_/_/ /_/ /___/____/_/ /_/ 
                                                
                個人 Zsh 設定
```

> 🛠️ 專為個人開發習慣設計的 Zsh 快捷鍵、函式與 LazyVim 優化配置。

## 🚀 快速安裝

只需在終端機執行以下指令即可完成安裝。此腳本會建立 `~/.config/vulcanzsh` 目錄，並將載入邏輯注入到您的 `~/.zshrc`。

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/install.zsh | zsh
```


## ⚠️ 必要前置條件

安裝前請確保您已完成以下環境設定

若未找到這些條件，安裝腳本將會**中止**：

1. **zsh** 與 **Oh My Zsh** `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
2. **zsh-autosuggestions** 插件  
   `git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions`
   *注意：記得在 `~/.zshrc` 的 `plugins` 清單中加入 `zsh-autosuggestions`。*


## ✨ 功能亮點

1. Zsh 快捷鍵與函式
  - Vim 風格歷史搜尋：使用 `Ctrl + k / Ctrl + j` 搜尋指令歷史。
  - 快速導航：`Ctrl + h / Ctrl + l` 進行單字級別的跳躍。
  - 接受自動建議：`Ctrl + o`
  - `v()` 函式：
    - v：在當前目錄開啟 nvim .
    - v <路徑>：智慧開啟。若目錄或檔案不存在會自動建立。
2. Neovim (LazyVim) 優化配置

我使用 LazyVim。以下是建議放置於 `~/.config/nvim/lua/plugins/` 的配置檔。

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

為縮排輔助線添加顏色以提升可視性。

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


## 🗑 移除方式

1. 刪除配置目錄：`rm -rf ~/.config/vulcanzsh`
2. 開啟 `~/.zshrc` 並刪除 `--- vulcanzsh Config ---` 標記之間的所有行。


## 🛠️ Neovim / LazyVim 設定（選用）

我使用 [LazyVim](https://www.lazyvim.org/) 作為編輯器。若要複製我的使用體驗，請按照以下步驟操作：

### 1. 啟用 Indent Extra
我的縮排配置依賴 `ui.indent` 擴充功能。
* 開啟 Neovim 並執行 `:LazyExtras`
* 找到並啟用 **`ui.indent-blankline`**

### 2. 插件
執行以下指令下載我精心調整的 **blink.cmp**（無換行補全）和 **indent-blankline**（彩虹縮排）設定：


```zsh
# 下載 blink.cmp 配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/plugins/blink.lua -o ~/.config/nvim/lua/plugins/blink.lua
```

```zsh
# 下載 indent-blankline 配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/plugins/indent-blankline.lua -o ~/.config/nvim/lua/plugins/indent-blankline.lua
```

### 快捷鍵設定

這些快捷鍵提供一致的「縮放」體驗，使用 Ctrl + f 可在一般模式與終端模式中切換單一視窗的全螢幕聚焦。

> [!CAUTION] 警告：重複執行追加指令會在 keymaps.lua 中產生重複的設定項目，請在執行後檢查您的檔案。

```zsh
# 追加視窗縮放快捷鍵配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/config/keymaps.lua >> ~/.config/nvim/lua/config/keymaps.lua
```


---

## Starship 提示字元自訂

本倉庫包含自訂的 **Starship** 配置，提供簡約、快速且資訊豐富的提示字元。針對 **Catppuccin Mocha** 配色進行優化，具有簡潔的佈局與 Git 狀態及目錄追蹤功能。

#### ⚠️ 必要前置條件

- [Starship](https://starship.rs/) (`brew install starship`)

#### 🛠️ 配置方式

執行以下指令備份您目前的配置（如果有的話）並下載新配置：

```zsh
# 如果目錄不存在則建立
mkdir -p ~/.config

# 備份現有配置（如果存在）
[ -f ~/.config/starship.toml ] && mv ~/.config/starship.toml ~/.config/starship.toml.bak

# 下載新的 starship 配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/starship/starship.toml -o ~/.config/starship.toml
```

---

## 🔍 選用功能

> [!TIP] 備註：這些功能採用模組化設計。如果不需要，只需從配置目錄中移除對應的檔案（*.zsh、*.toml）即可。

[選用功能](./optional/)
