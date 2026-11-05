// Guía que acompaña al jugador. obj_player lo crea al iniciar cada sala
hsp = 0;
vsp = 0;
grv = 1;
jumpsp = -40;
vel_max = 17;            // Un poco más rápido que el jugador (15) para poder alcanzarlo
distancia_seguir = 1050;  // Distancia media-cerca a la que se queda detrás del jugador
margen = 100;            // Zona muerta: si está así de cerca del punto ideal no se mueve (evita que tiemble)
distancia_maxima = 2500; // Si se queda más lejos que esto, reaparece junto al jugador
tiempo_lejos = 0;        // Fotogramas que lleva demasiado lejos

direccion_visual = 1;
orientacion_sprite = 1; // Cambia a -1 si el sprite del guía se ve caminando de espaldas

// Se esconde mientras los enemigos atacan al jugador (ver avisar_combate en scr_efectos)
escondido = false;
alpha = 1;

mask_index = spr_guia_idle;
sprite_index = spr_guia_idle;

// Lo pone detrás del jugador. Si ahí hay pared, lo pone junto a él
colocar_junto_al_jugador = function()
{
    var nuevo_x = obj_player.x - obj_player.direccion_visual * distancia_seguir;
    var nuevo_y = obj_player.y;
    if (place_meeting(nuevo_x, nuevo_y, obj_colision)) nuevo_x = obj_player.x;

    x = nuevo_x;
    y = nuevo_y;
    hsp = 0;
    vsp = 0;
    tiempo_lejos = 0;
}

// Nube de humo al desaparecer o aparecer
soltar_humo = function()
{
    crear_particulas(x, (bbox_top + bbox_bottom) / 2, 10, make_color_rgb(230, 230, 255), 18);
}
