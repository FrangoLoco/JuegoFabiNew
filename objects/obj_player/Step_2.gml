// Cámara centrada (horizontal) y con el jugador en la parte baja (vertical)
var _cam = view_camera[0];

if (_cam != -1)
{
    // Sacudida de cámara (golpes, impactos y muertes de enemigos). Se va apagando sola
    var _sacudida_x = 0;
    var _sacudida_y = 0;

    if (global.sacudida > 0)
    {
        global.sacudida = min(global.sacudida, 60); // techo para que no se acumule sin límite
        _sacudida_x = random_range(-global.sacudida, global.sacudida);
        _sacudida_y = random_range(-global.sacudida, global.sacudida);
        global.sacudida = max(global.sacudida * 0.85 - 0.5, 0);
    }

    camera_set_view_pos(
        _cam,
        x - camera_get_view_width(_cam)  / 2 + _sacudida_x,
        y - camera_get_view_height(_cam)     + _sacudida_y
    );
}