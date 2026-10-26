// 1. Pasa de "enojada" a "ataque" y dispara
if (sprite_index == spr_naranja_enojada) {
    estado = "ataque";
    sprite_index = spr_naranja_ataque;
    image_index = 0;
    image_speed = 0.15;

    // Disparo único, apuntado al cuerpo del jugador
    if (!ha_disparado && instance_exists(obj_player)) {
        var centro_jugador = (obj_player.bbox_top + obj_player.bbox_bottom) / 2;
        var angulo = point_direction(x, y, obj_player.x, centro_jugador);

        disparar_semilla(angulo);

        // En furia dispara 3 semillas en abanico
        if (furia) {
            disparar_semilla(angulo - apertura_abanico);
            disparar_semilla(angulo + apertura_abanico);
        }

        // Retroceso al disparar
        escala_x = 1.3;
        escala_y = 0.75;
        sacudir_camara(6);

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
            image_speed = 0.2;
        }
    } else {
        estado = "idle";
        sprite_index = spr_naranja_ojo;
        image_speed = 0.2;
    }
}
