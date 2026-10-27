// Opciones del juego (volumen y pantalla completa). Se guardan en un archivo para recordarlas al volver a abrir el juego
#macro ARCHIVO_OPCIONES "opciones.ini"

function cargar_opciones()
{
    ini_open(ARCHIVO_OPCIONES);
    global.volumen_musica = ini_read_real("audio", "musica", 0.8);
    global.volumen_efectos = ini_read_real("audio", "efectos", 1);
    global.pantalla_completa = ini_read_real("video", "pantalla_completa", 0) == 1;
    ini_close();

    aplicar_opciones();

    // La primera vez que se abre el juego en ventana, se ajusta al monitor (la sala inicial es de 3840x2160)
    if (!variable_global_exists("ventana_ajustada"))
    {
        global.ventana_ajustada = true;
        if (!global.pantalla_completa) ajustar_ventana();
    }
}

function guardar_opciones()
{
    ini_open(ARCHIVO_OPCIONES);
    ini_write_real("audio", "musica", global.volumen_musica);
    ini_write_real("audio", "efectos", global.volumen_efectos);
    ini_write_real("video", "pantalla_completa", global.pantalla_completa ? 1 : 0);
    ini_close();
}

function aplicar_opciones()
{
    // Sonidos de las carpetas Sonidos/Musica y Sonidos/Efectos. Si agregan sonidos nuevos, agréguenlos aquí
    var musica = [snd_fondo, snd_bosque, snd_combate];
    var efectos = [snd_cuchillo, snd_pasos, snd_salto, snd_correr];

    for (var i = 0; i < array_length(musica); i++) audio_sound_gain(musica[i], global.volumen_musica, 0);
    for (var i = 0; i < array_length(efectos); i++) audio_sound_gain(efectos[i], global.volumen_efectos, 0);

    // Solo se cambia la ventana si de verdad cambió el modo, para no reacomodarla cada vez que se mueve el volumen
    if (window_get_fullscreen() != global.pantalla_completa)
    {
        window_set_fullscreen(global.pantalla_completa);
        if (!global.pantalla_completa) ajustar_ventana();
    }
}

// Deja la ventana en 16:9 (la proporción del juego) ocupando el 80 % del monitor y centrada
function ajustar_ventana()
{
    var ancho = min(display_get_width() * 0.8, display_get_height() * 0.8 * 16 / 9);
    window_set_size(round(ancho), round(ancho * 9 / 16));

    // El centrado tiene que esperar un fotograma a que la ventana cambie de tamaño
    call_later(1, time_source_units_frames, function() { window_center(); });
}
