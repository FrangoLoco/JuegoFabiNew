draw_set_font(fnt_debug);
draw_set_color(c_black);
draw_set_halign(fa_left);

var pos_x = 20;
var pos_y = 100; // Dibuja debajo del texto de las vidas para no superponerse

// 1. Dibujar teclas mantenidas presionadas actualmente
var teclas_actuales = "Mantenido: ";
if (keyboard_check(ord("W"))) teclas_actuales += "[W] ";
if (keyboard_check(ord("A"))) teclas_actuales += "[A] ";
if (keyboard_check(ord("D"))) teclas_actuales += "[D] ";
if (keyboard_check(ord("Z"))) teclas_actuales += "[Z] ";
if (keyboard_check(vk_space)) teclas_actuales += "[Espacio] ";
if (keyboard_check(vk_left))  teclas_actuales += "[Izq] ";
if (keyboard_check(vk_right)) teclas_actuales += "[Der] ";

draw_text(pos_x, pos_y, teclas_actuales);

// 2. Dibujar la lista del historial
pos_y += 80;
draw_text(pos_x, pos_y, "Historial de pulsaciones:");

for (var i = 0; i < array_length(historial); i++) 
{
    // Crea un efecto de desvanecimiento para las teclas más antiguas
    var opacidad = 1 - (i / limite_historial);
    draw_set_alpha(opacidad);
    
    // Dibuja cada tecla en forma de lista descendente
    draw_text(pos_x, pos_y + 80 + (i * 100), "- " + historial[i]);
}

// Restaurar la opacidad global a 1 para no afectar otros elementos de la GUI
draw_set_alpha(1);
// Dibuja el estado actual del jugador en la pantalla
if (instance_exists(obj_player))
{
    draw_text(20, 100, "ESTADO DEL JUGADOR: " + obj_player.estado);
}
draw_text(20, 160, "HITBOXES EN MEMORIA: " + string(instance_number(obj_hitbox_ataque)));