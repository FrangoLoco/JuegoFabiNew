// Inventario del jugador: espacios, teclas 1 a 9, mouse y dibujo. obj_player lo crea al iniciar cada sala
// Los objetos del nivel lo llaman con: with (obj_inventario) agregar_item(sprite, "Nombre");
inventario_abierto = false;
inventario_alpha   = 0;

// Mensaje de error que se muestra en la etiqueta de abajo
mensaje_inv = "";
tiempo_mensaje = 0;

max_slots_inv = 9; // Grid de 3x3, cada espacio se usa con su tecla del 1 al 9
inventario_items = array_create(max_slots_inv, undefined); // Cada espacio guarda una estructura o undefined si está vacío
escala_slots = array_create(max_slots_inv, 1); // Rebote del espacio al usar su objeto
slot_seleccionado = 0; // Espacio que se muestra en la etiqueta de abajo (mouse o última tecla)
mouse_anterior_x = device_mouse_x_to_gui(0);
mouse_anterior_y = device_mouse_y_to_gui(0);

// Acomodo del grid dentro de la capa, en píxeles del sprite spr_inventario
inv_grid_x = 560;      // Centro del primer espacio
inv_grid_y = 650;
inv_espacio_x = 280;   // Distancia entre centros de espacios
inv_espacio_y = 310;
inv_medio_slot = 105;  // Medio tamaño de cada parche

// Cada espacio es un parche cosido distinto: color, inclinación, esquinas chuecas y un pequeño desfase
// Se calculan con una fórmula fija (no con random) para que siempre se vean igual
var colores_parche = [
    make_color_rgb(150, 100, 110), // Rojizo, como el parche de arriba a la izquierda
    make_color_rgb(95, 115, 145),  // Azul, como el de la derecha
    make_color_rgb(120, 98, 140),  // Morado, como el del centro
    make_color_rgb(165, 140, 95),  // Café claro
];
var azar = function(_n) { return frac(abs(sin(_n * 12.9898) * 43758.5453)) * 2 - 1; }; // De -1 a 1
parches_inv = array_create(max_slots_inv);
for (var i = 0; i < max_slots_inv; i++)
{
    var esquinas = array_create(8);
    for (var k = 0; k < 8; k++) esquinas[k] = azar(i * 8 + k + 1);

    var col = i mod 3;
    var fila = floor(i / 3);
    parches_inv[i] = {
        angulo: azar(i + 100) * 7,
        color: colores_parche[(col + fila * 2) mod array_length(colores_parche)],
        esquinas: esquinas,
        desfase_x: azar(i + 200) * 16,
        desfase_y: azar(i + 300) * 16,
    };
}

// Posición del inventario en la GUI. La usan el Step (para el mouse) y el Draw GUI
obtener_capa_inventario = function()
{
    var esc = display_get_gui_width() / 3840;
    var inv_w = sprite_get_width(spr_inventario) * esc;
    var inv_h = sprite_get_height(spr_inventario) * esc;
    var hud_bottom = 120 * esc + sprite_get_height(spr_hud_salud) * esc;

    var inv_x = 80 * esc + inv_w / 2 + 100 * esc;
    var inv_y = hud_bottom + 20 * esc + inv_h / 2 - 900 * esc;
    inv_y += (1 - inventario_alpha) * 150 * esc; // Sube deslizándose al abrirse

    return {
        x: inv_x,
        y: inv_y,
        esc: esc,
        izq: inv_x - sprite_get_xoffset(spr_inventario) * esc,    // Esquina superior izquierda del sprite
        arriba: inv_y - sprite_get_yoffset(spr_inventario) * esc,
    };
}

// Centro de un espacio del inventario en la GUI
posicion_slot = function(_capa, _i)
{
    var parche = parches_inv[_i];
    return {
        x: _capa.izq + (inv_grid_x + (_i mod 3) * inv_espacio_x + parche.desfase_x) * _capa.esc,
        y: _capa.arriba + (inv_grid_y + floor(_i / 3) * inv_espacio_y + parche.desfase_y) * _capa.esc,
    };
}

// Texto corto que se muestra en la etiqueta al seleccionar un objeto
descripcion_item = function(_spr)
{
    switch (_spr)
    {
        case spr_hongo: return "Cura 20 de vida";
    }
    return "No se puede usar";
}

// Función para añadir objetos: se apila con uno igual o va al primer espacio vacío
agregar_item = function(_spr, _nombre) {
    var _vacio = -1;

    for (var i = 0; i < max_slots_inv; i++) {
        var _item = inventario_items[i];
        if (_item == undefined) {
            if (_vacio == -1) _vacio = i;
        }
        else if (_item.spr == _spr) {
            _item.cantidad += 1;
            return;
        }
    }

    if (_vacio != -1) {
        inventario_items[_vacio] = {
            spr: _spr,
            nombre: _nombre,
            cantidad: 1
        };
    }
}

// Usa el objeto del espacio indicado (0 a 8). Devuelve qué pasó para mostrar el mensaje
usar_item = function(_indice) {
    var _item = inventario_items[_indice];
    if (_item == undefined) return "vacio";

    switch (_item.spr)
    {
        case spr_hongo:
            if (!instance_exists(obj_player) || !obj_player.curar(20)) return "vida_llena";
            break;

        default:
            return "no_usable";
    }

    // Se consumió: resta uno y libera el espacio si se acabó
    _item.cantidad -= 1;
    if (_item.cantidad <= 0) inventario_items[_indice] = undefined;
    escala_slots[_indice] = 1.35;
    return "usado";
}

// Intenta usar un espacio (tecla o clic) y muestra el mensaje si no se pudo
intentar_usar_slot = function(_indice)
{
    slot_seleccionado = _indice;
    var resultado = usar_item(_indice);

    switch (resultado)
    {
        case "usado":
				//nota: busquen sonidos plebada
            // audio_play_sound(snd_curacion, 1, false);
            tiempo_mensaje = 0;
            break;
        case "vacio":
            mensaje_inv = "No hay nada en el espacio " + string(_indice + 1) + ".";
            tiempo_mensaje = 120;
            break;
        case "no_usable":
            mensaje_inv = "Ese objeto no se puede usar.";
            tiempo_mensaje = 120;
            break;
        case "vida_llena":
            mensaje_inv = "Tu vida ya esta al maximo.";
            tiempo_mensaje = 120;
            break;
    }
}