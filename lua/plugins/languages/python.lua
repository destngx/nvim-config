return {
  -- Python indent (follows the PEP8 style)
  { "Vimjas/vim-python-pep8-indent",   ft = { "python" } },
  -- Python-related text object
  { "jeetsukumaran/vim-pythonsense",   ft = { "python" } },
  { "machakann/vim-swap",              event = "VimEnter" },
  -- Add indent object for vim (useful for languages like Python)
  { "michaeljsmith/vim-indent-object", event = "VimEnter" },
}
