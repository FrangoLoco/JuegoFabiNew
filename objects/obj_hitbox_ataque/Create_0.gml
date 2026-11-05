// El hitbox es efímero: obj_player le asigna cuánto dura (alarm[0]) según el ataque
alarm[0] = 10;

danio = 0;        // obj_player asigna estos valores al crear el hitbox
empuje = 1;       // Multiplica el retroceso del enemigo
direccion = 1;    // Hacia dónde mira el jugador (1 o -1)
tipo = "alto";    // "alto" o "bajo". Algunos enemigos reciben más daño de un tipo (ver multiplicador_golpe)
dueno = noone;    // Jugador al que sigue
desfase_x = 0;    // Distancia desde los pies del jugador
desfase_y = 0;
golpeados = [];   // Enemigos que ya recibieron daño de este golpe, para no dañarlos en cada fotograma

// Se pega al jugador (el sprite tiene el origen a la mitad del lado izquierdo, así crece hacia donde mira)
seguir_dueno = function()
{
    if (!instance_exists(dueno)) return;
    x = dueno.x + desfase_x * direccion;
    y = dueno.y + desfase_y;
}
