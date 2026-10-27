// Efectos comunes de los enemigos
event_inherited();

// Se rompe al chocar con el suelo o una pared
if (place_meeting(x, y, obj_colision))
{
    crear_particulas(x, y, 4, make_color_rgb(120, 80, 40), 10);
    instance_destroy();
}

// Se destruye al salir de la sala para no quedarse en memoria
if (x < -200 || x > room_width + 200 || y < -200 || y > room_height + 200)
{
    instance_destroy();
}
