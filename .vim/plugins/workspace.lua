function get_this()
  -- Check if the current buffer is read-only
  if not vim.bo.readonly then
    print("Buffer is not read-only.")
    return
  end

  local current_file = vim.fn.expand("%:p")
  local workdir = vim.fn.getcwd()
  local new_file = workdir .. "/" .. vim.fn.fnamemodify(current_file, ":t")

  -- Copy file, make writable, close original, and open new file
  os.execute("cp " .. current_file .. " " .. new_file .. " && chmod +w " .. new_file)
  vim.cmd("bdelete")
  vim.cmd("edit " .. new_file)
end



function toggle_ih()
    -- todo : from chat gpt, refactor and check correcteness 
    local current_file = vim.api.nvim_buf_get_name(0)  -- Get the current file name

    local function file_exists(filename)
        return vim.loop.fs_stat(filename) ~= nil
    end

    if current_file:match("_ih%.e$") then
        -- If file ends with "ih.e", switch to "*.e"
        local new_file = current_file:gsub("_ih%.e$", ".e")
        if file_exists(new_file) then
            vim.cmd("edit " .. new_file)  -- Open the new file
        else
            print("File does not exist: " .. new_file)
        end
    elseif current_file:match("%.e$") then
        -- If file ends with ".e", switch to "*ih.e"
        local new_file = current_file:gsub("%.e$", "_ih.e")
        if file_exists(new_file) then
            vim.cmd("edit " .. new_file)  -- Open the new file
        else
            print("File does not exist: " .. new_file)
        end
    else
        print("Current file is not compatible with toggle_ih")
    end
end



-- Define Vim Commands: --
vim.api.nvim_create_user_command("GetThis", get_this, {desc = "fetch this file, assume in the revision"})
vim.api.nvim_create_user_command("ToggleIH", toggle_ih, {desc = "jump from src to header"})
