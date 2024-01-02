#!/usr/bin/env bash
CRE=$(tput setaf 1)
CYE=$(tput setaf 3)
CGR=$(tput setaf 2)
CBL=$(tput setaf 4)
BLD=$(tput bold)
CNC=$(tput sgr0)

username=$(whoami)
backup_folder=~/.ricebkp
date=$(date +%Y%m%d-%H%M%S)

logo () {
local text="${1:?}"
printf "\n"
echo "██╗   ██╗███╗   ███╗██╗    ██╗ █████╗ ██╗   ██╗██╗███████╗";
echo "██║   ██║████╗ ████║██║    ██║██╔══██╗██║   ██║██║██╔════╝";
echo "██║   ██║██╔████╔██║██║ █╗ ██║███████║██║   ██║██║█████╗  ";
echo "╚██╗ ██╔╝██║╚██╔╝██║██║███╗██║██╔══██║╚██╗ ██╔╝██║██╔══╝  ";
echo " ╚████╔╝ ██║ ╚═╝ ██║╚███╔███╔╝██║  ██║ ╚████╔╝ ██║███████╗";
echo "  ╚═══╝  ╚═╝     ╚═╝ ╚══╝╚══╝ ╚═╝  ╚═╝  ╚═══╝  ╚═╝╚══════╝";
printf "\n\n"
printf '%s%s%s%s%s%s%s' "${CRE}" "${text}"
}

logo "Welcome ${username}!"

printf '\n%s%sThis script will change your systems configuration files, and install some development tools of your choice.\n Although the backup will be made, it will only be your configurations, so only install it if you are completely sure of what you are doing.%s\n\n' "${BLD}" "${CRE}" "${CNC}"

while true; do
	read -rp "Do you wish to continue? [y/N]: " yn
		case $yn in
			[Yy]* ) break;;
			[Nn]* ) exit;;
			* ) printf " Error: just write 'y' or 'n'\n\n";;
		esac
    done
clear

logo "Installing needed packages.."

dependencias=(base-devel rustup pacman-contrib bspwm polybar sxhkd \
			  alacritty brightnessctl neovim dunst rofi lsd stalonetray \
			  jq polkit-gnome git playerctl mpd xclip \
			  geany ranger mpc xdo xdotool jgmenu \
			  feh ueberzug maim pamixer libwebp xdg-user-dirs \
			  webp-pixbuf-loader xorg-xprop xorg-xkill physlock papirus-icon-theme \
			  ttf-jetbrains-mono ttf-jetbrains-mono-nerd ttf-terminus-nerd ttf-inconsolata ttf-joypixels \
			  zsh zsh-autosuggestions zsh-history-substring-search zsh-syntax-highlighting \
			  imagemagick xorg-xdpyinfo xorg-xsetroot xorg-xwininfo xorg-xrandr meson ninja)

is_installed() {
  pacman -Qi "$1" &> /dev/null
  return $?
}

printf "%s%s\nChecking for required packages...%s\n" "${BLD}" "${CBL}" "${CNC}"
for paquete in "${dependencias[@]}"
do
  if ! is_installed "$paquete"; then
    sudo pacman -S "$paquete" --noconfirm
    printf "\n"
  else
    printf '%s%s is already installed on your system!%s\n' "${CGR}" "$paquete" "${CNC}"
    sleep 1
  fi
done
sleep 3
clear

logo "Installing paru"
rustup default stable
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
cd ..
rm -rf paru
sleep 5
clear

logo "Installing packages, select the best option for the packages listed"
paru -a picom-git
paru -a google-chrome
paru -a visual-studio-code-bin
paru -a betterlockscreen

bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
sleep 5
clear

echo ""
logo "Select the necessary development environments:"
echo ""
source utils/checkbox.sh "android-sdk" "react" "flutter" "vuejs" "php" "nodejs"

printf "\n"

android_sdk=false;
react=false;
flutter=false;
vuejs=false;
php=false;
nodejs=false;

for ((i = 0; i < max; i++)); do
  if [ "$i" = 0 ] && [ "${selected[i]}" = true ]; then
    android_sdk=true;
  fi
  if [ "$i" = 1 ] && [ "${selected[i]}" = true ]; then
    react=true;
  fi
  if [ "$i" = 2 ] && [ "${selected[i]}" = true ]; then
    flutter=true;
  fi
  if [ "$i" = 3 ] && [ "${selected[i]}" = true ]; then
    vuejs=true;
  fi
  if [ "$i" = 4 ] && [ "${selected[i]}" = true ]; then
    php=true;
  fi
  if [ "$i" = 5 ] && [ "${selected[i]}" = true ]; then
    nodejs=true;
  fi
done
sleep 5
clear

if [ $android_sdk == true ];then
    logo "Setuping android-sdk environment..."
    sudo pacman -S jdk17-openjdk 
    archlinux-java set java-17-openjdk
    paru -a android-studio
    sleep 5
    clear
fi

if [ $react == true ];then
    logo "Setuping react-js/react-native environment (for react-native emulator use android-sdk option)..."
    sudo pacman -S nodejs npm yarn 
    paru -a nvm
    sudo npm install -g typescript --save-dev
    sleep 5
    clear
fi

if [ $flutter == true ];then
    logo "Setuping flutter environment (for emulator use android-sdk option).."
    paru -a flutter
    sleep 5
    clear
fi

if [ $vuejs == true ];then
    logo "Setuping vuejs environment..."
    sudo pacman -S nodejs npm yarn 
    paru -a nvm
    sudo npm install -g @vue/cli
    sleep 5
    clear
fi

if [ $php == true ];then
    logo "Setuping php environment..."
    sudo pacman -S nodejs npm yarn 
    paru -a php72
    paru -a php72-fpm
    paru -a php72-xdebug
    sudo pacman -S nginx
    sudo systemctl enable php72-fpm
    sudo systemctl enable nginx
    cp dotfiles/misc/nginx/nginx.conf /etc/nginx/
    cp dotfiles/misc/php/40-xdebug.ini /etc/php72/conf.d/
    sleep 5
    clear
fi

if [ $nodejs == true ];then
    logo "Setuping nodejs environment..."
    sudo pacman -S nodejs npm yarn 
    paru -a nvm
    paru -a postman-bin
    sleep 5
    clear
fi