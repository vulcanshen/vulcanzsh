# ------------------------------------------------------------------------------
# 1. GLOBAL COMPLETION SETTINGS (Zsh Built-in)
# ------------------------------------------------------------------------------

# Generate high-quality LS_COLORS using the 'vivid' tool
export LS_COLORS=$(vivid generate catppuccin-mocha)
export LISTMAX=500                 # Allow more items before asking to show them

unsetopt menucomplete             # Do not autoselect the first completion entry
setopt listambiguous              # Show completion menu only on ambiguous input

# Styling and Formatting
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no                             # Use fzf-tab instead of native menu
zstyle ':completion:*:messages' format '[%d]'              # System messages style
zstyle ':completion:*:descriptions' format '[%d]'          # Group descriptions style
zstyle ':completion:*:options' auto-description '%10d'

# Matcher list: Enable case-insensitive and fuzzy matching (e.g., ._ matching)
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# ------------------------------------------------------------------------------
# 2. CARAPACE & FZF-TAB CORE INITIALIZATION
# ------------------------------------------------------------------------------

# Priority order for completion groups
zstyle ':fzf-tab:*' group-order 'main-commands' 'alias-commands' 'all-files' 'directories'
zstyle ':fzf-tab:*' prefix ''            # Keep the search query clean
zstyle ':fzf-tab:*' format '(%d)'        # Group header format
zstyle ':fzf-tab:*' show-group quiet      # Only show headers for relevant groups

# Initialize Carapace completion engine
source <(carapace _carapace zsh)

# ------------------------------------------------------------------------------
# 3. FZF-TAB BEHAVIOR & INTERFACE
# ------------------------------------------------------------------------------

zstyle ':completion:*' nospace true           # Prevent auto-adding spaces (vital for path traversal)
zstyle ':fzf-tab:*' query-string ''           # Start fzf with an empty query (prevents redundant filtering)
zstyle ':fzf-tab:*' continuous-trigger '/'    # Trigger next-level completion immediately after '/'
zstyle ':fzf-tab:*' fzf-command fzf           # Use fzf as the backend

# FZF UI Flags and Key Bindings
zstyle ':fzf-tab:*' fzf-flags --color=16 --height=50% --reverse --inline-info --border --preview-window=right:50% \
  --bind 'ctrl-u:half-page-up,ctrl-d:half-page-down' \
  --bind 'U:preview-page-up,D:preview-page-down'

zstyle ':fzf-tab:*' switch-group '<' '>'      # Cycle through completion groups

# ------------------------------------------------------------------------------
# 4. GIT SPECIFIC PREVIEWS
# ------------------------------------------------------------------------------

zstyle ':fzf-tab:complete:git:*' fzf-preview '
  # (Q) removes shell escaping, % removes trailing space
  local t_word="${(Q)word% }"
  case "$group" in
    "[alias commands]") 
      echo "\033[1;33mGit Alias Definition:\033[0m"
      git config --get "alias.$t_word" ;;
    "["*" commands]")
      git help "${t_word}" | bat -lhelp --color=always --theme=base16 ;;
    "[head commits]"|"[local branches]"|"[remote branches]")
      # Logic to handle "detached HEAD" strings like "(HEAD detached at 38.4.0)"
      if [[ "$t_word" == *"detached"* ]]; then
        local clean="${${t_word#\(}%\)}"  # Strip parentheses
        local parts=(${(z)clean})         # Split string into array
        t_word="${parts[-1]}"             # Extract the commit hash/version
      fi
      git log --pretty=format:"%C(yellow)%h%Creset | %C(green)%ad%Creset | %C(blue)%an%Creset |%C(auto)%d%Creset %s %C(cyan)[%ae]" \
              --date=short --graph --color=always "${t_word}" -- ;;
    *)
      # Fallback debug info
      echo "group:$group\nword: $word\nrealpath: $realpath" ;;
  esac'

# ------------------------------------------------------------------------------
# 5. GENERAL FILE SYSTEM & PROCESS PREVIEWS
# ------------------------------------------------------------------------------

zstyle ':fzf-tab:complete:*:*' fzf-preview '
  local t_word="${(Q)word% }"
  case "$group" in
    "[local directory]") 
      eza --icons=always --color=always --long "$realpath" ;;
    "[process executables]") 
      ps --pid="$word" -o cmd --no-headers -w -w ;;
    "[files]"|"[file]") 
      local target="$PWD/${t_word}"
      if [ -d "$target" ]; then
        eza --icons=always --color=always --long "$target"
      elif [ -f "$target" ]; then
        # Preview file content using bat with a base16 theme
        bat --color=always --theme=base16 "$target"
      else
        echo "group:$group\nword: $word\nrealpath: $realpath"
      fi ;;
    *) 
      echo "group:$group\nword: $word\nrealpath: $realpath" ;;
  esac'