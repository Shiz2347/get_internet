// --- 1. ГРАВИТАЦИЯ И ПАДЕНИЕ БЛОКА ---
v_speed += grv;

// Столкновение блока с обычным полом при падении
if (place_meeting(x, y + v_speed, obj_floor)) {
    while (!place_meeting(x, y + sign(v_speed), obj_floor)) {
        y += sign(v_speed);
    }
    v_speed = 0;
}
y += v_speed;


// --- 2. СТОЛКНОВЕНИЕ И ТОЛКАНИЕ (Вся магия тут) ---
h_speed = 0; 

// Ищем игрока вплотную к блоку (замени Obj_player на имя своего объекта игрока)
var _player_left = instance_place(x - 6, y, Object_player); // Игрок слева от блока
var _player_right = instance_place(x + 6, y, Object_player); // Игрок справа от блока
var _player_above = instance_place(x, y - 6, Object_player); // Игрок стоит НА блоке

// Кнопки ходьбы игрока
var _key_right = keyboard_check(ord("D"));
var _key_left = keyboard_check(ord("A"));

// А) ЕСЛИ ИГРОК ТОЛКАЕТ СЛЕВА НАПРАВО (Жмёт D)
if (_player_left != noone && _key_right) {
    // Если за блоком нет стены — толкаем его и двигаем игрока
    if (!place_meeting(x + push_speed, y, obj_floor)) {
        h_speed = push_speed;
        _player_left.x += push_speed;
    } else {
        // Если за блоком СТЕНА — блок стоит, а игрока не пускаем внутрь блока
        _player_left.x = x - (_player_left.bbox_right - _player_left.x) - 1;
    }
} 
// Если игрок просто упёрся слева и НЕ жмёт D (или жмёт А, то есть отходит)
else if (_player_left != noone && !_key_right) {
    _player_left.x = x - (_player_left.bbox_right - _player_left.x) - 1; // Не даём пройти сквозь
}

// Б) ЕСЛИ ИГРОК ТОЛКАЕТ СПРАВА НАЛЕВО (Жмёт A)
if (_player_right != noone && _key_left) {
    if (!place_meeting(x - push_speed, y, obj_floor)) {
        h_speed = -push_speed;
        _player_right.x -= push_speed;
    } else {
        // Если за блоком стена — стопорим игрока
        _player_right.x = x + (sprite_width) + (_player_right.x - _player_right.bbox_left) + 1;
    }
} 
// Если игрок просто упёрся справа и НЕ жмёт А
else if (_player_right != noone && !_key_left) {
    _player_right.x = x + (sprite_width) + (_player_right.x - _player_right.bbox_left) + 1; // Не даём пройти сквозь
}

// В) ЕСЛИ ИГРОК СТОИТ НА БЛОКЕ СВЕРХУ
if (_player_above != noone) {
    // Если игрок падает на блок, приземляем его строго на верхнюю грань
    if (_player_above.v_speed >= 0) {
        _player_above.y = y - 1; 
        _player_above.v_speed = 0; // Сбрасываем ему скорость падения
    }
}

// Перемещаем блок
x += h_speed;
