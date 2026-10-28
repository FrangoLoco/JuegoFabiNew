// Botones en pantalla para jugar en celular. obj_player lo crea solo si es_movil() es true
// Cada botón se coloca a cierta distancia de las orillas de la pantalla (en el lienzo de 3840x2160 del HUD),
// así quedan bien en celulares con pantallas más anchas o más altas que 16:9
//   dx: distancia a la orilla izquierda (o derecha si desde_derecha)
//   dy: distancia a la orilla de abajo (o de arriba si desde_arriba)
boton_izquierda = { icono: "izquierda", dx: 360,  dy: 380, radio: 190, desde_derecha: false, desde_arriba: false, presionado: false, recien: false };
boton_derecha   = { icono: "derecha",   dx: 820,  dy: 380, radio: 190, desde_derecha: false, desde_arriba: false, presionado: false, recien: false };
boton_ataque    = { icono: "ataque",    dx: 900,  dy: 300, radio: 175, desde_derecha: true,  desde_arriba: false, presionado: false, recien: false };
boton_salto     = { icono: "salto",     dx: 400,  dy: 420, radio: 215, desde_derecha: true,  desde_arriba: false, presionado: false, recien: false };
boton_pausa     = { icono: "pausa",     dx: 150,  dy: 440, radio: 95,  desde_derecha: true,  desde_arriba: true,  presionado: false, recien: false };
botones = [boton_izquierda, boton_derecha, boton_ataque, boton_salto, boton_pausa];

// El área que cuenta como "tocar el botón" es un poco más grande que el dibujo, para que sea fácil atinarle
margen_toque = 1.35;

// Transparencia de los botones (0 = invisibles, 1 = sólidos). Al tocarlos se ven más para que se note
alfa_normal = 0.35;
alfa_presionado = 0.7;

// Cada botón se dibuja completo en esta superficie y luego se pinta con transparencia
// (si se dibujaran sus capas con transparencia directo en pantalla, al encimarse se verían casi sólidas)
superficie = -1;
radio_maximo = 0;
for (var i = 0; i < array_length(botones); i++) radio_maximo = max(radio_maximo, botones[i].radio);

escala = function()
{
    return display_get_gui_width() / 3840;
}

// Centro del botón [x, y] en coordenadas de la GUI
posicion = function(boton)
{
    var e = escala();
    var px = boton.desde_derecha ? display_get_gui_width() - boton.dx * e : boton.dx * e;
    var py = boton.desde_arriba ? boton.dy * e : display_get_gui_height() - boton.dy * e;
    return [px, py];
}

esta_en_pausa = function()
{
    return instance_exists(obj_pausa) && obj_pausa.pausado;
}
