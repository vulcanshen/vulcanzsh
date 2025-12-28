
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
zstyle ':fzf-tab:*' fzf-flags --color=16 --height=50% --reverse --inline-info --border --preview-window=right:70%:wrap \
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

zstyle ':fzf-tab:complete:kill:*' fzf-preview '
  local pid="${(Q)word}"
  
  if [[ "$pid" =~ ^([0-9]+) ]]; then
    pid="${match[1]}"
  fi
  
  if [[ "$pid" =~ ^[0-9]+$ ]]; then
    echo "\033[1;33mProcess Information (PID: $pid)\033[0m"
    ps -p "$pid" -o pid,ppid,user,%cpu,%mem,stat,start,time 2>/dev/null
    echo ""
    echo "\033[1;32mFull Command:\033[0m"
    ps -p "$pid" -o args= 2>/dev/null
    echo ""
    echo "\033[1;35mNetwork Connections:\033[0m"
    
    if command -v lsof >/dev/null 2>&1; then
      # 使用 lsof 獲取詳細網路連線資訊
      local connections=$(lsof -Pan -p "$pid" -i 2>/dev/null | tail -n +2)
      
      if [ -n "$connections" ]; then
        echo "$connections" | while read -r line; do
          local proto=$(echo "$line" | awk "{print \$8}")
          local addr=$(echo "$line" | awk "{print \$9}")
          local state=$(echo "$line" | awk "{print \$10}")
          
          # 判斷是 LISTEN 還是 ESTABLISHED
          if [[ "$state" == "LISTEN" ]] || [[ "$addr" == *"LISTEN"* ]]; then
            echo "  \033[1;32m●\033[0m $proto $addr \033[1;32m[LISTEN]\033[0m"
          elif [[ "$state" == "ESTABLISHED" ]] || [[ "$addr" == *"->"* ]]; then
            echo "  \033[1;34m○\033[0m $proto $addr \033[1;34m[ESTABLISHED]\033[0m"
          else
            echo "  \033[1;33m◆\033[0m $proto $addr $state"
          fi
        done
      else
        echo "  \033[2mNo network connections\033[0m"
      fi
    elif command -v ss >/dev/null 2>&1; then
      # 使用 ss（Linux）
      local connections=$(ss -tnp 2>/dev/null | grep "pid=$pid")
      
      if [ -n "$connections" ]; then
        echo "$connections" | while read -r line; do
          local state=$(echo "$line" | awk "{print \$1}")
          local local_addr=$(echo "$line" | awk "{print \$4}")
          local remote_addr=$(echo "$line" | awk "{print \$5}")
          
          if [[ "$state" == "LISTEN" ]]; then
            echo "  \033[1;32m●\033[0m TCP $local_addr \033[1;32m[LISTEN]\033[0m"
          elif [[ "$state" == "ESTAB" ]]; then
            echo "  \033[1;34m○\033[0m TCP $local_addr -> $remote_addr \033[1;34m[ESTABLISHED]\033[0m"
          else
            echo "  \033[1;33m◆\033[0m TCP $local_addr -> $remote_addr [$state]"
          fi
        done
      else
        echo "  \033[2mNo network connections\033[0m"
      fi
    else
      echo "  \033[2m(lsof or ss not available)\033[0m"
    fi
  fi'

zstyle ':fzf-tab:complete:*:*' fzf-preview '
  local t_word="${(Q)word% }"
  case "$group" in
    "[local directory]") 
      eza --icons=always --color=always --long "$realpath" ;;
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
      echo "Not implement yet"
      echo "group:$group"
      echo "word:$word"
      echo "realpath:$realpath"
      echo "desc:$desc"
      ;;
  esac'

_kill_fzf_friendly() {
  local -a pids descriptions
  local pid name
  
  # 使用 zsh 內建的字串操作：${name##*/} 取得最後一個 / 之後的內容
  while read -r pid name; do
    pids+=("$pid")
    descriptions+=("${pid}::${name##*/}")
  done < <(ps -u "$USER" -o pid=,comm= 2>/dev/null | tail -n +2 | head -n 500)
  
  compadd -d descriptions -a pids
}

compdef _kill_fzf_friendly kill
