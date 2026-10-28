// Controles táctiles para celular. obj_controles_tactiles llena estas variables cada fotograma
// y obj_player / obj_pausa las leen junto con el teclado

// Ponlo en true para ver y probar los controles táctiles en PC con el mouse
#macro PROBAR_CONTROLES_TACTILES true

// true en Android e iOS (o en PC si PROBAR_CONTROLES_TACTILES está activado)
function es_movil()
{
    return os_type == os_android || os_type == os_ios || PROBAR_CONTROLES_TACTILES;
}

// Pone todos los toques en "sin presionar"
function reiniciar_toques()
{
    global.toque_izquierda = false; // Se mantiene mientras el dedo está encima
    global.toque_derecha = false;
    global.toque_salto = false;     // Solo es true el fotograma en que se toca (como keyboard_check_pressed)
    global.toque_ataque = false;
    global.toque_pausa = false;
}
