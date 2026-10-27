vsp += grv;
hsp *= 0.97; // Resistencia del aire
x += hsp;
y += vsp;

tiempo += 1;
if (tiempo >= duracion)
{
    instance_destroy();
}
