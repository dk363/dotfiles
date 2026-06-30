This is my dotfiles repo. :) 

I hope you like it. 

# Usage: 

1. run zsh.sh to use zsh as your shell and oh-my-zsh

2. Refine vim
```bash
sudo apt update
sudo apt install vim-gtk3
sudo apt install xclip
```

3. install rcm 
```bash
rcup -v
```

4. install miniforge as python package manager. 
```bash
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"

bash Miniforge3-$(uname)-$(uname -m).sh
```

after install conda, edit .condarc
```
auto_activate: false
```

5. install docker 
```bash
sudo sh get-docker.sh
```

