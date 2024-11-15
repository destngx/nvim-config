<div align="center">
<p>
    <a>
      <img alt="Linux" src="https://img.shields.io/badge/Linux-%23.svg?style=flat-square&logo=linux&color=FCC624&logoColor=black" />
    </a>
    <a>
      <img alt="macOS" src="https://img.shields.io/badge/macOS-%23.svg?style=flat-square&logo=apple&color=000000&logoColor=white" />
    </a>
    <a>
      <img alt="Windows" src="https://img.shields.io/badge/Windows-%23.svg?style=flat-square&logo=windows&color=0078D6&logoColor=white" />
    </a>
    <a href="https://github.com/destngx/nvim-config/releases/latest">
      <img alt="Latest release" src="https://img.shields.io/github/v/release/jdhao/nvim-config" />
    </a>
    <a href="https://github.com/neovim/neovim/releases/tag/stable">
      <img src="https://img.shields.io/badge/Neovim-0.10.0-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green" alt="Neovim minimum version"/>
    </a>
    <a href="https://github.com/destngx/nvim-config/search?l=vim-script">
      <img src="https://img.shields.io/github/languages/top/destngx/nvim-config" alt="Top languages"/>
    </a>
    <a href="https://github.com/destngx/nvim-config/graphs/commit-activity">
      <img src="https://img.shields.io/github/commit-activity/m/destngx/nvim-config?style=flat-square" />
    </a>
    <a href="https://github.com/destngx/nvim-config/releases/tag/v0.9.5">
      <img src="https://img.shields.io/github/commits-since/destngx/nvim-config/v0.9.5?style=flat-square" />
    </a>
    <a href="https://github.com/destngx/nvim-config/graphs/contributors">
      <img src="https://img.shields.io/github/contributors/destngx/nvim-config?style=flat-square" />
    </a>
    <a>
      <img src="https://img.shields.io/github/repo-size/destngx/nvim-config?style=flat-square" />
    </a>
    <a href="https://github.com/destngx/nvim-config/blob/master/LICENSE">
      <img src="https://img.shields.io/github/license/destngx/nvim-config?style=flat-square&logo=GNU&label=License" alt="License"/>
    </a>
</p>
</div>

## My personal neovim config that is inspired by [EcoVim](https://github.com/ecosse3/nvim) and [jdhao neovim config](https://github.com/jdhao/nvim-config).

I use kanagawa theme for better on my eyes :)

Feel free to use it and modify it to your liking. And starred my repo if you like it.

![image](https://github.com/destngx/nvim-config/assets/92440783/db8dd463-82d2-4520-b7f0-226596e29127)

## Prerequisities

- Make sure you have installed the latest version of Neovim v0.9.0+ (nightly is preferred).
- Have wget, curl, unzip, git, make, pip, python, npm, node, luarocks, fd, ripgrep and cargo installed on your system. You can check if you are missing anything with :checkhealth command.
- Have any nerd font installed. Fira Code has been used in screenshots. You can download it from nerdfonts.com.

Try install script if it works for you.
``` sh
cd .install
bash run.sh
```
## Requirements:
1. **[ripgrep](https://github.com/BurntSushi/ripgrep)**
2. **[fd-find](https://github.com/sharkdp/fd)**
3. **[fzf](https://github.com/junegunn/fzf)**: version > 0.53
4. **git version** > 2.30.
5. **[lazy-git](https://github.com/jesseduffield/lazygit)**

``` sh
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
```
## Features

You can search word under cursor with dictionary in MacOS with K in markdown file. Feel free to config other dictionary app if you are using Linux or Windows.

URL highlight and open with `gx` in normal mode using `url-open` plugin.

With the following plugins has been integrated into to support for full stack development:

> [!INFO] I have actively updated this config so it may be changed in the future.
> You can try telescope instead of fzf-lua at telescope branch. But it will not be updated since I don't use it.
> There are some plugins that I don't use but I still keep it for reference use.

1. **[AdvancedNewFile.nvim]()**: Create new files and folders
2. **[Comment.nvim]()**: quickly comment code with treesitter power
3. **[LuaSnip](https://github.com/L3MON4D3/LuaSnip)**
4. **[alpha-nvim]()** customizable dashboard
5. **[autosave.nvim]()**
6. **[better-escape.nvim]()**
7. **[bigfile.nvim]()**: Automatically turn off some features of neovim when working with large files
<!-- 8. **[grapple.nvim]()** -->
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
26. **[fzf-lua]()**: finder, grep text, and more.
27. **[lualine.nvim]()**: Statusline
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
<!-- 44. **[mini.bufremove]()** -->
<!-- 45. **[multicursors.nvim]()** -->
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
<!-- 61. **[nvim-nonicons]()** -->
62. **[nvim-notify]()**
63. **[nvim-spectre]()**: refactor, find and replace
64. **[nvim-spider]()**: move by subwords and skip insignificant punctuation
65. **[nvim-surround]()**
<!-- 66. **[nvim-toggleterm.lua]()** -->
67. **[nvim-tree.lua]()**: a file explorer tree
68. **[nvim-treesitter]()**: syntax highlighting and code context
69. **[nvim-treesitter-context]()**: view context of current line in the top
70. **[nvim-treesitter-textobjects]()**
71. **[nvim-treesitter-textsubjects]()**
72. **[nvim-ts-context-commentstring]()**
73. **[nvim-ufo]()**
74. **[mini-icons]()**
75. **[obsidian.nvim]()**: for take note zetelkasten working with obsidian-vault
<!-- 76. **[octo.nvim]()** -->
<!-- 77. **[package-info.nvim]()**: enhancement for package.json -->
<!-- 78. **[parrot.nvim]()**: AI assistant -->
79. **[plenary.nvim]()**
<!-- 80. **[popup.nvim]()** deprecated -->
81. **[printer.nvim]()**: quickly put a print/log of the word with `gpiW`
82. **[promise-async]()**
83. **[rainbow-delimiters.nvim]()**
84. **[refactoring.nvim]()**: refactor code like in the book Refactoring by Martin Fowler
85. **[shade.nvim]()**: dim other pane buffer
86. **[stay-in-place.nvim]()**: maintaining the cursor position during various actions
87. **[tailwind-fold.nvim]()**
88. **[tailwind-sorter.nvim]()**
<!-- 89. **[telescope-fzf-native.nvim]()** -->
<!-- 90. **[telescope-repo.nvim]()** -->
<!-- 91. **[telescope.nvim]()** -->
92. **[template-string.nvim]()**: auto change backtick when use template string
93. **[todo-comments.nvim]()**
94. **[kanagawa.nvim]()**: Themes
95. **[treesj]()**: splitting and joining block code efficiency
96. **[trouble.nvim]()**
<!-- 97. **[tsc.nvim]()**: project wide async ts type-checking -->
98. **[tw-values.nvim]()**
99. **[twilight.nvim]()**
100. **[vtsls]()**
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
