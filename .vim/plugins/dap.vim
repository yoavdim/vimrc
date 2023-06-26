lua <<EOF
    require('dap-python').setup()
    require("nvim-dap-virtual-text").setup {commented = true}
    require("dapui").setup()

    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open()  end 
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end 
    dap.listeners.before.event_exited["dapui_config"]     = function() dapui.close() end
    vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end)
    vim.keymap.set('n', '<Leader>r', function() require('dap').continue() end)
EOF
