// 1. НАСТРОЙКИ СЕТКИ (теперь 7 кусочков в ширину!)
var cols = 7;               // Максимум 7 кусочков в одной горизонтальной полосе

// Автоматически берем точную ширину и высоту из первого спрайта
var chunk_width = sprite_get_width(___document_0_1);   
var chunk_height = sprite_get_height(___document_0_1); 

// 2. СПИСОК ВСЕХ 63 СПРАЙТОВ
var sprites = [
    ___document_0_1,  ___document_0_2,  ___document_0_3,  ___document_0_4,  ___document_0_5,  ___document_0_6,  ___document_0_7,
    ___document_0_8,  ___document_0_9,  ___document_0_10, ___document_0_11, ___document_0_12, ___document_0_13, ___document_0_14,
    ___document_0_15, ___document_0_16, ___document_0_17, ___document_0_18, ___document_0_19, ___document_0_20, ___document_0_21,
    ___document_0_22, ___document_0_23, ___document_0_24, ___document_0_25, ___document_0_26, ___document_0_27, ___document_0_28,
    ___document_0_29, ___document_0_30, ___document_0_31, ___document_0_32, ___document_0_33, ___document_0_34, ___document_0_35,
    ___document_0_36, ___document_0_37, ___document_0_38, ___document_0_39, ___document_0_40, ___document_0_41, ___document_0_42,
    ___document_0_43, ___document_0_44, ___document_0_45, ___document_0_46, ___document_0_47, ___document_0_48, ___document_0_49,
    ___document_0_50, ___document_0_51, ___document_0_52, ___document_0_53, ___document_0_54, ___document_0_55, ___document_0_56,
    ___document_0_57, ___document_0_58, ___document_0_59, ___document_0_60, ___document_0_61, ___document_0_62, ___document_0_63
];

// 3. ЦИКЛ ОТРИСОВКИ СЕТКИ
for (var i = 0; i < 63; i++) {
    // Магия деления: остаток от деления на 7 всегда будет от 0 до 6. Это наши колонки.
    var col = i % cols;       
    var row = i div cols;     // Целочисленное деление на 7 дает номер строки (от 0 до 8)
    
    var xx = col * chunk_width;
    var yy = row * chunk_height;
    
    draw_sprite(sprites[i], 0, xx, yy);
}