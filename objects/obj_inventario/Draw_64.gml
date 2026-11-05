// Inventario: una capa con parches cosidos, cada parche es un espacio (teclas 1 a 9)
if (inventario_alpha > 0.01)
{
    var capa = obtener_capa_inventario();
    var esc_inv = capa.esc;
    var grosor = 5 * esc_inv;

    // Oscurece el juego detrás para que el inventario resalte
    draw_set_alpha(0.4 * inventario_alpha);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);

    draw_sprite_ext(spr_inventario, 0, capa.x, capa.y, esc_inv, esc_inv, 0, c_white, inventario_alpha);

    // Título (el origen del sprite está en el centro del recuadro del título)
    draw_set_alpha(inventario_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    dibujar_texto_contorno(capa.x, capa.y, "INVENTARIO", 0.7 * esc_inv, c_white, 2 * esc_inv);

    // Parches
    for (var i = 0; i < max_slots_inv; i++)
    {
        var item = inventario_items[i];
        var parche = parches_inv[i];
        var pos = posicion_slot(capa, i);
        var elegido = (i == slot_seleccionado);

        // Al abrir, los parches aparecen uno tras otro
        var aparecer = clamp((inventario_alpha - i * 0.05) / 0.55, 0, 1);
        aparecer = 1 - power(1 - aparecer, 3);
        if (aparecer <= 0) continue;

        var medio = inv_medio_slot * esc_inv * escala_slots[i] * aparecer;
        var color = parche.color;
        if (item == undefined) color = merge_color(color, make_color_rgb(70, 75, 70), 0.55); // Vacío: tela apagada
        if (elegido) color = merge_color(color, c_white, 0.2);
        var alfa = inventario_alpha * ((item == undefined) ? 0.75 : 1);

        dibujar_parche(pos.x, pos.y, medio, medio, parche.angulo, parche.esquinas, color, grosor, alfa);

        // Objeto flotando suavemente (el elegido se mueve más)
        if (item != undefined)
        {
            var flotar = sin(current_time / 350 + i) * (elegido ? 8 : 3) * esc_inv;
            var item_tam = 150 * esc_inv * escala_slots[i] * aparecer;

            // Brillo suave detrás del objeto para que resalte sobre la tela
            draw_set_alpha((elegido ? 0.3 : 0.18) * inventario_alpha);
            draw_set_color(c_white);
            draw_circle(pos.x, pos.y, item_tam * 0.55, false);
            draw_set_alpha(1);

            // Centrado en el parche usando solo la parte visible del sprite
            dibujar_sprite_centrado(item.spr, 0, pos.x, pos.y + flotar, item_tam, parche.angulo * 0.5, inventario_alpha);

            // Cantidad en una etiqueta pequeña abajo a la derecha
            if (item.cantidad > 1)
            {
                var cant_x = pos.x + medio * 0.72;
                var cant_y = pos.y + medio * 0.78;
                draw_set_alpha(0.85 * inventario_alpha);
                draw_set_color(c_black);
                draw_roundrect_ext(cant_x - 42 * esc_inv, cant_y - 24 * esc_inv, cant_x + 42 * esc_inv, cant_y + 24 * esc_inv, 20 * esc_inv, 20 * esc_inv, false);
                draw_set_alpha(inventario_alpha);
                draw_set_halign(fa_center);
                draw_set_valign(fa_middle);
                dibujar_texto_contorno(cant_x, cant_y, "x" + string(item.cantidad), 0.4 * esc_inv, make_color_rgb(255, 220, 60), 2 * esc_inv);
            }
        }

        // Tecla: un botón cosido en la esquina del parche
        dibujar_boton_cosido(pos.x - medio * 0.85, pos.y - medio * 0.85, 34 * esc_inv * aparecer, string(i + 1), 0.42 * esc_inv, inventario_alpha);
    }

    // Etiqueta de abajo: nombre y efecto del objeto elegido, o el mensaje de error
    var etiqueta_x = capa.izq + 900 * esc_inv;
    var etiqueta_y = capa.arriba + 1530 * esc_inv;
    var temblor_msg = (tiempo_mensaje > 105) ? random_range(-6, 6) * esc_inv : 0; // Tiembla al aparecer el mensaje
    dibujar_parche(etiqueta_x + temblor_msg, etiqueta_y, 330 * esc_inv, 85 * esc_inv, -2, [0, 0, 0.5, -0.3, 0, 0, -0.5, 0.3], make_color_rgb(45, 50, 60), grosor, 0.9 * inventario_alpha);

    draw_set_alpha(inventario_alpha);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    if (tiempo_mensaje > 0)
    {
        dibujar_texto_contorno(etiqueta_x + temblor_msg, etiqueta_y, mensaje_inv, 0.42 * esc_inv, make_color_rgb(255, 90, 90), 2 * esc_inv);
    }
    else
    {
        var item_elegido = inventario_items[slot_seleccionado];
        if (item_elegido != undefined)
        {
            dibujar_texto_contorno(etiqueta_x, etiqueta_y - 22 * esc_inv, item_elegido.nombre, 0.5 * esc_inv, c_white, 2 * esc_inv);
            dibujar_texto_contorno(etiqueta_x, etiqueta_y + 30 * esc_inv, descripcion_item(item_elegido.spr) + "  -  tecla " + string(slot_seleccionado + 1), 0.33 * esc_inv, make_color_rgb(190, 200, 220), 2 * esc_inv);
        }
        else
        {
            dibujar_texto_contorno(etiqueta_x, etiqueta_y, "Espacio " + string(slot_seleccionado + 1) + " vacio", 0.42 * esc_inv, make_color_rgb(150, 155, 170), 2 * esc_inv);
        }
    }

    draw_set_alpha(1);
}
