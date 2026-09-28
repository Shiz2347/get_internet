// Проверяем текущую комнату.
// Замени rm_menu на реальное имя твоей комнаты главного меню!
if (room == Room_menu || room == Room_Art_Gallery) {
    exit; // Если мы в меню, прерываем выполнение кода, инвентарь не рисуется
}

var _x = 5
var _y = 3

draw_sprite(sprite_index, 0, _x, _y)