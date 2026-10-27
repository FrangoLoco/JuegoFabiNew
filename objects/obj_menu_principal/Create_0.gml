// Pantalla de inicio. Tiene dos pantallas: "principal" y "creditos". Las opciones son obj_panel_opciones
// Todo se dibuja en el Draw GUI sobre el lienzo de 3840x2160 del HUD, escalado a la GUI real
cargar_opciones();

pantalla = "principal";
aparicion = 0; // De 0 a 1: cada pantalla entra deslizándose y apareciendo
tiempo = 0;    // Para las animaciones (personajes, título, fondo)

// Pantalla principal
botones_principal = ["JUGAR", "OPCIONES", "CREDITOS", "SALIR"];
seleccion = 0;
escala_botones = array_create(array_length(botones_principal), 1);

panel_abierto = false; // Para saber cuándo se cierra el panel de opciones

// Créditos: cambien estos nombres por los del equipo (la fuente no tiene acentos)
creditos = [
    "Aninly-Mel",
    "FrangoLoco",
    "Gilberto Cervantes Rodriguez",
    "Nissy Nini",
];

// Fundido a negro: empieza en negro y aclara. Al elegir JUGAR se oscurece y cambia de sala
fundido = 1;
saliendo = false;

// Para que el mouse solo cambie la selección cuando se mueve
mouse_anterior_x = device_mouse_x_to_gui(0);
mouse_anterior_y = device_mouse_y_to_gui(0);

// Música del menú
audio_stop_all();
musica = audio_play_sound(snd_bosque, 7, true);

// Medidas en el lienzo de 3840x2160, relativas al centro de la pantalla
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

// Posiciones de cada cosa (en el lienzo, relativas al centro)
rect_boton_principal = function(i) { return rect_centro(0, -150 + i * 200, 450, 75); }
rect_volver          = function()  { return rect_centro(0, 400, 350, 75); }

cambiar_pantalla = function(nueva)
{
    pantalla = nueva;
    aparicion = 0;
}

elegir_principal = function()
{
    switch (seleccion)
    {
        case 0: // Jugar: se oscurece la pantalla y la música se apaga poco a poco
            saliendo = true;
            audio_sound_gain(musica, 0, 600);
            break;
        case 1: instance_create_depth(0, 0, -15000, obj_panel_opciones); break;
        case 2: cambiar_pantalla("creditos"); break;
        case 3: game_end(); break;
    }
}

