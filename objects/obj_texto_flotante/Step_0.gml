// Se mueve poco a poco y se destruye al terminar su duración
tiempo += 1;
x += vel_x;
y += vel_y;

if (tiempo >= duracion)
{
    instance_destroy();
}
