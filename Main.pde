/**
 * Laboratorio 4 Modelación y Simulación
 * Autores : Rodrigo Escobar
 *           Nicolas Torreblanca
 * Fecha de Entrega : 04-12-2022
 * 
 * Programa que busca generar una simulación de una Bandada de Aves que 
 * siguen a un lider, que sigue un comportamiento sinusoidal.
 * 
 */


Flock flock;
Leader lider;
Scarecrow espantador;

// setup
// Sin entradas y salidas
// Configura el espacio donde se realizara la simulacion.

void setup() {
  size(1600, 960);
  flock = new Flock();
  
  // Se agrega una cantidad inicial de aves en el sistema
  for (int i = 0; i < 125; i++) {
    flock.addBoid(new Boid(width/2,height/2));
  }
  
  // Se inicializa un lider igualmente
  lider =  new Leader();
  espantador = new Scarecrow();
}


// draw
// Sin entradas
// Sin salidas
// Permite ejecutar el comportamiento de las aves.
void draw() {
  background(151, 221, 234);
  flock.run(lider,espantador);
  lider.run();
  espantador.run();
}

// Funcion mousePressed
// Sin entradas ni salidas
// Permite agregar nuevas aves a la simulacion con el click del mousse.

void mousePressed() {
 flock.addBoid(new Boid(mouseX,mouseY));
}
