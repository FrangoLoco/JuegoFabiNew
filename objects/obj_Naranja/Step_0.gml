// Efectos comunes de los enemigos (estirar/aplastar, destello)
event_inherited();

// En furia (menos de la mitad de vida) se pone roja, flota más rápido y ataca más seguido
if (furia) {
    image_blend = make_color_rgb(255, 160, 160);
    cooldown_ataque = 80;
}

// Flota suavemente arriba y abajo
tiempo_flotar += furia ? 4 : 2;
y = inicio_y + dsin(tiempo_flotar) * 25;

// Tiembla mientras se enoja para avisar que va a disparar
temblor = (estado == "enojada" && image_speed > 0) ? (furia ? 10 : 6) : 0;

if (instance_exists(obj_player)) {
    var dis = point_distance(x, y, obj_player.x, obj_player.y);

    // Solo si está en reposo y puede atacar, detecta al jugador
    if (estado == "idle" && puedo_atacar) {
        if (dis <= distancia_deteccion) {
            estado = "enojada";
            sprite_index = spr_naranja_enojada;
            image_index = 0;
            image_speed = furia ? 0.25 : 0.15; // Velocidad pausada (más rápida en furia)
            ha_disparado = false;
            escala_x = 0.85; // Se infla antes de atacar
            escala_y = 1.15;
        }
    }
}
