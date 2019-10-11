#!/bin/bash
if [ `arch` != "x86_64" ] ; then
  exit
fi
# upgrade
echo -e "\e[36m===================================================="
echo -e "\e[36mUpdating Softwares..."
echo -e "\e[36m====================================================\e[m"
sudo apt update
sudo apt -y upgrade
# set locale
echo -e "\e[36m===================================================="
echo -e "\e[36mChanging locale (language) from English to Japanese..."
echo -e "\e[36m====================================================\e[m"
sudo apt install -y locales
echo -e "ja_JP.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=ja_JP.UTF-8
echo export LANG=ja_JP.UTF-8 >> ~/.profile
source ~/.profile
# setup Japanese font
echo -e "\e[36m===================================================="
echo -e "\e[36mInstalling Japanese Fonts..."
echo -e "\e[36m====================================================\e[m"
sudo apt install -y fontconfig
curl -OL https://github.com/adobe-fonts/source-han-code-jp/archive/2.011R.tar.gz
tar zxf 2.011R.tar.gz
sudo cp ./source-han-code-jp-2.011R/OTF/* /usr/local/share/fonts
sudo fc-cache -fv
# setup Fcitx and mozc
echo -e "\e[36m===================================================="
echo -e "\e[36mInstalling Japanese IME..."
echo -e "\e[36m====================================================\e[m"
sudo apt install -y fcitx-mozc
fcitx-remote -a mozc
echo -e "Environment=\"GTK_IM_MODULE=fcitx\"\nEnvironment=\"QT_IM_MODULE=fcitx\"\nEnvironment=\"XMODIFIERS=@im=fcitx\""  | sudo tee -a /etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf
echo -e "/usr/bin/fcitx-autostart" >> ~/.sommelierrc
# setup VS Code and install Japanese Language Pack Extenstion
echo -e "\e[36m===================================================="
echo -e "\e[36mInstalling VS Code..."
echo -e "\e[36m====================================================\e[m"
curl -OL "https://go.microsoft.com/fwlink/?LinkID=760868" > vscode.deb
sudo apt install ./vscode.deb -y
code --install-extension MS-CEINTL.vscode-language-pack-ja
echo -e "{\"locale\":\"ja\"}" > ~/.config/Code/User/locale.json
# remove files
echo -e "\e[36m===================================================="
echo -e "\e[36mDelete "
echo -e "\e[36m====================================================\e[m"
rm -rf vscode.deb 2.011R.tar.gz ./source-han-code-jp-2.011R
echo "Complete"