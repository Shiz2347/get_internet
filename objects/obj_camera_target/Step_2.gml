if (instance_exists(Object35)) {
    // 1. Получаем размеры нулевой камеры
    var _cam_w = camera_get_view_width(view_camera[0]);
    var _cam_h = camera_get_view_height(view_camera[0]);

    // 2. Центрируем камеру строго на Object35
    var _cam_x = Object35.x - (_cam_w / 2);
    var _cam_y = Object35.y - (_cam_h / 2);

    // 3. Ограничиваем края, но разрешаем уходить вверх и влево в минус
    _cam_x = clamp(_cam_x, -2000, room_width - _cam_w);
    _cam_y = clamp(_cam_y, -5000, room_height - _cam_h);

    // 4. Двигаем камеру
    camera_set_view_pos(view_camera[0], _cam_x, _cam_y);
}
