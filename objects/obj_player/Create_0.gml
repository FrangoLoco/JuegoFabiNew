// Evento Create de obj_player
hsp = 0;       // Velocidad horizontal actual
vsp = 0;       // Velocidad vertical actual
grv = 1;     // Fuerza de gravedad
walksp = 15;    // Velocidad máxima de caminata
jumpsp = -40;   // Fuerza del salto (negativa porque en GM el eje Y sube hacia abajo)
vida_max = 100; // La vida va de 0 a 100
vida = vida_max;
danio_ataque = 20; // Daño que hace cada golpe del cuchillo
invulnerable = false; // Controla si el jugador puede recibir daño
direccion_visual = 1;
estado = "libre"; // Puede ser "libre" o "atacando"
mask_index = spr_player_idle;

// Monedas: son globales para que se conserven al cambiar de sala o al reiniciarla
if (!variable_global_exists("monedas")) global.monedas = 0;
monedas_hud = global.monedas; // Valor que muestra el HUD, sube de uno en uno hasta alcanzar global.monedas
escala_monedas = 1;           // El contador crece un poco cada vez que suma una moneda
escala_base_moneda = 90 / sprite_get_width(spr_moneda); // 90 px de diámetro en el lienzo 3840, sea cual sea el tamaño del sprite
temporizador_monedas = 0;

global.sacudida = 0; // Intensidad de la sacudida de cámara (ver End Step y sacudir_camara)

// Menú de pausa: uno por sala
if (!instance_exists(obj_pausa)) instance_create_depth(0, 0, -10000, obj_pausa);

// Frame del HUD de salud: 0 = max, 1 = med, 2 = baja, 3 = min
// Cada 25 puntos de vida perdidos se pasa al siguiente frame (100 = max, 75 = med, 50 = baja, 25 o menos = min)
obtener_frame_salud = function()
{
    var frames_hud = sprite_get_number(spr_hud_salud);
    return clamp(floor((vida_max - vida) / (vida_max / frames_hud)), 0, frames_hud - 1);
}

// Resta vida al jugador y le da inmunidad temporal. Los enemigos llaman a esto en vez de tocar "vida" directamente
recibir_danio = function(cantidad, tiempo_inmunidad)
{
    if (invulnerable) return;

    vida = max(vida - cantidad, 0);

    if (vida <= 0)
    {
        // Reiniciar la sala (aquí puede ir la pantalla de Game Over más adelante)
        room_restart();
    }
    else
    {
        invulnerable = true;
        alarm[0] = tiempo_inmunidad;
        sacudir_camara(30);
    }
}

// Inventario
inventario_abierto = false;
inventario_alpha   = 0;

// SISTEMA DE INVENTARIO
inventario_items = []; // Array que guardará nuestras estructuras
max_slots_inv = 9;     // Cuántos espacios tiene el inventario

// Función para añadir objetos
agregar_item = function(_spr, _nombre) {
    var _encontrado = false;
    
    // 1. Buscar si ya tenemos este objeto para sumarle cantidad
    for (var i = 0; i < array_length(inventario_items); i++) {
        if (inventario_items[i].spr == _spr) {
            inventario_items[i].cantidad += 1;
            _encontrado = true;
            break;
        }
    }
    
    // 2. Si no lo tenemos, crear un nuevo espacio
    if (!_encontrado) {
        if (array_length(inventario_items) < max_slots_inv) {
            array_push(inventario_items, {
                spr: _spr,
                nombre: _nombre,
                cantidad: 1
            });
        } else {
            // Opcional: sonido de error o mensaje de "Inventario lleno"
        }
    }
}

// Función para usar el hongo (o cualquier objeto curativo)
usar_hongo = function() {
    for (var i = 0; i < array_length(inventario_items); i++) {
        if (inventario_items[i].spr == spr_hongo) {
            if (vida < vida_max) { // Solo curar si no tenemos la vida al máximo
                vida = min(vida + 20, vida_max); // Cura 20 de vida
                inventario_items[i].cantidad -= 1;
                
                // Si ya no quedan hongos, borrar el espacio del array
                if (inventario_items[i].cantidad <= 0) {
                    array_delete(inventario_items, i, 1);
                }
                break;
            }
        }
    }
}
