// El hitbox será efímero. Solo existirá durante 40 fotogramas para registrar el impacto.
alarm[0] = 40;

danio = 0;      // obj_player lo asigna al crear el hitbox
golpeados = []; // Enemigos que ya recibieron daño de este golpe, para no dañarlos en cada fotograma
