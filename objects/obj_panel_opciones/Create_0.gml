// Panel de opciones (música, sonidos y pantalla completa). Lo abren el menú principal y el menú de pausa
// Mientras existe, quien lo abrió no lee teclas ni dibuja sus botones. Se crea con depth -15000 para quedar encima de la pausa (-10000). GameMaker no dibuja nada fuera de -16000 a 16000
if (!variable_global_exists("volumen_musica")) cargar_opciones(); // Por si el juego se probó sin pasar por el menú

seleccion = 0;   // 0 = música, 1 = sonidos, 2 = pantalla completa, 3 = volver
aparicion = 0;   // De 0 a 1: el panel entra deslizándose y apareciendo
esperar = true;  // Ignora el primer fotograma para que la tecla que lo abrió no cambie nada
arrastrando = false; // Si se está arrastrando una barra de volumen con el mouse

// Para que el mouse solo cambie la selección cuando se mueve
mouse_anterior_x = device_mouse_x_to_gui(0);
mouse_anterior_y = device_mouse_y_to_gui(0);

// Medidas en el lienzo de 3840x2160 del HUD, relativas al centro de la pantalla
escala_menu = function()
{
    return display_get_gui_width() / 3840;
}

// Rectángulo [x1, y1, x2, y2] en la GUI de un elemento centrado en (dx, dy) respecto al centro, con medio ancho y medio alto
rect_centro = function(dx, dy, medio_ancho, medio_alto)
{
    var e = escala_menu();
    var cx = display_get_gui_width() / 2 + dx * e;
    var cy = display_get_gui_height() / 2 + dy * e;
    return [cx - medio_ancho * e, cy - medio_alto * e, cx + medio_ancho * e, cy + medio_alto * e];
}

rect_fila   = function(i) { return rect_centro(0, -300 + i * 190, 900, 80); }
rect_barra  = function(i) { return rect_centro(430, -300 + i * 190, 430, 45); }
rect_volver = function()  { return rect_centro(0, 400, 350, 75); }

// Cambia el volumen de música (0) o sonidos (1) sin salirse de 0 a 1
ajustar_volumen = function(fila, valor)
{
    valor = clamp(round(valor * 20) / 20, 0, 1); // De 5 en 5 %
    if (fila == 0) global.volumen_musica = valor;
    else
    {
        // Suena un efecto para escuchar el volumen nuevo
        if (valor != global.volumen_efectos) audio_play_sound(snd_salto, 1, false);
        global.volumen_efectos = valor;
    }
    aplicar_opciones();
}

alternar_pantalla_completa = function()
{
    global.pantalla_completa = !global.pantalla_completa;
    aplicar_opciones();
}

cerrar = function()
{
    guardar_opciones();
    io_clear(); // Que el Esc o Enter con el que se cerró no lo lea también el menú de atrás
    instance_destroy();
}
