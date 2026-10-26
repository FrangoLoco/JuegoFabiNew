// Se encoge hasta desaparecer. El contorno negro combina con el estilo de los dibujos
var radio_actual = radio * (1 - tiempo / duracion);

draw_set_color(c_black);
draw_circle(x, y, radio_actual + 4, false);
draw_set_color(color);
draw_circle(x, y, radio_actual, false);
