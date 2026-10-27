// Efectos comunes de los enemigos (estirar/aplastar, retroceso, destello)
event_inherited();

// 1. Aplicar Gravedad constantemente
vsp = vsp + grv;

// 2. Lógica de Suelo (Temporizador y Salto)
if (place_meeting(x, y + 1, obj_colision))
{
    // Detener movimiento horizontal y asignar sprite inactivo
    hsp = 0;
    sprite_index = spr_limon;
    image_speed = 0.25;

    // Disminuir el temporizador un punto por cada fotograma
    if (temporizador > 0)
    {
        temporizador -= 1;

        // Anticipación: se agacha y tiembla justo antes de saltar
        if (temporizador < tiempo_anticipacion)
        {
            escala_x = 1.25;
            escala_y = 0.75;
            temblor = 4;
        }
    }
    else
    {
        // El tiempo se agotó: Ejecutar el salto y estirarse hacia arriba
        vsp = jumpsp;
        temblor = 0;
        escala_x = 0.7;
        escala_y = 1.35;

        if (instance_exists(obj_player) && point_distance(x, y, obj_player.x, obj_player.y) <= distancia_deteccion)
        {
            // Salta hacia el jugador: calcula la velocidad para caer donde está ahora
            var tiempo_aire = 2 * abs(jumpsp) / grv;
            hsp = clamp((obj_player.x - x) / tiempo_aire, -velocidad_persecucion, velocidad_persecucion);

            // Cuando te persigue descansa menos entre saltos
            temporizador = irandom_range(35, 55);
        }
        else
        {
            // Salto al azar
            // random_range(3, 6): Genera una velocidad decimal impredecible entre 3 y 6
            // choose(-1, 1): Decide de forma binaria si el vector será positivo (derecha) o negativo (izquierda)
            hsp = random_range(3, 6) * choose(-1, 1);

            // Reiniciar el reloj para la próxima vez que aterrice
            temporizador = tiempo_espera;
        }
    }
}
else
{
    // Lógica de Aire: Asignar sprite de salto
    sprite_index = spr_limon_salto;
    image_speed = 1;
}

// 3. Colisión Horizontal (Rebote en paredes durante el salto)
if (place_meeting(x + hsp, y, obj_colision))
{
    while (!place_meeting(x + sign(hsp), y, obj_colision))
    {
        x = x + sign(hsp);
    }
    // Si choca con un muro en el aire, invierte su inercia para rebotar
    hsp = -hsp;
}
// Aplicar vector X
x = x + hsp;

// 4. Colisión Vertical
if (place_meeting(x, y + vsp, obj_colision))
{
    while (!place_meeting(x, y + sign(vsp), obj_colision))
    {
        y = y + sign(vsp);
    }
    vsp = 0;
}
// Aplicar vector Y
y = y + vsp;

// 5. Aterrizaje: se aplasta y levanta polvo
var en_suelo_ahora = place_meeting(x, y + 1, obj_colision);
if (en_suelo_ahora && !en_suelo)
{
    escala_x = 1.4;
    escala_y = 0.6;
    crear_particulas(x, y, 4, make_color_rgb(150, 120, 90), 12);
}
en_suelo = en_suelo_ahora;

// 6. Dirección Visual
// Solo voltea el dibujo si existe un movimiento horizontal activo
if (hsp != 0)
{
    mirar = sign(hsp);
}
