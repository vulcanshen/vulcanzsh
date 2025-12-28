GITHUB_USER="vulcanshen"
REPO_NAME="vulcanzsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/${BRANCH}"
print_success() { echo -e "\e[32m[+] $1\e[0m" }
print_info()    { echo -e "\e[34m[i] $1\e[0m" }
print_warn()    { echo -e "\e[33m[!] $1\e[0m" }
print_error()   { echo -e "\e[31m[-] $1\e[0m" }
MARKER_START="# --- vulcanzsh optional config Start ---"
MARKER_END="# --- vulcanzsh optional config End ---"

ZSH_CONF_DIR="$HOME/.config/vulcanzsh/optional"
mkdir -p "$ZSH_CONF_DIR"

LOAD_CMD="for f in $ZSH_CONF_DIR/*.zsh; do [ -f \"\$f\" ] && source \"\$f\"; done"

curl -fsSL ${BASE_URL}/optional/zsh/llv.zsh -o ${ZSH_CONF_DIR}/llv.zsh
curl -fsSL ${BASE_URL}/optional/zsh/tab-enhancement.zsh -o ${ZSH_CONF_DIR}/tab-enhancemant.zsh

if ! grep -q "$MARKER_START" ~/.zshrc; then
    echo -e "\n$MARKER_START" >> ~/.zshrc
    echo "$LOAD_CMD" >> ~/.zshrc
    echo "$MARKER_END" >> ~/.zshrc
    print_success "Injection added to ~/.zshrc"
else
    print_info "Configuration markers found in ~/.zshrc, files updated."
fi