// 1. Pasa de "enojada" a "ataque" y dispara
if (sprite_index == spr_naranja_enojada) {
    estado = "ataque";
    sprite_index = spr_naranja_ataque;
    image_index = 0;
    image_speed = 0.15;

    // Disparo único
    if (!ha_disparado && instance_exists(obj_player)) {
        var bala = instance_create_layer(x, y, "Instances", obj_semilla);
        
        // Orientación según la posición del jugador
        if (obj_player.x < x) {
            bala.direction = 180; // Izquierda
            bala.image_angle = 180;
        } else {
            bala.direction = 0;   // Derecha
            bala.image_angle = 0;
        }
        
        bala.speed = 10;
        bala.image_xscale = 2; // Escala/tamaño del proyectil
        bala.image_yscale = 2;
        
        ha_disparado = true;
    }
}

// 2. Termina la animación de "ataque" e inicia el cooldown
else if (sprite_index == spr_naranja_ataque) {
    puedo_atacar = false;
    alarm[0] = cooldown_ataque;

    if (instance_exists(obj_player)) {
        var dis = point_distance(x, y, obj_player.x, obj_player.y);
        
        // Si el jugador sigue cerca, mantiene la sprite enojada pausada
        if (dis <= distancia_deteccion) {
            estado = "enojada";
            sprite_index = spr_naranja_enojada;
            image_index = 0;
            image_speed = 0; 
        } else {
            estado = "idle";
            sprite_index = spr_naranja_ojo;
            image_speed = 1;
        }
    } else {
        estado = "idle";
        sprite_index = spr_naranja_ojo;
    }
}