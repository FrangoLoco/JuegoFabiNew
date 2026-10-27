// Transición: Se desclava y regresa a patrulla/reposo
estado = "patrulla";
sprite_index = spr_gnomo;
temblor = 0;
escala_x = 0.8;  // Pequeño salto al desclavarse
escala_y = 1.25;
alarm[1] = furia ? 60 : cooldown_ataque; // Inicia tiempo de espera para volver a atacar
