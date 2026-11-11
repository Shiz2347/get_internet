var _count = array_length(inventory_slots);
var _base_x = 20; 
var _base_y = 15; 
var _step_x = 40; 

for (var i = 0; i < _count; i++) {
    var _item_name = inventory_slots[i];
    var _icon_sprite = asset_get_index("spr_icon_" + _item_name);
    
    var _draw_x = _base_x + (i * _step_x);
    var _draw_y = _base_y;
    
    if (sprite_exists(_icon_sprite)) {
        draw_sprite(_icon_sprite, 0, _draw_x, _draw_y);
    } else {
        // Если иконку забыли нарисовать — напишет текстом, чтобы было видно, что предмет взялся
        draw_text(_draw_x, _draw_y, _item_name);
    }
}
