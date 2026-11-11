inventory_slots = array_create(0); // Список названий подобранных предметов
max_slots = 5;

// Сюда вписываешь реальные иконки, которые уже есть в проекте
keep_icons = [spr_icon_coin, spr_icon_coin2];

// Универсальная функция подбора (ее вызывают сами предметы)
function try_pickup(_item_name) {
    if (array_length(inventory_slots) < max_slots) {
        array_push(inventory_slots, _item_name);
        return true; // Подобрали успешно
    }
    return false; // Места нет
}
