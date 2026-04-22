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


echo "→ Backing up existing configs..."
BACKUP="$HOME/.dotfiles-backup-$(date +%Y%m%d%H%M%S)"
mkdir -p "$BACKUP"
for f in ~/.config/nvim ~/.tmux.conf ~/.zshrc ~/.p10k.zsh ~/.config/cheat/conf.yml \
          ~/.config/cheat/cheatsheets/personal \
          "$HOME/Library/Preferences/glow/glow.yml"; do
  [ -e "$f" ] && cp -rL "$f" "$BACKUP/" && echo "  backed up $f"
done

echo "→ Cleaning up old configs..."
rm -rf ~/.config/nvim ~/.tmux.conf ~/.zshrc ~/.p10k.zsh ~/.config/cheat/conf.yml \
       ~/.config/cheat/cheatsheets/personal \
       "$HOME/Library/Preferences/glow/glow.yml"

echo "→ Linking configs..."
mkdir -p ~/.config ~/.config/cheat ~/.config/cheat/cheatsheets ~/.config/ghostty \
         "$HOME/Library/Preferences/glow"

link $DOTFILES/nvim ~/.config/nvim
link $DOTFILES/.tmux.conf ~/.tmux.conf
link $DOTFILES/.zshrc ~/.zshrc
link $DOTFILES/.p10k.zsh ~/.p10k.zsh
link $DOTFILES/cheatsheets/personal ~/.config/cheat/cheatsheets/personal
link $DOTFILES/ghostty/config ~/.config/ghostty/config
sed "s|/Users/andrew|$HOME|g" $DOTFILES/glow/glow.yml > "$HOME/Library/Preferences/glow/glow.yml"
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

echo "→ Installing CLI tools via Homebrew..."
if command -v brew &> /dev/null; then
  brew bundle --file="$DOTFILES/Brewfile"
  # Symlink brew-installed zsh plugins into oh-my-zsh custom directory
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  ln -sf "$(brew --prefix)/share/powerlevel10k" "$ZSH_CUSTOM/themes/powerlevel10k"
  ln -sf "$(brew --prefix)/share/zsh-autosuggestions" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  ln -sf "$(brew --prefix)/share/zsh-syntax-highlighting" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  # Install fzf shell bindings (key bindings + completion) non-interactively
  if [ ! -f ~/.fzf.zsh ]; then
    "$(brew --prefix)/opt/fzf/install" --all --no-bash --no-fish
  fi
else
  echo "⚠ Homebrew not found — install missing tools manually:"
  echo "  neovim, tmux, lazygit, ripgrep, fd, fzf, cheat, glow, sqlite-rsync"
fi

echo "→ Reloading tmux config (if running)..."
if tmux info &>/dev/null 2>&1; then
  tmux source-file ~/.tmux.conf
  echo "  tmux config reloaded"
fi

echo "✓ Done! Open tmux and press prefix + I to install plugins."
echo "  Run 'source ~/.zshrc' or open a new terminal to load shell functions."
