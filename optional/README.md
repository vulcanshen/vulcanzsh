# 選用功能

選用功能是基於基礎功能的架構之上，所以需要基礎功能先載入才能正常運作

> [NOTE!] 注意: 這部分的設定一定得在基礎功能 `--- vulcanzsh Config Start ---` 載入之後

## 快速安裝

```sh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/optional/install.zsh | zsh
```

## zsh

### llv (樹狀檢視列表)

一個優化的快捷指令，用於視覺化顯示您的目錄結構。使用 `${1:-1}` 語法優雅地處理選用參數。

#### ⚠️ 必要前置條件

請確保您已安裝以下工具：

1. [eza](https://github.com/eza-community/eza)

#### 🚀 快速安裝

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/optional/zsh/llv.zsh -o ~/.config/vulcanzsh/optional/llv.zsh
```

### cli tab 強化功能

[tab-enhancement.zsh](./zsh/tab-enhancement.zsh)

整合了 Carapace (補全來源)、fzf-tab (視覺化介面) 以及現代化的 CLI 工具（eza, bat, vivid）。

#### ⚠️ 必要前置條件

請確保您已安裝以下工具：

1. [eza](https://github.com/eza-community/eza)
2. [bat](https://github.com/sharkdp/bat)
3. [vivid](https://github.com/sharkdp/vivid)
4. [carapace](https://github.com/carapace-sh/carapace)
5. [fzf-tab](https://github.com/Aloxaf/fzf-tab)

#### 🚀 快速安裝

```zsh
curl -fsSL https://raw.githubusercontent.com/vulcanshen/vulcanzsh/refs/heads/main/optional/zsh/tab-enhancement.zsh -o ~/.config/vulcanzsh/optional/tab-enhancemant.zsh
```