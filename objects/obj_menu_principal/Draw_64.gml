var ancho_gui   = display_get_gui_width();
var alto_gui    = display_get_gui_height();
var e           = escala_menu();
var cx          = ancho_gui / 2;
var cy          = alto_gui / 2;
var alto_lienzo = alto_gui / e; 
var desliz      = (1 - aparicion) * 150 * e; 

// 1. FONDO
var spr_w   = sprite_get_width(spr_menu);
var spr_h   = sprite_get_height(spr_menu);
var num_frms = sprite_get_number(spr_menu);
var frame   = floor(tiempo / 20) mod num_frms;

if (spr_w >= 3840 && spr_h >= alto_lienzo)
{
    var fondo_x = clamp(5500 + sin(tiempo / 1200) * 3500, 0, spr_w - 3840);
    var fondo_y = clamp(max(4060 - alto_lienzo, 0), 0, spr_h - alto_lienzo);
    draw_sprite_part_ext(spr_menu, frame, fondo_x, fondo_y, 3840, alto_lienzo, 0, 0, e, e, c_white, 1);
}
else
{
    draw_sprite_stretched_ext(spr_menu, frame, 0, 0, ancho_gui, alto_gui, c_white, 1);
}

// 2. CONFIGURACIÓN DE FUENTE
draw_set_font(fnt_debug);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

// 3. CONTENIDO
var hay_panel = instance_exists(obj_panel_opciones);

switch (pantalla)
{
    case "principal":
        if (!hay_panel) // Si no hay panel, dibujamos el menú
        {
            // Título
            var titulo_y = cy - 620 * e + sin(tiempo / 40) * 15 * e + desliz;
            dibujar_texto_contorno(cx + 20 * e, titulo_y + 20 * e, "BACK TO HOME", 3.2 * e, COLOR_ROSA, 10 * e);
            dibujar_texto_contorno(cx, titulo_y, "BACK TO HOME", 3.2 * e, c_white, 10 * e);

            // Botones (con transparencia de entrada)
            draw_set_alpha(aparicion);
            for (var i = 0; i < array_length(botones_principal); i++)
            {
                var rect = rect_boton_principal(i);
                dibujar_boton((rect[0] + rect[2]) / 2, (rect[1] + rect[3]) / 2 + desliz, 
                              (rect[2] - rect[0]) / 2, (rect[3] - rect[1]) / 2, 
                              botones_principal[i], i == seleccion, escala_botones[i], e, aparicion);
            }
            draw_set_alpha(1); // Restaurar para que el texto de ayuda no sea transparente

            // Texto de ayuda inferior
            dibujar_texto_contorno(cx, alto_gui - 110 * e, "W/S  Elegir      Enter  Aceptar", 0.55 * e, make_color_rgb(150, 170, 240), 3 * e);
        }
        break;

    case "creditos":
        draw_set_alpha(aparicion);
        
        // Marco de fondo
        dibujar_marco(cx - 1000 * e, cy - 640 * e + desliz, cx + 1000 * e, cy + 640 * e + desliz, 36 * e, COLOR_FONDO_BARRA);

        // Título
        dibujar_texto_contorno(cx + 14 * e, cy - 496 * e + desliz, "CREDITOS", 1.8 * e, COLOR_ROSA, 7 * e);
        dibujar_texto_contorno(cx, cy - 510 * e + desliz, "CREDITOS", 1.8 * e, c_white, 7 * e);

        dibujar_texto_contorno(cx, cy - 330 * e + desliz, "EQUIPO DE DESARROLLO", 0.8 * e, make_color_rgb(255, 220, 60), 4 * e);

        // Lista de nombres
        var nombre_y = cy - 230 * e + desliz;
        for (var i = 0; i < array_length(creditos); i++)
        {
            dibujar_texto_contorno(cx, nombre_y, creditos[i], 0.75 * e, c_white, 4 * e);
            nombre_y += 95 * e;
        }
        dibujar_texto_contorno(cx, nombre_y + 50 * e, "Gracias por jugar!", 0.6 * e, make_color_rgb(150, 170, 240), 3 * e);

        // Botón volver
        var volver = rect_volver();
        dibujar_boton((volver[0] + volver[2]) / 2, (volver[1] + volver[3]) / 2 + desliz, 
                      (volver[2] - volver[0]) / 2, (volver[3] - volver[1]) / 2, 
                      "VOLVER", true, 1.08, e, aparicion);
        
        draw_set_alpha(1);
        break;
}

// 4. FUNDIDO A NEGRO
if (fundido > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(fundido);
    draw_rectangle(0, 0, ancho_gui, alto_gui, false);
}

// 5. RESTAURAR ESTADO GLOBAL
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);