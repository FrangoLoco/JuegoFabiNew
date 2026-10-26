// Sacude la cámara. La intensidad es en píxeles y se va apagando sola (ver End Step de obj_player)
function sacudir_camara(_intensidad)
{
    if (!variable_global_exists("sacudida")) global.sacudida = 0;
    global.sacudida = max(global.sacudida, _intensidad);
}

// Lanza partículas (jugo, polvo, tierra) que salen disparadas hacia arriba y caen con gravedad
function crear_particulas(_x, _y, _cantidad, _color, _fuerza)
{
    repeat (_cantidad)
    {
        var particula = instance_create_depth(_x, _y, -900, obj_particula);
        var angulo = random_range(20, 160);
        var velocidad = random_range(0.4, 1) * _fuerza;
        particula.hsp = lengthdir_x(velocidad, angulo);
        particula.vsp = lengthdir_y(velocidad, angulo);
        particula.color = _color;
    }
}
