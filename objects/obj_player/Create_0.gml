hsp = 0;
vsp = 0;
grv = 1;
walksp = 15;
jumpsp = -40;
vida_max = 100;
vida = vida_max;
invulnerable = false;
direccion_visual = 1;
estado = "libre";
mask_index = spr_player_idle;

// Ataques. Las posiciones del hitbox son desde los pies del jugador, mirando a la derecha
// Alto: corte en arco hacia arriba. Rápido, poco alcance, cubre por encima de la cabeza
// y se puede usar caminando o saltando. Sirve contra lo que viene por el aire (gnomo saltando, naranja, semillas)
ataque_alto = {
    tipo: "alto",
    sprite: spr_player_cuchillo,
    danio: 20,
    empuje: 1,          // Multiplica qué tan lejos sale volando el enemigo
    duracion: 22,       // Fotogramas que dura todo el ataque
    golpe_inicio: 3,    // Fotograma en el que aparece el hitbox
    golpe_duracion: 10, // Fotogramas que el hitbox puede dañar
    hitbox_x: 60,       // Borde trasero del hitbox
    hitbox_y: -925,     // Centro vertical (cubre de -1600 a -250)
    hitbox_ancho: 650,
    hitbox_alto: 1350,
    impulso: 0,
    moverse: true,      // Se puede caminar mientras ataca
    tono: 1.15,         // Tono del sonido del cuchillo
};

// Bajo: estocada con embestida a ras de suelo. Más alcance, daño y empuje, pero tarda en salir,
// no se puede usar en el aire y deja al jugador quieto un rato. Sirve para alejar enemigos del suelo
// y castigar al gnomo cuando se queda clavado (hace el doble de daño)
ataque_bajo = {
    tipo: "bajo",
    sprite: spr_player_ataque_bajo,
    danio: 30,
    empuje: 1.8,
    duracion: 40,
    golpe_inicio: 7,
    golpe_duracion: 9,
    hitbox_x: 150,
    hitbox_y: -400,     // Cubre de -800 al suelo
    hitbox_ancho: 1000,
    hitbox_alto: 800,
    impulso: 35,        // Velocidad de la embestida hacia adelante (se va frenando)
    moverse: false,
    tono: 0.8,
};

ataque_actual = ataque_alto;
tiempo_ataque = 0;
impulso_ataque = 0;

iniciar_ataque = function(_ataque)
{
    estado = "atacando";
    ataque_actual = _ataque;
    tiempo_ataque = 0;
    impulso_ataque = 0;
    image_index = 0;
    audio_play_sound(snd_cuchillo, 1, false, 1, 0, _ataque.tono);
}

// El hitbox sigue al jugador mientras dura (ver Step de obj_hitbox_ataque)
crear_hitbox = function(_ataque)
{
    var hitbox = instance_create_depth(x, y, depth, obj_hitbox_ataque);
    hitbox.dueno = id;
    hitbox.desfase_x = _ataque.hitbox_x;
    hitbox.desfase_y = _ataque.hitbox_y;
    hitbox.direccion = direccion_visual;
    hitbox.image_xscale = direccion_visual * _ataque.hitbox_ancho / sprite_get_width(spr_hitbox);
    hitbox.image_yscale = _ataque.hitbox_alto / sprite_get_height(spr_hitbox);
    hitbox.danio = _ataque.danio;
    hitbox.empuje = _ataque.empuje;
    hitbox.tipo = _ataque.tipo;
    hitbox.alarm[0] = _ataque.golpe_duracion;
    with (hitbox) seguir_dueno();
}

// Monedas globales (las muestra obj_hud)
if (!variable_global_exists("monedas")) global.monedas = 0;

global.sacudida = 0;
global.combate = 0;

// Instancias que acompañan al jugador en cada sala
if (!instance_exists(obj_pausa)) instance_create_depth(0, 0, -10000, obj_pausa);           // Menú de pausa
if (!instance_exists(obj_hud)) instance_create_depth(0, 0, -9000, obj_hud);                // Vida y monedas
if (!instance_exists(obj_inventario)) instance_create_depth(0, 0, -9500, obj_inventario);  // Inventario (se dibuja encima del HUD)
if (!instance_exists(obj_guia)) instance_create_depth(x - 750, y, depth + 1, obj_guia);    // Guía que sigue al jugador

// Frame del HUD de salud
obtener_frame_salud = function()
{
    var frames_hud = sprite_get_number(spr_hud_salud);
    return clamp(floor((vida_max - vida) / (vida_max / frames_hud)), 0, frames_hud - 1);
}

// Recibir daño
recibir_danio = function(cantidad, tiempo_inmunidad)
{
    if (invulnerable) return;

    vida = max(vida - cantidad, 0);
    avisar_combate(180);

    if (vida <= 0)
    {
        room_restart();
    }
    else
    {
        invulnerable = true;
        alarm[0] = tiempo_inmunidad;
        sacudir_camara(30);
    }
}

// Cura al jugador. Devuelve false si ya tenía la vida llena (la usa obj_inventario)
curar = function(cantidad)
{
    if (vida >= vida_max) return false;
    vida = min(vida + cantidad, vida_max);
    return true;
}
