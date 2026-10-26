event_inherited();
nivel = 3;   // Enemigo más difícil
monedas = 3;
vida_max = 60; // 3 golpes
vida = vida_max;
fuerza_empuje = 0; // Es pesada, no se mueve al recibir golpes
color_jugo = make_color_rgb(255, 140, 30);

// Sprite inicial
sprite_index = spr_naranja_ojo;
image_speed = 0.2;
image_xscale = 2;
image_yscale = 2;

// Variables de detección y ataque
distancia_deteccion = 2000; // Ajusta según la distancia deseada
cooldown_ataque = 130;      // Tiempo entre ataques (en frames)
puedo_atacar = true;
ha_disparado = false;
velocidad_semilla = 16;
apertura_abanico = 15;      // Grados entre semillas cuando dispara 3 en furia

// Flota suavemente arriba y abajo
inicio_y = y;
tiempo_flotar = random(360);

// Estado actual ("idle", "enojada", "ataque")
estado = "idle";

// Dispara una semilla en el ángulo indicado
disparar_semilla = function(angulo)
{
    var bala = instance_create_layer(x, y, "Instances", obj_semilla);
    bala.direction = angulo;
    bala.image_angle = angulo;
    bala.speed = velocidad_semilla;
    bala.image_xscale = 2; // Escala/tamaño del proyectil
    bala.image_yscale = 2;
}
