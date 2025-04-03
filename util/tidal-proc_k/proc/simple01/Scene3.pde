class Scene3 extends Scene {

  int row, col, slot;
  int rows = 1;
  int cols = 1;
  int slots = 1;
  int minCols = 1;
  int maxCols = 20;
  int minRows = 1;
  int maxRows = 20;
  int minSlots = 1;
  int maxSlots = 20;
  float spaceSize = 350;
  float currentHitVal = 0;
  float vary = 0;
  float shapeSizeX = 1;
  float shapeSizeY = 1;
  float shapeSizeZ = 1;
  boolean reset = false;
  float fadeAmount = 0;
  float currentFade = 0;
  float rotationAmount = 0;
  float currentRotation = 0;

  int newCols, newRows, newSlots;

  Scene3() {
    name = "scene3";
  }

  void init(String oldSceneName) {
    cam.reset(0);
  }

  void hit(float hitVal, float a, float b, float c, float d, float fade) {
    reset = true;

    newCols = int(map(a, 0, 1, minCols, maxCols));
    newRows = int(map(b, 0, 1, minRows, maxRows));
    newSlots = int(map(c, 0, 1, minSlots, maxSlots));
    fadeAmount = map(fade, 0, 1, 0, 1);
    rotationAmount = map(d, 0, 1, 0, 0.05);

    currentHitVal = hitVal;
    currentFade = 0;
    currentRotation = 0;
  }

  void doRotation() {
    cam.rotateY(0.01);
    cam.rotateX(0.002);
  }

  void draw() {    
    postDraw2d();

    if (reset) {
      cam.reset(0);
      reset = false;
    }

    rows = newRows;
    cols = newCols;
    slots = newSlots;

    shapeSizeX = spaceSize / rows; 
    shapeSizeY = spaceSize / cols;
    shapeSizeZ = spaceSize / slots;

    noFill();
    strokeWeight(2);

    translate(-spaceSize/2, -spaceSize/2, -spaceSize/2);

    float x = shapeSizeX * factor + currentFade;
    float y = shapeSizeY * factor + currentFade;
    float z = shapeSizeZ * factor + currentFade;

    for (row = 0; row < rows; row++) {
      for (col = 0; col < cols; col++) {
        for (slot = 0; slot < slots; slot++) {

          translate(row * shapeSizeX, col * shapeSizeY, slot * shapeSizeZ);

          translate(shapeSizeX/2, shapeSizeY/2, shapeSizeZ/2);
          rotateX(currentRotation);
          if (currentHitVal < 1) {
            stroke(0, 255, 0);
            drawPyramid(x/2, y/2, z/2);
          } else {
            stroke(0, 255, 255);
            drawBox(x, y, z);
          }
          rotateX(-currentRotation);
          translate(-shapeSizeX/2, -shapeSizeY/2, -shapeSizeZ/2);

          translate(-row * shapeSizeX, -col * shapeSizeY, -slot * shapeSizeZ);
        }
      }
    }

    translate(spaceSize/2, spaceSize/2, spaceSize/2);

    doRotation();

    currentFade -= fadeAmount;
    currentRotation += rotationAmount;
  }

  float factor = 0.6;
  void drawBox(float sizeX, float sizeY, float sizeZ) {   
    //float x = sizeX * factor;
    //float y = sizeY * factor;
    //float z = sizeZ * factor;

    //box(sizeX * factor, sizeY * factor, sizeZ * factor);
    box(sizeX, sizeY, 0);
  }

  void drawPyramid(float sizeX, float sizeY, float sizeZ) {
    //float size = shapeSize * 0.4 * currentScale;
    //float x = sizeX / 2 * factor;
    //float y = sizeY / 2 * factor;
    float x = sizeX;
    float y = sizeY;

    beginShape();

    vertex(-x, y, 0);
    vertex( x, y, 0);
    vertex(   0, -y, 0);

    vertex( x, y, 0);
    vertex( x, y, 0);
    vertex(   0, -y, 0);

    vertex( x, y, 0);
    vertex(-x, y, 0);
    vertex(   0, -y, 0);

    vertex(-x, y, 0);
    vertex(-x, y, 0);
    vertex(0, -y, 0);    

    endShape();
  }
}