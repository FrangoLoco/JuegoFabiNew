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

// Dibuja un parche de tela cosido, como los de la capa del inventario
// _medio_x, _medio_y: medio ancho y medio alto. _angulo: inclinación en grados
// _esquinas: 8 números (x, y por esquina) de -1 a 1 que deforman las esquinas para que no sea un rectángulo perfecto
// _grosor: grosor del contorno y de las puntadas
function dibujar_parche(_x, _y, _medio_x, _medio_y, _angulo, _esquinas, _color, _grosor, _alfa)
{
    // Esquinas en orden: arriba izquierda, arriba derecha, abajo derecha, abajo izquierda
    var base = [-1, -1, 1, -1, 1, 1, -1, 1];
    var deformar = min(_medio_x, _medio_y) * 0.12;
    var esq_x = array_create(4);
    var esq_y = array_create(4);
    for (var i = 0; i < 4; i++)
    {
        var lx = base[i * 2] * _medio_x + _esquinas[i * 2] * deformar;
        var ly = base[i * 2 + 1] * _medio_y + _esquinas[i * 2 + 1] * deformar;
        esq_x[i] = _x + lx * dcos(_angulo) + ly * dsin(_angulo);
        esq_y[i] = _y - lx * dsin(_angulo) + ly * dcos(_angulo);
    }

    // Sombra para que el parche se vea encima de la capa
    var sombra = _grosor * 3;
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_x + sombra, _y + sombra, c_black, _alfa * 0.35);
    for (var i = 0; i <= 4; i++) draw_vertex_color(esq_x[i mod 4] + sombra, esq_y[i mod 4] + sombra, c_black, _alfa * 0.35);
    draw_primitive_end();

    // Tela: más clara en el centro
    var color_centro = merge_color(_color, c_white, 0.18);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex_color(_x, _y, color_centro, _alfa);
    for (var i = 0; i <= 4; i++) draw_vertex_color(esq_x[i mod 4], esq_y[i mod 4], _color, _alfa);
    draw_primitive_end();

    // Contorno
    draw_set_alpha(_alfa);
    draw_set_color(c_black);
    for (var i = 0; i < 4; i++)
    {
        var j = (i + 1) mod 4;
        draw_line_width(esq_x[i], esq_y[i], esq_x[j], esq_y[j], _grosor * 1.5);
        draw_circle(esq_x[i], esq_y[i], _grosor * 0.75, false);
    }

    // Puntadas: línea punteada un poco hacia adentro del borde
    draw_set_color(merge_color(_color, c_black, 0.65));
    for (var i = 0; i < 4; i++)
    {
        var j = (i + 1) mod 4;
        var x1 = lerp(_x, esq_x[i], 0.8);
        var y1 = lerp(_y, esq_y[i], 0.8);
        var x2 = lerp(_x, esq_x[j], 0.8);
        var y2 = lerp(_y, esq_y[j], 0.8);
        var puntadas = max(1, floor(point_distance(x1, y1, x2, y2) / (_grosor * 7)));
        for (var k = 0; k < puntadas; k++)
        {
            var t1 = (k + 0.2) / puntadas;
            var t2 = (k + 0.7) / puntadas;
            draw_line_width(lerp(x1, x2, t1), lerp(y1, y2, t1), lerp(x1, x2, t2), lerp(y1, y2, t2), _grosor);
        }
    }
    draw_set_alpha(1);
}

// Dibuja un botón de ropa con un texto en medio (se usa para la tecla de cada espacio del inventario)
function dibujar_boton_cosido(_x, _y, _radio, _texto, _escala_texto, _alfa)
{
    draw_set_alpha(_alfa);
    draw_set_color(c_black);
    draw_circle(_x + _radio * 0.12, _y + _radio * 0.15, _radio, false); // Sombra
    draw_circle(_x, _y, _radio, false);
    draw_set_color(make_color_rgb(225, 205, 160));
    draw_circle(_x, _y, _radio * 0.86, false);
    draw_set_color(make_color_rgb(175, 145, 100));
    draw_circle(_x, _y, _radio * 0.62, true);
    draw_set_color(c_white);
    draw_circle(_x - _radio * 0.4, _y - _radio * 0.4, _radio * 0.13, false); // Brillo

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(make_color_rgb(70, 45, 30));
    draw_text_transformed(_x, _y, _texto, _escala_texto, _escala_texto, 0);
    draw_set_alpha(1);
}

// Dibuja un sprite con su parte visible centrada en (_x, _y) y ajustada a _tam_max píxeles,
// sin importar dónde tenga el origen ni cuánto espacio vacío tenga alrededor (se usa en el inventario)
function dibujar_sprite_centrado(_spr, _subimg, _x, _y, _tam_max, _angulo, _alfa)
{
    var ancho = sprite_get_bbox_right(_spr) - sprite_get_bbox_left(_spr) + 1;
    var alto = sprite_get_bbox_bottom(_spr) - sprite_get_bbox_top(_spr) + 1;
    var escala = _tam_max / max(ancho, alto);

    // Centro de la parte visible, medido desde el origen del sprite y ya escalado
    var centro_x = ((sprite_get_bbox_left(_spr) + sprite_get_bbox_right(_spr) + 1) / 2 - sprite_get_xoffset(_spr)) * escala;
    var centro_y = ((sprite_get_bbox_top(_spr) + sprite_get_bbox_bottom(_spr) + 1) / 2 - sprite_get_yoffset(_spr)) * escala;

    // Se gira alrededor de ese centro
    var dibujo_x = _x - (centro_x * dcos(_angulo) + centro_y * dsin(_angulo));
    var dibujo_y = _y - (-centro_x * dsin(_angulo) + centro_y * dcos(_angulo));

    draw_sprite_ext(_spr, _subimg, dibujo_x, dibujo_y, escala, escala, _angulo, c_white, _alfa);
}
