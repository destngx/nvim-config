## My personal neovim config that is inspired by [EcoVim](https://github.com/ecosse3/nvim) and [jdhao neovim config](https://github.com/jdhao/nvim-config).
Try install script if it works for you.

## Requirements:
1. **[ripgrep](https://github.com/BurntSushi/ripgrep)**
2. **[locate](https://github.com/cljoly/telescope-repo.nvim/discussions/13)**
3. **[fd-find](https://github.com/sharkdp/fd)**
4. **[fzf](https://github.com/junegunn/fzf)**
5. **git version** > 2.30.
6. **[lazy-git](https://github.com/jesseduffield/lazygit)**
``` sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```
## Features
With the following plugins has been integrated into to support for full stack development:

1. **[AdvancedNewFile.nvim]()**: Create new files and folders
2. **[Comment.nvim]()**: quickly comment code with treesitter power
3. **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)**
4. **[alpha-nvim]()** customizable dashboard
5. **[autosave.nvim]()**
6. **[better-escape.nvim]()**
7. **[bigfile.nvim]()**: Automatically turn off some features of neovim when working with large files
8. **[grapple.nvim]()**
9. **[cinnamon.nvim]()**: Smooth scrolling for any movement command or string of commands
10. **[cmp-buffer]()**
11. **[cmp-calc]()**
12. **[cmp-cmdline]()**
13. **[cmp-git]()**
14. **[cmp-npm]()**
15. **[cmp-nvim-lsp]()**
16. **[cmp-nvim-lua]()**
17. **[cmp-path]()**
18. **[cmp-tailwind-colors]()**
19. **[cmp_luasnip]()**
20. **[codeium.nvim]()**: AI code completion (fast but not good privacy)
21. **[comment-box.nvim]()**: create code comment in a styled box
22. **[diffview.nvim]()**
23. **[dressing.nvim]()**: UI enhancement
24. **[flash.nvim]()** navigate like the flash
25. **[friendly-snippets]()**: completion Snippets collection for a set of different programming languages.
26. **[fzf-lua]()**
27. **[galaxyline.nvim]()**: Statusline
28. **[git-conflict.nvim]()**
29. **[git-worktree.nvim]()**
30. **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: super fast git decorations implemented purely in Lua
31. **[glance.nvim]()**: pretty window for previewing, navigating and changing lsp location
32. **[hlargs.nvim]()**
33. **[hydra.nvim]()**
34. **[indent-blankline.nvim]()**
35. **[lazy.nvim]()**
36. **[lazygit.nvim]()**
37. **[lspkind-nvim]()**
38. **[markdown-preview.nvim]()**
39. **[markid]()**
40. **[mason-lspconfig.nvim]()**
41. **[mason.nvim]()**
42. **[mini.ai]()**
43. **[mini.align]()**
44. **[mini.bufremove]()**
45. **[multicursors.nvim]()**
46. **[neovim-session-manager]()**
47. **[noice.nvim]()**: experimental interface for messages, command-line and the popup menu
48. **[nui.nvim]()**
49. **[numb.nvim]()**: Jump or Peak line when typing a number in command_palette
50. **[nvim-autopairs]()**
51. **[nvim-cmp]()**
52. **[nvim-colorizer.lua]()**
53. **[nvim-dap]()**
54. **[nvim-dap-repl-highlights]()**
55. **[nvim-dap-ui]()**
56. **[nvim-dap-virtual-text]()**
57. **[nvim-dap-vscode-js]()**
58. **[nvim-lsp-file-operations]()**: enhances file operations using lsp
59. **[nvim-lspconfig]()**
60. **[vim-sleuth]()**:
61. **[nvim-nonicons]()**
62. **[nvim-notify]()**
63. **[nvim-spectre]()**: refactor, find and replace
64. **[nvim-spider]()**: move by subwords and skip insignificant punctuation
65. **[nvim-surround]()**
66. **[nvim-toggleterm.lua]()**
67. **[nvim-tree.lua]()**: a file explorer tree
68. **[nvim-treesitter]()**: syntax highlighting and code context
69. **[nvim-treesitter-context]()**: view context of current line in the top
70. **[nvim-treesitter-textobjects]()**
71. **[nvim-treesitter-textsubjects]()**
72. **[nvim-ts-context-commentstring]()**
73. **[nvim-ufo]()**
74. **[nvim-web-devicons]()**
75. **[obsidian.nvim]()**: for take note zetelkasten working with obsidian-vault
76. **[octo.nvim]()**
77. **[package-info.nvim]()**: enhancement for package.json
78. **[parrot.nvim]()**: AI assistant
79. **[plenary.nvim]()**
80. **[popup.nvim]()** deprecated
81. **[printer.nvim]()**: quickly put a print/log of the word with `gpiW`
82. **[promise-async]()**
83. **[rainbow-delimiters.nvim]()**
84. **[refactoring.nvim]()**: refactor code like in the book Refactoring by Martin Fowler
85. **[shade.nvim]()**: dim other pane buffer
86. **[stay-in-place.nvim]()**: maintaining the cursor position during various actions
87. **[tailwind-fold.nvim]()**
88. **[tailwind-sorter.nvim]()**
89. **[telescope-fzf-native.nvim]()**
90. **[telescope-repo.nvim]()**
91. **[telescope.nvim]()**
92. **[template-string.nvim]()**: auto change backtick when use template string
93. **[todo-comments.nvim]()**
94. **[tokyonight.nvim]()**: Themes
95. **[treesj]()**: splitting and joining block code efficiency
96. **[trouble.nvim]()**
97. **[tsc.nvim]()**: project wide async ts type-checking
98. **[tw-values.nvim]()**
99. **[twilight.nvim]()**
100. **[typescript-tools.nvim]()**
101. **[vim-indent-object]()**
102. **[vim-python-pep8-indent]()**
103. **[vim-pythonsense]()**
104. **[vim-repeat]()**: dot repeat for non native command
105. **[vim-rooter]()**: change project root to current file
106. **[vim-speeddating]()**
107. **[vim-swap]()**
108. **[vim-table-mode]()**
109. **[which-key.nvim]()**
110. **[wrapping.nvim]()**
111. **[zen-mode.nvim]()**
