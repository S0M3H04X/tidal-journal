class Scene3b extends Scene {
  float spaceSize = 350;
  float currentFade = 0;
  float fadeRate = 0;
  float currentHitVal;
  float rotateRate = 0;
  float currentRotate = 0;

  Scene3b() {
    name = "scene3b";
  }

  void init(String oldSceneName) {
    cam.reset(0);
  }

  void hit(float hitVal, float a, float b, float c, float d, float fade) {
    currentHitVal = hitVal;
    fadeRate = map(fade, 0, 1, 0, 3);
    rotateRate = map(d, 0, 1, 0, 0.01);
    currentFade = 0;
    currentRotate = 0;
  }

  void draw() {    
    postDraw2d();
    cam.rotateY(0.02);
    noFill();
    strokeWeight(2);
    stroke(0, 255, 0);
    
    rotateZ(currentRotate);

    if (currentHitVal > 0.5) {
      stroke(255,255,0);
      drawBox(spaceSize, spaceSize, spaceSize);
    } else {
      stroke(255,0,255);
      drawPyramid(spaceSize, spaceSize, spaceSize);
    }
    rotateZ(-currentRotate);

    currentFade += fadeRate;
    currentRotate += rotateRate;
  }

  float factor = 0.6;
  void drawBox(float sizeX, float sizeY, float sizeZ) {   

    float x = sizeX/2;
    float y = sizeY/2 - currentFade;
    float z = sizeZ/2;
    float topScale = 0.7;

    beginShape(QUADS);

    //top, starting back left
    vertex(x, y, -z);
    vertex(-x, y, -z);
    vertex(-x, y, z);
    vertex(x, y, z);

    //bottom, starting back left
    vertex(x*topScale, -y, -z*topScale);
    vertex(-x*topScale, -y, -z*topScale);
    vertex(-x*topScale, -y, z*topScale);
    vertex(x*topScale, -y, z*topScale);

    //left, starting back top
    vertex(-x, y, -z);
    vertex(-x*topScale, -y, -z*topScale);
    vertex(-x*topScale, -y, z*topScale);
    vertex(-x, y, z);

    //right, starting back top
    vertex(x, y, -z);
    vertex(x*topScale, -y, -z*topScale);
    vertex(x*topScale, -y, z*topScale);
    vertex(x, y, z);

    endShape();
  }

  void drawPyramid(float sizeX, float sizeY, float sizeZ) {
    float x = sizeX/2;
    float y = sizeY/2 - currentFade;
    float z = sizeZ/2;

    beginShape();

    // back, lower right first
    vertex(x, -y, -z);
    vertex(-x, -y, -z);
    vertex(0, y, 0);

    // front
    vertex(x, -y, z);
    vertex(-x, -y, z);
    vertex(0, y, 0);

    // right
    vertex( x, -y, z);
    vertex(x, -y, -z);
    vertex(0, y, 0);

    // left
    vertex(-x, -y, z);
    vertex(-x, -y, -z);
    vertex(0, y, 0);    

    endShape();
  }
}