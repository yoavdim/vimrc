" Similar to vim fzf, this is a fuzzy searcher

if !has('nvim-0.5.0')
	finish
endif

" Help: Actions Inside Telescope:
" <C-x> go to file selection as a split   
" <C-v> go to file selection as a vsplit   
" <C-t> go to a file in a new tab

let g:my_telescope_supported=1

"nnoremap <silent> <space>o <cmd>lua require('telescope.builtin').current_buffer_tags()<cr>
nnoremap <silent> <space>; <cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<cr>

lua << EOF
function ag_additional_args_func(opts)
    if ag_additional_args then
        return ag_additional_args
    end
    return nil
end

function search_with_ag(string)
    require('telescope.builtin').grep_string{search=string, word_match="-w", use_regex=true, additional_args=ag_additional_args_func}
end
EOF
command! -nargs=1 F lua search_with_ag([[<args>]])
function! SearchWordWithTelescope()
    execute 'F ' expand('<cword>')
endfunction
nnoremap <silent> <space>s :lua search_with_ag()<CR>
vnoremap <silent> <space>s "zy:F <C-R>z<CR>

lua << EOF
local delete_buffer = function(prompt_entry)
	local action_state = require "telescope.actions.state"
	local actions = require('telescope.actions')
	local picker = action_state.get_current_picker(prompt_entry)

	picker:delete_selection(function(entry)
		vim.api.nvim_command("bd " .. tostring(entry.bufnr))
	end)
--	for _, entry in ipairs(picker:get_multi_selection()) do
--		vim.api.nvim_command("bd " .. tostring(entry.bufnr))
--	end
--
--	actions.close(prompt_entry)
end

local search_exact = function(prompt_entry)
	local action_state = require "telescope.actions.state"
	local actions = require('telescope.actions')
	local picker = action_state.get_current_picker(prompt_entry)
	local finders = require "telescope.finders"

	grep_string_ops = picker.grep_string_ops
	if not grep_string_ops then
		print("No grep_string configurations were found")
		return
	end

	-- toggle exact search
	grep_string_ops.word_match = not grep_string_ops.word_match and "-w" or nil
	ag_com = vim.tbl_flatten {
				grep_string_ops.vimgrep_arguments,
				grep_string_ops.additional_args,
				grep_string_ops.word_match,
				"--",
				grep_string_ops.search,
			}

	new_finder = finders.new_oneshot_job(ag_com,
										 {
											 entry_maker = require("telescope.make_entry").gen_from_vimgrep{} 
										 })

	-- TODO: this doesn't work... Needs fixing
	prompt_title = "Find Word (" .. grep_string_ops.word .. ")"
	prompt_title = prompt_title .. (grep_string_ops.word_match and " - exact match" or "")
    picker.prompt_title = prompt_title

	picker:refresh(new_finder)

--	vim.api.nvim_buf_set_lines(picker.prompt_bufnr, 0, 1, false, { "word" })
end


-- Function to determine the preferred vimgrep_arguments
function get_vimgrep_arguments()
  if vim.fn.executable("ag") == 1 then
    return {
      "ag", 
      "--nocolor", 
      "--noheading",
      "--filename", 
      "--column", 
      "--smart-case",
      "--follow"
    }
  elseif vim.fn.executable("rg") == 1 then
    return nil -- Use Telescope's default if rg is available
  elseif vim.fn.executable("grep") == 1 then
    return {
      "grep", 
      "--color=never", 
      "--line-number", 
	  "--with-filename",
	  "-b", -- grep doesn't support a `--column` option :(
	  "--ignore-case",
	  "--recursive",
	  "--no-messages"
    }
  else
    error("Neither 'ag', 'rg', nor 'grep' is available!")
  end
end

