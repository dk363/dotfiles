This is my dotfiles repo. :) 

I hope you like it. 

# Usage: 

1. run zsh.sh to use zsh as your shell
2. install homebrew with 
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
3. cd .dotfiles dir and run
```bash
brew bundle install
```
4. install miniforge as python package manager. 
```bash
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

bash Miniforge3-$(uname)-$(uname -m).sh
```
5. install docker 
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

