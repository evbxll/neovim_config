# Install Neovim on macOS

## macOS (Homebrew)

# Install Homebrew if you don't have it
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
```
brew install neovim
mkdir -p ~/.config
cp -r nvim ~/.config/
nvim
```

## Linux

```
sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt update
```

```
sudo apt install neovim
mkdir -p ~/.config
cp -r nvim ~/.config/
nvim
```
