var tecla_pausa = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(ord("P"));

if (!pausado)
{
    if (tecla_pausa && instance_exists(obj_player)) pedir_pausa = true;
    exit;
}

aparicion = lerp(aparicion, 1, 0.2);
oscuro = lerp(oscuro, 1, 0.2);

// Mientras el panel de opciones está abierto, él maneja las teclas. Al cerrarse, los botones vuelven a entrar
var hay_panel = instance_exists(obj_panel_opciones);
if (panel_abierto && !hay_panel) aparicion = 0;
panel_abierto = hay_panel;
if (hay_panel) exit;

if (tecla_pausa)
{
    quitar_pausa();
    exit;
}

// 1. Teclado
var total = array_length(opciones);
if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) seleccion = (seleccion - 1 + total) mod total;
if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) seleccion = (seleccion + 1) mod total;
var aceptar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z"));

// 2. Mouse: elige el botón que tenga encima (solo si se movió, para no pelear con el teclado)
var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var mouse_se_movio = (mouse_x_gui != mouse_anterior_x || mouse_y_gui != mouse_anterior_y);
mouse_anterior_x = mouse_x_gui;
mouse_anterior_y = mouse_y_gui;

for (var i = 0; i < total; i++)
{
    var rect = rect_boton(i);
    if (point_in_rectangle(mouse_x_gui, mouse_y_gui, rect[0], rect[1], rect[2], rect[3]))
    {
        if (mouse_se_movio) seleccion = i;
        if (mouse_check_button_pressed(mb_left))
        {
            seleccion = i;
            aceptar = true;
        }
    }
}

// 3. Animación de los botones: el elegido crece un poco
for (var i = 0; i < total; i++)
{
    escala_botones[i] = lerp(escala_botones[i], (i == seleccion) ? 1.08 : 1, 0.25);
}

if (aceptar) elegir_opcion();
