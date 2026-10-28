// Con el juego en pausa se ocultan (el menú de pausa ocupa la pantalla)
if (esta_en_pausa()) exit;

var e = escala();

// Superficie cuadrada del tamaño del botón más grande (se vuelve a crear si cambia la escala o se pierde)
var lado = ceil(2 * radio_maximo * e) + 4;
if (!surface_exists(superficie) || surface_get_width(superficie) != lado)
{
    if (surface_exists(superficie)) surface_free(superficie);
    superficie = surface_create(lado, lado);
}
var centro = lado / 2;

draw_set_circle_precision(48);

for (var i = 0; i < array_length(botones); i++)
{
    var boton = botones[i];
    var pos = posicion(boton);
    var r = boton.radio * e * (boton.presionado ? 0.92 : 1); // Se hunde un poco al tocarlo

    // 1. Dibujar el botón sólido en la superficie, centrado en ella
    surface_set_target(superficie);
    draw_clear_alpha(c_black, 0);

    var bx = centro;
    var by = centro;
    dibujar_boton_circular(bx, by, r, boton.presionado, 1);

    // Ícono de cada botón
    switch (boton.icono)
    {
        case "izquierda":
            dibujar_triangulo_contorno(bx - 0.35 * r, by, bx + 0.2 * r, by - 0.32 * r, bx + 0.2 * r, by + 0.32 * r, 0.3, 1);
            break;

        case "derecha":
            dibujar_triangulo_contorno(bx + 0.35 * r, by, bx - 0.2 * r, by - 0.32 * r, bx - 0.2 * r, by + 0.32 * r, 0.3, 1);
            break;

        case "salto":
            dibujar_triangulo_contorno(bx, by - 0.35 * r, bx - 0.32 * r, by + 0.2 * r, bx + 0.32 * r, by + 0.2 * r, 0.3, 1);
            break;

        case "ataque":
            // Cuchillo en diagonal: mango café, guarda y hoja blanca, todo con contorno negro
            var mango_x = bx - 0.34 * r;
            var mango_y = by + 0.34 * r;
            var guarda_x = bx - 0.12 * r;
            var guarda_y = by + 0.12 * r;
            var punta_x = bx + 0.34 * r;
            var punta_y = by - 0.34 * r;

            draw_set_color(c_black);
            draw_line_width(mango_x, mango_y, punta_x, punta_y, 0.24 * r);
            draw_line_width(guarda_x - 0.17 * r, guarda_y - 0.17 * r, guarda_x + 0.17 * r, guarda_y + 0.17 * r, 0.16 * r);
            draw_set_color(make_color_rgb(140, 90, 50));
            draw_line_width(mango_x, mango_y, guarda_x, guarda_y, 0.13 * r);
            draw_set_color(c_white);
            draw_line_width(guarda_x, guarda_y, punta_x - 0.03 * r, punta_y + 0.03 * r, 0.13 * r);
            draw_set_color(COLOR_MARCO_AZUL);
            draw_line_width(guarda_x - 0.13 * r, guarda_y - 0.13 * r, guarda_x + 0.13 * r, guarda_y + 0.13 * r, 0.07 * r);
            break;

        case "pausa":
            // Dos barras blancas con contorno negro
            for (var barra = -1; barra <= 1; barra += 2)
            {
                var barra_x = bx + barra * 0.16 * r;
                draw_set_color(c_black);
                draw_rectangle(barra_x - 0.12 * r, by - 0.34 * r, barra_x + 0.12 * r, by + 0.34 * r, false);
                draw_set_color(c_white);
                draw_rectangle(barra_x - 0.07 * r, by - 0.29 * r, barra_x + 0.07 * r, by + 0.29 * r, false);
            }
            break;
    }

    surface_reset_target();

    // 2. Pintar el botón en su lugar con transparencia pareja
    draw_surface_ext(superficie, pos[0] - centro, pos[1] - centro, 1, 1, 0, c_white, boton.presionado ? alfa_presionado : alfa_normal);
}
