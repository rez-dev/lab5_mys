// Clase Boid
// Esta clase busca generar un ave que pertenece a la bandada

class Boid {
  
////////////////////////////// ATRIBUTOS  //////////////////////////////

  // Un ave cuando vuela tiene una posicion, velocidad y aceleracion
  // Ademas de que tiene un tamaño en si
  // Y una velocidad maxima que puede alcanzar
  // Como tambien una fuerza que puede recibir.
  
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    
  float maxspeed;   
  
  
////////////////////////////// INICIALIZACION  //////////////////////////////

  Boid(float x, float y) {
    
    //Se establece un vector de aceleracion, de velocidad y de posicion
    //Al igual que un radio, una influencia maxima y una velocidad maxima
    
    acceleration = new PVector(0, 0);
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    position = new PVector(x, y);
    r = 10.0;
    maxspeed = 1.75;
    maxforce = 0.03;
  }
  
////////////////////////////// METODOS //////////////////////////////
  
  // Método run:
  // Permite mover a las aves en el entorno
  // Entradas : Arreglo de aves x Lider
  // Salida: Sin salidas
  
  void run(ArrayList<Boid> boids, Leader leader, Scarecrow disruptor) {
    flock(boids,leader,disruptor);
    update();
    borders();
    render();
  }
  
////////////////////////////////////////////////////////////  

  // Método applyForce:
  // Permite aplicar la fuerza a cada ave en la aceleración
  // Entradas : PVector de fuerza
  // Salida: Sin salidas

  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
////////////////////////////////////////////////////////////  
  
  // Método flock:
  // Permite simular el funcionamiento de una Bandada de Aves que siguen un lider
  // Entradas : Arreglo de aves x Lider
  // Salida: Sin salidas
  
  void flock(ArrayList<Boid> boids, Leader leader, Scarecrow disruptor) {
    
    //Previamente se mencionó el concepto de fuerza
    //La fuerza se compone de 4 conceptos
    
    //Separación: La distancia que un ave quiere mantener distancia con sus compañeras.
    //Cohesión: Un ave quiere volar con el grupo y no alejarse demasiado.
    //Alineación: Un ave quiere volar en la dirección del grupo y a velocidad similar.
    //Seguimiento: El ave quiere seguir a su lider de bandada
    
    //Si se desea calcular la fuerza, se deben considerar esos 4 elementos.
    
    //Se definen estos 4 elementos 
    //Se Utilizan las respectivas funciones que calculan los elementos.
    
    PVector separation = separate(boids);   
    PVector alignament = align(boids);      
    PVector cohesive = cohesion(boids);   
    PVector following = followLeader(leader);
    PVector separationScarecrow = separateScarecrow(boids);
    PVector separationLeader = separateLeader(boids);
    
    // Se les aplica una valoración a cada una de los conceptos
  
    separation.mult(2.5);
    alignament.mult(1.5);
    cohesive.mult(1.5);
    following.mult(1.1);
    separationScarecrow.mult(4.0);
    separationLeader.mult(1.0);
    
    // Para luego ser aplicados a la aceleracion
    // Mediante la función applyForce
    
    applyForce(separation);
    applyForce(alignament);
    applyForce(cohesive);
    applyForce(following);
    applyForce(separationScarecrow);
    applyForce(separationLeader);
  }
  
//////////////////////////////////////////////////////////// 

  // Funcion update:
  // Actualiza la velocidad, aceleracion y posición de un ave
  // Entradas : Sin entradas
  // Salida: Sin salidas
  
  void update() {
    
    //A la velocidad se le añade la aceleración
    //Donde la aceleración esta dada por la fuerza
    
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    
    //Luego la velocidad actualiza la posición
  
    position.add(velocity);
    
    //Para luego reiniciar la aceleración
    //Con el fin de que solo se considere la fuerza 
    //En el instante de calculo, y no fuerzas anteriores
    
    acceleration.mult(0);
    
    //Por ende, la aceleración esta dada por el calculo de fuerza.
  }
 
////////////////////////////////////////////////////////////

  // Método seek:
  // Permite a las aves fijar un objetivo dada una posicion
  // Entradas : Pvector del Objetivo
  // Salida: Pvector de la dirección que debe seguir el ave
  
  PVector seek(PVector target) {
    
     // Se genera un Pvector hacia la posicion del objetivo
     // Tomando la posicion actual y la del objetivo
     
    PVector desired = PVector.sub(target, position); 
    
     //Se normaliza y se limita la velocidad
    
    desired.normalize();
    desired.mult(maxspeed);
    
    //Se le aplica la velocidad y se le limita el 
    //Direccionamiento otorgado por la fuerza
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce); 
    return steer;
  }

