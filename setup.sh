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

# Bash aliases
if [ -f "$HOME/.bashrc" ]; then
    title "Bash aliases"
    if ! grep -Fq '.dotfiles/aliases' "$HOME/.bashrc"; then
        printf '\n%s\n' '[[ -f ~/.dotfiles/aliases ]] && source ~/.dotfiles/aliases' >> "$HOME/.bashrc"
        info "Added aliases to ~/.bashrc"
    else
        info "Aliases already imported from ~/.bashrc"
    fi
fi

# Zsh aliases
if [ -f "$HOME/.zshrc" ]; then
    title "Zsh aliases"
    if ! grep -Fq '.dotfiles/aliases' "$HOME/.zshrc"; then
        printf '\n%s\n' '[[ -f ~/.dotfiles/aliases ]] && source ~/.dotfiles/aliases' >> "$HOME/.zshrc"
        info "Added aliases to ~/.zshrc"
    else
        info "Aliases already imported from ~/.zshrc"
    fi
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

echo $GRN"\nSetup finished. Open a new terminal or run: source ~/.bashrc"$NON
