var ancho_gui = display_get_gui_width();
var alto_gui = display_get_gui_height();
var e = escala_menu();
var cx = ancho_gui / 2;
var cy = alto_gui / 2;
var alto_lienzo = alto_gui / e; // 2160 en pantallas 16:9
var desliz = (1 - aparicion) * 150 * e; // Cada pantalla entra deslizándose desde abajo

// 1. Fondo: el bosque del juego, moviéndose lento de lado a lado
var fondo_x = 5500 + sin(tiempo / 1200) * 3500;
var fondo_y = max(4060 - alto_lienzo, 0);
draw_sprite_part_ext(spr_fondo_1, 0, fondo_x, fondo_y, 3840, alto_lienzo, 0, 0, e, e, c_white, 1);
var suelo_y = (3776 - fondo_y) * e; // Altura del suelo del bosque en pantalla

// 2. Personajes de adorno: el jugador a la izquierda y los enemigos a la derecha, en orden de nivel
var escala_respirar = 1 + sin(tiempo / 25) * 0.015;
draw_sprite_ext(spr_player_idle, floor(tiempo / 20) mod sprite_get_number(spr_player_idle), cx - 1300 * e, suelo_y, 0.85 * e, 0.85 * e * escala_respirar, 0, c_white, 1);

// Limón (nivel 1): salta en su lugar, se estira en el aire y se aplasta al caer
var ciclo_limon = tiempo mod 100;
var limon_y = suelo_y;
var limon_sprite = spr_limon;
var limon_xs = 1;
var limon_ys = 1;
if (ciclo_limon < 40)
{
    limon_y -= sin(pi * ciclo_limon / 40) * 350 * e;
    limon_sprite = spr_limon_salto;
    limon_xs = 0.85;
    limon_ys = 1.15;
}
else if (ciclo_limon < 48)
{
    limon_xs = 1.3;
    limon_ys = 0.7;
}
draw_sprite_ext(limon_sprite, floor(tiempo / 10) mod sprite_get_number(limon_sprite), cx + 1700 * e, limon_y, 0.8 * e * limon_xs, 0.8 * e * limon_ys, 0, c_white, 1);

// Gnomo (nivel 2): camina en su lugar con un rebote
var rebote_gnomo = abs(sin(tiempo / 15)) * 0.05;
draw_sprite_ext(spr_gnomo, floor(tiempo / 15) mod sprite_get_number(spr_gnomo), cx + 1200 * e, suelo_y, 1.1 * e, 1.1 * e * (1 + rebote_gnomo), 0, c_white, 1);

// Naranja (nivel 3): flota arriba a la derecha
draw_sprite_ext(spr_naranja_ojo, floor(tiempo / 12) mod sprite_get_number(spr_naranja_ojo), cx + 1450 * e, cy - 380 * e + sin(tiempo / 30) * 40 * e, 1.3 * e, 1.3 * e, 0, c_white, 1);

// Oscurecer un poco para que el menú resalte
draw_set_color(c_black);
var hay_panel = instance_exists(obj_panel_opciones);
draw_set_alpha((pantalla == "principal" && !hay_panel) ? 0.3 : 0.55);
draw_rectangle(0, 0, ancho_gui, alto_gui, false);
draw_set_alpha(1);

draw_set_font(fnt_debug);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

switch (pantalla)
{
    case "principal":
        if (hay_panel) break; // El panel de opciones se dibuja solo, encima de todo
        
        // Título con sombra rosa que flota un poco
        var titulo_y = cy - 620 * e + sin(tiempo / 40) * 15 * e;
        dibujar_texto_contorno(cx + 20 * e, titulo_y + 20 * e, "BACK TO HOME", 3.2 * e, COLOR_ROSA, 10 * e);
        dibujar_texto_contorno(cx, titulo_y, "BACK TO HOME", 3.2 * e, c_white, 10 * e);

        draw_set_alpha(aparicion);
        for (var i = 0; i < array_length(botones_principal); i++)
        {
            var rect = rect_boton_principal(i);
            dibujar_boton((rect[0] + rect[2]) / 2, (rect[1] + rect[3]) / 2 + desliz, (rect[2] - rect[0]) / 2, (rect[3] - rect[1]) / 2, botones_principal[i], i == seleccion, escala_botones[i], e, aparicion);
        }

        draw_set_halign(fa_center);
        dibujar_texto_contorno(cx, alto_gui - 110 * e, "W/S  Elegir      Enter  Aceptar", 0.55 * e, make_color_rgb(150, 170, 240), 3 * e);
        break;

    case "creditos":
        draw_set_alpha(aparicion);
        dibujar_marco(cx - 1000 * e, cy - 640 * e + desliz, cx + 1000 * e, cy + 640 * e + desliz, 36 * e, COLOR_FONDO_BARRA);

        draw_set_halign(fa_center);
        dibujar_texto_contorno(cx + 14 * e, cy - 496 * e + desliz, "CREDITOS", 1.8 * e, COLOR_ROSA, 7 * e);
        dibujar_texto_contorno(cx, cy - 510 * e + desliz, "CREDITOS", 1.8 * e, c_white, 7 * e);

        dibujar_texto_contorno(cx, cy - 330 * e + desliz, "EQUIPO DE DESARROLLO", 0.8 * e, make_color_rgb(255, 220, 60), 4 * e);

        var nombre_y = cy - 230 * e + desliz;
        for (var i = 0; i < array_length(creditos); i++)
        {
            dibujar_texto_contorno(cx, nombre_y, creditos[i], 0.75 * e, c_white, 4 * e);
            nombre_y += 95 * e;
        }
        dibujar_texto_contorno(cx, nombre_y + 50 * e, "Gracias por jugar!", 0.6 * e, make_color_rgb(150, 170, 240), 3 * e);

        var volver = rect_volver();
        dibujar_boton((volver[0] + volver[2]) / 2, (volver[1] + volver[3]) / 2 + desliz, (volver[2] - volver[0]) / 2, (volver[3] - volver[1]) / 2, "VOLVER", true, 1.08, e, aparicion);
        break;
}

// 3. Fundido a negro (al entrar y al empezar a jugar)
if (fundido > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(fundido);
    draw_rectangle(0, 0, ancho_gui, alto_gui, false);
}

// Restaurar valores para no afectar otros dibujos
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
