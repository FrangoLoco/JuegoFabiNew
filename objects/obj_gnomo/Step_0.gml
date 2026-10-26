// Aplicar gravedad en casi todos los estados excepto estando clavado
if (estado != "clavado") {
    vsp += grv;
}

// -------------------------------------------------------------
// LÓGICA DE ESTADOS
// -------------------------------------------------------------
switch (estado) {
    
    case "patrulla":
        sprite_index = spr_gnomo;
        image_speed = 1;
        
        // Detectar si el jugador está dentro de la distancia
        if (instance_exists(obj_player) && puedo_atacar) {
            var dis = point_distance(x, y, obj_player.x, obj_player.y);
            
            if (dis <= distancia_deteccion) {
                // Iniciar salto directo
                estado = "salto";
                vsp = fuerza_salto;
                
                // Moverse un poco hacia la posición X del jugador al saltar
                if (obj_player.x < x) hsp = -5;
                else hsp = 5;
            }
        }
        break;

    case "salto":
        sprite_index = spr_gnomo_ataque;
        
        // Cuando llega al punto más alto del salto (comienza a caer)
        if (vsp >= 0) {
            estado = "picada";
            hsp = 0; // Detiene el avance horizontal para caer en picada vertical
            vsp = velocidad_picada; // Caída rápida
        }
        break;

    case "picada":
        sprite_index = spr_gnomo_ataque;
        image_angle = 0; // Mantiene el gorro apuntando abajo si el sprite ya está dibujado así
        break;

    case "clavado":
        sprite_index = spr_gnomo_ataque;
        hsp = 0;
        vsp = 0;
        break;
}

// -------------------------------------------------------------
// COLISIONES Y MOVIMIENTO
// (Reemplaza 'obj_bloque' por tu objeto de pared/suelo)
// -------------------------------------------------------------

// Colisión horizontal
if (place_meeting(x + hsp, y, obj_colision)) {
    while (!place_meeting(x + sign(hsp), y, obj_colision)) {
        x += sign(hsp);
    }
    hsp = 0;
}
x += hsp;

// Colisión vertical
if (place_meeting(x, y + vsp, obj_colision)) {
    while (!place_meeting(x, y + sign(vsp), obj_colision)) {
        y += sign(vsp);
    }
    
    // Si cae en picada y toca el suelo, SE CLAVA
    if (estado == "picada") {
        estado = "clavado";
        puedo_atacar = false;
        alarm[0] = tiempo_clavado; // Cuenta atrás para desclavarse
    }
    
    vsp = 0;
}
y += vsp;