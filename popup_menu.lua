local M = {}
local api = vim.api

vim.cmd("highlight PopupMenuFloatBorder guifg=#006db3")
vim.cmd("highlight PopupMenuFloatTitle guifg=#6ab7ff")
vim.cmd("highlight PopupMenuText guifg=#abb2bf")
vim.cmd("highlight PopupMenuTextSelected guifg=#abb2bf guibg=#383c44")

---@param popup_table table<string>
---@param opt table<T>
---@param callback function()
---@return callback(string)
function M.popup_menu(popup_table, opt, callback)
    local buffer = api.nvim_create_buf(false, true)

    if opt == nil then
    	opt = {
	    start_index = 1,
	    relative = 'cursor',
	    row = 0,
	    col = 0,
	    width = 40,
	    height = 5,
	    border = 'rounded',
	    title = 'popup_menu',
	    zindex = 1,
	}
    end

    opt.title = { { opt.title, 'PopupMenuFloatTitle' } }

    local start_index = opt.start_index
    local cursor_pos = opt.start_index
    local height = math.min(opt.height, #popup_table)

    -- popup_windowを作成
    local window = api.nvim_open_win(buffer, true, {
	relative = opt.relative,
	row = opt.row,
	col = opt.col,
	width = opt.width,
	height = height,
	focusable = true,
	border = opt.border,
	title = opt.title,
	title_pos = 'left',
	noautocmd = true,
	zindex = opt.zindex,
    })
    api.nvim_win_set_option(window, 'number',  false)
    api.nvim_win_set_option(window, 'relativenumber', false)
    api.nvim_win_set_option(window, 'wrap',  false)
    api.nvim_win_set_option(window, 'cursorline',  false)
    api.nvim_win_set_option(window, 'winhighlight',  'FloatBorder:PopupMenuFloatBorder,NormalFloat:PopupMenuText')
    
    -- ハイライト用のnamespace, extmarkを作成
    local ns_id = api.nvim_create_namespace("popup_menu_ns")
    local current_extmark = nil

    -- 選択カーソル表示(cursor_posの位置にハイライト)
    ---@param cursor_pos number 
    ---@param buffer number
    local function window_update(cursor_pos, buffer)
	if current_extmark then
	    api.nvim_buf_del_extmark(buffer, ns_id, current_extmark)
	end

	current_extmark = api.nvim_buf_set_extmark(buffer, ns_id, cursor_pos - 1, 0, {
	    end_row = cursor_pos,
	    hl_group = "PopupMenuTextSelected",
	    priority = 100,
	    hl_eol = true,
	})
    end

    -- popup_menu描画関数
    local function popup_menu_render()
	-- スクロール表示部分をdisplay_tableに格納
	local end_index = math.min(start_index + height - 1, #popup_table)
	local display_table = {}

	for i = start_index, end_index do
	    table.insert(display_table, popup_table[i])
	end

	-- popup_windowを更新
	api.nvim_buf_set_lines(buffer, 0, -1, true, display_table)
	window_update(cursor_pos, buffer)
    end

    -- cursor制御関数(スクロール処理も行う)
    ---@param direction number
    local function popup_menu_move_cursor(direction)
	if direction == "down" then
	    if cursor_pos < height and (start_index + cursor_pos - 1) < #popup_table then
		cursor_pos = cursor_pos + 1
	    elseif (start_index + height - 1) < #popup_table then
		start_index = start_index + 1
	    end
	elseif direction == "up" then
	    if cursor_pos > 1 then
		cursor_pos = cursor_pos - 1
	    elseif start_index > 1 then
		start_index = start_index - 1
	    end
	end
	popup_menu_render()
    end

    --選択した要素をcallbackで返す
    local function popup_menu_select()
	local select_index = start_index + cursor_pos - 1
	if popup_table[select_index] then
	    api.nvim_win_close(window, false)
	    if callback then
		callback(popup_table[select_index])
	    end
	end
    end

    -- キーマッピング
    vim.tbl_map(function(buf)
	vim.keymap.set('n', '<ESC>', function()
	    api.nvim_win_close(window, false)
	end, { buffer = buf })

	vim.keymap.set('n', '<Down>', function() popup_menu_move_cursor("down") end, { buffer = buf })

        vim.keymap.set('n', '<Up>', function() popup_menu_move_cursor("up") end, { buffer = buf })

	vim.keymap.set('n', '<CR>', function() popup_menu_select() end, { buffer = buf })
    end, { buffer })

    -- 初期表示
    popup_menu_render()
end

return M
