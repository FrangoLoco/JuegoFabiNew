// Aparece un poco más grande y se encoge a su tamaño normal en los primeros fotogramas
var escala_actual = escala * (1 + 0.5 * max(0, 1 - tiempo / 8));

// Se desvanece durante la segunda mitad de su duración
draw_set_alpha(clamp(2 - 2 * tiempo / duracion, 0, 1));
draw_set_font(fnt_debug);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

dibujar_texto_contorno(x, y, texto, escala_actual, color, 5);

// Restaurar valores para no afectar otros dibujos
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
