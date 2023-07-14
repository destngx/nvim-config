# My personal neovim config that is inspired by [Ecovim](https://github.com/ecosse3/nvim).

## Requirement:
- ripgrep
- locate
- fd-find
- fzf
- git > 2.30.
- lazy-git
```
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```

## With the following plugins has been integrated into to support for backend:
- codeium free AI code assistance
- Lazy nvim
- nvim spider for jump_by_subwords
- winbar lsp with nvim-navic 
- nvim nonicons and nvim-web-devicons
- alpha.nvim: start screen
- treesitter
- auto-save.nvim
- better-escape.nvim
- *nvim-spectre: find and replace
- telescope
- nvim-tree: explorer
- stay-in-place: keep cursor place when tab selected lines
- lsp and mason for language server
- nvim-cmp for show completion
- dressing show model for command, searchbox, etc.
- lspkind show icon for completion
- trouble.nvim show diagnostic inline
- typescript-tool: better tsserver
- *template-string: auto change quote to back tick when use ${}
- tsc.nvim to check ts type error
- *glance.nvim inspire by vscode peekview
- *treessj split join line in a neat way
- Comment.nvim, comment box: comment out code
- toggle-term
- nvim-repeat with dot key
- vim-table-mode for markdown
- *vim-visual-multi multi cursor
- numb.nvim peek when inser line number
- better comment with todo comment
- zen mode w/ twilight theme
- *jumping around with flash.nvim
- show key binding with which-key
- bufferline/galaxyline
- bufremoved.nvim
- nvim-notify
- package-info in package.json show version
- open markdown preview in browser
- *neovim-session-manager
- *nvim surround to quick wrap selected with brackets
- *shade inactive window with shade.nvim
- ultra folding with nvim-ufo
- *alignment with mini.align
- *mini.ai
- quickly put a print/log of the word with `gpiW`
- indent-blankline
- nvim-autopairs
- nvim-colorizer to show color in code
- cmp-tailwind-colors: tailwindcss color hints to nvim-cmp completion results
- fold tailwind classname with tailwind-fold
- gitsigns to show git status on leftside of buffer
- git diffview
- *git-conflict
- *git-worktree
- lazygit
- *debug with nvim-dap, nvim-dap-repl-highlights
# Custom key set thta support fullstack
