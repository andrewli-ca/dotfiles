#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

# Safely create a symlink, removing any existing symlink at the destination first
link() {
  [ -L "$2" ] && rm "$2"
  ln -sf "$1" "$2"
}

echo "→ Installing Oh My Zsh (if not present)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "→ Installing Zsh plugins..."
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

echo "→ Linking configs..."
mkdir -p ~/.config ~/.config/cheat

link $DOTFILES/nvim ~/.config/nvim
link $DOTFILES/.tmux.conf ~/.tmux.conf
link $DOTFILES/.zshrc ~/.zshrc
mkdir -p ~/.config/cheat/cheatsheets
link $DOTFILES/cheatsheets/personal ~/.config/cheat/cheatsheets/personal
link $DOTFILES/cheatsheets/work ~/.config/cheat/cheatsheets/work

echo "→ Downloading community cheatsheets..."
if [ ! -d ~/.config/cheat/cheatsheets/community ]; then
  git clone https://github.com/cheat/cheatsheets ~/.config/cheat/cheatsheets/community
fi

echo "→ Templating cheat config for current user..."
sed "s|/Users/andrew|$HOME|g" $DOTFILES/cheat-conf.yml > ~/.config/cheat/conf.yml

echo "→ Installing TPM (tmux plugin manager)..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

echo "→ Installing cheat CLI (if not present)..."
if ! command -v cheat &> /dev/null; then
  if command -v brew &> /dev/null; then
    brew install cheat
  else
    echo "⚠ cheat not found — install manually: https://github.com/cheat/cheat"
  fi
fi

echo "✓ Done! Open tmux and press prefix + I to install plugins."
