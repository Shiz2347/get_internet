// ==========================================
// 1. КНОПКИ УПРАВЛЕНИЯ И НАСТРОЙКИ
// ==========================================
var _key_up = keyboard_check(ord("W"));
var _key_down = keyboard_check(ord("S"));
var _key_jump = keyboard_check_pressed(vk_space);
var _left = keyboard_check(ord("A"));
var _right = keyboard_check(ord("D"));

var _move_x = _right - _left;

var _speed = 12; // Скорость бега
var _jump_power = -20; // Высота обычного прыжка
var _grv = 1; // Гравитация

// --- РЕДАКТИРУЙ ВЫСОТУ ВЫТАЛКИВАНИЯ ТУТ ---
// Чем больше цифра (со знаком минус), тем выше подпрыгнет игрок, когда долезет до верха.
// Например: -8 — низкий подскок, -12 — средний, -16 — высокий. Поиграй с этим значением!
var _ladder_exit_impulse = -40; 


// СПИСОК ВСЕХ ТВОИХ ЛЕСТНИЦ (1, 2, 3, 4)
var _ladder_types = [Obj_ladder, Obj_ladder2, Obj_ladder3, Obj_ladder4];
var _ladder_inst = noone;

// Ищем, касается ли игрок хотя бы одной из лестниц
for (var i = 0; i < array_length(_ladder_types); i++) {
    var _check = instance_place(x, y, _ladder_types[i]);
    if (_check != noone) { _ladder_inst = _check; break; }
}


// ==========================================
// 2. ЛОГИКА НА ЛЕСТНИЦЕ
// ==========================================
if (_ladder_inst != noone) {
   
    // Если нажали "Вверх" — хватаемся за лестницу
    if (_key_up && !is_climbing) {
        is_climbing = true;
        v_speed = 0; 
    }
   
    if (is_climbing) {
        // Ровняем игрока строго по центру лестницы
        x = _ladder_inst.x;
       
        // Движение по лестнице вверх/вниз
        if (_key_up) { y -= climb_speed; }
        if (_key_down) { y += climb_speed; }
       
        // --- АНИМАЦИЯ НА ЛЕСТНИЦЕ ---
        sprite_index = Sprite_climb;
        
        if (_key_up) {
            image_speed = 1; // Вверх — вперед
        } else if (_key_down) {
            image_speed = -1; // Вниз — назад
        } else {
            image_speed = 0; // Стоим — пауза
        }
       
        // ПРОВЕРКА ВЕРХУШКИ ЛЕСТНИЦЫ:
        // Проверяем, есть ли лестница выше текущей
        var _ladder_above = noone;
        for (var i = 0; i < array_length(_ladder_types); i++) {
            var _check_above = instance_place(x, y - climb_speed, _ladder_types[i]);
            if (_check_above != noone) { _ladder_above = _check_above; break; }
        }
        
        // Если это самый верх (выше лестниц нет)
        if (_ladder_above == noone) {
            // Если ноги игрока подошли к верхнему краю лестницы
            if (y <= _ladder_inst.bbox_top + climb_speed) {
                is_climbing = false; // Отключаем лестницу навсегда для этого подъема
                
                // Перемещаем игрока чуть выше края, чтобы он гарантированно отлепился от лестницы
                y = _ladder_inst.bbox_top - 5; 
                
                // Даем тот самый импульс автоматического выталкивания!
                v_speed = _ladder_exit_impulse; 
                
                image_speed = 1;
            }
        }
       
        // Сход с лестницы в самом низу при касании земли
        if (place_meeting(x, y + 1, obj_floor_and_walls) && _key_down) {
            is_climbing = false;
            image_speed = 1;
        }
       
        // Отпрыгивание в сторону на Пробел
        if (_key_jump) {
            is_climbing = false;
            image_speed = 1;
            if (_move_x != 0) {
                v_speed = -15;          
                x += _move_x * 15;     
            } else {
                v_speed = 0;            
            }
        }
    }
} else {
    if (is_climbing) {
        is_climbing = false;
        image_speed = 1;
    }
}


