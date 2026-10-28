// Colores del HUD (sacados de las imágenes de Assets) para que todo el juego se vea igual
#macro COLOR_MARCO_MORADO make_color_rgb(65, 38, 161)
#macro COLOR_MARCO_AZUL   make_color_rgb(84, 109, 193)
#macro COLOR_FONDO_BARRA  make_color_rgb(39, 43, 70)
#macro COLOR_VERDE_VIDA   make_color_rgb(39, 157, 55)
#macro COLOR_ROSA         make_color_rgb(246, 0, 127)

// Dibuja un texto con contorno negro para que se lea sobre cualquier fondo
// Usa la fuente y la alineación que estén activas en ese momento
function dibujar_texto_contorno(_x, _y, _texto, _escala, _color, _grosor)
{
    draw_set_color(c_black);
    for (var i = -1; i <= 1; i++)
    {
        for (var j = -1; j <= 1; j++)
        {
            draw_text_transformed(_x + i * _grosor, _y + j * _grosor, _texto, _escala, _escala, 0);
        }
    }

    draw_set_color(_color);
    draw_text_transformed(_x, _y, _texto, _escala, _escala, 0);
}

// Dibuja un marco como los del HUD: contorno negro, banda morada con brillo azul y relleno
function dibujar_marco(_x1, _y1, _x2, _y2, _grosor, _relleno)
{
    draw_set_color(c_black);
    draw_rectangle(_x1, _y1, _x2, _y2, false);

    var borde = _grosor * 0.25;
    draw_rectangle_color(_x1 + borde, _y1 + borde, _x2 - borde, _y2 - borde, COLOR_MARCO_AZUL, COLOR_MARCO_MORADO, COLOR_MARCO_AZUL, COLOR_MARCO_MORADO, false);

    var linea = _grosor * 0.8;
    draw_set_color(c_black);
    draw_rectangle(_x1 + linea, _y1 + linea, _x2 - linea, _y2 - linea, false);

    draw_set_color(_relleno);
    draw_rectangle(_x1 + _grosor, _y1 + _grosor, _x2 - _grosor, _y2 - _grosor, false);
}

// Dibuja el corazón del HUD (se toma del sprite spr_hud_salud). (_x, _y) es la esquina superior izquierda
function dibujar_corazon(_x, _y, _escala, _alfa)
{
    draw_sprite_part_ext(spr_hud_salud, 0, 357, 177, 116, 105, _x, _y, _escala, _escala, c_white, _alfa);
}

// Botón de menú: marco del HUD, verde si está elegido y con un corazón rebotando a su izquierda
// _crecer: escala extra del botón (el elegido crece un poco). _escala: escala de la GUI
function dibujar_boton(_x, _y, _medio_ancho, _medio_alto, _texto, _elegido, _crecer, _escala, _alfa)
{
    var medio_ancho = _medio_ancho * _crecer;
    var medio_alto = _medio_alto * _crecer;

    dibujar_marco(_x - medio_ancho, _y - medio_alto, _x + medio_ancho, _y + medio_alto, 24 * _escala, _elegido ? COLOR_VERDE_VIDA : make_color_rgb(25, 28, 48));

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    dibujar_texto_contorno(_x, _y, _texto, 0.9 * _escala * _crecer, c_white, 4 * _escala);

    if (_elegido)
    {
        var corazon_x = _x - medio_ancho - 140 * _escala + sin(current_time / 150) * 15 * _escala;
        dibujar_corazon(corazon_x, _y - 52 * _escala, _escala, _alfa);
    }
}

// Botón redondo para los controles táctiles: contorno negro, aro morado/azul y centro oscuro (verde si está presionado)
function dibujar_boton_circular(_x, _y, _radio, _presionado, _alfa)
{
    draw_set_alpha(_alfa);
    draw_set_color(c_black);
    draw_circle(_x, _y, _radio, false);
    draw_circle_color(_x, _y, _radio * 0.9, COLOR_MARCO_AZUL, COLOR_MARCO_MORADO, false);
    draw_set_color(c_black);
    draw_circle(_x, _y, _radio * 0.74, false);
    draw_set_color(_presionado ? COLOR_VERDE_VIDA : COLOR_FONDO_BARRA);
    draw_circle(_x, _y, _radio * 0.68, false);
    draw_set_alpha(1);
}

// Triángulo blanco con contorno negro (para las flechas de los controles)
function dibujar_triangulo_contorno(_x1, _y1, _x2, _y2, _x3, _y3, _grosor, _alfa)
{
    draw_set_alpha(_alfa);
    var cx = (_x1 + _x2 + _x3) / 3;
    var cy = (_y1 + _y2 + _y3) / 3;

    // El contorno es el mismo triángulo un poco más grande (_grosor = 0.3 es 30 % más grande), dibujado detrás
    var g = 1 + _grosor;
    draw_set_color(c_black);
    draw_triangle(cx + (_x1 - cx) * g, cy + (_y1 - cy) * g, cx + (_x2 - cx) * g, cy + (_y2 - cy) * g, cx + (_x3 - cx) * g, cy + (_y3 - cy) * g, false);
    draw_set_color(c_white);
    draw_triangle(_x1, _y1, _x2, _y2, _x3, _y3, false);
    draw_set_alpha(1);
}

// Dibuja una moneda dorada con contorno negro
function dibujar_moneda(_x, _y, _radio)
{
    draw_set_color(c_black);
    draw_circle(_x, _y, _radio, false);
    draw_set_color(make_color_rgb(255, 200, 40));
    draw_circle(_x, _y, _radio * 0.85, false);
    draw_set_color(make_color_rgb(200, 130, 20));
    draw_circle(_x, _y, _radio * 0.55, true);
    draw_set_color(c_white);
    draw_circle(_x - _radio * 0.35, _y - _radio * 0.35, _radio * 0.12, false);
}
