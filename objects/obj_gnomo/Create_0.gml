event_inherited();
nivel = 2;
monedas = 2;
vida_max = 40; // 2 golpes
vida = vida_max;
fuerza_empuje = 20;
color_jugo = make_color_rgb(220, 60, 60);

// Sprites iniciales
sprite_index = spr_gnomo;
orientacion_sprite = -1; // El sprite del gnomo mira a la izquierda (cambia a 1 si se ve caminando de espaldas)

// Variables de movimiento y física
hsp = 0;              // Velocidad horizontal
vsp = 0;              // Velocidad vertical
grv = 0.5;            // Gravedad
fuerza_salto = -40;   // Fuerza del salto hacia arriba
velocidad_picada = 22;// Velocidad rápida de caída
velocidad_salto_max = 18; // Velocidad horizontal máxima al saltar hacia el jugador

// Patrulla: camina de un lado a otro alrededor de donde aparece
vel_patrulla = 4;
dir_patrulla = choose(-1, 1);
inicio_x = x;
rango_patrulla = 700;

// Variables de ataque
distancia_deteccion = 1400; // Distancia para iniciar el ataque
puedo_atacar = true;
cooldown_ataque = 120;     // Tiempo de espera tras desclavarse (en frames)
tiempo_clavado = 90;       // Cuántos frames se queda atascado en el suelo
tiempo_aviso = 30;         // Cuántos frames avisa (se agacha y tiembla) antes de saltar
tiempo_apice = 14;         // Cuántos frames se queda flotando arriba antes de caer en picada
temporizador = 0;
y_suelo = y;               // Altura del suelo donde se dibuja la sombra de caída

// Estados: "patrulla", "aviso", "salto", "apice", "picada", "clavado"
estado = "patrulla";
