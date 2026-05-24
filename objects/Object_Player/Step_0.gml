// --- 1. НАСТРОЙКИ ---
var _speed = 2.5;        // Скорость бега (чуть прибавил, 2 — совсем медленно)
var _jump_power = -7; // Высота прыжка
var _grv = 0.5;        // Гравитация

// --- 2. ВВОД ---
var _left  = keyboard_check(ord("A"));
var _right = keyboard_check(ord("D"));
var _jump  = keyboard_check_pressed(vk_space); // Или vk_enter, если привычнее

var _move_x = _right - _left;

// --- 3. ПРОВЕРКА ПОЛА ---
// Проверяем, есть ли пол ровно под ногами (на 1 пиксель ниже)
var _is_on_floor = place_meeting(x, y + 1, obj_floor);

// --- 4. ГОРИЗОНТАЛЬНОЕ ДВИЖЕНИЕ (X) ---
// Если впереди нет стены (obj_wall) — идем
if (!place_meeting(x + (_move_x * _speed), y, obj_wall)) {
    x += _move_x * _speed;
}

// --- 5. ВЕРТИКАЛЬНОЕ ДВИЖЕНИЕ (Y) И ПРЫЖОК ---
// Гравитация тянет вниз всегда
v_speed += _grv;

// Если мы на полу и нажали прыжок
if (_is_on_floor && _jump) {
    v_speed = _jump_power;
}

// ПРОВЕРКА СТОЛКНОВЕНИЙ (И пол, и потолок/стены)
// Мы проверяем и obj_floor, и obj_wall
if (place_meeting(x, y + v_speed, obj_floor) || place_meeting(x, y + v_speed, obj_wall)) {
    
    // Попиксельно доводим до упора (вверх или вниз)
    while (!place_meeting(x, y + sign(v_speed), obj_floor) && !place_meeting(x, y + sign(v_speed), obj_wall)) {
        y += sign(v_speed);
    }
    
    // Если врезались в потолок (летели вверх, v_speed < 0), 
    // обнуляем скорость, чтобы начать падать сразу
    v_speed = 0; 
}

y += v_speed; // Применяем итоговую вертикальную скорость

// --- 6. АНИМАЦИЯ ---
if (!_is_on_floor) {
    // В воздухе всегда спрайт прыжка
    sprite_index = Sprite27;
} else {
    if (_move_x != 0) {
        sprite_index = Sprite24; // Идем
        image_xscale = -_move_x;       // Твое отзеркаливание
    } else {
        sprite_index = Sprite25; // Стоим
    }
}