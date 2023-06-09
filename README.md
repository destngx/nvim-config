# My personal neovim config that is inspired by [Ecovim](https://github.com/ecosse3/nvim).

# With the following plugins has been integrated into to support for backend:

- better-escape
- pylsp
- dockerls
- auto-save

# Requirement:
fd-find, fzf, git > 2.30.

lazy-git
```
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

