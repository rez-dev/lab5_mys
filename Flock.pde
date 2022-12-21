//Clase Flock
//Esta clase busca representar a la bandada

class Flock {
  
  ///////////////////////////// ATRIBUTOS  //////////////////////////////
  
  //Una bandada en el caso del laboratorio contiene
  //La bandada de aves -> Arraylist de aves
  //Un lider
  
  ArrayList<Boid> boids; 
  Leader leader;
  Scarecrow espantador;

////////////////////////////// INICIALIZACION  //////////////////////////////

  //Para inicializar la clase, se necesita inicializar el arraylist.
  
  Flock() {
    boids = new ArrayList<Boid>(); 
  }

////////////////////////////// METODOS //////////////////////////////
  
  // Método run:
  // Permite mover a las aves en el entorno
  // Entradas : Lider
  // Salida: Sin salidas

  void run(Leader leader, Scarecrow espantador) {
    
    // Mueve a cada pajaro
    for (Boid b : boids) {
      b.run(boids,leader,espantador);  
    }
  }
  
  // Método addBoid:
  // Permite agregar un ave a la simulacion
  // Entradas : un Ave
  // Salida: Sin salidas

  void addBoid(Boid b) {
    boids.add(b);
  }

}
