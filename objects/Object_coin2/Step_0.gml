if (instance_exists(Object_player)) {
    var _dist = point_distance(x, y, Object_player.x, Object_player.y);
    
    if (_dist < 250) {
        sprite_index = Sprite_coin_glow2;
        
        if (keyboard_check_pressed(ord("E")) || keyboard_check_pressed(ord("F")) || mouse_check_button_pressed(mb_right)) {
            if (instance_exists(obj_inventory_data)) {
                // Вызываем функцию инвентаря. Если место есть — предмет исчезает
                if (obj_inventory_data.try_pickup(item_name)) {
                    instance_destroy();
                }
            }
        }
    } else {
        sprite_index = Sprite_coin2;
    }
}
