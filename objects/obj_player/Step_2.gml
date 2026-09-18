// Camara centrada
var _cam = view_camera[0];

camera_set_view_pos(
    _cam,
    x - camera_get_view_width(_cam)  / 2,
    y - camera_get_view_height(_cam)
);