// Sombra en el suelo que marca dónde va a caer el gnomo: le da al jugador tiempo de esquivar
if (estado == "salto" || estado == "apice" || estado == "picada")
{
    var altura = max(y_suelo - y, 0);
    var tam = clamp(1 - altura / 2000, 0.35, 1); // Más pequeña mientras más alto está

    draw_set_color(c_black);
    draw_set_alpha(0.25 + 0.35 * tam);
    draw_ellipse(x - 200 * tam, y_suelo - 35 * tam, x + 200 * tam, y_suelo + 35 * tam, false);
    draw_set_alpha(1);
}

// Dibujo normal del enemigo (estirar/aplastar, destello y barra de vida)
event_inherited();
