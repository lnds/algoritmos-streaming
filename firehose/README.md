# Firehose

Esta aplicación calcula en tiempo real los top 5 trending topics en BlueSky.

Para determinar los trending topics buscamos los hashtags (palabras que empiezan con #)


Usamos el algoritmo CountMin Sketches (ver este video: https://www.youtube.com/watch?v=mPxslXpg8wA)


Para ejecutar:


    mix deps.get
    mix run --no-halt


