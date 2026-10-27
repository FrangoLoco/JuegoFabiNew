aparicion = lerp(aparicion, 1, 0.15);

if (esperar)
{
    esperar = false;
    exit;
}

var arriba = keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));
var abajo = keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"));
var izquierda = keyboard_check_pressed(vk_left) || keyboard_check_pressed(ord("A"));
var derecha = keyboard_check_pressed(vk_right) || keyboard_check_pressed(ord("D"));
var aceptar = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space) || keyboard_check_pressed(ord("Z"));
var regresar = keyboard_check_pressed(vk_escape) || keyboard_check_pressed(vk_backspace) || keyboard_check_pressed(ord("P"));

var mouse_x_gui = device_mouse_x_to_gui(0);
var mouse_y_gui = device_mouse_y_to_gui(0);
var mouse_se_movio = (mouse_x_gui != mouse_anterior_x || mouse_y_gui != mouse_anterior_y);
mouse_anterior_x = mouse_x_gui;
mouse_anterior_y = mouse_y_gui;
var clic = mouse_check_button_pressed(mb_left);

if (arriba) seleccion = (seleccion + 3) mod 4;
if (abajo) seleccion = (seleccion + 1) mod 4;

// Mouse: pasar por encima elige la fila; en las barras se puede hacer clic o arrastrar
for (var i = 0; i < 3; i++)
{
    var fila = rect_fila(i);
    if (!arrastrando && mouse_se_movio && point_in_rectangle(mouse_x_gui, mouse_y_gui, fila[0], fila[1], fila[2], fila[3])) seleccion = i;
}
var volver = rect_volver();
var sobre_volver = point_in_rectangle(mouse_x_gui, mouse_y_gui, volver[0], volver[1], volver[2], volver[3]);
if (!arrastrando && sobre_volver && mouse_se_movio) seleccion = 3;

if (seleccion <= 1)
{
    var valor = (seleccion == 0) ? global.volumen_musica : global.volumen_efectos;
    if (izquierda) ajustar_volumen(seleccion, valor - 0.1);
    if (derecha) ajustar_volumen(seleccion, valor + 0.1);

    // Solo se arrastra si el clic empezó sobre la barra (no con el clic que abrió el panel)
    var barra = rect_barra(seleccion);
    if (clic && point_in_rectangle(mouse_x_gui, mouse_y_gui, barra[0], barra[1], barra[2], barra[3])) arrastrando = true;
    if (!mouse_check_button(mb_left)) arrastrando = false;
    if (arrastrando)
    {
        ajustar_volumen(seleccion, (mouse_x_gui - barra[0]) / (barra[2] - barra[0]));
    }
}
else if (seleccion == 2)
{
    var fila = rect_fila(2);
    var clic_fila = clic && point_in_rectangle(mouse_x_gui, mouse_y_gui, fila[0], fila[1], fila[2], fila[3]);
    if (aceptar || izquierda || derecha || clic_fila) alternar_pantalla_completa();
}
else if (aceptar || (clic && sobre_volver))
{
    regresar = true;
}

if (regresar) cerrar();
