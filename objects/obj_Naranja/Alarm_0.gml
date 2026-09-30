puedo_atacar = true;
ha_disparado = false; // Restablece el permiso de disparo para el siguiente ataque

// Si el jugador sigue en rango, reactiva la animación para atacar otra vez
if (estado == "enojada") {
    image_speed = 0.15;
}