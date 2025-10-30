class Cycle {
   PVector position, velocidad;
   float grosor = 1.5;
   
   Cycle(String n) {
     position = new PVector(height-offsetSubdivision, 0);
     velocidad = new PVector(-movSequenser, 0.0);
     grosor = (n.equals("1")) ? 1 : 0.25;
     
   }
   
   void draw() {
     noFill();
     stroke(0);

     position.add(velocidad);
     strokeWeight(grosor);
     line(position.y, position.x, position.y, height);
     if ( position.x < -30 ) {
       cycles.remove(this);
     }
   }
}