////////////////////////////////////////////////////////////


  // Método Render:
  // Permite generar las aves en la simulación
  // Entradas : Sin entradas
  // Salida: Un triangulo que representa un ave.
  

  void render() {
    float theta = velocity.heading2D() + radians(90);    
    fill(0, 0, 255);
    stroke(255);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

////////////////////////////////////////////////////////////

  // Método Borders:
  // Permite que las aves en la simulacion no salgan del entorno
  // Entradas : Sin entradas
  // Salida: Sin salidas
  
  void borders() {
    
    // En caso de alcanzar un borde de la simulacion
    // El ave aparecerá en el lado contrario del tablero.
    
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }
  
////////////////////////////////////////////////////////////

// A continuacion se encuentran los metodos que permiten calcular
// la fuerza, por ende la aceleración del ave.

  // Método Separate:
  // Permite que las aves mantenerse separadas lo suficiente para volar
  // De manera amena
  // Entradas : Array de Aves
  // Salida: Pvector de separacion
  
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 50.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // Para cada pajarito revisar si hay un ave cerca
    for (Boid other : boids) {
      float distance = PVector.dist(position, other.position);
      
      // Si la distancia es mayor a 0 y menor a la distancia deseada de separación
      
      if ((distance > 0) && (distance < desiredseparation)) {
        // Generamos un vector que indica a donde debe ir el ave
        // Se genera un vector para cada pajarito que esta cerca
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(distance);       
        steer.add(diff);
        count++;            
       
      }
    }
    // Despues unimos todos los vectores para obtener un unico vector
    if (count > 0) {
      steer.div((float)count);
    }

    // Mientras que el vector sea mayor a 0
    // Es decir, que exista un lugar a donde moverse
    // Se le aplicara la normalizacion, la maxima velocidad
    // se le limita la maxima aceleracion
    // Ademas de que se le resta la velocidad
    // Ya que el vector que apunta está dado por
    // Steer = desired - velocity
    
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  // Método SeparateScarecrow:
  // Permite que las aves se alejen del ave disruptiva
  // Entradas : Array de Aves
  // Salida: Pvector de separacion
  
    PVector separateScarecrow (ArrayList<Boid> boids) {
    float desiredseparation = 200.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    float distance = PVector.dist(position, disruptor.position);
      
    // Si la distancia es mayor a 0 y menor a la distancia deseada de separación
    
    if ((distance > 0) && (distance < desiredseparation)) {
      // Generamos un vector que indica a donde debe ir el ave
      PVector diff = PVector.sub(position, disruptor.position);
      diff.normalize();
      diff.div(distance);       
      steer.add(diff);
      count++;            
    }
    // Despues unimos todos los vectores para obtener un unico vector
    if (count > 0) {
      steer.div((float)count);
    }

    // Mientras que el vector sea mayor a 0
    // Es decir, que exista un lugar a donde moverse
    // Se le aplicara la normalizacion, la maxima velocidad
    // se le limita la maxima aceleracion
    // Ademas de que se le resta la velocidad
    // Ya que el vector que apunta está dado por
    // Steer = desired - velocity
    
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  // Método SeparateLeader:
  // Permite que las aves no esten encima del lider
  // Entradas : Array de Aves
  // Salida: Pvector de separacion
  
      
    PVector separateLeader (ArrayList<Boid> boids) {
    float desiredseparation = 10.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    
    float distance = PVector.dist(position, lider.position);
      
    // Si la distancia es mayor a 0 y menor a la distancia deseada de separación
    
    if ((distance > 0) && (distance < desiredseparation)) {
      // Generamos un vector que indica a donde debe ir el ave
      PVector diff = PVector.sub(position, lider.position);
      diff.normalize();
      diff.div(distance);       
      steer.add(diff);
      count++;            
    }
    // Despues unimos todos los vectores para obtener un unico vector
    if (count > 0) {
      steer.div((float)count);
    }

    // Mientras que el vector sea mayor a 0
    // Es decir, que exista un lugar a donde moverse
    // Se le aplicara la normalizacion, la maxima velocidad
    // se le limita la maxima aceleracion
    // Ademas de que se le resta la velocidad
    // Ya que el vector que apunta está dado por
    // Steer = desired - velocity
    
    if (steer.mag() > 0) {
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Método Align:
  // Permite que las aves vuelen en la dirección del grupo y a velocidad similar.
  // Entradas : Array de Aves
  // Salida: P vector de alineación
  
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    
    // Primero para cada vecino cercano, se les calcula la distancia.
    
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    //Para despues obtener la velocidad promedio entre los vecinos
    //Con esto generamos un vector Steer
    //Que nos indicara un vector de velocidad promedio de las aves
    //Que vuelan cerca de cada ave.
    
    if (count > 0) {
      sum.div((float)count);
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } 
    else {
      return new PVector(0, 0);
    }
  }
  // Método Cohesión:
  // Permite que las aves vuelen en grupo y no se alejen demasiado de la bandada
  // Entradas : Array de Aves
  // Salida: P vector de cohesion
  
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   
    int count = 0;
    
    // Primero se acumulan todas las posicionnes de los pajaros cercanos
    
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); 
        count++;
      }
    }
    
    // Luego, se calcula el promedio
    // Se retorna un vector que apunta a la posicion
    // Donde deben ir para mantenerse cerca de la bandada
    
    if (count > 0) {
      sum.div(count);
      return seek(sum);  
    } 
    else {
      return new PVector(0, 0);
    }
  }
  
  // Método followLeader:
  // Permite que las aves del grupo sigan al lider
  // Entradas : Lider
  // Salida: P vector con la posición del lider
  
  PVector followLeader (Leader leader) {
      return seek(leader.position);  
  }
}
