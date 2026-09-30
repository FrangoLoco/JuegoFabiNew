// Sprite inicial
sprite_index = spr_naranja_ojo;
image_xscale = 2; 
image_yscale = 2;

// Variables de detección y ataque
distancia_deteccion = 1500; // Ajusta según la distancia deseada
cooldown_ataque = 90;      // Tiempo entre ataques (en frames)
puedo_atacar = true;
ha_disparado = false;

// Estado actual ("idle", "enojada", "ataque")
estado = "idle";