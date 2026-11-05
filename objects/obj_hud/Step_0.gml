// Las monedas del contador suben de una en una con un pequeño rebote
if (monedas_hud < global.monedas)
{
    temporizador_monedas -= 1;
    if (temporizador_monedas <= 0)
    {
        monedas_hud += 1;
        escala_monedas = 1.4;
        temporizador_monedas = 8;
    }
}
else { monedas_hud = global.monedas; }
escala_monedas = lerp(escala_monedas, 1, 0.15);
