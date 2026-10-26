// Si el gnomo está cayendo en picada o saltando, le resta vida al jugador
if (estado == "picada" || estado == "salto") {
    if (!other.invulnerable) {
        other.vidas -= 1;
        other.invulnerable = true;
        other.alarm[0] = 30; // Tiempo de inmunidad del jugador
    }
}