// ==========================================
// 3. ТВОЙ ОСНОВНОЙ КОД ДВИЖЕНИЯ
// ==========================================
if (!is_climbing) {
    
    // Вход на лестницу сверху вниз (если стоим над ней и жмем S)
    if (_key_down) {
        var _ladder_below = noone;
        for (var i = 0; i < array_length(_ladder_types); i++) {
            var _check_below = instance_place(x, y + climb_speed, _ladder_types[i]);
            if (_check_below != noone) { _ladder_below = _check_below; break; }
        }
        
        if (_ladder_below != noone && !place_meeting(x, y, _ladder_below)) {
            is_climbing = true;
            y += climb_speed * 2; 
            v_speed = 0;
        }
    }

    // --- ПРОВЕРКА ПОЛА ---
    var _is_on_normal_floor = place_meeting(x, y + 1, obj_floor_and_walls);
    var _is_on_oneway = false;

    // Проверка верхушки лестницы как сквозной платформы (сделал точь-в-точь как твои платформы)
    var _ladder_floor_check = noone;
    for (var i = 0; i < array_length(_ladder_types); i++) {
        var _check_floor = instance_place(x, y + 1, _ladder_types[i]);
        if (_check_floor != noone) { _ladder_floor_check = _check_floor; break; }
    }
    
    var _is_on_ladder_top = false;
    if (_ladder_floor_check != noone && v_speed >= 0) {
        // Если наши ноги опускаются на верхнюю грань лестницы
        if ((y - v_speed) <= _ladder_floor_check.bbox_top + 1) {
            _is_on_ladder_top = true;
        }
    }

    // Твой родной код проверки сквозных платформ
    if (v_speed >= 0) {
        var _plat = instance_position(x, bbox_bottom + 1, Obj_oneway_platform);
        if (_plat == noone) { _plat = instance_position(x, bbox_bottom + 1, Obj_oneway_platform2); }
       
        if (_plat != noone) {
            if ((bbox_bottom - v_speed) <= _plat.bbox_top + 1) { _is_on_oneway = true; }
        }
    }

    // Теперь верхушка лестницы — это полноценная сквозная платформа!
    var _is_on_floor = _is_on_normal_floor || _is_on_oneway || _is_on_ladder_top;

    // --- ГОРИЗОНТАЛЬНОЕ ДВИЖЕНИЕ (Твой код) ---
    if (!place_meeting(x + (_move_x * _speed), y, obj_floor_and_walls)) {
        x += _move_x * _speed;
    }

    // --- ВЕРТИКАЛЬНОЕ ДВИЖЕНИЕ И ПРЫЖОК ---
    v_speed += _grv;

    if (_is_on_floor && _key_jump) { 
        v_speed = _jump_power;
        _is_on_floor = false;
    }

    // Столкновение с обычным полом (Твой код)
    if (place_meeting(x, y + v_speed, obj_floor_and_walls)) {
        while (!place_meeting(x, y + sign(v_speed), obj_floor_and_walls)) { y += sign(v_speed); }
        v_speed = 0;
    }
    // Столкновение со сквозными платформами (и верхушкой лестницы) при падении
    else if (v_speed > 0) {
        var _plat = instance_position(x, bbox_bottom + v_speed, Obj_oneway_platform);
        if (_plat == noone) { _plat = instance_position(x, bbox_bottom + v_speed, Obj_oneway_platform2); }
       
        if (_plat != noone) {
            if ((bbox_bottom - v_speed) <= _plat.bbox_top + 1) {
                y = _plat.bbox_top - (bbox_bottom - y);
                v_speed = 0;
                _is_on_floor = true;
            }
        }
        // Точно такая же проверка для приземления на верхушку лестницы сверху
        else if (_ladder_floor_check != noone) {
            if ((y - v_speed) <= _ladder_floor_check.bbox_top + 1) {
                y = _ladder_floor_check.bbox_top;
                v_speed = 0;
                _is_on_floor = true;
            }
        }
    }

    // Перемещаем игрока
    y += v_speed;

    // --- АНИМАЦИЯ НА ЗЕМЛЕ (Твой код) ---
    image_speed = 1; 
    
    if (!_is_on_floor) {
        sprite_index = Sprite_jump;
    } else {
        if (_move_x != 0) {
            sprite_index = Sprite_walk;
            image_xscale = _move_x;      
        } else {
            sprite_index = Sprite_is_standing_still;      
        }
    }
}