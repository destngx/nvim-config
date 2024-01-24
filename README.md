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
# Custom key set that support fullstack

1. Search and Navigation:

diffview.nvim
telescope-fzf-native.nvim
telescope-repo.nvim
telescope.nvim

2.Markdown and Preview:

markdown-preview.nvim

3. Version Control:

git-conflict.nvim
git-worktree.nvim
gitsigns.nvim
octo.nvim

4. Debugging:

nvim-dap
nvim-dap-repl-highlights
nvim-dap-ui
nvim-dap-virtual-text
nvim-dap-vscode-js

5. Project Management:

neovim-session-manager
nvim-rooter

6. Appearance Themes:

tokyonight.nvim

7. Colors and Syntax Highlighting:

nvim-colorizer.lua
twilight.nvim

8. Snippets:

friendly-snippets

9. LSP (Language Server Protocol):

nvim-lsp-file-operations
nvim-lspconfig
nvim-treesitter
nvim-treesitter-textobjects
nvim-treesitter-textsubjects
nvim-ts-context-commentstring



10. Code Formatting, Indentation, and Auto-pairing:

nvim-autopairs
vim-indent-object
vim-python-pep8-indent
vim-pythonsense

11. Git Integration:

git-conflict.nvim
git-worktree.nvim
gitsigns.nvim
octo.nvim

12. Popup and Notifications:

popup.nvim
nvim-notify

13. Performance and Speed:

lazy.nvim
lazygit.nvim

14. File Operations:

nvim-lsp-file-operations

15. Quality of Life:

stay-in-place.nvim
vim-repeat
vim-speeddating
vim-swap

16. User Interface:

alpha-nvim
bufferline.nvim
galaxyline.nvim
indent-blankline.nvim
nvim-tree.lua
popup.nvim

17. Utility:

bigfile.nvim
glance.nvim
noice.nvim
nui.nvim
numb.nvim
promise-async
refactoring.nvim
shade.nvim
tailwind-fold.nvim
tailwind-sorter.nvim
template-string.nvim
todo-comments.nvim
treesj
trouble.nvim
tsc.nvim
tw-values.nvim
vim-rooter
wrapping.nvim

