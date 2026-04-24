# vulcanzsh

```
              __                            __  
 _   ____  __/ /________ _____  ____  _____/ /_ 
| | / / / / / / ___/ __ `/ __ \/_  / / ___/ __ \
| |/ / /_/ / / /__/ /_/ / / / / / /_(__  ) / / /
|___/\__,_/_/\___/\__,_/_/ /_/ /___/____/_/ /_/ 
                                                
                個人 Zsh 設定
```

> 專為個人開發習慣設計的 Zsh 快捷鍵與函式配置

## 快速安裝

```zsh
git clone git@github.com:vulcanshen/vulcanzsh.git ~/.config/vulcanzsh
```

安裝後在 `~/.zshrc` 中加入：

```zsh
source ~/.config/vulcanzsh/source.zsh
```

## 必要前置條件

- **zsh** 與 **[Oh My Zsh](https://ohmyz.sh/)**
- **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)** 插件（`Meta + o` 接受建議需要）

## 檔案結構

```
~/.config/vulcanzsh/
├── source.zsh                   # 入口，set -o vi 後自動載入同目錄下所有 .zsh
├── alias.zsh                    # 別名設定
├── bindkey.zsh                  # 快捷鍵設定
├── clip.zsh                     # 複製檔案到剪貼簿
├── completion.zsh               # 補全設定
├── export.zsh                   # 環境變數
├── functions.zsh                # 自訂函式
├── fzf-tab-enhancement.zsh      # fzf-tab 進階預覽設定
├── llv.zsh                      # eza 樹狀目錄檢視
├── path.zsh                     # PATH 設定
└── v.zsh                        # nvim 智慧開啟函式
```

## 核心功能

### bindkey.zsh — 快捷鍵

> 使用 Meta 鍵作為修飾鍵（macOS 為 Option、Windows/Linux 為 Alt）。
> macOS 終端機需確認 Option 鍵已設定為 Meta 鍵。

| 快捷鍵 | 功能 | 模式 |
|--------|------|------|
| `Meta + k` | 向上搜尋歷史指令 | 命令列 |
| `Meta + j` | 向下搜尋歷史指令 | 命令列 |
| `Meta + h` | 向左跳一個單字 | 命令列 |
| `Meta + l` | 向右跳一個單字 | 命令列 |
| `Meta + o` | 接受 autosuggestion | 命令列 |
| `Meta + k / j` | 上下選擇 | 選單模式 |

### clip.zsh — 複製檔案到剪貼簿

- `clip <檔案>`：將檔案複製到系統剪貼簿，可直接在 Finder 中貼上

### v.zsh — 智慧開啟 nvim

- `v`：在當前目錄開啟 `nvim .`
- `v <檔案>`：自動 cd 到檔案所在目錄再開啟
- `v <目錄>`：cd 到該目錄後開啟 `nvim .`

### fzf-tab-enhancement.zsh — fzf-tab 進階預覽

整合 fzf-tab 的進階補全預覽，包含：

- 檔案預覽（bat）、目錄預覽（eza）、圖片預覽（chafa）
- Git 指令補全預覽（alias、branch、commit log）
- `kill` 指令的 process 預覽（CPU、記憶體、網路連線）

**依賴**：[fzf-tab](https://github.com/Aloxaf/fzf-tab)、[carapace](https://carapace.sh/)、[bat](https://github.com/sharkdp/bat)、[eza](https://github.com/eza-community/eza)、[chafa](https://github.com/hpjansson/chafa)（圖片預覽用）、[vivid](https://github.com/sharkdp/vivid)

### llv.zsh — 樹狀目錄檢視

- `llv [level]`：用 eza 顯示樹狀目錄，預設深度 1

**依賴**：[eza](https://github.com/eza-community/eza)

## 完整移除

1. 刪除配置目錄：
   ```zsh
   rm -rf ~/.config/vulcanzsh
   ```

2. 編輯 `~/.zshrc`，刪除 `source ~/.config/vulcanzsh/source.zsh` 這一行
