function mostrarMensaje() 
{
    const frases =
     [
        " Eres más fuerte de lo que crees. ¡Sigue adelante!",
        " El dolor que hoy sientes es la fuerza que tendrás mañana.",
        " No pares hasta que te sientas orgullosa de ti misma.",
        " La disciplina es el puente entre tus metas y tus logros.",
        " El único límite eres tú. ¡Rompe barreras!"
    ];

    // Escoge una frase aleatoria
    const fraseAleatoria = frases[Math.floor(Math.random() * frases.length)];

    // Muestra la frase en la página
    const mensaje = document.getElementById("mensaje");
    mensaje.textContent = fraseAleatoria;

    // También lo mostramos en la consola
    console.log(`Frase motivadora: "${fraseAleatoria}"`);
}
