// 1. Aplicar Gravedad constantemente
vsp = vsp + grv;

// 2. Lógica de Suelo (Temporizador y Salto Aleatorio)
if (place_meeting(x, y + 1, obj_colision))
{
    // Detener movimiento horizontal y asignar sprite inactivo
    hsp = 0;
    sprite_index = spr_limon;
    
    // Disminuir el temporizador un punto por cada fotograma
    if (temporizador > 0)
    {
        temporizador -= 1;
    }
    else
    {
        // El tiempo se agotó: Ejecutar el salto vertical
        vsp = jumpsp;
        
        // Calcular dirección y fuerza horizontal aleatoria
        // random_range(3, 6): Genera una velocidad decimal impredecible entre 3 y 6
        // choose(-1, 1): Decide de forma binaria si el vector será positivo (derecha) o negativo (izquierda)
        hsp = random_range(3, 6) * choose(-1, 1);
        
        // Reiniciar el reloj para la próxima vez que aterrice
        temporizador = tiempo_espera;
    }
}
else
{
    // Lógica de Aire: Asignar sprite de salto
    sprite_index = spr_limon_salto;
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

// 5. Dirección Visual
// Solo voltea el sprite si existe un movimiento horizontal activo
if (hsp != 0)
{
    image_xscale = sign(hsp);
}