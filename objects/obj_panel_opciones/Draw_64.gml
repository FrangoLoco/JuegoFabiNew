// El fondo oscurecido lo dibuja quien abrió el panel (menú principal o pausa)
var e = escala_menu();
var cx = display_get_gui_width() / 2;
var cy = display_get_gui_height() / 2;
var desliz = (1 - aparicion) * 150 * e; // Entra deslizándose desde abajo

draw_set_alpha(aparicion);
dibujar_marco(cx - 1000 * e, cy - 640 * e + desliz, cx + 1000 * e, cy + 640 * e + desliz, 36 * e, COLOR_FONDO_BARRA);

draw_set_font(fnt_debug);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
dibujar_texto_contorno(cx + 14 * e, cy - 496 * e + desliz, "OPCIONES", 1.8 * e, COLOR_ROSA, 7 * e);
dibujar_texto_contorno(cx, cy - 510 * e + desliz, "OPCIONES", 1.8 * e, c_white, 7 * e);

var etiquetas = ["MUSICA", "SONIDOS", "PANTALLA COMPLETA"];
for (var i = 0; i < 3; i++)
{
    var fila = rect_fila(i);
    var fila_y = (fila[1] + fila[3]) / 2 + desliz;
    var elegido = (i == seleccion);

    // Nombre de la opción (amarilla y con corazón si está elegida)
    draw_set_halign(fa_left);
    dibujar_texto_contorno(cx - 790 * e, fila_y, etiquetas[i], 0.8 * e, elegido ? make_color_rgb(255, 220, 60) : c_white, 4 * e);
    if (elegido) dibujar_corazon(cx - 935 * e + sin(current_time / 150) * 10 * e, fila_y - 52 * e, e, aparicion);

    var barra = rect_barra(i);
    var barra_y1 = barra[1] + desliz;
    var barra_y2 = barra[3] + desliz;
    draw_set_halign(fa_center);

    if (i <= 1)
    {
        // Volumen: una barra como la de vida, verde según el porcentaje
        var valor = (i == 0) ? global.volumen_musica : global.volumen_efectos;
        var borde = 18 * e;
        dibujar_marco(barra[0], barra_y1, barra[2], barra_y2, borde, COLOR_FONDO_BARRA);
        if (valor > 0)
        {
            draw_set_color(COLOR_VERDE_VIDA);
            draw_rectangle(barra[0] + borde, barra_y1 + borde, barra[0] + borde + (barra[2] - barra[0] - 2 * borde) * valor, barra_y2 - borde, false);
        }
        dibujar_texto_contorno((barra[0] + barra[2]) / 2, (barra_y1 + barra_y2) / 2, string(round(valor * 100)) + "%", 0.6 * e, c_white, 3 * e);
    }
    else
    {
        // Pantalla completa: caja verde con SI o caja oscura con NO
        var caja_x = (barra[0] + barra[2]) / 2;
        var caja_y = (barra_y1 + barra_y2) / 2;
        dibujar_marco(caja_x - 200 * e, caja_y - 60 * e, caja_x + 200 * e, caja_y + 60 * e, 18 * e, global.pantalla_completa ? COLOR_VERDE_VIDA : make_color_rgb(25, 28, 48));
        dibujar_texto_contorno(caja_x, caja_y, global.pantalla_completa ? "SI" : "NO", 0.8 * e, c_white, 4 * e);
    }
}

var volver = rect_volver();
dibujar_boton((volver[0] + volver[2]) / 2, (volver[1] + volver[3]) / 2 + desliz, (volver[2] - volver[0]) / 2, (volver[3] - volver[1]) / 2, "VOLVER", seleccion == 3, seleccion == 3 ? 1.08 : 1, e, aparicion);

draw_set_halign(fa_center);
if (!es_movil()) dibujar_texto_contorno(cx, cy + 560 * e + desliz, "W/S  Elegir      A/D  Ajustar      Esc  Volver", 0.55 * e, make_color_rgb(150, 170, 240), 3 * e); // En celular no hay teclado

// Restaurar valores para no afectar otros dibujos
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
