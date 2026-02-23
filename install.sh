#!/bin/bash
set -e
DOTFILES="$HOME/.dotfiles"

# Safely create a symlink — removes existing symlinks, backs up real files/dirs
link() {
  if [ -L "$2" ]; then
    rm "$2"
  elif [ -e "$2" ]; then
    mv "$2" "$2.bak"
    echo "  backed up $2 → $2.bak"
  fi
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

echo "→ Backing up existing configs..."
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP"
for f in ~/.config/nvim ~/.tmux.conf ~/.zshrc ~/.config/cheat/conf.yml \
          ~/.config/cheat/cheatsheets/personal; do
  [ -e "$f" ] && cp -rL "$f" "$BACKUP/" && echo "  backed up $f"
done

echo "→ Cleaning up old configs..."
rm -rf ~/.config/nvim ~/.tmux.conf ~/.zshrc ~/.config/cheat/conf.yml \
       ~/.config/cheat/cheatsheets/personal

echo "→ Linking configs..."
mkdir -p ~/.config ~/.config/cheat ~/.config/cheat/cheatsheets

link $DOTFILES/nvim ~/.config/nvim
link $DOTFILES/.tmux.conf ~/.tmux.conf
link $DOTFILES/.zshrc ~/.zshrc
link $DOTFILES/cheatsheets/personal ~/.config/cheat/cheatsheets/personal
mkdir -p ~/.config/cheat/cheatsheets/work

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
