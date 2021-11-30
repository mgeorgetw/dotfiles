Create required directories:

```bash
mkdir -p ~/.config/nvim
mkdir -p ~/tmp
```

Create symlinks:

```bash
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim
ln -s ~/dotfiles/vim/coc-settings.json ~/.config/nvim/coc-settings.json
```

- All plugins and scripts are stored in the dotfiles/vim directory.
