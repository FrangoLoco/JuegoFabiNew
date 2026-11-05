// Cada enemigo solo recibe daño una vez por golpe, aunque el hitbox siga encima de él
if (!array_contains(golpeados, other.id))
{
    array_push(golpeados, other.id);
    var multiplicador = other.multiplicador_golpe(tipo);
    var cantidad = round(danio * multiplicador);

    // Aviso de golpe crítico cuando se usó el ataque correcto en el momento correcto
    if (multiplicador > 1)
    {
        var aviso = instance_create_depth(other.x, other.bbox_top - 40, -1000, obj_texto_flotante);
        aviso.texto = "CRITICO!";
        aviso.color = make_color_rgb(255, 230, 60);
        aviso.escala = 1.6;
        aviso.duracion = 45;
        sacudir_camara(12);
    }

    other.recibir_golpe(cantidad, direccion * empuje);
}
