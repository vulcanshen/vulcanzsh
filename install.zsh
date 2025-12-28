#!/usr/bin/env zsh

# --- Configuration ---
GITHUB_USER="vulcanshen"
REPO_NAME="vulcanzsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/${BRANCH}"

print_success() { echo -e "\e[32m[+] $1\e[0m" }
print_info()    { echo -e "\e[34m[i] $1\e[0m" }
print_warn()    { echo -e "\e[33m[!] $1\e[0m" }
print_error()   { echo -e "\e[31m[-] $1\e[0m" }

echo '

              __                            __  
 _   ____  __/ /________ _____  ____  _____/ /_ 
| | / / / / / / ___/ __ `/ __ \/_  / / ___/ __ \
| |/ / /_/ / / /__/ /_/ / / / / / /_(__  ) / / /
|___/\__,_/_/\___/\__,_/_/ /_/ /___/____/_/ /_/ 
                                                
                Personal Zsh Settings
'

echo "[*] Starting vulcanzsh configuration setup..."

MISSING_DEP=0

# --- Prerequisites Check ---
if [ -z "$ZSH" ] && [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_error "Oh My Zsh not detected."
    echo "    Suggestion: Install it via: sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)\""
    MISSING_DEP=1
fi

AUTOSUGGEST_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
if [[ ! "$plugins" =~ "zsh-autosuggestions" ]] && [ ! -d "$AUTOSUGGEST_DIR" ]; then
    print_error "zsh-autosuggestions plugin not detected."
    echo "    Suggestion: Clone it via: git clone https://github.com/zsh-users/zsh-autosuggestions \${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    echo "    Then add 'zsh-autosuggestions' to your plugins list in ~/.zshrc"
    MISSING_DEP=1
fi

if [ "$MISSING_DEP" -ne 0 ]; then
    print_error "Installation aborted due to missing prerequisites."
    exit 1
fi

# 1. Create directory
ZSH_CONF_DIR="$HOME/.config/vulcanzsh"
mkdir -p "$ZSH_CONF_DIR"

# 2. Download files
print_info "Downloading configuration files from GitHub..."
curl -fsSL "${BASE_URL}/zsh/bindkey.zsh" -o "${ZSH_CONF_DIR}/bindkey.zsh" || { print_error "Failed to download bindkey.zsh"; exit 1; }
curl -fsSL "${BASE_URL}/zsh/v.zsh" -o "${ZSH_CONF_DIR}/v.zsh" || { print_error "Failed to download v.zsh"; exit 1; }

# 3. Inject into ~/.zshrc
MARKER_START="# --- vulcanzsh config Start ---"
MARKER_END="# --- vulcanzsh config End ---"
LOAD_CMD="for f in $ZSH_CONF_DIR/*.zsh; do [ -f \"\$f\" ] && source \"\$f\"; done"

if ! grep -q "$MARKER_START" ~/.zshrc; then
    echo -e "\n$MARKER_START" >> ~/.zshrc
    echo "$LOAD_CMD" >> ~/.zshrc
    echo "$MARKER_END" >> ~/.zshrc
    print_success "Injection added to ~/.zshrc"
else
    print_info "Configuration markers found in ~/.zshrc, files updated."
fi

# --- Finalizing ---

print_success "Installation complete!"

if [[ -t 0 ]]; then
    print_info "Restarting zsh to apply changes..."
    exec zsh -l
else
    print_info "Please run 'source ~/.zshrc' to apply changes."
fi