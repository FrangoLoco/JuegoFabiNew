// Efectos comunes de todos los enemigos. Los hijos lo ejecutan con event_inherited() al inicio de su Step

// Recuperar la forma normal después de estirarse o aplastarse
escala_x = lerp(escala_x, 1, 0.2);
escala_y = lerp(escala_y, 1, 0.2);

if (destello > 0) destello -= 1;
if (tiempo_barra > 0) tiempo_barra -= 1;
vida_mostrada = lerp(vida_mostrada, vida, 0.08);

// Retroceso al recibir un golpe, se frena poco a poco y no atraviesa paredes
if (empuje != 0)
{
    if (place_meeting(x + empuje, y, obj_colision))
    {
        empuje = 0;
    }
    else
    {
        x += empuje;
        empuje *= 0.8;
        if (abs(empuje) < 1) empuje = 0;
    }
}
