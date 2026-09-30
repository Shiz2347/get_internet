// ==========================================
// 1. КНОПКИ УПРАВЛЕНИЯ И НАСТРОЙКИ
// ==========================================
var _key_up = keyboard_check(ord("W"));
var _key_down = keyboard_check(ord("S"));
var _key_jump = keyboard_check_pressed(vk_space);
var _left = keyboard_check(ord("A"));
var _right = keyboard_check(ord("D"));

// УПРАВЛЕНИЕ ЗАЦЕПОМ И СХОДОМ
var _key_grab = keyboard_check(ord("Q")) || keyboard_check(ord("W")) || keyboard_check(ord("E"));
var _key_release = keyboard_check_pressed(vk_lshift); 

var _move_x = _right - _left;

var _speed = 12; // Скорость бега
var _jump_power = -20; // Высота обычного прыжка
var _grv = 1; // Гравитация

// --- НАСТРОЙКИ ДЛЯ ЗАЦЕПОВ ---
var _hook_jump_power_y = -18; // Сила прыжка с зацепа вверх
var _hook_jump_power_x = 14;  // Сила отталкивания от зацепа вбок

// НАСТРОЙКА РАДИУСА ЗАЦЕПА (в пикселях)
var _hook_grab_radius = 80; 

// РАЗНИЦА СМЕЩЕНИЯ ТОЧЕК ORIGIN ТУТ (в пикселях)
// На сколько опустить игрока при отпускании зацепа, чтобы компенсировать Origin в ногах.
// Поиграй с этим числом (60, 65, 70, 75), чтобы падение шло идеально из рук!
var _origin_offset_y = 200; 

// --- РЕДАКТИРУЙ ВЫСОТУ ВЫТАЛКИВАНИЯ ТУТ ---
var _ladder_exit_impulse = -40; 

// СПИСОК ВСЕХ ТВОИХ ЛЕСТНИЦ И ЗАЦЕПОВ
var _ladder_types = [Obj_ladder, Obj_ladder2, Obj_ladder3, Obj_ladder4];
var _hook_types = [Obj_hook_point]; 

var _ladder_inst = noone;
var _hook_inst = noone;

// Ищем, касается ли игрок лестницы
for (var i = 0; i < array_length(_ladder_types); i++) {
    var _check = instance_place(x, y, _ladder_types[i]);
    if (_check != noone) { _ladder_inst = _check; break; }
}

// Поиск зацепа в увеличенном радиусе вокруг игрока
for (var i = 0; i < array_length(_hook_types); i++) {
    var _nearest_hook = instance_nearest(x, y, _hook_types[i]);
    if (_nearest_hook != noone) {
        if (distance_to_object(_nearest_hook) <= _hook_grab_radius) {
            _hook_inst = _nearest_hook;
            break;
        }
    }
}


// ==========================================
// 2. ЛОГИКА НА ЛЕСТНИЦЕ ИЛИ ЗАЦЕПЕ
// ==========================================

if (!variable_instance_exists(id, "grabbed_hook")) { grabbed_hook = noone; }

// Хватаемся за объект при нажатии Q, W или E
if (_hook_inst != noone && _key_grab && !is_climbing && grabbed_hook == noone) {
    is_climbing = true;
    grabbed_hook = _hook_inst; 
    v_speed = 0;
}

