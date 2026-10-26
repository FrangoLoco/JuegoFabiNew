// Valores por defecto de todos los enemigos. Cada hijo los sobrescribe en su Create después de event_inherited()
nivel = 0;      // Dificultad del enemigo: 1 = limón, 2 = gnomo, 3 = naranja
monedas = 0;    // Monedas que suelta al ser eliminado
vida_max = 1;   // El cuchillo del jugador hace 20 de daño por golpe
vida = vida_max;
fuerza_empuje = 25;    // Qué tan lejos sale volando al recibir un golpe (0 = no se mueve)
color_jugo = c_white;  // Color de las partículas que suelta al ser golpeado

// Efectos visuales (los usa el Draw del padre)
destello = 0;      // Fotogramas que el enemigo se ve blanco después de recibir un golpe
escala_x = 1;      // Estirar y aplastar: vuelven solos a 1 en el Step del padre
escala_y = 1;
temblor = 0;       // Píxeles que tiembla al dibujarse (para avisar que va a atacar)
mirar = 1;         // Hacia dónde mira el dibujo (1 o -1) sin voltear la máscara de colisión
empuje = 0;        // Velocidad del retroceso al recibir un golpe
tiempo_barra = 0;  // Fotogramas que se ve la barra de vida después de un golpe
vida_mostrada = 0; // La barra blanca baja poco a poco para que se note cuánto daño hiciste
furia = false;     // Se activa al bajar de la mitad de vida. Cada enemigo decide qué hace con ella

// Colores según el nivel: 1 = amarillo, 2 = naranja, 3 = rosa
colores_nivel = [c_white, make_color_rgb(255, 230, 60), make_color_rgb(255, 150, 30), make_color_rgb(255, 60, 200)];

// Recibe un golpe del jugador: resta vida, muestra el daño y si muere suelta sus monedas
// direccion: 1 o -1, hacia dónde sale empujado
recibir_golpe = function(cantidad, direccion)
{
    if (tiempo_barra <= 0) vida_mostrada = vida;
    vida -= cantidad;

    destello = 8;
    tiempo_barra = 180;
    escala_x = 1.3;
    escala_y = 0.75;
    empuje = direccion * fuerza_empuje;

    var centro_y = (bbox_top + bbox_bottom) / 2;
    crear_particulas(x, centro_y, 5, color_jugo, 20);
    sacudir_camara(8);

    // Hitmarker con el daño, sale hacia un lado al azar para no taparse con otros
    var marca = instance_create_depth(x + random_range(-60, 60), bbox_top + 80, -1000, obj_texto_flotante);
    marca.texto = string(cantidad);
    marca.color = make_color_rgb(255, 70, 70);
    marca.escala = 1.5;
    marca.vel_x = random_range(-2, 2);
    marca.duracion = 40;

    if (vida <= 0)
    {
        if (monedas > 0)
        {
            global.monedas += monedas;

            // Mientras más difícil el enemigo, más grande y llamativo el aviso de monedas
            var aviso = instance_create_depth(x, bbox_top, -1000, obj_texto_flotante);
            aviso.texto = "+" + string(monedas);
            aviso.color = colores_nivel[clamp(nivel, 0, array_length(colores_nivel) - 1)];
            aviso.escala = 1 + nivel * 0.5;
        }

        // Explosión de jugo más grande mientras más difícil el enemigo
        crear_particulas(x, centro_y, 14 + nivel * 6, color_jugo, 30 + nivel * 5);
        sacudir_camara(15 + nivel * 8);
        instance_destroy();
    }
    else if (!furia && vida <= vida_max / 2)
    {
        furia = true;
    }
}
