# install
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/yoavdim/vimrc/master/setup_nvim.sh)"
```
# zsh
```shell
sudo apt-get install zsh
```
```shell
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
```shell
echo 'export PATH=${HOME}/.local/bin:${PATH}' >> ~/.zshrc
```
```shell
echo 'alias vim=nvim' >> ~/.zshrc
echo 'alias v=nvim' >> ~/.zshrc
echo 'alias g=gnome-terminal -- nvim' >> ~/.zshrc
```
# keygen
```shell
ssh-keygen -t ed25519 -C "yoav.dim@github.com"  # press Enters
```
```shell
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
cat ~/.ssh/id_ed25519.pub
```
copy-paste here: https://github.com/settings/ssh/new
