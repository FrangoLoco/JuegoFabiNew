if (!instance_exists(obj_player)) exit;

var frame_hud  = obj_player.obtener_frame_salud();
var ancho_gui  = display_get_gui_width();
var escala_hud = ancho_gui / 3840;

// Barra de vida
draw_sprite_ext(spr_hud_salud, frame_hud, 80 * escala_hud, 120 * escala_hud, escala_hud, escala_hud, 0, c_white, 1);

draw_set_font(fnt_debug);
draw_set_valign(fa_middle);
draw_set_halign(fa_left);

dibujar_texto_contorno(575 * escala_hud, 349 * escala_hud, string(obj_player.vida), escala_hud, c_white, 4 * escala_hud);

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
