// Arreglo para almacenar el historial
historial = [];
limite_historial = 10; // Cantidad de teclas anteriores a recordar

// Función para traducir el código de tecla a texto
obtener_nombre_tecla = function(key) 
{
    switch(key) 
    {
        case vk_space: return "Espacio";
        case vk_left: return "Flecha Izquierda";
        case vk_right: return "Flecha Derecha";
        case vk_up: return "Flecha Arriba";
        case vk_down: return "Flecha Abajo";
        case vk_enter: return "Enter";
        case vk_escape: return "Escape";
        case vk_shift: return "Shift";
        case vk_control: return "Control";
        default: return chr(key); // Convierte la letra (ej. 'Z', 'W') a texto
    }
}