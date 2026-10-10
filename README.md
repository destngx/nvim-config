# DestNgxVim

<p align="center">
  <img alt="Linux" src="https://img.shields.io/badge/Linux-%23.svg?style=flat-square&logo=linux&color=FCC624&logoColor=black" />
  <img alt="macOS" src="https://img.shields.io/badge/macOS-%23.svg?style=flat-square&logo=apple&color=000000&logoColor=white" />
  <a href="https://github.com/neovim/neovim/releases/tag/stable">
    <img alt="Neovim minimum version" src="https://img.shields.io/badge/Neovim-0.11%2B-blueviolet.svg?style=flat-square&logo=Neovim&logoColor=green" />
  </a>
  <a href="https://github.com/destngx/nvim-config/graphs/commit-activity">
    <img alt="Commit activity" src="https://img.shields.io/github/commit-activity/m/destngx/nvim-config?style=flat-square" />
  </a>
  <a href="https://github.com/destngx/nvim-config/blob/master/LICENSE">
    <img alt="License" src="https://img.shields.io/github/license/destngx/nvim-config?style=flat-square&logo=GNU&label=License" />
  </a>
</p>

My personal Neovim config in Lua, managed with [lazy.nvim](https://github.com/folke/lazy.nvim).
Started from [EcoVim](https://github.com/ecosse3/nvim), with ideas from
[jdhao/nvim-config](https://github.com/jdhao/nvim-config). Theme: kanagawa.

![screenshot](https://github.com/destngx/nvim-config/assets/92440783/db8dd463-82d2-4520-b7f0-226596e29127)

## Requirements

> [!TIP]
> Recommended: use [destngx/dotfiles](https://github.com/destngx/dotfiles) (Nix) to spin up
> everything below in one go. It is optional - installing the tools manually works too.

- Neovim **0.11+**, `git`, `curl`, `unzip`, a C compiler
- `ripgrep`, `fd`, `fzf` 0.53+
- `node` / `npm`, `python3` / `pip` (Mason installs servers with these)
- A [Nerd Font](https://www.nerdfonts.com/)
- Optional, picked up when on `PATH`: `lazygit`, `delta`, `tree-sitter` CLI,
  `tofu` / `terraform` (+ `tofu-ls` / `terraform-ls`), `trivy`, `checkov`

> [!NOTE]
> If `nix` is on `PATH`, the config reads the dotfiles flake at `~/projects/dotfiles` to locate
> SQLite for nvim-neoclip history. Without that clone, neoclip reports an error on load.
> Without Nix, this step is skipped.

Run `:checkhealth` to see what is missing.

## Installation

```sh
mv ~/.config/nvim ~/.config/nvim.bak   # back up existing config
git clone https://github.com/destngx/nvim-config.git ~/.config/nvim
nvim                                   # lazy.nvim bootstraps and installs plugins
```

`.install/run.sh` is an interactive alternative; it **deletes** `~/.config/nvim` and
`~/.local/share/nvim` (after offering a backup).

## Configuration

User switches live in [`lua/config/DestNgxVim.lua`](lua/config/DestNgxVim.lua): colorscheme,
float borders, completion behavior, rooter patterns, AI toggles (or `COPILOT=1`),
notification engine, inline diagnostics and dashboard splash.

The Obsidian vault path is hardcoded in `lua/plugins/languages/markdown_file.lua`.

## Features

- **Completion / LSP:** blink.cmp, native `vim.lsp.config` with Mason, conform (biome or
  prettier), nvim-lint, trouble, tiny-inline-diagnostic, TypeScript and Tailwind helpers
- **Navigation:** fzf-lua, flash, oil, neo-tree, grug-far, nvim-bqf, smart-splits
- **Git:** gitsigns, diffview, git-conflict, lazygit, and built-in worktree management
  (`<leader>gw`, `:Worktree`)
- **Editing:** treesitter (+ textobjects, context), mini.ai, surround, treesj, ufo folds,
  autosave, neoclip, big file handling
- **UI:** kanagawa, lualine, noice, which-key, snacks dashboard, zen-mode
- **Notes:** previm, obsidian.nvim, img-clip, `K` for macOS Dictionary in Markdown
- **AI (opt-in):** Copilot

Full pinned list: [`lazy-lock.json`](lazy-lock.json).

## Key mappings

Leader is `<Space>`; press it and which-key shows everything. Groups: `a` AI, `c` Code,
`g` Git, `l` Lists, `m` Markdown, `o` Obsidian, `s` Search. Also `s` flash jump,
`gx` open URL, `<leader>z` zen mode.

## Maintenance

`:Lazy sync` (commit `lazy-lock.json`), `:TSUpdate`, `:Mason`, `:checkhealth`.

## License

[GPL-3.0](LICENSE)
