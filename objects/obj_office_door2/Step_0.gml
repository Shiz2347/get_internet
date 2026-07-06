/// @description Вставьте описание здесь
// Вы можете записать свой код в этом редакторе
// Расстояние, с которого появляется обводка (можешь поменять цифру)
var _dist = 30; 

// ВАЖНО: замени "Obj_player" на точное название объекта твоего игрока!
if (instance_exists(Object_player) && distance_to_object(Object_player) <= _dist) {
    
    visible = true; // Игрок рядом — показываем обводку
    
    // Проверяем нажатие "E" на клавиатуре ИЛИ правой кнопки мыши (ПКМ)
    if (keyboard_check_pressed(ord("E")) || mouse_check_button_pressed(mb_right)) {
        room_goto(Room_game1); // Переносим в новую комнату
    }
    
} else {
    visible = false; // Игрок далеко — прячем обводку
}
