#!/usr/bin/env bash

set -e 

IS_WSL=false
while [[ "$#" -gt 0 ]]; do
    case $1 in
        --wsl) IS_WSL=true; shift ;;
        *) shift ;;
    esac
done

TARGET_USER="wilblik"

echo -e "\e[34m[>] Updating pacman keyring and synchronizing system...\e[0m"
pacman-key --init
pacman-key --populate archlinux
pacman -Syu --noconfirm

echo -e "\e[34m[>] Installing packages...\e[0m"
pacman -S --needed --noconfirm base-devel sudo git openssh stow curl vi neovim emacs

if ! id -u "$TARGET_USER" >/dev/null 2>&1; then
    echo -e "\e[34m[>] Setting up user ($TARGET_USER)...\e[0m"
    useradd -m -G wheel -s /bin/bash "$TARGET_USER"
    echo -e "\e[33m[!] Input required: Set the password for $TARGET_USER\e[0m"
    passwd "$TARGET_USER"
else
    echo -e "\e[32m[+] User $TARGET_USER already registered.\e[0m"
fi

echo -e "\e[34m[>] Unlocking wheel group sudo privileges...\e[0m"
sed -i 's/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers

if [ "$IS_WSL" = true ]; then
    echo -e "\e[34m[>] Setting WSL default user to $TARGET_USER...\e[0m"
    cat <<EOF > /etc/wsl.conf
[user]
default=$TARGET_USER
EOF
fi

echo -e "\e[34m[>] Installing AUR wrapper (yay)...\e[0m"
su - "$TARGET_USER" -c '
    if ! command -v yay &> /dev/null; then
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        rm -rf /tmp/yay
    else
        echo "yay is already installed."
    fi
'

echo -e "\e[34m[>] Configuring git...\e[0m"
git config --global init.defaultBranch master
git config --global user.email "48726405+Wilblik@users.noreply.github.com"
git config --global user.name "Wilblik"

echo -e "\e[34m[>] Setting up SSH keys...\e[0m"
su - "$TARGET_USER" -c '
    SSH_DIR="$HOME/.ssh"
    KEY_FILE="$SSH_DIR/id_ed25519"
    
    if [ ! -f "$KEY_FILE" ]; then
        mkdir -p "$SSH_DIR"
        chmod 700 "$SSH_DIR"
        # Generate the key with no passphrase (-N "") for seamless automation
        ssh-keygen -t ed25519 -C "48726405+Wilblik@users.noreply.github.com" -f "$KEY_FILE" -N ""
        echo "SSH key generated successfully."
    else
        echo "SSH key already exists. Skipping generation."
    fi
    
    echo -e "\e[33m[!] Your public SSH key for GitHub:\e[0m"
    cat "${KEY_FILE}.pub"
'

echo -e "\e[32m[+] Setup complete.\e[0m"

if [ "$IS_WSL" = true ]; then
    echo -e "\e[33m[!] Action Required: Restart the WSL instance for changes to take effect.\e[0m"
    echo -e "    Run this in PowerShell: wsl --terminate archlinux"
else
