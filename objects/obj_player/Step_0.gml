// 1. Entradas de Control (teclado o botones táctiles en celular)
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A")) || global.toque_izquierda;
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D")) || global.toque_derecha;
var key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W")) || global.toque_salto;
var key_abajo = keyboard_check(vk_down) || keyboard_check(ord("S"));
var key_ataque = keyboard_check_pressed(ord("Z")) || global.toque_ataque;
var key_ataque_bajo = keyboard_check_pressed(ord("C")) || (key_ataque && key_abajo) || global.toque_ataque_bajo; // C o Abajo + Z

var en_suelo = place_meeting(x, y + 1, obj_colision);

// 2. Físicas
var move = key_right - key_left;
hsp = move * walksp;
vsp = vsp + grv;

// Durante el ataque bajo el jugador se compromete: no puede caminar ni saltar
var bloqueado = (estado == "atacando" && !ataque_actual.moverse);

if (en_suelo && key_jump && !bloqueado)
{
    vsp = jumpsp;
    audio_play_sound(snd_salto, 1, false);
}

// 3. Ataque
// Alto (Z): rápido, cubre arriba y se puede usar caminando o en el aire
// Bajo (C o Abajo + Z): estocada con embestida, más alcance y daño, pero solo en el suelo y deja al jugador expuesto
if (estado == "libre")
{
    if (key_ataque_bajo && en_suelo) iniciar_ataque(ataque_bajo);
    else if (key_ataque || key_ataque_bajo) iniciar_ataque(ataque_alto);
}

if (estado == "atacando")
{
    tiempo_ataque += 1;

    if (!ataque_actual.moverse)
    {
        hsp = impulso_ataque * direccion_visual;
        impulso_ataque *= 0.85;
    }

    // El golpe sale después del arranque del ataque
    if (tiempo_ataque == ataque_actual.golpe_inicio)
    {
        crear_hitbox(ataque_actual);
        impulso_ataque = ataque_actual.impulso;
        if (ataque_actual.impulso > 0) crear_particulas(x, y, 6, make_color_rgb(150, 120, 90), 15); // Polvo de la embestida
    }

    if (tiempo_ataque >= ataque_actual.duracion) estado = "libre";
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
    sprite_index = ataque_actual.sprite;
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

// 6. Orientación visual (no se voltea a media animación de ataque)
if (hsp != 0 && estado == "libre") direccion_visual = sign(hsp);
