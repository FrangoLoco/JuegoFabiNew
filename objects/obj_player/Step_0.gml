// Temporizador del mensaje de alerta
if (tiempo_mensaje > 0) {
    tiempo_mensaje -= 1;
}

// Abrir/Cerrar Inventario
if (keyboard_check_pressed(ord("X")))
{
    inventario_abierto = !inventario_abierto;
    
    // Si cerramos el inventario, borramos el mensaje de error de golpe
    if (!inventario_abierto) {
        tiempo_mensaje = 0;
    }
}
inventario_alpha = lerp(inventario_alpha, inventario_abierto ? 1 : 0, 0.2);

// 1. Entradas de Control
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var key_ataque = keyboard_check_pressed(ord("Z")); 

// 2. Físicas
var move = key_right - key_left;
hsp = move * walksp;
vsp = vsp + grv;

if (place_meeting(x, y + 1, obj_colision)) && (key_jump)
{
    vsp = jumpsp;
    audio_play_sound(snd_salto, 1, false);
}

// 3. Ataque
if (key_ataque) && (estado == "libre")
{
    estado = "atacando";
    image_index = 0;
    audio_play_sound(snd_cuchillo, 1, false);
    var hitbox = instance_create_depth(x, y - 30, depth, obj_hitbox_ataque);
    hitbox.image_xscale = direccion_visual; 
    hitbox.danio = danio_ataque;
    alarm[1] = 40; 
}

// 4. Colisiones
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

// 5. Renderizado jerárquico
if (estado == "atacando")
{
    sprite_index = spr_player_cuchillo;
}
else
{
    if (!place_meeting(x, y + 1, obj_colision)) 
    {
        sprite_index = spr_player_salto;
    }
    else
    {
        if (hsp == 0) { sprite_index = spr_player_idle; }
        else { sprite_index = spr_player_caminar; }
    }
}

// 5b. Sonido de pasos
var caminando = (estado == "libre") && place_meeting(x, y + 1, obj_colision) && (hsp != 0);
if (caminando && !audio_is_playing(snd_pasos)) { audio_play_sound(snd_pasos, 1, true); }
else if (!caminando && audio_is_playing(snd_pasos)) { audio_stop_sound(snd_pasos); }

// 6. Orientación visual
if (hsp != 0) direccion_visual = sign(hsp);

// 7. Monedas HUD
if (monedas_hud < global.monedas)
{
    temporizador_monedas -= 1;
    if (temporizador_monedas <= 0)
    {
        monedas_hud += 1;
        escala_monedas = 1.4;
        temporizador_monedas = 8;
    }
}
else { monedas_hud = global.monedas; }
escala_monedas = lerp(escala_monedas, 1, 0.15);

// 8. Uso de Hongo
if (inventario_abierto) 
{
    if (keyboard_check_pressed(ord("E"))) 
    {
        var resultado = usar_hongo();
        
        switch (resultado)
        {
            case "usado":
					//nota: busquen sonidos plebada
                // audio_play_sound(snd_curacion, 1, false);
                break;
            case "sin_hongos":
                mensaje_inv = "No tienes hongos en el inventario.";
                tiempo_mensaje = 120;
                break;
            case "vida_llena":
                mensaje_inv = "Tu vida ya esta al maximo.";
                tiempo_mensaje = 120;
                break;
        }
    }
}