var _count = array_length(inventory_slots);

var _base_x = 20; 
var _base_y = 15; 
var _step_x = 40; 

for (var i = 0; i < _count; i++) {
    if (i > 4) break; 
    
    // Принудительно превращаем имя в строку, чтобы избежать багов с типами данных
    var _item_name = string(inventory_slots[i]);
    
    var _sprite_name = "spr_icon_" + _item_name;
    var _icon_sprite = asset_get_index(_sprite_name);
    
    // ИСПРАВЛЕНО: Используем надежную встроенную проверку существования спрайта
    if (sprite_exists(_icon_sprite)) {
        var _draw_x = _base_x + (i * _step_x);
        var _draw_y = _base_y;
        
        draw_sprite(_icon_sprite, 0, _draw_x, _draw_y);
    } else {
        // Выводим в консоль имя в кавычках, чтобы сразу увидеть скрытые пробелы
        show_debug_message("Внимание: Спрайт '" + _sprite_name + "' не существует в базе проекта!");
    }
}
