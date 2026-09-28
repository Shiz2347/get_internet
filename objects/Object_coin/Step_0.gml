// 1. Проверяем расстояние до игрока
var _dist = point_distance(x, y, Object_player.x, Object_player.y);

// 2. Если близко — светящийся спрайт, если далеко — обычный
if (_dist < 250) {
    sprite_index = Sprite_coin_glow;
    
    // Проверка нажатия кнопки (E или ПКМ)
    var _pressed = (keyboard_check_pressed(ord("E")) || mouse_check_button_pressed(mb_right));
    
    if (_pressed) {
        // Проверяем, существует ли менеджер данных перед добавлением
        if (instance_exists(obj_inventory_data)) {
            
            // Проверяем лимит (меньше 5 штук)
            var _current_count = array_length(obj_inventory_data.inventory_slots);
            if (_current_count < 5) {
                array_push(obj_inventory_data.inventory_slots, "coin");
                instance_destroy(); // Уничтожаем монетку
            } else {
                show_debug_message("Инвентарь полон!");
            }
            
        } else {
            // Если менеджера вдруг нет на сцене, просто удалим монетку, чтобы не зависать
            instance_destroy();
        }
    }
} else {
    sprite_index = Sprite_coin;
}
