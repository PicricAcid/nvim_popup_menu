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
local opt = {
  start_index = 1,
  relative = "cursor",
  row = 0,
  col = 0,
  width = 40,
  height = 2,
  border = "rounded",
  title = "popup_menu",
  zindex = 1,
}

popup_menu.popup_menu(table, opt, function(result)
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
| height      | floating windoeのheightと同じ   |
| border      | floating windowのborderと同じ   |
| title       | floating windowのtitleと同じ    |
| zindex      | popup_menuのzindex             |

heightを指定したとき、要素数がheightを上回る場合はスクロールして表示するようになります。

# 補足
ハイライトを独自に作っています(todo: Vimのハイライトと合わせる)  
PopupMenuFloatBorder  
PopupMenuFloatTitle  
PopupMenuText  
PopupMenuTextSelected  
これらを変更すれば見た目を変えられます。

