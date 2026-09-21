// Evento Create de obj_player
hsp = 0;       // Velocidad horizontal actual
vsp = 0;       // Velocidad vertical actual
grv = 1;     // Fuerza de gravedad
walksp = 15;    // Velocidad máxima de caminata
jumpsp = -40;   // Fuerza del salto (negativa porque en GM el eje Y sube hacia abajo)
vidas = 3;
invulnerable = false; // Controla si el jugador puede recibir daño
direccion_visual = 1;
estado = "libre"; // Puede ser "libre" o "atacando"
mask_index = spr_player_idle;