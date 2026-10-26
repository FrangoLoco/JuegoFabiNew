// Sprites iniciales
sprite_index = spr_gnomo;

// Variables de movimiento y física
hsp = 0;              // Velocidad horizontal
vsp = 0;              // Velocidad vertical
grv = 0.5;            // Gravedad
fuerza_salto = -50;   // Fuerza del salto hacia arriba
velocidad_picada = 20;// Velocidad rápida de caída

// Variables de ataque
distancia_deteccion = 1200; // Distancia para iniciar el ataque
puedo_atacar = true;
cooldown_ataque = 120;     // Tiempo de espera tras desclavarse (en frames)
tiempo_clavado = 90;       // Cuántos frames se queda atascado en el suelo

// Estados: "patrulla", "salto", "picada", "clavado"
estado = "patrulla";