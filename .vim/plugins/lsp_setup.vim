" attach verible/veridian lsp
if !has('nvim-0.5.0')
	finish
endif

lua <<EOF

-- call neodev before lspconfig
require("neodev").setup{library = { plugins = { "nvim-dap-ui" }, types = true }}

local use_cmp = true

-- bindings taken from verible:
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  if not use_cmp then
      -- Enable completion triggered by <c-x><c-o>
      vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      vim.keymap.set('i', '<C-tab>', '<C-x><C-o>')
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>a', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)

    local success, lsp_signature = pcall(require, 'lsp_signature')
    if success then
        lsp_signature.on_attach({hint_enable = true,
        floating_window = false,
        hint_prefix = "💡 ",})
    end
end


local util = require 'lspconfig/util'
local nvim_lsp = require'lspconfig'

local function setup_veridian_lsp() -- TODO doesnt work - when does, gives completions
    local root_pattern = util.root_pattern("veridian.yml", ".git")
    local configs = require'lspconfig/configs'
        configs.veridian = {
          default_config = {
            cmd = {"veridian"},
            filetypes = {"systemverilog", "verilog", "verilog_systemverilog"},
            capabilities = require('cmp_nvim_lsp').default_capabilities(),
            root_dir = function(fname)
                local filename = util.path.is_absolute(fname) and fname
                    or util.path.join(vim.loop.cwd(), fname)
                return root_pattern(filename) or util.path.dirname(filename)
            end,
            settings = {}
          }
        }
    nvim_lsp.veridian.setup{on_attach = on_attach} 
end


local function setup_verible_lsp()
    require'lspconfig'.verible.setup {
        on_attach = on_attach,
        cmd = {os.getenv("HOME") .. "/.local/bin/verible/verible-verilog-ls"},
        filetypes = {"systemverilog", "verilog", "verilog_systemverilog"},
        root_dir = function() 
            if os.getenv("trunk_cfg") ~= nil then -- for apple
                return os.getenv("trunk_cfg")
            end
            return vim.loop.cwd() -- default, work directory
        end
    }
    -- INFO: run in trunk_cfg: find . -name "*.sv" -o -name "*.svh" -o -name "*.v" | sort > verible.filelist
end


-- TODO turn into a general lsp.vim
-- python lsp (take git as root) --
local function setup_python_lsp()
    local lspconfig = require 'lspconfig'
    local util = require 'lspconfig.util'

    lspconfig.pyright.setup {
        cmd = { "pyright-langserver", "--stdio", "--verbose" },
        on_attach = on_attach,

        capabilities = require('cmp_nvim_lsp').default_capabilities(), -- TODO only when using cmp
        root_dir = util.root_pattern(".git")
    }
end



local function setup_lsps()
	local success, lspconfig = pcall(require, 'lspconfig')
	if not success then
		return
	end

  setup_python_lsp()
  setup_veridian_lsp()
  setup_verible_lsp()

  -- status icon for LSP loading
  local fidget
	success, fidget = pcall(require, 'fidget')
  if success then
    fidget.setup{}
  end

  local lsp_signature
	success, lsp_signature = pcall(require, 'lsp_signature')
  if success then
    lsp_signature.setup{
      floating_window = false
    }
  end

end

setup_lsps()
EOF
