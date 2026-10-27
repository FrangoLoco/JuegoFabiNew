// La captura se toma aquí porque en el Draw GUI la escena del juego ya está dibujada
if (pedir_pausa)
{
    pedir_pausa = false;
    pausar();
}
if (!pausado) exit;

var ancho_gui = display_get_gui_width();
var alto_gui = display_get_gui_height();
var e = escala_menu();
var desliz = (1 - aparicion) * 150 * e; // El panel entra deslizándose desde abajo
var cx = ancho_gui / 2;
var cy = alto_gui / 2 + desliz;

// 1. Juego congelado de fondo, oscurecido
draw_set_alpha(1);
if (sprite_exists(captura)) draw_sprite_stretched(captura, 0, 0, 0, ancho_gui, alto_gui);
draw_set_color(c_black);
draw_set_alpha(0.6 * oscuro);
draw_rectangle(0, 0, ancho_gui, alto_gui, false);

// Con el panel de opciones abierto solo se ve el juego oscurecido; el panel se dibuja solo encima
if (instance_exists(obj_panel_opciones))
{
    draw_set_alpha(1);
    exit;
}

draw_set_alpha(aparicion);

// 2. Panel con el mismo marco morado/azul del HUD
dibujar_marco(cx - 900 * e, cy - 620 * e, cx + 900 * e, cy + 620 * e, 36 * e, COLOR_FONDO_BARRA);

draw_set_font(fnt_debug);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 3. Título con sombra rosa (el color de la barra de vida baja)
dibujar_texto_contorno(cx + 14 * e, cy - 476 * e, "PAUSA", 2.2 * e, COLOR_ROSA, 8 * e);
dibujar_texto_contorno(cx, cy - 490 * e, "PAUSA", 2.2 * e, c_white, 8 * e);

// 4. Retrato del personaje con su estado de salud actual (se toma del sprite del HUD)
draw_sprite_part_ext(spr_hud_salud, frame_retrato, 3, 4, 345, 352, cx - 810 * e, cy - 340 * e, e, e, c_white, aparicion);

// 5. Vida y monedas debajo del retrato
draw_set_halign(fa_left);
var fila_vida = cy + 110 * e;
dibujar_corazon(cx - 810 * e, fila_vida - 52 * e, e, aparicion);
dibujar_texto_contorno(cx - 668 * e, fila_vida, string(vida_jugador), e, c_white, 4 * e);

var fila_monedas = cy + 240 * e;
dibujar_moneda(cx - 752 * e, fila_monedas, 50 * e);
dibujar_texto_contorno(cx - 668 * e, fila_monedas, "x " + string(global.monedas), e, make_color_rgb(255, 220, 60), 4 * e);

// 6. Botones: el elegido se pinta verde como la barra de vida llena y tiene un corazón al lado
for (var i = 0; i < array_length(opciones); i++)
{
    var rect = rect_boton(i);
    var boton_x = (rect[0] + rect[2]) / 2;
    var boton_y = (rect[1] + rect[3]) / 2 + desliz;
    dibujar_boton(boton_x, boton_y, (rect[2] - rect[0]) / 2, (rect[3] - rect[1]) / 2, opciones[i], i == seleccion, escala_botones[i], e, aparicion);
}
draw_set_halign(fa_center);

// 7. Controles
dibujar_texto_contorno(cx, cy + 520 * e, "W/S  Elegir      Enter  Aceptar      Esc  Continuar", 0.55 * e, make_color_rgb(150, 170, 240), 3 * e);

// Restaurar valores para no afectar otros dibujos
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
