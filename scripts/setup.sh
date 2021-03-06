#!/bin/bash
if [ `arch` != "x86_64" ] ; then
  echo -e "\e[31mエラー：このスクリプトはX86_64アーキテクチャのChromebookのみサポートしています。お使いのChromebookはARM製プロセッサなどが搭載されているため、サポートしていません。\e[m"
  exit
fi
# upgrade
echo -e "\e[36m===================================================="
echo -e "\e[36mソフトウェアをアップデート・インストールしています"
echo -e "\e[36m====================================================\e[m"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt update
sudo apt -y upgrade
# set locale
echo -e "\e[36m===================================================="
echo -e "\e[36ロケール（言語設定）を日本語に変更しています"
echo -e "\e[36m====================================================\e[m"
sudo apt install -y locales
echo -e "ja_JP.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
sudo locale-gen
sudo update-locale LANG=ja_JP.UTF-8
echo export LANG=ja_JP.UTF-8 >> ~/.profile
source ~/.profile
# setup Japanese font
echo -e "\e[36m===================================================="
echo -e "\e[36m日本語フォントをインストールしています"
echo -e "\e[36m====================================================\e[m"
sudo apt install -y fontconfig
curl -OL https://github.com/adobe-fonts/source-han-code-jp/archive/2.011R.tar.gz
tar zxf 2.011R.tar.gz
sudo cp ./source-han-code-jp-2.011R/OTF/* /usr/local/share/fonts
sudo fc-cache -fv
# setup Fcitx and mozc
echo -e "\e[36m===================================================="
echo -e "\e[36m日本語IME (mozc)をインストールしています"
echo -e "\e[36m====================================================\e[m"
sudo apt install -y fcitx-mozc
fcitx-remote -a mozc
echo -e "Environment=\"GTK_IM_MODULE=fcitx\"\nEnvironment=\"QT_IM_MODULE=fcitx\"\nEnvironment=\"XMODIFIERS=@im=fcitx\""  | sudo tee -a /etc/systemd/user/cros-garcon.service.d/cros-garcon-override.conf
echo -e "/usr/bin/fcitx-autostart" >> ~/.sommelierrc
# setup VS Code and install Japanese Language Pack Extenstion
echo -e "\e[36m===================================================="
echo -e "\e[36mVisual Studio Codeをインストールしています"
echo -e "\e[36m====================================================\e[m"
sudo apt install -y code
code --install-extension MS-CEINTL.vscode-language-pack-ja
echo -e "{\"locale\":\"ja\"}" > ~/.config/Code/User/locale.json
# remove files
echo -e "\e[36m===================================================="
echo -e "\e[36m一時ファイルを削除しています"
echo -e "\e[36m====================================================\e[m"
rm -rf 2.011R.tar.gz ./source-han-code-jp-2.011R
echo "Complete"