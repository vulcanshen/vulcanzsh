# vulcanzsh

```
              __                            __  
 _   ____  __/ /________ _____  ____  _____/ /_ 
| | / / / / / / ___/ __ `/ __ \/_  / / ___/ __ \
| |/ / /_/ / / /__/ /_/ / / / / / /_(__  ) / / /
|___/\__,_/_/\___/\__,_/_/ /_/ /___/____/_/ /_/ 
                                                
                個人 Zsh 設定
```

> 專為個人開發習慣設計的 Zsh 設定：一般設定、強化模組與獨立函式的分層配置

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
- Oh My Zsh 插件：
  - **[zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)**（`Meta + o` 接受建議需要）
  - **[fast-syntax-highlighting](https://github.com/zdharma-continuum/fast-syntax-highlighting)**（語法高亮）
- 各功能所需的外部工具見下方對應段落（carapace、vivid、eza、neovim、tmux、fzf…）

## 檔案結構

```
~/.config/vulcanzsh/
├── source.zsh                  # 入口 loader：依序載入 config/ → functions/ → modules/
├── config/                     # 一般設定（shell 基礎行為）
│   ├── alias.zsh               # 別名（含 reloadcomp 等）
│   ├── bindkey.zsh             # vi 模式（bindkey -v）＋ 快捷鍵
│   ├── completion.zsh          # 補全來源、樣式、compinit 快取
│   ├── export.zsh              # 環境變數
│   └── path.zsh                # PATH
├── modules/                    # 強化模組（高內聚、自成一格的功能）
│   ├── tmux-workflow.zsh       # tmux session 進場/切換/新建流程
│   └── fzf-tab-enhancement.zsh # fzf-tab 進階預覽（目前停用，見下方）
└── functions/                  # 獨立小工具函式（一檔一指令，檔名＝指令）
    ├── v.zsh    clip.zsh   llv.zsh
    ├── ssh.zsh  mtp.zsh    cld.zsh
    └── chrome.zsh  chromedev.zsh
```

## 組織原則

- **`config/`** — 設定 shell **基礎行為**的「一般設定」（別名、快捷鍵、補全、環境變數、PATH），彼此低耦合。
- **`modules/`** — **高內聚、自成一格**的「強化模組」，有自己的邏輯或副作用，抽掉不影響基礎 shell。
- **`functions/`** — **獨立小工具函式**，一檔一指令、檔名即指令名。新增功能只要丟一個 `functions/xxx.zsh`，`source.zsh` 會自動載入。
- **`source.zsh`** — 純載入入口，依 `config → functions → modules` 順序 source（`fzf-tab-enhancement.zsh` 已排除）。

## 核心功能

### config/bindkey.zsh — 快捷鍵

啟用 **vi 模式**（`bindkey -v`），並加上以下自訂鍵（皆綁在 viins keymap）。

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

### config/completion.zsh — 補全

- **補全來源**：kubectl、task、gitlab-ci-local、tofu，以及 **[carapace](https://carapace.sh/)**（數百個指令的補全引擎）
- 大小寫不敏感 + 模糊比對、原生可選單（`menu select`）
- 補全清單配色由 **[vivid](https://github.com/sharkdp/vivid)** 產生（catppuccin-mocha）
- `kill` 補全附上 process 名稱
- **compinit 每日快取**：dump 檔超過 24h 才完整重建，否則走 `-C` 快路徑；想立即套用新裝工具的補全，執行 `reloadcomp`

### functions/ — 獨立函式

| 指令 | 功能 | 依賴 |
|------|------|------|
| `v [路徑]` | 智慧開啟 nvim（給檔案→cd 到其目錄再開；給目錄→cd 進去再開）| [neovim](https://neovim.io/) |
| `clip <檔案>` | 複製檔案到系統剪貼簿（可直接在 Finder 貼上）| macOS |
| `llv [深度]` | eza 樹狀目錄檢視（預設深度 1）| [eza](https://github.com/eza-community/eza) |
| `ssh` | 強制 `TERM=xterm-256color` 的 ssh 包裝 | — |
| `mtp` | 強制 `TERM=xterm-256color` 的 multipass 包裝 | multipass |
| `chrome [url]` | 開啟 Google Chrome | macOS |
| `chromedev [url]` | 開啟 Chrome（停用 web security ＋ 獨立 profile，開發用）| macOS |
| `cld [session]` | `claude`；帶參數則 `claude --resume <session>` | claude |

### modules/tmux-workflow.zsh — tmux session 流程

一套 tmux **session 管理流程**：開新 shell 自動進入 entrance session 並跳出 session 選單、fzf 選單切換／新建 session（新 session 自動以神話名稱命名）、rename window、session 關閉後自動接手再開選單。

由 `~/.config/tmux/tmux.conf` 的按鍵綁定與 hook 呼叫（以路徑 `source` 本檔）。

**依賴**：[tmux](https://github.com/tmux/tmux)、[fzf](https://github.com/junegunn/fzf)

### modules/fzf-tab-enhancement.zsh — fzf-tab 進階預覽（目前停用）

> ⚠️ **目前未載入**：已在 `source.zsh` 排除，因為 `fzf-tab` 已從 `~/.zshrc` 的 Oh My Zsh plugins 移除。檔案保留備用。
> **恢復方式**：① 把 `fzf-tab` 加回 `~/.zshrc` 的 `plugins` ② 移除 `source.zsh` 的排除條件。

fzf-tab 的進階補全預覽：檔案（bat）／目錄（eza）／圖片（chafa）預覽、git 指令補全預覽（alias、branch、commit log）、`kill` 指令的 process 預覽（CPU、記憶體、網路連線）。

**依賴**：[fzf-tab](https://github.com/Aloxaf/fzf-tab)、[carapace](https://carapace.sh/)、[bat](https://github.com/sharkdp/bat)、[eza](https://github.com/eza-community/eza)、[chafa](https://github.com/hpjansson/chafa)（圖片預覽）、[vivid](https://github.com/sharkdp/vivid)

## 完整移除

1. 刪除配置目錄：
   ```zsh
   rm -rf ~/.config/vulcanzsh
   ```

2. 編輯 `~/.zshrc`，刪除 `source ~/.config/vulcanzsh/source.zsh` 這一行
