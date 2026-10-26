// Evento Create de obj_player
hsp = 0;       // Velocidad horizontal actual
vsp = 0;       // Velocidad vertical actual
grv = 1;     // Fuerza de gravedad
walksp = 15;    // Velocidad máxima de caminata
jumpsp = -40;   // Fuerza del salto (negativa porque en GM el eje Y sube hacia abajo)
vida_max = 100; // La vida va de 0 a 100
vida = vida_max;
danio_ataque = 20; // Daño que hace cada golpe del cuchillo
invulnerable = false; // Controla si el jugador puede recibir daño
direccion_visual = 1;
estado = "libre"; // Puede ser "libre" o "atacando"
mask_index = spr_player_idle;

// Monedas: son globales para que se conserven al cambiar de sala o al reiniciarla
if (!variable_global_exists("monedas")) global.monedas = 0;
monedas_hud = global.monedas; // Valor que muestra el HUD, sube de uno en uno hasta alcanzar global.monedas
escala_monedas = 1;           // El contador crece un poco cada vez que suma una moneda
temporizador_monedas = 0;

global.sacudida = 0; // Intensidad de la sacudida de cámara (ver End Step y sacudir_camara)

// Resta vida al jugador y le da inmunidad temporal. Los enemigos llaman a esto en vez de tocar "vida" directamente
recibir_danio = function(cantidad, tiempo_inmunidad)
{
    if (invulnerable) return;

    vida = max(vida - cantidad, 0);

    if (vida <= 0)
    {
        // Reiniciar la sala (aquí puede ir la pantalla de Game Over más adelante)
        room_restart();
    }
    else
    {
        invulnerable = true;
        alarm[0] = tiempo_inmunidad;
        sacudir_camara(30);
    }
}
