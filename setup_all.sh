#!/usr/bin/env bash

# set -e          # Exit on error
# set -o pipefail # Exit on pipe error
# set -x          # Enable verbosity

# Dont link DS_Store files
find . -name ".DS_Store" -exec rm {} \;

# PROGRAMS=(alias bash env git python scripts stow tmux vim zsh)
PROGRAMS=(alias aspell bash env git latex python scripts stow tmux vim zsh mac terminal)
OLD_DOTFILES="dotfile_bk_$(date -u +"%Y%m%d%H%M%S")"
mkdir $OLD_DOTFILES

function backup_if_exists() {
    if [ -f $1 ]; then
        mv $1 $OLD_DOTFILES
    fi
    if [ -d $1 ]; then
        mv $1 $OLD_DOTFILES
    fi
    if [ -e $1 ]; then
        mv $1 $OLD_DOTFILES
    fi
}


# Clean common conflicts
backup_if_exists ~/.bash_profile
backup_if_exists ~/.bashrc
backup_if_exists ~/.zshrc
backup_if_exists ~/.gitconfig
backup_if_exists ~/.tmux.conf
backup_if_exists ~/.profile
backup_if_exists ~/.p10k.zsh

mkdir -p ~/.vim/undodir

# Get dotfiles directory (where this script is located)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup and link zprezto runcoms to dotfiles
if [[ -d ~/.zprezto/runcoms ]]; then
    for f in ~/.zprezto/runcoms/z*(N); do
        if [[ -f "$f" && ! -L "$f" ]]; then
            mv "$f" $OLD_DOTFILES
        elif [[ -L "$f" ]]; then
            rm "$f"
        fi
    done
    
    # Create symlinks from zprezto runcoms to dotfiles
    for rcfile in zshrc zshenv zprofile zpreztorc zlogin zlogout; do
        if [[ -f "$DOTFILES_DIR/zsh/.zprezto/runcoms/$rcfile" ]]; then
            ln -sf "$DOTFILES_DIR/zsh/.zprezto/runcoms/$rcfile" ~/.zprezto/runcoms/$rcfile
        fi
    done
fi

for program in ${PROGRAMS[@]}; do
  stow -v --target=$HOME $program
  echo "Configuring $program"
done

echo "Done!"
