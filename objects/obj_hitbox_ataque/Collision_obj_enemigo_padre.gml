// Cada enemigo solo recibe daño una vez por golpe, aunque el hitbox siga encima de él
if (!array_contains(golpeados, other.id))
{
    array_push(golpeados, other.id);
    other.recibir_golpe(danio, image_xscale); // image_xscale = hacia dónde mira el jugador
}
