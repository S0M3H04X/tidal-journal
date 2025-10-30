class Sound {
  PVector position, velocidad;
  int x = 1;
  int n = 1;
  String s = "";
  color colorB;
  float sizeMin = 2;
  float sizeMax = 10;
  float size = sizeMax;
  int fractionCycle = 0;
  int cycle = 0;
  int connectionN = 0; 
  float offset = 0;
  String figure = "triangle"; 


  Sound(StringDict tidalLayer) {
    connectionN = parseInt( tidalLayer.get("connectionN") );
    float cycleF = parseFloat( tidalLayer.get("cycle") );
    cycle = (int)cycleF;
    fractionCycle = (int)((cycleF - (int)(cycleF)) * 100); 
    int countSameFractionCycle = 0;
    for (int i=0; i<sounds.size(); i++) {
      if ( sounds.get(i)!= null) { 
        if ( connectionN == sounds.get(i).connectionN && fractionCycle == sounds.get(i).fractionCycle && cycle == sounds.get(i).cycle ) {
          countSameFractionCycle++;
        }
      }
    }
    offset = countSameFractionCycle * (sizeMin*1.2); //map(countSameFractionCycle, 0, 8, 0, alturaBar);
    this.x = connectionN;
    float y = map(this.x, 1, connectionTotal, 20, (height-alturaBar)+50);
    position = new PVector(width-offsetSubdivision, y+offset);
    velocidad = new PVector(-movSequenser, 0.0);
    if ( tidalLayer.hasKey("color") ) {
      String colorLayer = "FF"+tidalLayer.get("color");
      colorB = color( unhex(colorLayer) );
    } else {
      int numb = 0;
      for (int c=0; c<tidalLayer.get("s").length(); c++) {
        numb += (int)tidalLayer.get("s").charAt(c)  ;
      }
      if ( tidalLayer.hasKey("n") ) {
        numb *= ( parseInt( tidalLayer.get("n") )) ;
      } else {
        numb *= 18181818;
      }
      randomSeed(numb);
      colorB = color(random(255), random(255), random(255)); 
    }

    if ( tidalLayer.hasKey("sizeMin") ) {
      sizeMin = parseInt( tidalLayer.get("sizeMin") );
    }
    if ( tidalLayer.hasKey("sizeMax") ) {
      sizeMax = parseInt( tidalLayer.get("sizeMax") );
    }
    if ( tidalLayer.hasKey("figure") ) {
      figure = tidalLayer.get("figure");
    }
  }

  void draw() {
    noStroke();
    fill(colorB);
    position.add(velocidad);
    pushMatrix();
    translate(position.y+200, position.x+100);
    rotateX(PI/2);
    
    //TODO -> emoji?
    switch(figure) {
      case "circle": 
        ellipse(0, 0, size, size);
        break;
      case "rect": 
        rectMode(CENTER); 
        rect(0, 0, size, size);
        break;
      case "triangle": 
        triangle(-(size*5), size*5, 0, -(size*5), size*5, size*5 );
        break; 
      default:
        ellipse(0, 0, size, size);
        break;
    }
    popMatrix();
    if ( position.x < -(sizeMin+10) ) {
      sounds.remove(this);
    }
    size -= 1.0;
    size = constrain(size, sizeMin, sizeMax);
  }
}
