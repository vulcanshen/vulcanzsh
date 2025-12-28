# 📦 vulcanzsh 選用進階功能

選用功能建構於核心功能之上，需要先載入基礎設定才能正常運作。

> [!NOTE]  
> **重要**：選用功能的設定必須放在基礎功能 `--- vulcanzsh config start ---` 之後載入。

## 📋 載入順序說明

在你的 `~/.zshrc` 中，請確保按照以下順序載入：

```sh
# --- vulcanzsh config start ---
for f in $HOME/.config/vulcanzsh/*.zsh; do [ -f "$f" ] && source "$f"; done
# --- vulcanzsh config end ---

# 選用功能要在基礎設定之後載入
# --- vulcanzsh optional config start ---
for f in $HOME/.config/vulcanzsh/optional/*.zsh; do [ -f "$f" ] && source "$f"; done
# --- vulcanzsh optional config end ---
```

---

## 🚀 快速安裝全部選用功能

執行以下指令一次安裝所有選用功能：

```sh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/optional/install.zsh | zsh
```

---

## 🔧 個別功能說明

### 1. 🌳 llv - 樹狀目錄檢視

使用 **eza** 優化的樹狀目錄列表指令，提供彩色、圖示化的目錄結構顯示。

#### 功能特色

- 🎨 彩色輸出，清晰易讀
- 📁 目錄優先排序
- 🔢 可自訂顯示深度（預設 1 層）
- 🎯 檔案類型圖示化

#### 使用方式

```zsh
# 顯示當前目錄第一層內容（預設）
llv

# 顯示兩層深度
llv 2

# 顯示三層深度
llv 3
```

#### 必要前置條件

- **[eza](https://github.com/eza-community/eza)** - 現代化的 `ls` 替代品

#### 單獨安裝

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/optional/zsh/llv.zsh -o ~/.config/vulcanzsh/optional/llv.zsh
```

---

### 2. ⚡ tab-enhancement - CLI Tab 補全強化

整合 **Carapace**（補全來源）、**fzf-tab**（互動式選單）與現代化 CLI 工具（eza、bat、vivid），打造極致的 Tab 補全體驗。

#### 功能特色

- 🎯 智慧模糊搜尋補全選項
- 👁️ 檔案與目錄的即時預覽
- 🎨 語法高亮顯示
- 🔍 支援多種指令的進階補全
- ⌨️ 直覺的快捷鍵操作

#### 使用方式

安裝後，當你在終端機輸入指令並按下 `Tab` 鍵時：

1. 會顯示互動式選單
2. 可使用方向鍵或輸入文字進行模糊搜尋
3. 選擇檔案或目錄時會顯示預覽內容
4. 按 `Enter` 確認選擇

#### 必要前置條件

請依序安裝以下工具：

1. **[eza](https://github.com/eza-community/eza)** - 現代化檔案列表工具
2. **[bat](https://github.com/sharkdp/bat)** - 語法高亮的 `cat` 替代品
3. **[vivid](https://github.com/sharkdp/vivid)** - LS_COLORS 主題生成器
4. **[carapace](https://github.com/carapace-sh/carapace)** - 多 shell 指令補全工具
5. **[fzf-tab](https://github.com/Aloxaf/fzf-tab)** - fzf 風格的 Zsh Tab 補全

#### 單獨安裝

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/optional/zsh/tab-enhancement.zsh -o ~/.config/vulcanzsh/optional/tab-enhancement.zsh
```

---

## 🗑️ 移除選用功能

### 移除特定功能

只需刪除對應的 `.zsh` 檔案：

```zsh
# 移除 llv
rm ~/.config/vulcanzsh/optional/llv.zsh

# 移除 tab 補全強化
rm ~/.config/vulcanzsh/optional/tab-enhancement.zsh

# 重新載入配置
source ~/.zshrc
```

### 移除全部選用功能

```zsh
# 刪除整個 optional 目錄
rm -rf ~/.config/vulcanzsh/optional

# 從 ~/.zshrc 中移除以下區塊：
# --- vulcanzsh optional config start ---
# for f in $HOME/.config/vulcanzsh/optional/*.zsh; do [ -f "$f" ] && source "$f"; done
# --- vulcanzsh optional config end ---

# 重新載入配置
source ~/.zshrc
```

---

## 💡 使用建議

### llv 最佳實踐

- 使用 `llv 2` 或 `llv 3` 快速預覽專案結構
- 避免在大型專案使用過深的層級，以免輸出過多內容
- 可搭配 `grep` 或管道符號篩選特定檔案類型

### tab-enhancement 最佳實踐

- 善用模糊搜尋功能，輸入部分關鍵字即可快速定位
- 預覽功能可幫助你在選擇前確認檔案內容
- 搭配 `cd`、`ls`、`git` 等指令使用效果最佳
