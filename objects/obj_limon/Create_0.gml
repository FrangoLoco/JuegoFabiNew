event_inherited();
nivel = 1;   // Enemigo más fácil
monedas = 1;
vida_max = 20; // 1 golpe
vida = vida_max;
fuerza_empuje = 35; // Es ligero, sale volando lejos
color_jugo = make_color_rgb(240, 230, 60);

// Físicas autónomas del enemigo
hsp = 0;            // Inicia en reposo absoluto
vsp = 0;
grv = 1;          // Fuerza de gravedad constante
jumpsp = -60;       // Incrementado a -11 para asegurar que salte por encima de la altura del jugador

// Control de estados y tiempos
tiempo_espera = 60; // 60 fotogramas = 1 segundo de espera
temporizador = tiempo_espera;
tiempo_anticipacion = 18; // Fotogramas que se agacha y tiembla antes de saltar (le avisa al jugador)

// Persecución: si ve al jugador salta hacia él en vez de saltar al azar
distancia_deteccion = 2000;
velocidad_persecucion = 14; // Velocidad horizontal máxima al saltar hacia el jugador

en_suelo = false; // Para detectar el momento exacto en que aterriza

// Fijar la máscara de colisión para evitar errores al cambiar el sprite
mask_index = spr_limon;
