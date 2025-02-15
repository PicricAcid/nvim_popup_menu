# nvim_popup_menu
Neovimでpopup_menuを使えるようにするluaスクリプトです。

# 使い方
nvim/lua/utils下などにこのスクリプトを置き、
```
local popup_menu = require("utils.popup_menu")
```
などでrequireしてください。

スクリプト内にはpopup_menu({table}, {index}, {callback})という公開関数があります。   
{table}: menuに表示する選択肢の配列   
{index}: 選択の初期位置  
{callback}: 選択肢を引数に取るcallback  

以下のように呼び出します。  
```
local table = { "Item1", "Item2", "Item3" }
local index = 1

popup_menu.popup_menu(table, index, function(result)
  print(result)
end)
```

# 補足
ハイライトを独自に作っています(todo: Vimのハイライトと合わせる)  
PopupMenuFloatBorder  
PopupMenuFloatTitle  
PopupMenuText  
PopupMenuTextSelected  
これらを変更すれば見た目を変えられます。

