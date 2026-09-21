// Validar si el jugador es susceptible a recibir daño
if (!other.invulnerable)
{
    other.vidas = other.vidas - 1; // Resta una vida al jugador (other hace referencia a obj_player)
    
    // Validar si el jugador ha muerto
    if (other.vidas <= 0)
    {
        // Reiniciar la sala, destruir al jugador o mostrar pantalla de Game Over
        room_restart(); 
    }
    else
    {
        // Activar la invulnerabilidad temporal
        other.invulnerable = true;
        
        // Configurar la Alarma 0 del jugador a 60 fotogramas (1 segundo a 60FPS)
        other.alarm[0] = 60;
    }
}