# j1banez/dotfiles

My dotfiles with a quick installation script.
I do not advice anyone to install it as is but rather
to look at the script if it can help you!

## Installation

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/j1banez/dotfiles/master/setup.sh)"
```

Curl, Git, Vim and Bash must be installed.

Optional dependencies (recommended based on enabled configs):

- Zsh + Oh My Zsh
- Neovim
- Tmux
- Ghostty
- restic (for `bin/s3restic`)
