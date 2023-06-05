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
ln -s ~/dotfiles/vim/pack ~/.config/nvim/pack
ln -s ~/dotfiles/global-gitignore ~/.gitignore
```

Install tools:

RipGrep recursively searches directories

```bash
brew install ripgrep
```

Install FD, an alternative to `find`

```bash
brew install fd
```

Tree-sitter language parser for syntax highlighting

```bash
brew install tree-sitter
```

Prettierd for Prettier support

```bash
brew install fsouza/prettierd/prettierd
```

Eslint_d for fast linting

```bash
yarn global add eslint_d
```


- All plugins and scripts are stored in the dotfiles/vim directory.
