// 1. Capturar la entrada del teclado (Soporta flechas y WASD)
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));

// 2. Calcular la dirección y el movimiento horizontal
var move = key_right - key_left;
hsp = move * walksp;

// 3. Aplicar gravedad a la velocidad vertical
vsp = vsp + grv;

// 4. Lógica de salto (Solo si está tocando el suelo)
if (place_meeting(x, y + 1, obj_colision)) && (key_jump)
{
    vsp = jumpsp;
}

// 5. Colisión Horizontal
if (place_meeting(x + hsp, y, obj_colision))
{
    while (!place_meeting(x + sign(hsp), y, obj_colision))
    {
        x = x + sign(hsp);
    }
    hsp = 0;
}
x = x + hsp;

// 6. Colisión Vertical
if (place_meeting(x, y + vsp, obj_colision))
{
    while (!place_meeting(x, y + sign(vsp), obj_colision))
    {
        y = y + sign(vsp);
    }
    vsp = 0;
}
y = y + vsp;

// 7. Control de Animaciones y Estado
// Evaluar si el personaje está en el aire (no hay colisión un píxel por debajo)
if (!place_meeting(x, y + 1, obj_colision))
{
    sprite_index = spr_player_salto;
    image_speed = 1; // Detiene la reproducción de fotogramas (útil si el salto es un solo frame)
    
    // Opcional: Control de frames si el sprite de salto tiene animaciones de subida y caída
    // if (sign(vsp) > 0) image_index = 1; else image_index = 0;
}
else
{
    // El personaje está tocando el suelo
    image_speed = 1; // Restaura la velocidad normal de animación definida en el sprite
    
    if (hsp == 0)
    {
        // Sin movimiento horizontal
        sprite_index = spr_player_idle;
    }
    else
    {
        // Con vector de movimiento horizontal activo
        sprite_index = spr_player_caminar;
    }
}

// 8. Dirección Visual (Invertir el sprite en el eje X)
if (hsp != 0)
{
    image_xscale = sign(hsp);
}