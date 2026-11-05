// Menú de pausa (Esc o P). obj_player lo crea al iniciar cada sala
pausado = false;
pedir_pausa = false; // La pausa empieza en el Draw GUI, cuando la escena ya está dibujada y se puede capturar
captura = -1;        // Sprite con la imagen del juego congelado que se ve detrás del menú

opciones = ["CONTINUAR", "OPCIONES", "REINICIAR NIVEL", "MENU PRINCIPAL"];
seleccion = 0;
escala_botones = array_create(array_length(opciones), 1); // El botón elegido crece un poco
aparicion = 0;       // De 0 a 1: el panel entra deslizándose y apareciendo
oscuro = 0;          // De 0 a 1: qué tanto se oscurece el juego de fondo
panel_abierto = false; // Para saber cuándo se cierra el panel de opciones

// Datos del jugador que se guardan al pausar (los objetos desactivados no se pueden leer)
frame_retrato = 0;
vida_jugador = 0;

// Para que el mouse solo cambie la selección cuando se mueve
mouse_anterior_x = 0;
mouse_anterior_y = 0;

// Las medidas del menú están en el lienzo de 3840x2160 del HUD y se escalan a la GUI real
escala_menu = function()
{
    return display_get_gui_width() / 3840;
}

// Rectángulo [x1, y1, x2, y2] del botón i en coordenadas de la GUI
rect_boton = function(i)
{
    var e = escala_menu();
    var cx = display_get_gui_width() / 2;
    var cy = display_get_gui_height() / 2;
    var centro_y = cy + (-300 + i * 180) * e;
    return [cx - 230 * e, centro_y - 70 * e, cx + 770 * e, centro_y + 70 * e];
}

pausar = function()
{
    captura = sprite_create_from_surface(application_surface, 0, 0, surface_get_width(application_surface), surface_get_height(application_surface), false, false, 0, 0);

    with (obj_player)
    {
        other.vida_jugador = vida;
        other.frame_retrato = obtener_frame_salud();
    }

    // Congela todo menos este menú
    instance_deactivate_all(true);
    reiniciar_toques(); // Los controles táctiles quedan congelados; que no se quede guardado el toque de pausa
    audio_pause_all();

    pausado = true;
    aparicion = 0;
    oscuro = 0;
    seleccion = 0;
    escala_botones = array_create(array_length(opciones), 1);
    mouse_anterior_x = device_mouse_x_to_gui(0);
    mouse_anterior_y = device_mouse_y_to_gui(0);
}

quitar_pausa = function()
{
    instance_activate_all();
    audio_resume_all();

    if (sprite_exists(captura)) sprite_delete(captura);
    captura = -1;
    pausado = false;

    // Evita que la tecla con la que se cerró el menú haga saltar o atacar al jugador
    io_clear();
    reiniciar_toques();
}

elegir_opcion = function()
{
    switch (seleccion)
    {
        case 0: // Continuar
            quitar_pausa();
            break;

        case 1: // Opciones: el panel se encarga de todo hasta que se cierra
            instance_create_depth(0, 0, -15000, obj_panel_opciones);
            break;

        case 2: // Reiniciar nivel
            quitar_pausa();
            audio_stop_all(); // obj_sonido_fondo vuelve a poner la música al reiniciar
            room_restart();
            break;

        case 3: // Regresar a la pantalla de inicio
            quitar_pausa();
            audio_stop_all();
            room_goto(rm_menu);
            break;
    }
}
