// VARIABLES ESENCIALES
velocidad = 2;          // Velocidad horizontal de caminar
mov = "frontal";

// VARIABLES DE MOVIMIENTOS IGUALADAS A FALSE
derecha = false;
izquierda = false;
arriba = false;
abajo = false;

// VARIABLES DE FÍSICA Y SALTO
jump_speed = -12;
gravedad = 0.4;

// *** CAMBIO IMPORTANTE ***
// Usamos una variable personalizada, NO 'vspeed'
v_velocidad = 0;

invencible = false;
h_knockback = 10;
golpe_dado = false;