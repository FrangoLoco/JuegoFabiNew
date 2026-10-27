// Aplicar daño si el jugador no es invulnerable
// Inmunidad temporal de 30 fotogramas para evitar pérdidas múltiples de vida
other.recibir_danio(25, 30); // 25 de daño

// Destruir la semilla al chocar
instance_destroy();