if (alpha <= 0.01) exit;

var escala_x = direccion_visual * orientacion_sprite * abs(image_xscale);
var escala_y = abs(image_yscale);

draw_sprite_ext(sprite_index, image_index, x, round(y), escala_x, escala_y, 0, c_white, alpha);
