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
{opt}: オプション 
{callback}: 選択肢を引数に取るcallback  

以下のように呼び出します。  
```
local table = { "Item1", "Item2", "Item3" }
local index = 1

popup_menu.popup_menu(table, index, function(result)
  print(result)
end)
```

2025/02/16追記: optでオプションを追加できるようにしました。  
popup_menu({table}, {opt}, {callback})の{opt}に追加します。  
追加できるオプションは以下です。  

| タグ名       | 説明                            |
|-------------|--------------------------------|
| start_index | 選択の初期位置                   |
| relative    | floating windowのrelativeと同じ |
| row         | floating windowのrowと同じ      |
| col         | floating windowのcolと同じ      |
| width       | floating windowのwidthと同じ    |
| border      | floating windowのborderと同じ   |
| title       | floating windowのtitleと同じ    |

heightは指定できません。渡されたtable数で固定です。

# 補足
ハイライトを独自に作っています(todo: Vimのハイライトと合わせる)  
PopupMenuFloatBorder  
PopupMenuFloatTitle  
PopupMenuText  
PopupMenuTextSelected  
これらを変更すれば見た目を変えられます。

