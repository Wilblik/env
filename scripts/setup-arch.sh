#!/usr/bin/env bash

set -e

echo -e "\e[34m[>] Updating pacman keyring and updating system...\e[0m"
sudo pacman-key --init
sudo pacman-key --populate archlinux
sudo pacman -Syu --noconfirm

echo -e "\e[34m[>] Installing packages...\e[0m"
sudo pacman -S --needed --noconfirm base-devel git openssh stow curl neovim emacs zsh less ripgrep fd htop cmake openrgb openal steam keepassxc

echo -e "\e[34m[>] Installing AUR wrapper (yay)...\e[0m"
if ! command -v yay &> /dev/null; then
    cd /tmp
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd "$HOME"
    rm -rf /tmp/yay
else
    echo "yay is already installed."
fi

echo -e "\e[34m[>] Installing AUR packages...\e[0m"
yay -Sy --needed --noconfirm brave-bin coolercontrol-bin

echo -e "\e[34m[>] Enforcing XDG Base Directory specification for ZSH...\e[0m"
sudo mkdir -p /etc/zsh
echo 'export ZDOTDIR="$HOME/.config/zsh"' | sudo tee /etc/zsh/zshenv

echo -e "\e[34m[>] Changing default shell to ZSH...\e[0m"
chsh -s /usr/bin/zsh

echo -e "\e[34m[>] Provisioning ZSH framework and plugins...\e[0m"
XDG_DATA_HOME="$HOME/.local/share"
ZSH_DIR="$XDG_DATA_HOME/ohmyzsh"
ZSH_CUSTOM="$ZSH_DIR/custom"

mkdir -p "$XDG_DATA_HOME"

if [ ! -d "$ZSH_DIR" ]; then
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$ZSH_DIR"
fi

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

echo -e "\e[34m[>] Setting up SSH keys...\e[0m"
SSH_DIR="$HOME/.ssh"
KEY_FILE="$SSH_DIR/id_ed25519"

if [ ! -f "$KEY_FILE" ]; then
    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"
    ssh-keygen -t ed25519 -C "48726405+Wilblik@users.noreply.github.com" -f "$KEY_FILE" -N ""
    echo "SSH key generated successfully."
else
    echo "SSH key already exists. Skipping generation."
fi

echo -e "\e[34m[>] Cloning environment repository and provisioning Stow...\e[0m"
if [ ! -d "$HOME/.env" ]; then
    git clone https://github.com/Wilblik/env.git "$HOME/.env"
else
    echo "Environment repository already exists."
fi

if [ -d "$HOME/.env/dotfiles" ]; then
    cd "$HOME/.env/dotfiles"
    for pkg in */ ; do
	pkg_name="${pkg%/}"
        if stow -t "$HOME" "$pkg_name" 2>/dev/null; then
            echo -e "\e[32m[+] Stowed: $pkg_name\e[0m"
        else
            echo -e "\e[33m[!] Skipped $pkg_name: Conflict detected.\e[0m"
        fi
    done
else
    echo -e "\e[31m[!] Error: dotfiles directory not found in repository.\e[0m"
fi

echo -e "\e[34m[>] Provisioning Doom Emacs...\e[0m"

export XDG_CONFIG_HOME="$HOME/.config"
export EMACSDIR="$XDG_CONFIG_HOME/emacs"
export DOOMDIR="$XDG_CONFIG_HOME/doom"

if [ ! -d "$EMACSDIR" ]; then
    git clone --depth 1 https://github.com/doomemacs/doomemacs "$EMACSDIR"
    yes | "$EMACSDIR/bin/doom" install
    yes | "$EMACSDIR/bin/doom" sync
else
    echo "Doom Emacs is already installed."
fi

echo -e "\e[36m--------------------------------------------------\e[0m"
echo -e "\e[33m[!] Your public SSH key for GitHub:\e[0m"
cat "${KEY_FILE}.pub"
echo -e "\e[33m[!] Add this key to https://github.com/settings/keys\e[0m"
echo -e "\e[36m--------------------------------------------------\e[0m"

echo -e "\e[32m[+] Setup complete.\e[0m"
