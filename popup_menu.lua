local M = {}
local api = vim.api

vim.cmd("highlight PopupMenuFloatBorder guifg=#006db3")
vim.cmd("highlight PopupMenuFloatTitle guifg=#6ab7ff")
vim.cmd("highlight PopupMenuText guifg=#abb2bf")
vim.cmd("highlight PopupMenuTextSelected guifg=#abb2bf guibg=#383c44")

---@return number
local function get_buffer()
    local buf = api.nvim_create_buf(false, true)
    return buf
end

---@param buffer number
---@param title? string|table<table<string>>
---@param height number
local function open_popup_window(buffer, title, height)
    if title ~= nil and type(title) == 'string' then
	title = { { title, 'PopupMenuFloatTitle' } }
    end

    local win = api.nvim_open_win(buffer, true, {
	relative = 'cursor',
	row = 0,
	col = 0,
	width = 40,
	height = height,
	focusable = true,
	border = "rounded",
	title = title,
	title_pos = 'left',
	noautocmd = true,
    })
    api.nvim_win_set_option(win, 'number',  false)
    api.nvim_win_set_option(win, 'relativenumber', false)
    api.nvim_win_set_option(win, 'wrap',  false)
    api.nvim_win_set_option(win, 'cursorline',  false)
    api.nvim_win_set_option(win, 'winhighlight',  'FloatBorder:PopupMenuFloatBorder,NormalFloat:PopupMenuText')

    return win
end

---@param buffer number
---@param row number
---@return number
local function open_popup_window_selected(buffer, row)
    local win = api.nvim_open_win(buffer, true, {
	relative = 'win',
	row = row,
	col = 0,
	width = 40,
	height = 1,
	focusable = true,
	noautocmd = true,
    })
    api.nvim_win_set_option(win, 'number',  false)
    api.nvim_win_set_option(win, 'relativenumber', false)
    api.nvim_win_set_option(win, 'wrap',  false)
    api.nvim_win_set_option(win, 'cursorline',  false)
    api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:PopupMenuTextSelected')

    return win
end

---@param buffer number
---@param buffer_selected number
---@param table table<string>
---@param index number
---@return number, number
local function popup_menu_create(buffer, buffer_selected, table, index)
    api.nvim_buf_set_lines(buffer, 0, -1, true,  table)
    api.nvim_buf_set_lines(buffer_selected, 0, -1, true, { table[index] })

    local window = open_popup_window(buffer, "popup_menu", #table)
    local window_selected = open_popup_window_selected(buffer_selected, index-1)

    return window, window_selected
end

---@param buffer_selected number
---@param table table<string>
---@param index number
---@return number
local function popup_menu_update(buffer_selected, table, index)
    
    api.nvim_buf_set_lines(buffer_selected, 0, -1, true, { table[index] })
    local new_window_selected = open_popup_window_selected(buffer_selected, index-1)
    
    return new_window_selected
end

---@param table table<string>
---@param index number
---@param callback function()
---@return string
function M.popup_menu(table, index, callback)
    local buffer = get_buffer()
    local buffer_selected = get_buffer()
 
    local window, window_selected = popup_menu_create(buffer, buffer_selected, table, index)

    vim.tbl_map(function(buf)
	vim.keymap.set('n', '<ESC>', function()
	    api.nvim_win_close(window, false)
	    api.nvim_win_close(window_selected, false)
	end, { buffer = buf })

	vim.keymap.set('n', '<Down>', function()
	    index = index + 1
	    if index > #table then
		index = 1
	    end
	    api.nvim_win_close(window_selected, false)
	    window_selected = popup_menu_update(buffer_selected, table, index)
	end, { buffer = buf })

        vim.keymap.set('n', '<Up>', function()
	    index = index - 1
	    if index < 1 then
		index = #table
	    end
	    api.nvim_win_close(window_selected, false)
	    window_selected = popup_menu_update(buffer_selected, table, index)
	end, { buffer = buf })

	vim.keymap.set('n', '<CR>', function()
	    api.nvim_win_close(window, false)
	    api.nvim_win_close(window_selected, false)
	    if callback then callback(table[index]) end
	end, { buffer = buf })
    end, { buffer, buffer_selected })
end

return M
