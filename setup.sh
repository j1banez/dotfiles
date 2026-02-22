#!/bin/sh

set -e

# Colors for output
GRN="\033[0;32m"
BLU="\033[0;34m"
RED="\033[0;31m"
YEL="\033[0;33m"
PUR="\033[1;35m"
NON="\033[0m"

# Gets the absolute path of the dotfiles directory
DOTFILES_DIR="$HOME/.dotfiles"

# Prints a title
title() { echo "\n"$BLU"$@:"$NON ; }

# Prints an information
info() { echo $PUR": $@"$NON ; }

# Prints a warning
warning() { echo $RED"! $@"$NON ; }

# Prints && executes a command
exe() { echo $YEL"> $@"$NON ; "$@" ; }

# Tries to git clone
trygit() { exe git clone "$@" 2>/dev/null || warning "git repository already exists" ; }

#
# Setup start
#

title ".dotfiles"
# Clones dotfiles if needed
trygit https://github.com/j1banez/dotfiles "$DOTFILES_DIR"
# (-(-.(-.-).-)-)
info "dotfiles git repository path: $DOTFILES_DIR"

# Git
title "Git"
# Symlinks git config files
exe ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
exe ln -sf "$DOTFILES_DIR/.gitignore_global" "$HOME/.gitignore_global"
info "Git config done!"

# Vim
title "Vim"
# Symlinks .vim directory
exe ln -sfn "$DOTFILES_DIR/.vim" "$HOME/.vim"
# Install/Clone Vundle into .vim/bundle
trygit https://github.com/VundleVim/Vundle.vim.git "$HOME/.vim/bundle/Vundle.vim"
# Symlinks vimrc
exe ln -sf "$HOME/.vim/vimrc" "$HOME/.vimrc"
# Install vim plugin via Vundle
exe vim +PluginInstall +qall
info "Vim config done!"

# Neo Vim
title "Neo Vim"
mkdir -p "$HOME/.config/nvim"
exe ln -sf "$DOTFILES_DIR/.config/nvim/init.lua" "$HOME/.config/nvim/init.lua"
info "Neo Vim config done!"

# Bash
title "Bash"
# Download git-prompt script
if [ ! -f "$HOME/.git-prompt.sh" ]; then
    curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o "$HOME/.git-prompt.sh"
fi
# Symlinks bashrc
exe ln -sf "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
info "Bash config done!"

# Zsh
title "Zsh"
if [ -d "$HOME/.oh-my-zsh" ]; then
    exe ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
    exe ln -sfn "$DOTFILES_DIR/.oh-my-zsh/custom" "$HOME/.oh-my-zsh/custom"
    info "Zsh config done!"
else
    warning "Oh My Zsh not found. Install it manually first: https://ohmyz.sh"
    warning "Then run setup.sh again to link ~/.zshrc and ~/.oh-my-zsh/custom"
fi

# Tmux
title "Tmux"
exe ln -sf "$DOTFILES_DIR/.tmux.conf" "$HOME/.tmux.conf"
info "Tmux config done!"

# Ghostty
title "Ghostty"
mkdir -p "$HOME/.config/ghostty"
exe ln -sf "$DOTFILES_DIR/.config/ghostty/config" "$HOME/.config/ghostty/config"
info "Ghostty config done!"

# s3restic local config
title "s3restic"
mkdir -p "$HOME/.config/s3restic"
if [ ! -f "$HOME/.config/s3restic/env" ]; then
    cat > "$HOME/.config/s3restic/env" <<'EOF'
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export BUCKET_NAME=
EOF
    chmod 600 "$HOME/.config/s3restic/env"
    info "Created $HOME/.config/s3restic/env"
fi
info "s3restic config done!"

title "bin"
# Create bin directory
mkdir -p "$HOME/bin"
# Copy programs into home bin directory
set -- "$DOTFILES_DIR/bin/"*
if [ -e "$1" ]; then
    cp -r "$@" "$HOME/bin"
    info "Some programs has been placed in ~/bin"
else
    warning "No files found in $DOTFILES_DIR/bin"
fi

echo $GRN"\nSetup finished. Open a new terminal or run: source ~/.zshrc"$NON
