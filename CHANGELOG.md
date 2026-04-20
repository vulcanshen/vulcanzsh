# Changelog

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
