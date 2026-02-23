#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

echo "→ Installing Oh My Zsh (if not present)..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

echo "→ Linking configs..."
mkdir -p ~/.config ~/.config/cheat

ln -sf $DOTFILES/nvim ~/.config/nvim
ln -sf $DOTFILES/.tmux.conf ~/.tmux.conf
ln -sf $DOTFILES/.zshrc ~/.zshrc
# Remove old whole-dir symlink if present (migration from older setup)
if [ -L ~/.config/cheat/cheatsheets ]; then
  rm ~/.config/cheat/cheatsheets
fi
mkdir -p ~/.config/cheat/cheatsheets
ln -sf $DOTFILES/cheatsheets/personal ~/.config/cheat/cheatsheets/personal
ln -sf $DOTFILES/cheatsheets/work ~/.config/cheat/cheatsheets/work

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
