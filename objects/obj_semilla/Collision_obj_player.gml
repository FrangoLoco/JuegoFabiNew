// Aplicar daño si el jugador no es invulnerable
if (!other.invulnerable) {
    other.vidas -= 1;
    
    // Inmunidad temporal para evitar pérdidas múltiples de vida
    other.invulnerable = true;
    other.alarm[0] = 30; // Ajusta según la alarma de tu obj_player
}

// Destruir la semilla al chocar
instance_destroy();