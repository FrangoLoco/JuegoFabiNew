// Begin Step: se leen los toques antes de que obj_player y obj_pausa lean los controles en su Step

// Con el juego en pausa no se lee nada (el menú de pausa se maneja tocando sus botones)
if (esta_en_pausa())
{
    reiniciar_toques();
    for (var i = 0; i < array_length(botones); i++) botones[i].presionado = false;
    exit;
}

// 1. Ver qué botón toca cada dedo (hasta 5 a la vez). Cuenta el más cercano para que los botones vecinos no se pisen
var e = escala();
var presionados = array_create(array_length(botones), false);
for (var dedo = 0; dedo < 5; dedo++)
{
    if (!device_mouse_check_button(dedo, mb_left)) continue;

    var toque_x = device_mouse_x_to_gui(dedo);
    var toque_y = device_mouse_y_to_gui(dedo);
    var mas_cercano = -1;
    var menor_distancia = infinity;

    for (var i = 0; i < array_length(botones); i++)
    {
        var pos = posicion(botones[i]);
        var distancia = point_distance(toque_x, toque_y, pos[0], pos[1]);
        if (distancia <= botones[i].radio * margen_toque * e && distancia < menor_distancia)
        {
            mas_cercano = i;
            menor_distancia = distancia;
        }
    }
    if (mas_cercano >= 0) presionados[mas_cercano] = true;
}

// 2. "recien" es true solo en el fotograma en que el dedo empieza a tocar el botón
for (var i = 0; i < array_length(botones); i++)
{
    botones[i].recien = presionados[i] && !botones[i].presionado;
    botones[i].presionado = presionados[i];
}

// 3. Pasar el estado a las variables que leen el jugador y la pausa
global.toque_izquierda = boton_izquierda.presionado;
global.toque_derecha = boton_derecha.presionado;
global.toque_ataque = boton_ataque.recien;
global.toque_salto = boton_salto.recien;
global.toque_pausa = boton_pausa.recien;
