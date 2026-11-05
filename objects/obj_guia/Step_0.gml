if (!instance_exists(obj_player)) exit;

// Siempre se dibuja detrás del jugador
depth = obj_player.depth + 1;

// 1. Esconderse durante el combate
if (global.combate > 0) global.combate -= 1;
var hay_combate = (global.combate > 0);

if (hay_combate && !escondido)
{
    escondido = true;
    soltar_humo();
}
else if (!hay_combate && escondido)
{
    // Ya pasó el peligro: reaparece cerca del jugador
    escondido = false;
    colocar_junto_al_jugador();
    soltar_humo();
}

alpha = lerp(alpha, escondido ? 0 : 1, 0.15);
if (escondido) exit;

// 2. Seguir al jugador desde atrás
var objetivo_x = obj_player.x - obj_player.direccion_visual * distancia_seguir;
var dif = objetivo_x - x;

if (abs(dif) > margen) hsp = clamp(dif * 0.08, -vel_max, vel_max);
else hsp = lerp(hsp, 0, 0.3);
if (abs(hsp) < 0.5) hsp = 0;

vsp = vsp + grv;

var en_suelo = place_meeting(x, y + 1, obj_colision);

// Salta si una pared le bloquea el paso
if (en_suelo && hsp != 0 && place_meeting(x + sign(hsp) * 40, y, obj_colision))
{
    vsp = jumpsp;
}

// 3. Colisiones
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

// 4. Si se quedó atorado, muy lejos o se cayó de la sala, reaparece junto al jugador
if (point_distance(x, y, obj_player.x, obj_player.y) > distancia_maxima) tiempo_lejos += 1;
else tiempo_lejos = 0;

if (tiempo_lejos > 90 || y > room_height + 500)
{
    soltar_humo();
    colocar_junto_al_jugador();
    soltar_humo();
    alpha = 0;
}

// 5. Sprite y orientación
if (place_meeting(x, y + 1, obj_colision) && hsp != 0) sprite_index = spr_guia_caminar;
else sprite_index = spr_guia_idle;

// Mira hacia donde camina; quieto, mira al jugador
if (hsp != 0) direccion_visual = sign(hsp);
else if (obj_player.x != x) direccion_visual = sign(obj_player.x - x);
