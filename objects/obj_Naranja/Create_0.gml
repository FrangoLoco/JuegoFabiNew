// Sprite inicial
sprite_index = spr_naranja_ojo;
image_xscale = 2; 
image_yscale = 2;

// Variables de detección y ataque
distancia_deteccion = 2000; // Ajusta según la distancia deseada
cooldown_ataque = 130;      // Tiempo entre ataques (en frames)
puedo_atacar = true;
ha_disparado = false;

// Estado actual ("idle", "enojada", "ataque")
estado = "idle";