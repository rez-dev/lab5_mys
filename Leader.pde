// Clase leader
// Esta clase busca generar un ave que es un lider para la bandada

class Leader {
  
///////////////////////////// ATRIBUTOS  //////////////////////////////
  
  // Un ave cuando vuela tiene una posicion, velocidad y aceleracion
  // Ademas de que tiene un tamaño en si
  // Y una velocidad maxima que puede alcanzar
 
  float x = random(0,500);
  float y = 0;
  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxspeed;   

////////////////////////////// INICIALIZACION  //////////////////////////////

    Leader() {
    acceleration = new PVector(0, 0);
    
    // Se declara la posicion, velocidad,radio
    // maxima velocidad y maxima fuerza del lider
    
    float angle = random(TWO_PI);
    velocity = new PVector(0.1, 0.1);
    position = new PVector(x, y);
    r = 10.0;
    maxspeed = 2;
  }
  
////////////////////////////// METODOS //////////////////////////////
  
  // Método run:
  // Permite mover al lider en el entorno
  // Entradas : Sin entradas
  // Salida: Sin salidas

  void run() {
    //volar();
    update();
    borders();
    render();
  }

////////////////////////////////////////////////////////////

  // Funcion update:
  // Actualiza la velocidad, aceleracion y posición de un ave lider
  // Entradas : Sin entradas
  // Salida: Sin salidas

  void update() {
    
    //Actualiza la velocidad, y se le limita con el maximo.
    
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    
    // Luego, se escribe el movimiento buscado para el lider
    // En este caso una funcion sinusoidal de la forma 
    
    // a * sin(b * x) + c * x^2 + d
    // por ende definimos a,b,c y d
    
    //float a = 100;
    //float b = 0.03;
    //float c = 0;
    //float d = 480;
    
    float a = 100;
    float b = 0.03;
    float c = 0.0002;
    float d = 480;
    
    y = a*sin(b*x) + (c * x * x) + d;
    if (y > height+r) {
      y = y - height;
      if (y >= height) {
        y = y - height;
        if (y >= height) y = y - height;
      }
    }
    
    // Aplicamos una restricción para reiniciar
    // En caso de que se alcancen los bordes
    
    if(x>width+r) x = 0;
    else x = x+2.0;
  
    //Actualizamos la posición
    //Reiniciamos la aceleracion
    
    position.set(x,y);
    acceleration.mult(0);
    //print("xd " + x);
  }
  
////////////////////////////////////////////////////////////


  // Método Render:
  // Permite generar al lider en la simulación
  // Entradas : Sin entradas
  // Salida: Un triangulo que representa al lider  

  void render() {
  
    
    float theta = velocity.heading2D() + radians(90);    
    fill(255, 0, 0);
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
  // Permite que el lider en la simulacion no salgan del entorno
  // Entradas : Sin entradas
  // Salida: Sin salidas
  
  void borders() {
    //print("borders");
    
    // En caso de alcanzar un borde de la simulacion
    // El lider aparecerá en el lado contrario del tablero.
    
    
    if (position.x < -r) {
    position.x = width+r;
    print("border1");
  }
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) {
      position.x = -r;
      print("hola ");
      print("pos x " + position.x);
    }
    if (position.y > height+r) position.y = -r;
  }
}
