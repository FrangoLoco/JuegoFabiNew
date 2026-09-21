// 1. Entradas de Control
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var key_ataque = keyboard_check_pressed(ord("Z")); 

// 2. Físicas de desplazamiento continuo
var move = key_right - key_left;
hsp = move * walksp;
vsp = vsp + grv;

if (place_meeting(x, y + 1, obj_colision)) && (key_jump)
{
    vsp = jumpsp;
}

// 3. Activación del Ataque
if (key_ataque) && (estado == "libre")
{
    estado = "atacando";
    image_index = 0; // Obliga al sprite de ataque a leer su único fotograma válido
    
    var hitbox = instance_create_depth(x, y - 30, depth, obj_hitbox_ataque);
    hitbox.image_xscale = direccion_visual; 
    
    alarm[1] = 40; 
}

// 4. Motor de Colisiones Geométricas
if (place_meeting(x + hsp, y, obj_colision))
{
    while (!place_meeting(x + sign(hsp), y, obj_colision)) x += sign(hsp);
    hsp = 0;
}
x += hsp;

if (place_meeting(x, y + vsp, obj_colision))
{
    while (!place_meeting(x, y + sign(vsp), obj_colision)) y += sign(vsp);
    vsp = 0;
}
y += vsp;

// 5. Control de renderizado jerárquico (Debe ser lo ÚLTIMO en tu evento Step)
if (estado == "atacando")
{
    // Prioridad 1: Si ataca, fuerza el cuchillo e ignora todo lo demás
    sprite_index = spr_player_cuchillo;
}
else
{
    // Prioridad 2: Si está libre, reacciona a la física
    if (!place_meeting(x, y + 1, obj_colision))
    {
        sprite_index = spr_player_salto;
    }
    else
    {
        if (hsp == 0) 
        {
            sprite_index = spr_player_idle;
        }
        else 
        {
            sprite_index = spr_player_caminar;
        }
    }
}

// 6. Orientación visual
if (hsp != 0) direccion_visual = sign(hsp);