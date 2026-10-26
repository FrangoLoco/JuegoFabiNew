// Si el gnomo está saltando o cayendo en picada, le resta vida al jugador
if (estado == "picada" || estado == "salto" || estado == "apice") {
    other.recibir_danio(25, 30); // 25 de daño, 30 = tiempo de inmunidad del jugador
}
