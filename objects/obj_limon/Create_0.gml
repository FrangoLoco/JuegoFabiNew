// Físicas autónomas del enemigo
hsp = 0;            // Inicia en reposo absoluto
vsp = 0;
grv = 1;          // Fuerza de gravedad constante
jumpsp = -60;       // Incrementado a -11 para asegurar que salte por encima de la altura del jugador

// Control de estados y tiempos
tiempo_espera = 60; // 60 fotogramas = 1 segundo de espera
temporizador = tiempo_espera;

// Fijar la máscara de colisión para evitar errores al cambiar el sprite
mask_index = spr_limon;