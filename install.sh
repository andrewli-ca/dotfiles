#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

echo "→ Linking configs..."
mkdir -p ~/.config ~/.config/cheat

ln -sf $DOTFILES/nvim ~/.config/nvim
ln -sf $DOTFILES/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES/.zshrc ~/.zshrc
ln -sf $DOTFILES/cheatsheets ~/.config/cheat/cheatsheets

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
