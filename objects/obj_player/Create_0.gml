hsp = 0;
vsp = 0;
grv = 1;
walksp = 15;
jumpsp = -40;
vida_max = 100;
vida = vida_max;
danio_ataque = 20;
invulnerable = false;
direccion_visual = 1;
estado = "libre";
mask_index = spr_player_idle;

// Variables de mensajes
mensaje_inv = "";
tiempo_mensaje = 0;

// Monedas globales
if (!variable_global_exists("monedas")) global.monedas = 0;
monedas_hud = global.monedas;
escala_monedas = 1;
escala_base_moneda = 90 / sprite_get_width(spr_moneda);
temporizador_monedas = 0;

global.sacudida = 0;

// Menú de pausa
if (!instance_exists(obj_pausa)) instance_create_depth(0, 0, -10000, obj_pausa);

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

// Inventario
inventario_abierto = false;
inventario_alpha   = 0;
inventario_items = []; // Array que guarda las estructuras
max_slots_inv = 9;

// Función para añadir objetos
agregar_item = function(_spr, _nombre) {
    var _encontrado = false;
    
    for (var i = 0; i < array_length(inventario_items); i++) {
        if (inventario_items[i].spr == _spr) {
            inventario_items[i].cantidad += 1;
            _encontrado = true;
            break;
        }
    }
    
    if (!_encontrado) {
        if (array_length(inventario_items) < max_slots_inv) {
            array_push(inventario_items, {
                spr: _spr,
                nombre: _nombre,
                cantidad: 1
            });
        }
    }
}

// FUNCIÓN PARA USAR HONGOS
usar_hongo = function() {
    var _index_hongo = -1;
    
    // 1. Buscar el hongo
    for (var i = 0; i < array_length(inventario_items); i++) {
        if (inventario_items[i].spr == spr_hongo) {
            _index_hongo = i;
            break;
        }
    }

    // 2. Si no hay hongo (OJO: con guion bajo)
    if (_index_hongo == -1) {
        return "sin_hongos"; 
    }

    // 3. Si hay hongo y la vida no está llena
    if (vida < vida_max) {
        vida = min(vida + 20, vida_max);
        inventario_items[_index_hongo].cantidad -= 1;
        
        if (inventario_items[_index_hongo].cantidad <= 0) {
            array_delete(inventario_items, _index_hongo, 1);
        }
        return "usado"; 
    }
    
    // 4. Si hay hongo pero vida llena (OJO: con guion bajo)
    return "vida_llena"; 
}