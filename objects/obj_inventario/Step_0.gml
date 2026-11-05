// Temporizador del mensaje de alerta
if (tiempo_mensaje > 0) {
    tiempo_mensaje -= 1;
}

// Abrir/Cerrar Inventario
if (keyboard_check_pressed(ord("X")) || global.toque_inventario)
{
    inventario_abierto = !inventario_abierto;
    
    // Si cerramos el inventario, borramos el mensaje de error de golpe
    if (!inventario_abierto) {
        tiempo_mensaje = 0;
    }
}
inventario_alpha = lerp(inventario_alpha, inventario_abierto ? 1 : 0, 0.2);

// Usar objetos del inventario con las teclas 1 a 9 o con clic (solo con el inventario abierto)
// El espacio seleccionado crece un poco; el que se acaba de usar rebota
for (var i = 0; i < max_slots_inv; i++)
{
    var escala_objetivo = (inventario_abierto && i == slot_seleccionado) ? 1.1 : 1;
    escala_slots[i] = lerp(escala_slots[i], escala_objetivo, 0.2);
}

var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var mouse_se_movio = (mouse_x_gui != mouse_anterior_x || mouse_y_gui != mouse_anterior_y);
mouse_anterior_x = mouse_x_gui;
mouse_anterior_y = mouse_y_gui;

if (inventario_abierto)
{
    // Teclas
    for (var i = 0; i < max_slots_inv; i++)
    {
        if (keyboard_check_pressed(ord(string(i + 1))) || keyboard_check_pressed(vk_numpad1 + i))
        {
            intentar_usar_slot(i);
            break;
        }
    }

    // Mouse: pasar encima selecciona, clic usa
    var capa = obtener_capa_inventario();
    for (var i = 0; i < max_slots_inv; i++)
    {
        var pos = posicion_slot(capa, i);
        if (point_distance(mouse_x_gui, mouse_y_gui, pos.x, pos.y) > inv_medio_slot * capa.esc) continue;

        if (mouse_se_movio) slot_seleccionado = i;
        if (mouse_check_button_pressed(mb_left)) intentar_usar_slot(i);
        break;
    }
}
