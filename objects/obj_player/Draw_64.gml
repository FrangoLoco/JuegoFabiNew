// Evento Draw GUI de obj_player
// HUD de salud: el frame depende de la vida (ver obtener_frame_salud en el Create)
var frame_hud = obtener_frame_salud();

// Las imágenes del HUD se diseñaron sobre un lienzo de 3840x2160, se escala al tamaño real de la GUI
var escala_hud = display_get_gui_width() / 3840;

draw_sprite_ext(spr_hud_salud, frame_hud, 80 * escala_hud, 120 * escala_hud, escala_hud, escala_hud, 0, c_white, 1);

draw_set_font(fnt_debug);
draw_set_halign(fa_left);
draw_set_valign(fa_middle);

// Número de vida a la derecha del corazón (el corazón ocupa x 437-552, y 297-401 en el lienzo de 3840)
dibujar_texto_contorno(575 * escala_hud, 349 * escala_hud, string(vida), escala_hud, c_white, 4 * escala_hud);

// Contador de monedas en la esquina superior derecha, a la altura de la barra de vida
// El texto se alinea a la derecha y la moneda se coloca a su izquierda según lo ancho que sea el número
var texto_monedas = "x " + string(monedas_hud);
var texto_derecha = display_get_gui_width() - 80 * escala_hud;
var ancho_texto = string_width(texto_monedas) * escala_hud;
var moneda_y = 230 * escala_hud;
var moneda_x = texto_derecha - ancho_texto - 80 * escala_hud;
var radio = 45 * escala_hud * escala_monedas;

dibujar_moneda(moneda_x, moneda_y, radio);

draw_set_halign(fa_right);
dibujar_texto_contorno(texto_derecha, moneda_y, texto_monedas, escala_hud * escala_monedas, make_color_rgb(255, 220, 60), 4 * escala_hud);

// Restaurar la alineación para no afectar otros textos de la GUI
draw_set_halign(fa_left);
draw_set_valign(fa_top);
