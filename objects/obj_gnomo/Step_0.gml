// Efectos comunes de los enemigos (estirar/aplastar, retroceso, destello)
event_inherited();

// En furia (menos de la mitad de vida) se pone rojo y es más rápido y agresivo
if (furia)
{
    image_blend = make_color_rgb(255, 160, 160);
}
var multiplicador = furia ? 1.6 : 1;

// Aplicar gravedad en casi todos los estados excepto estando clavado o flotando en el ápice
if (estado != "clavado" && estado != "apice") {
    vsp += grv;
}

var en_suelo = place_meeting(x, y + 1, obj_colision);

// -------------------------------------------------------------
// LÓGICA DE ESTADOS
// -------------------------------------------------------------
switch (estado) {

    case "patrulla":
        sprite_index = spr_gnomo;
        image_speed = 0.25 * multiplicador;
        temblor = 0;

        // Camina de un lado a otro. Se da la vuelta en paredes, orillas o al alejarse mucho de su inicio
        if (en_suelo) {
            var siguiente_x = x + dir_patrulla * vel_patrulla * multiplicador;
            if (place_meeting(siguiente_x, y, obj_colision)
                || !place_meeting(x + dir_patrulla * 250, y + 1, obj_colision)
                || (siguiente_x - inicio_x) * dir_patrulla > rango_patrulla) {
                dir_patrulla *= -1;
            }
            hsp = dir_patrulla * vel_patrulla * multiplicador;
            mirar = dir_patrulla * orientacion_sprite;

            // Rebote al caminar
            escala_y = 1 + abs(sin(current_time / 120)) * 0.06;
        }

        // Detectar si el jugador está dentro de la distancia
        if (instance_exists(obj_player) && puedo_atacar && en_suelo) {
            var dis = point_distance(x, y, obj_player.x, obj_player.y);

            if (dis <= distancia_deteccion) {
                // Aviso: se detiene, voltea al jugador y le sale un "!"
                estado = "aviso";
                temporizador = furia ? 15 : tiempo_aviso;
                hsp = 0;

                var signo = instance_create_depth(x, bbox_top - 60, -1000, obj_texto_flotante);
                signo.texto = "!";
                signo.color = make_color_rgb(255, 230, 60);
                signo.escala = 3;
                signo.vel_y = -2;
                signo.duracion = 30;
            }
        }
        break;

    case "aviso":
        sprite_index = spr_gnomo;
        image_speed = 0;
        hsp = 0;

        // Se agacha y tiembla para que el jugador sepa que va a saltar
        escala_x = 1.25;
        escala_y = 0.75;
        temblor = 5;
        if (instance_exists(obj_player)) mirar = sign(obj_player.x - x) * orientacion_sprite;

        temporizador -= 1;
        if (temporizador <= 0) {
            // Iniciar salto hacia el jugador
            estado = "salto";
            temblor = 0;
            vsp = fuerza_salto;
            y_suelo = y;
            escala_x = 0.7;
            escala_y = 1.35;

            if (instance_exists(obj_player)) {
                var tiempo_subida = abs(fuerza_salto) / grv;
                hsp = clamp((obj_player.x - x) / tiempo_subida, -velocidad_salto_max, velocidad_salto_max);
            }
        }
        break;

    case "salto":
        sprite_index = spr_gnomo_ataque;
        image_speed = 0.3;

        // Corrige su dirección en el aire para quedar encima del jugador (más en furia)
        if (instance_exists(obj_player)) {
            var hsp_deseado = clamp((obj_player.x - x) / 20, -velocidad_salto_max, velocidad_salto_max);
            hsp = lerp(hsp, hsp_deseado, furia ? 0.08 : 0.04);
        }

        // Cuando llega al punto más alto del salto se queda flotando un momento
        if (vsp >= 0) {
            estado = "apice";
            temporizador = furia ? 8 : tiempo_apice;
            hsp = 0;
            vsp = 0;
        }
        break;

    case "apice":
        sprite_index = spr_gnomo_ataque;
        hsp = 0;
        vsp = 0;
        temblor = 8;

        temporizador -= 1;
        if (temporizador <= 0) {
            estado = "picada";
            temblor = 0;
            vsp = velocidad_picada * multiplicador; // Caída rápida
        }
        break;

    case "picada":
        sprite_index = spr_gnomo_ataque;
        image_angle = 0; // Mantiene el gorro apuntando abajo si el sprite ya está dibujado así

        // Se estira mientras cae
        escala_x = 0.75;
        escala_y = 1.3;
        break;

    case "clavado":
        sprite_index = spr_gnomo_ataque;
        image_speed = 0;
        hsp = 0;
        vsp = 0;

        // Forcejea para desclavarse justo antes de salir (es el momento de pegarle)
        temblor = (alarm[0] < 20) ? 6 : 0;
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

    // Si cae en picada y toca el suelo, SE CLAVA con un impacto que sacude la pantalla
    if (estado == "picada") {
        estado = "clavado";
        puedo_atacar = false;
        alarm[0] = furia ? 55 : tiempo_clavado; // Cuenta atrás para desclavarse

        escala_x = 1.5;
        escala_y = 0.6;
        sacudir_camara(25);
        crear_particulas(x, y, 10, make_color_rgb(120, 90, 60), 25);
    }

    vsp = 0;
}
y += vsp;
