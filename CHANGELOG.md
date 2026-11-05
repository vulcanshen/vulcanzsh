# Changelog

## Unreleased

- 重構為三層：`config/`（一般設定）、`functions/`（一檔一指令，由 `functions.zsh` 與各單檔函式拆出）、`modules/`（強化模組）；`source.zsh` 改為純載入入口
- 新增 `.local/` 私人設定（外層結構的鏡子，目錄自帶 `.gitignore` 不進版控）：`.local/config/`、`.local/functions/`、`.local/modules/` 各自接在同名的外層之後載入；`SONAR_TOKEN_CLOUDFUSION_RCS` 移到 `.local/config/export.zsh`
- 新增 `modules/tmux-workflow.zsh`（原 `into-tmux.zsh`）：開 shell 自動進入 entrance session、fzf 選單切換／新建 session（神話名稱自動命名）、rename window、session 關閉後由失去 session 的 client 重選；隱藏的 o-mode session 不列入選單與計數
- 新增 `modules/history-skip-failed.zsh`：結束碼非 0 的指令不留在 history
- 停用 `fzf-tab-enhancement.zsh`（fzf-tab 已從 plugins 移除，檔案保留）；全域補全樣式搬到 `config/completion.zsh`
- `completion.zsh`：compinit 每日快取，新增 `reloadcomp` 手動重建
- vi 模式改由 `bindkey.zsh` 的 `bindkey -v` 啟用（原為 `source.zsh` 的 `set -o vi`）
- 新增函式 `cld`、`cpath`、`preview`（Quick Look）；`chromedev` 由 alias 改為函式；`llv` 支援路徑參數、`-lv` 深度與 tab 補全
- 新增 alias `trdn`、`gna`（`gitnexus analyze --index-only`）；`lzg` 改為 `lazygit -sm full log`；移除 `opf`
- 新增 XDG、`HOMEBREW_NO_ASK`、`ECC_GATEGUARD` 環境變數
- PATH：修正 `~/go/bin` 的 `~` 不展開、加入 GNU make 的 gnubin；coreutils gnubin 改用固定路徑，啟動時不再呼叫 `brew --prefix`

## v1.2.0 (2026-04-24)

- `source.zsh` 在載入其他模組前先執行 `set -o vi`，修正 bindkey 因 keymap 順序失效的問題
- 新增 `alias.zsh`、`completion.zsh`、`export.zsh`、`functions.zsh`、`path.zsh` 分拆設定檔
- 路徑改用 `$HOME` 取代硬編碼的絕對路徑

## v1.1.0 (2026-04-20)

- 新增 `clip.zsh`：`clip <檔案>` 將檔案複製到系統剪貼簿，可在 Finder 中貼上
- `bindkey.zsh` 快捷鍵從 Ctrl 改為 Meta 鍵（macOS Option / Windows·Linux Alt）
- 移除 `spfz.zsh`（fzf + superfile 整合）
- 更新 README.md 反映以上變更

## v1.0.0 (2026-04-14)

- 從 sideproj/vulcanzsh 獨立為 `~/.config/vulcanzsh` repo
- 移除 LazyVim、Starship 等非 zsh 設定
- 移除 `optional/` 目錄，所有模組扁平化至根目錄
- 新增 `source.zsh` 作為統一入口，`.zshrc` 只需一行即可載入
- 重寫 README.md
