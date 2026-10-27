tiempo += 1;
aparicion = lerp(aparicion, 1, 0.15);

// Fundido: al entrar aclara, al elegir JUGAR oscurece y cambia a la primera sala del juego
if (saliendo)
{
    fundido = min(fundido + 0.03, 1);
    if (fundido >= 1)
    {
        audio_stop_sound(musica);
        io_clear(); // Que la tecla con la que se eligió JUGAR no haga saltar al jugador
        room_goto_next(); // Siguiente sala en el orden de salas (rm_menu debe ser la primera)
    }
    exit;
}
fundido = max(fundido - 0.03, 0);

// Mientras el panel de opciones está abierto, él maneja las teclas. Al cerrarse, los botones vuelven a entrar
var hay_panel = instance_exists(obj_panel_opciones);
if (panel_abierto && !hay_panel) aparicion = 0;
panel_abierto = hay_panel;
if (hay_panel) exit;

// Controles comunes
var arriba = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var abajo = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var aceptar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z"));
var regresar = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace);

var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var mouse_se_movio = (mouse_x_gui != mouse_anterior_x || mouse_y_gui != mouse_anterior_y);
mouse_anterior_x = mouse_x_gui;
mouse_anterior_y = mouse_y_gui;
var clic = mouse_check_button_pressed(mb_left);

switch (pantalla)
{
    case "principal":
        var total = array_length(botones_principal);
        if (arriba) seleccion = (seleccion - 1 + total) mod total;
        if (abajo) seleccion = (seleccion + 1) mod total;

        for (var i = 0; i < total; i++)
        {
            var rect = rect_boton_principal(i);
            if (point_in_rectangle(mouse_x_gui, mouse_y_gui, rect[0], rect[1], rect[2], rect[3]))
            {
                if (mouse_se_movio) seleccion = i;
                if (clic)
                {
                    seleccion = i;
                    aceptar = true;
                }
            }
        }

        // El botón elegido crece un poco
        for (var i = 0; i < total; i++)
        {
            escala_botones[i] = lerp(escala_botones[i], (i == seleccion) ? 1.08 : 1, 0.25);
        }

        if (aceptar) elegir_principal();
        break;

    case "creditos":
        var rect_v = rect_volver();
        if (aceptar || regresar || (clic && point_in_rectangle(mouse_x_gui, mouse_y_gui, rect_v[0], rect_v[1], rect_v[2], rect_v[3])))
        {
            cambiar_pantalla("principal");
        }
        break;
}