-- for work:
-- open file from rev:
function find_in_revision(query)
  local telescope = require('telescope.builtin')
  -- Run the Bash script to get the revision (or latest if none)
  local sprev = vim.fn.system("decide_rev 2>/dev/null"):gsub("%s+$", "") -- Remove any trailing whitespace
  local folder = "/verification/" .. os.getenv("PROJECT") .. "/" .. sprev .. "/src" 
  print(folder)
  -- Check if the script returned a valid path
  if vim.fn.isdirectory(folder) == 1 then
    telescope.find_files({
      prompt_title = "Find Files in " .. sprev .. "/src",
      cwd = folder,
      default_text = query .. ".e",
      hidden = true,
      follow = true
    })
  else
    print("Invalid folder path returned from script")
  end
end

function grep_revision(query)
  local telescope = require('telescope.builtin')
  -- Run the Bash script to get the revision (or latest if none)
  local sprev = vim.fn.system("decide_rev 2>/dev/null"):gsub("%s+$", "") -- Remove any trailing whitespace
  local folder = "/verification/" .. os.getenv("PROJECT") .. "/" .. sprev .. "/src" 
  print(folder)
  -- Check if the script returned a valid path
  if vim.fn.isdirectory(folder) == 1 then
    telescope.live_grep({
      prompt_title = "Grep Revision " .. sprev .. "/src",
      cwd = folder,
      default_text = query,
      hidden = true,
      follow = true
    })
  else
    print("Invalid folder path returned from script")
  end
end

    

function find_in_src(query)
  local telescope = require('telescope.builtin')
  local folder = "../src"
  -- Check if the script returned a valid path
  if vim.fn.isdirectory(folder) == 1 then
    telescope.find_files({
      prompt_title = "Find Files in " .. "../src",
      cwd = folder,
      default_text = query .. ".e",
      hidden = true,
      follow = true
    })
  else
    print("No src folder")
  end
end

--   

function setup_telescope()
	local success, telescope = pcall(require, 'telescope')

	if not success then
		return
	end

	telescope.setup{
		defaults = {
			vimgrep_arguments = get_vimgrep_arguments(),
		},
		pickers = {
			buffers = {
				mappings = {
					i = {
						["<C-d>"] = delete_buffer,
					},
				},
			},
			grep_string = {
					mappings = {
						i = {
							["<C-x>"] = search_exact,
						},
					},
				},
		},
	--	extensions = {
	--		fzf = {
	--		  override_generic_sorter = false, -- override the generic sorter
	--		  override_file_sorter = true,     -- override the file sorter
	--		  case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
	--		}
	--	},
	}

    -- Keymaps:
    vim.api.nvim_create_user_command("Erev", function(opts) find_in_revision(opts.args or "") end, {nargs="?", desc="open file from the revision"})
    vim.api.nvim_create_user_command("Grev", function(opts) grep_revision(opts.args or "") end, {nargs="?", desc="grep revision"})
    vim.api.nvim_create_user_command("Esrc", function(opts) find_in_src(opts.args or "") end, {nargs="?", desc="open file from the src folder"})
	vim.api.nvim_set_keymap('n', 'gb', "<cmd>lua require('telescope.builtin').buffers{ sort_mru = true, ignore_current_buffer = true }<cr>", {noremap = true, desc = "list buffers"})
	vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true, desc = "find files"})
    vim.keymap.set('n', 'gD', function() require('telescope.builtin').lsp_definitions{jump_type="never"} end, {desc = "do definition (telescope)"})
    vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {desc ="go refernces"})
    vim.keymap.set('n', 'gR', function() require('telescope.builtin').lsp_references{jump_type="never"} end, {desc="list references"})
    vim.keymap.set('n', 'gl', require('telescope.builtin').treesitter, {desc = "list symbols in file"}) 
    vim.keymap.set('n', 'go', require('telescope.builtin').oldfiles, {desc = "open recent file"}) 
    require('telescope').load_extension('dap')
    require("telescope").load_extension("undo")
end

vim.api.nvim_command("augroup TelescopeAU")
vim.api.nvim_command("au!")
vim.api.nvim_command("autocmd User DoAfterConfigs ++nested lua setup_telescope()")
vim.api.nvim_command("augroup END")

EOF
