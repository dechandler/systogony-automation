
-- PLUGINS

-- Install packer from github
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

vim.api.nvim_exec(
    [[
      augroup Packer
      autocmd!
      autocmd BufWritePost init.lua PackerCompile
      augroup end
    ]],
    false
)

-- Here we can declare the plugins we'll be using.
local use = require('packer').use


require('packer').startup(function()
    -- Package manager itself.
    use 'wbthomason/packer.nvim'

    -- Git commands for nvim.
    use 'tpope/vim-fugitive'

    -- Use "gc" to comment lines in visual mode. Similarly to cmd+/ in other editors.
    use 'tpope/vim-commentary'

    -- A great tool for adding, removing and changing braces,
    -- brackets, quotes and various tags around your text.
    use 'tpope/vim-surround'

    -- UI to select things (files, search results, open buffers...)
    use { 'nvim-telescope/telescope.nvim', requires = { 'nvim-lua/plenary.nvim' } }

    -- A bar that will show at the top of you nvim containing your
    -- open buffers. Similarly to how other editors show tabs with open files.
    use { 'romgrk/barbar.nvim', requires = {'kyazdani42/nvim-web-devicons'} }

    -- A theme I particularly like.
    use 'bluz71/vim-moonfly-colors'

    -- Fancier status line with some information that
    -- will be displayed at the bottom.
    use 'itchyny/lightline.vim'

    -- Adds git related info in the signs columns
    -- (near the line numbers) and popups.
    use { 'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' } }
    
    -- Highlight, edit, and navigate code using a fast incremental
    -- parsing library. Treesitter is used by nvim for various things,
    -- but among others, for syntax coloring.
    -- Make sure that any themes you install support treesitter!
    use 'nvim-treesitter/nvim-treesitter'

    -- Additional textobjects for treesitter.
    use 'nvim-treesitter/nvim-treesitter-textobjects'

    -- Collection of configurations for built-in LSP client.
    use 'neovim/nvim-lspconfig'

    -- Autocompletion plugin.
    use 'hrsh7th/nvim-cmp'
    
    -- filesystem navigation
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
end)
