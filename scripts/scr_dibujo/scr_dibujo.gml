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
