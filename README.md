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
mkdir ~/scripts
echo 'export PATH=${HOME}/.local/bin:${HOME}/scripts:${PATH}' >> ~/.zshrc
```
```shell
echo 'alias vim=nvim' >> ~/.zshrc
echo 'alias v=nvim' >> ~/.zshrc
echo 'alias gv="gnome-terminal -- nvim"' >> ~/.zshrc
```
# more aliases
```shell
alias g='grep -i'
alias gr='grep -inr'
alias lrc='source ~/.zshrc'
alias erc='nvim ~/.zshrc'
function mkd() { mkdir "$1" ; cd "$1" ; }
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
