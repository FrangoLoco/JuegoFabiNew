// Evento Draw de obj_player

var transparencia = 1;

if (invulnerable)
{
    if ((current_time mod 200) < 100)
    {
        transparencia = 0.2;
    }
}

// Multiplicamos la dirección visual (1 o -1) por el valor absoluto de la escala actual.
// Esto asegura que el personaje se voltee sin deformar su tamaño base.
var escala_x = direccion_visual * abs(image_xscale);
var escala_y = abs(image_yscale);

draw_sprite_ext(sprite_index, image_index, x, round(y), escala_x, escala_y, 0, c_white, transparencia);