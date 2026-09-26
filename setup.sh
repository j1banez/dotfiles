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
exe ln -sf "$DOTFILES_DIR/.vimrc" "$HOME/.vimrc"
info "Vim config done!"

# Neovim: keep the existing LazyVim init.lua
title "Neovim"
if [ -f "$HOME/.config/nvim/init.lua" ]; then
    mkdir -p "$HOME/.config/nvim/lua/plugins"
    set -- "$DOTFILES_DIR/.config/nvim/lua/plugins/"*.lua
    if [ -e "$1" ]; then
        for plugin do
            nvim_custom="$HOME/.config/nvim/lua/plugins/${plugin##*/}"
            if [ -e "$nvim_custom" ] && [ ! -L "$nvim_custom" ]; then
                warning "Skipping $nvim_custom: file already exists"
            else
                exe ln -sfn "$plugin" "$nvim_custom"
            fi
        done
    else
        warning "No Neovim plugins found in dotfiles"
    fi
else
    warning "Neovim config not found; install LazyVim first"
fi

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

# Ghostty
title "Ghostty"
mkdir -p "$HOME/.config/ghostty"
ghostty_config="$HOME/.config/ghostty/config"
ghostty_custom="$DOTFILES_DIR/.config/ghostty/config"
if [ ! -e "$ghostty_config" ] && [ ! -L "$ghostty_config" ]; then
    exe ln -s "$ghostty_custom" "$ghostty_config"
elif [ -f "$ghostty_config" ] && [ ! -L "$ghostty_config" ] && ! grep -Fq "$ghostty_custom" "$ghostty_config"; then
    # Do not write through symlinks: they may point to system-managed files.
    printf '\nconfig-file = "%s"\n' "$ghostty_custom" >> "$ghostty_config"
fi
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
mkdir -p "$HOME/.local/bin"
set -- "$DOTFILES_DIR/bin/"*
if [ -e "$1" ]; then
    for program do
        [ -f "$program" ] || continue
        destination="$HOME/.local/bin/${program##*/}"
        if [ -e "$destination" ] && [ ! -L "$destination" ]; then
            warning "Skipping $destination: file already exists"
        else
            exe ln -sfn "$program" "$destination"
        fi
    done
    info "Programs linked in ~/.local/bin"
else
    warning "No files found in $DOTFILES_DIR/bin"
fi

echo $GRN"\nSetup finished."$NON
