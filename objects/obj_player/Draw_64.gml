// Evento Draw GUI de obj_player
var frame_hud  = obtener_frame_salud();
var ancho_gui  = display_get_gui_width();
var escala_hud = ancho_gui / 3840;

// Barra de vida
draw_sprite_ext(spr_hud_salud, frame_hud, 80 * escala_hud, 120 * escala_hud, escala_hud, escala_hud, 0, c_white, 1);

draw_set_font(fnt_debug);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);

dibujar_texto_contorno(575 * escala_hud, 349 * escala_hud, string(vida), escala_hud, c_white, 4 * escala_hud);

// Monedas
var texto_monedas = "x " + string(monedas_hud);
var escala_total  = escala_hud * escala_monedas;
var ancho_texto   = string_width(texto_monedas) * escala_hud;
var texto_derecha = ancho_gui - 80 * escala_hud;
var moneda_y      = 230 * escala_hud;
var moneda_x      = texto_derecha - ancho_texto - 80 * escala_hud;

draw_sprite_ext(spr_moneda, 0, moneda_x, moneda_y, escala_total, escala_total, 0, c_white, 1);

draw_set_halign(fa_right);
dibujar_texto_contorno(texto_derecha, moneda_y, texto_monedas, escala_total, make_color_rgb(255, 220, 60), 4 * escala_hud);

// Inventario
if (inventario_alpha > 0.01)
{
    var esc_inv = escala_hud;

    var inv_w = sprite_get_width(spr_inventario)  * esc_inv;
    var inv_h = sprite_get_height(spr_inventario) * esc_inv;

    // AJUSTE VERTICAL Y HORIZONTAL
    var hud_y      = 120 * escala_hud;
    var hud_alto   = sprite_get_height(spr_hud_salud) * escala_hud;
    var hud_bottom = hud_y + hud_alto;
    var offset_y   = -900;
    var offset_x   = 100;
    
    var inv_y = hud_bottom + 20 * escala_hud + inv_h / 2 + offset_y * escala_hud;
    var inv_x = 80 * escala_hud + inv_w / 2 + offset_x * escala_hud;

    draw_set_alpha(inventario_alpha);
    draw_sprite_ext(spr_inventario, 0, inv_x, inv_y, esc_inv, esc_inv, 0, c_white, 1);

    // TEXTO TÍTULO
    var sprite_titulo_x = 750;
    var sprite_titulo_y = 1000; // Ajusta esto si el texto de "INVENTARIO" está muy abajo
    var titulo_x = inv_x - inv_w / 2 + sprite_titulo_x * esc_inv;
    var titulo_y = inv_y - inv_h / 2 + sprite_titulo_y * esc_inv;

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    dibujar_texto_contorno(titulo_x, titulo_y, "INVENTARIO", 0.7 * esc_inv, c_white, 2 * esc_inv);

    // DIBUJAR LOS ITEMS
    // Coordenadas de la cuadrícula dentro del sprite (ajusta estos valores a tu gusto)
    var start_x = 300;  // Dónde empieza el primer slot a lo ancho
    var start_y = 1200; // Dónde empieza el primer slot a lo alto (debajo del título)
    var space_x = 250;  // Separación horizontal entre slots
    var space_y = 250;  // Separación vertical entre slots
    var cols = 4;       // Cuántos slots por fila

    for (var i = 0; i < array_length(inventario_items); i++)
    {
        var item = inventario_items[i];
        
        // Calcular en qué fila y columna va este item
        var col = i mod cols;
        var fila = floor(i / cols);

        // Calcular posición del slot en la pantalla
        var slot_x = (inv_x - inv_w / 2) + (start_x + col * space_x) * esc_inv;
        var slot_y = (inv_y - inv_h / 2) + (start_y + fila * space_y) * esc_inv;

        // 1. Dibujar el Sprite del item (centrado en el slot)
        var item_esc = 1.5 * esc_inv; // Ajusta el 1.5 si quieres que el objeto se vea más grande o chico
        draw_sprite_ext(item.spr, 0, slot_x, slot_y - 20 * esc_inv, item_esc, item_esc, 0, c_white, inventario_alpha);

        // 2. Dibujar el Nombre debajo del item
        dibujar_texto_contorno(slot_x, slot_y + 80 * esc_inv, item.nombre, 0.5 * esc_inv, c_white, 2 * esc_inv);

        // 3. Dibujar la Cantidad (esquina inferior derecha del slot)
        var texto_cant = "x" + string(item.cantidad);
        dibujar_texto_contorno(slot_x + 60 * esc_inv, slot_y + 30 * esc_inv, texto_cant, 0.6 * esc_inv, make_color_rgb(255, 220, 60), 2 * esc_inv);
    }

    draw_set_alpha(1);
}