// Если мы зафиксированы на зацепе
if (is_climbing && grabbed_hook != noone && instance_exists(grabbed_hook)) {
    
    // Сначала разворачиваем персонажа в сторону нажатия кнопок A/D
    if (_move_x != 0) {
        image_xscale = _move_x;
    }
    
    // Базово фиксируем позицию по центру зацепа
    x = grabbed_hook.x;
    y = grabbed_hook.y;
    
    // ЕСЛИ СМОТРИТ ВЛЕВО — СДВИГАЕМ ТЕЛО ВПРАВО, ЧТОБЫ РУКА ОСТАЛАСЬ НА КОЛЬЦЕ
    if (image_xscale == -1) {
        x += 37; 
    }
    
    // --- АНИМАЦИЯ ВИСЕНИЯ ---
    sprite_index = Sprite_hang; 
    image_speed = 1;            
    
    // СПРЫГНУТЬ ВНИЗ на Shift — мгновенно роняем игрока вниз с учетом разницы Origin
    if (_key_release) {
        is_climbing = false;
        grabbed_hook = noone; 
        
        y += _origin_offset_y;      // Сдвигаем координату Y вниз, компенсируя смену точек привязки
        sprite_index = Sprite_jump; // Включаем спрайт падения (теперь он встанет ровно)
        v_speed = 1;                // Задаем начальный импульс падения
    }
    
    // ОТПРЫГНУТЬ (на Пробел)
    if (_key_jump) {
        is_climbing = false;
        grabbed_hook = noone; 
        
        y += _origin_offset_y;      // Сдвигаем Y вниз, чтобы прыжок шел визуально из правильной точки
        v_speed = _hook_jump_power_y; 
        
        if (_move_x != 0) {
            x += _move_x * 8; 
            x += _move_x * _hook_jump_power_x; 
        }
    }
}
// Логика обычной лестницы
else if (_ladder_inst != noone) {
    grabbed_hook = noone; 
   
    if (_key_up && !is_climbing) {
        is_climbing = true;
        v_speed = 0; 
    }
   
    if (is_climbing) {
        x = _ladder_inst.x;
       
        if (_key_up) { y -= climb_speed; }
        if (_key_down) { y += climb_speed; }
       
        sprite_index = Sprite_climb; 
        
        if (_key_up) { image_speed = 1; } 
        else if (_key_down) { image_speed = -1; } 
        else { image_speed = 0; }
       
        var _ladder_above = noone;
        for (var i = 0; i < array_length(_ladder_types); i++) {
            var _check_above = instance_place(x, y - climb_speed, _ladder_types[i]);
            if (_check_above != noone) { _ladder_above = _check_above; break; }
        }
        
        if (_ladder_above == noone) {
            if (y <= _ladder_inst.bbox_top + climb_speed) {
                is_climbing = false;
                y = _ladder_inst.bbox_top - 5; 
                v_speed = _ladder_exit_impulse; 
                image_speed = 1;
            }
        }
       
        // Спрыгивание с лестницы на Shift
        if (_key_release || (place_meeting(x, y + 1, obj_floor_and_walls) && _key_down)) {
            is_climbing = false;
            image_speed = 1;
            v_speed = 1;
        }
       
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
        grabbed_hook = noone;
        image_speed = 1;
    }
}


// ==========================================
// 3. ТВОЙ ОСНОВНОЙ КОД ДВИЖЕНИЯ
// ==========================================
if (!is_climbing) {
    
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

    var _is_on_normal_floor = place_meeting(x, y + 1, obj_floor_and_walls);
    var _is_on_oneway = false;

    var _ladder_floor_check = noone;
    for (var i = 0; i < array_length(_ladder_types); i++) {
        var _check_floor = instance_place(x, y + 1, _ladder_types[i]);
        if (_check_floor != noone) { _ladder_floor_check = _check_floor; break; }
    }
    
    var _is_on_ladder_top = false;
    if (_ladder_floor_check != noone && v_speed >= 0) {
        if ((y - v_speed) <= _ladder_floor_check.bbox_top + 1) {
            _is_on_ladder_top = true;
        }
    }

    if (v_speed >= 0) {
        var _plat = instance_position(x, bbox_bottom + 1, Obj_oneway_platform);
        if (_plat == noone) { _plat = instance_position(x, bbox_bottom + 1, Obj_oneway_platform2); }
       
        if (_plat != noone) {
            if ((bbox_bottom - v_speed) <= _plat.bbox_top + 1) { _is_on_oneway = true; }
        }
    }

    var _is_on_floor = _is_on_normal_floor || _is_on_oneway || _is_on_ladder_top;

    if (!place_meeting(x + (_move_x * _speed), y, obj_floor_and_walls)) {
        x += _move_x * _speed;
    }

    v_speed += _grv;

    if (_is_on_floor && _key_jump) { 
        v_speed = _jump_power;
        _is_on_floor = false;
    }

    if (place_meeting(x, y + v_speed, obj_floor_and_walls)) {
        while (!place_meeting(x, y + sign(v_speed), obj_floor_and_walls)) { y += sign(v_speed); }
        v_speed = 0;
    }
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
        else if (_ladder_floor_check != noone) {
            if ((y - v_speed) <= _ladder_floor_check.bbox_top + 1) {
                y = _ladder_floor_check.bbox_top;
                v_speed = 0;
                _is_on_floor = true;
            }
        }
    }

    y += v_speed;

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
