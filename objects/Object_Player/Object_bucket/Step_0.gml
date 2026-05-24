var _dist = distance_to_object(Object_Player);

if (_dist < distance_to_act) {
    // Если игрок рядом — подсвечиваем лестницу
    sprite_index = Sprite_bucket1;

    // 2. Проверяем бездействие игрока
    // Если игрок стоит на месте (не нажимает кнопки движения)
    if (!keyboard_check(ord("A")) && !keyboard_check(ord("D")) && !keyboard_check(ord("W")) && !keyboard_check(ord("S"))) {
        idle_timer += 1;
    } else {
        // Если начал двигаться — сбрасываем таймер и подсказку
        idle_timer = 0;
        show_prompt = false;
    }

    // 3. Если натикало 5 секунд (в секунде обычно 60 кадров, значит 5 * 60 = 300)
    if (idle_timer >= 300) {
        show_prompt = true;
    }
} else {
    // Если игрок ушел — возвращаем обычный спрайт и сбрасываем всё
    sprite_index = Sprite_bucket ;
    idle_timer = 0;
    show_prompt = false;
}