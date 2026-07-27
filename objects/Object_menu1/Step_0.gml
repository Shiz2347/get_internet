/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе
// Проверяем, находится ли курсор мыши над объектом (id - это текущий объект)
if (position_meeting(mouse_x, mouse_y, id)) {
    // Если мышка НАВЕДЕНА
    sprite_index = Sprite_menu12; // Светится
    
    // ДОПОЛНИТЕЛЬНО: Если нажать левую кнопку мыши, переходим в игру
    if (mouse_check_button_pressed(mb_left)) {
        room_goto(Room_play_room1); // Замени Room_Game на название твоей первой игровой комнаты
    }
} else {
    // Если мышка НЕ наведена
    sprite_index = Sprite_menu11; // Обычный спрайт
}