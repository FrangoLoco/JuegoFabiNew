// Detectar si se presionó cualquier tecla en este fotograma
if (keyboard_check_pressed(vk_anykey)) 
{
    // Obtener el código de la última tecla presionada
    var tecla_cruda = keyboard_lastkey;
    var nombre_tecla = obtener_nombre_tecla(tecla_cruda);
    
    // Insertar el nombre de la tecla en la primera posición (índice 0) del arreglo
    array_insert(historial, 0, nombre_tecla);
    
    // Eliminar la entrada más antigua si se supera el límite
    if (array_length(historial) > limite_historial) 
    {
        array_pop(historial);
    }
}