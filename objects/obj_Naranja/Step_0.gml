if (instance_exists(obj_player)) {
    var dis = point_distance(x, y, obj_player.x, obj_player.y);

    // Solo si está en reposo y puede atacar, detecta al jugador
    if (estado == "idle" && puedo_atacar) {
        if (dis <= distancia_deteccion) {
            estado = "enojada";
            sprite_index = spr_naranja_enojada;
            image_index = 0;
            image_speed = 0.15; // Velocidad pausada
            ha_disparado = false;
        }
    }
}