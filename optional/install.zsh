GITHUB_USER="vulcanshen"
REPO_NAME="vulcanzsh"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${REPO_NAME}/${BRANCH}"

MARKER_START="# --- vulcanzsh optional config start ---"
MARKER_END="# --- vulcanzsh optional config end ---"

ZSH_CONF_DIR="$HOME/.config/vulcanzsh/optional"
mkdir -p "$ZSH_CONF_DIR"

LOAD_CMD="for f in $ZSH_CONF_DIR/*.zsh; do [ -f \"\$f\" ] && source \"\$f\"; done"

curl -fsSL ${BASE_URL}/optional/zsh/llv.zsh -o ${ZSH_CONF_DIR}/llv.zsh
curl -fsSL ${BASE_URL}/optional/zsh/tab-enhancement.zsh -o ${ZSH_CONF_DIR}/tab-enhancement.zsh

if ! grep -q "$MARKER_START" ~/.zshrc; then
    echo -e "\n$MARKER_START" >> ~/.zshrc
    echo "$LOAD_CMD" >> ~/.zshrc
    echo "$MARKER_END" >> ~/.zshrc
    echo "Injection added to ~/.zshrc"
else
    echo "Configuration markers found in ~/.zshrc, files updated."
fi