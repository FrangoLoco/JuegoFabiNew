// Dibujo del enemigo con estirar/aplastar y temblor
var dibujo_x = x;
var dibujo_y = y;
if (temblor > 0)
{
    dibujo_x += random_range(-temblor, temblor);
    dibujo_y += random_range(-temblor, temblor) * 0.5;
}
var dibujo_xscale = image_xscale * mirar * escala_x;
var dibujo_yscale = image_yscale * escala_y;

draw_sprite_ext(sprite_index, image_index, dibujo_x, dibujo_y, dibujo_xscale, dibujo_yscale, image_angle, image_blend, image_alpha);

// Destello blanco al recibir un golpe
if (destello > 0)
{
    gpu_set_fog(true, c_white, 0, 1);
    draw_sprite_ext(sprite_index, image_index, dibujo_x, dibujo_y, dibujo_xscale, dibujo_yscale, image_angle, c_white, destello / 8);
    gpu_set_fog(false, c_white, 0, 0);
}

// Barra de vida y nivel encima del enemigo, se ve un rato después de cada golpe
if (tiempo_barra > 0 && vida_max > 1)
{
    var ancho = 320;
    var alto = 32;
    var barra_x = x - ancho / 2;
    var barra_y = bbox_top - 110;

    draw_set_alpha(min(1, tiempo_barra / 30));

    draw_set_color(c_black);
    draw_rectangle(barra_x - 6, barra_y - 6, barra_x + ancho + 6, barra_y + alto + 6, false);
    draw_set_color(make_color_rgb(40, 40, 60));
    draw_rectangle(barra_x, barra_y, barra_x + ancho, barra_y + alto, false);

    // Blanco: vida que acabas de quitar. Color: vida actual (de verde a rojo)
    draw_set_color(c_white);
    draw_rectangle(barra_x, barra_y, barra_x + ancho * clamp(vida_mostrada / vida_max, 0, 1), barra_y + alto, false);
    draw_set_color(merge_color(c_red, c_lime, clamp(vida / vida_max, 0, 1)));
    draw_rectangle(barra_x, barra_y, barra_x + ancho * clamp(vida / vida_max, 0, 1), barra_y + alto, false);

    // Un rombo por cada nivel de dificultad, del color del nivel
    var color_nivel = colores_nivel[clamp(nivel, 0, array_length(colores_nivel) - 1)];
    for (var i = 0; i < nivel; i++)
    {
        var rombo_x = barra_x + 20 + i * 50;
        var rombo_y = barra_y - 40;
        draw_set_color(c_black);
        draw_triangle(rombo_x - 22, rombo_y, rombo_x, rombo_y - 22, rombo_x + 22, rombo_y, false);
        draw_triangle(rombo_x - 22, rombo_y, rombo_x, rombo_y + 22, rombo_x + 22, rombo_y, false);
        draw_set_color(color_nivel);
        draw_triangle(rombo_x - 15, rombo_y, rombo_x, rombo_y - 15, rombo_x + 15, rombo_y, false);
        draw_triangle(rombo_x - 15, rombo_y, rombo_x, rombo_y + 15, rombo_x + 15, rombo_y, false);
    }

    draw_set_alpha(1);
}
