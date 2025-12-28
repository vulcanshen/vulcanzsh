# vulcanzsh

```
              __                            __  
 _   ____  __/ /________ _____  ____  _____/ /_ 
| | / / / / / / ___/ __ `/ __ \/_  / / ___/ __ \
| |/ / /_/ / / /__/ /_/ / / / / / /_(__  ) / / /
|___/\__,_/_/\___/\__,_/_/ /_/ /___/____/_/ /_/ 
                                                
                個人 Zsh 設定
```

> 🛠️ 專為個人開發習慣設計的 Zsh 快捷鍵、函式與 LazyVim 優化配置

## 🚀 快速安裝

在終端機執行以下指令即可完成安裝。腳本會建立 `~/.config/vulcanzsh` 目錄，並將載入邏輯注入到 `~/.zshrc` 中。

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/install.zsh | zsh
```

## ⚠️ 必要前置條件

安裝前請確保已完成以下環境設定，若未滿足條件安裝腳本將會**中止執行**：

1. **zsh** 與 **[Oh My Zsh](https://ohmyz.sh/)**
   ```zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

2. **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** 插件
   ```zsh
   git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
   ```
   *注意：記得在 `~/.zshrc` 的 `plugins` 清單中加入 `zsh-autosuggestions`*

## ✨ 核心功能

### Zsh 快捷鍵與函式

- **Vim 風格歷史搜尋**：`Ctrl + k / Ctrl + j` 搜尋指令歷史
- **快速單字跳躍**：`Ctrl + h / Ctrl + l` 進行單字級別移動
- **接受自動建議**：`Ctrl + o`
- **智慧開啟 `v()` 函式**：
  - `v`：在當前目錄開啟 `nvim .`
  - `v <路徑>`：智慧開啟，自動建立不存在的目錄或檔案

### Neovim (LazyVim) 優化配置

本專案使用 LazyVim，以下是建議配置檔案，請放置於 `~/.config/nvim/lua/plugins/`。

#### blink.lua

調整補全選單快捷鍵，使用 `Ctrl + j/k` 選擇項目，`Enter` 確認。

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

#### indent-blankline.lua

為縮排輔助線添加彩虹色彩，提升程式碼層級辨識度。

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

## 🗑 完整移除

1. 刪除配置目錄：
   ```zsh
   rm -rf ~/.config/vulcanzsh
   ```

2. 編輯 `~/.zshrc`，刪除 `--- vulcanzsh config ---` 標記之間的所有內容

## 🛠️ LazyVim 完整設定（選用）

若要完整複製我的 [LazyVim](https://www.lazyvim.org/) 使用體驗，請依序執行以下步驟。

### 1. 啟用 Indent Extra

縮排配置需要 `ui.indent` 擴充功能：

- 在 Neovim 中執行 `:LazyExtras`
- 找到並啟用 **`ui.indent-blankline`**

### 2. 下載插件配置

一鍵下載 **blink.cmp** 與 **indent-blankline** 的精調配置：

```zsh
# 下載 blink.cmp 配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/plugins/blink.lua -o ~/.config/nvim/lua/plugins/blink.lua

# 下載 indent-blankline 配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/plugins/indent-blankline.lua -o ~/.config/nvim/lua/plugins/indent-blankline.lua
```

### 3. 視窗縮放快捷鍵

使用 `Ctrl + f` 在一般模式與終端模式中快速切換全螢幕視窗。

> [!CAUTION]  
> **警告**：重複執行會產生重複設定，請執行後檢查 `keymaps.lua` 內容。

```zsh
# 追加視窗縮放快捷鍵配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/lazyvim/config/keymaps.lua >> ~/.config/nvim/lua/config/keymaps.lua
```

---

## 🌟 Starship 提示字元自訂

提供簡約、快速且資訊豐富的終端提示字元，採用 **Catppuccin Mocha** 配色，具備 Git 狀態與目錄追蹤。

### 必要前置條件

- **[Starship](https://starship.rs/)**

### 安裝配置

執行以下指令自動備份現有配置並下載新配置：

```zsh
# 建立配置目錄（若不存在）
mkdir -p ~/.config

# 備份現有配置
[ -f ~/.config/starship.toml ] && mv ~/.config/starship.toml ~/.config/starship.toml.bak

# 下載 Starship 配置
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/starship/starship.toml -o ~/.config/starship.toml
```

---

## 🔍 選用進階功能

> [!TIP]  
> 這些功能採用模組化設計，需要額外安裝依賴工具。詳細說明請參考：

**[📦 選用功能文件](./optional)**

選用功能包括：
- **llv**：使用 eza 的彩色樹狀目錄檢視
- **tab-enhancement**：整合 Carapace、fzf-tab 與現代化 CLI 工具的進階 Tab 補全