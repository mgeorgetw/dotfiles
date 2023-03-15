Create required directories:

```bash
mkdir -p ~/.config/nvim
mkdir -p ~/tmp
```

Create symlinks:

```bash
ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/vimrc ~/.vim/vimrc
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/vim/coc-settings.json ~/.config/nvim/coc-settings.json
ln -s ~/dotfiles/global-gitignore ~/.gitignore
```

Install tools:

RipGrep

```bash
brew install ripgrep
```

```bash
sudo port install ripgrep
```

Install FD

```bash
brew install fd
```

```bash
sudo port install fd
```

- All plugins and scripts are stored in the dotfiles/vim directory.