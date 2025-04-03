class Scene2 extends Scene {

  int rows = 5;
  int cols = 5;
  int slots = 5;
  int minCols = 1;
  int maxCols = 10;
  int minRows = 1;
  int maxRows = 10;
  int minSlots = 1;
  int maxSlots = 10;
  int currentRow = 0, currentCol = 0, currentSlot = 0, shapeSize = 85;
  int red1 = 255, green1 = 100, blue1 = 200, red2 = 255, green2 = 200, blue2 = 120;
  Scene2Cell[][][] table;

  Scene2() {
    name = "scene2";
    buildTable();
  }

  void init(String oldSceneName) {
        if (oldSceneName != "scene2b"){
        cam.reset(0);
    }

  }

  void buildTable() {
    currentRow = 0;
    currentCol = 0;
    currentSlot = 0;
    table = new Scene2Cell[cols][rows][slots];
  }

  void hit(float hitVal, float a, float b, float c, float d, float fade) {
    
    int newCols = int(map(a, 0, 1, minCols, maxCols));
    int newRows = int(map(b, 0, 1, minRows, maxRows));
    int newSlots = int(map(c, 0, 1, minSlots, maxSlots));

    if (newCols != cols || newRows != rows || newSlots != slots) {
      rows = newRows;
      cols = newCols;
      slots = newSlots;
      buildTable();
    }

    if (currentRow == 0 && currentCol == 0 && currentSlot == 0) {
      buildTable();
    }

    table[currentCol][currentRow][currentSlot] = new Scene2Cell(hitVal);

    currentRow++;

    if (currentRow >= rows) {
      currentRow = 0;
      currentCol++;
    }

    if (currentCol >= cols) {
      currentCol = 0;
      currentSlot++;
    }

    if (currentSlot >= slots) {
      currentSlot = 0;
    }
  }

  void doRotation(){
    cam.rotateY(0.002);
  }

  void draw() {    

    postDraw2d();
    doRotation();
    sphereDetail(13);
    //lights();
    directionalLight(200, 102, 126, 0.15, -0.5, -0.7);
    ambientLight(55,55,55);

    float hitVal, strokeVal, opacity;
    Scene2Cell cell;

    if (table == null) {
      return;
    }

    noStroke();

    translate(-cols/2*shapeSize, -rows/2*shapeSize, -slots/2*shapeSize);

    for (int slot = 0; slot < slots; slot++) {
      for (int col = 0; col < cols; col++) {
        for (int row = 0; row < rows; row++) {

          // safety!
          if (col >= cols || row >= rows || slot >= slots) return;

          cell = table[col][row][slot];
          if (cell != null) {
            hitVal = cell.getHitVal();
          } else {
            break;
          }

          //strokeWeight(1);
          noStroke();
          translate(col * shapeSize, row * shapeSize, slot * shapeSize);

          if (hitVal > 0.5) {
            fill(red2, green2, blue2, 255);
            box(shapeSize *0.5);
          } else {
            fill(red1, green1, blue1, 255);
            sphere(shapeSize * 0.3);
          } 

          translate(-col * shapeSize, -row * shapeSize, -slot * shapeSize);

          //if (cell != null) cell.fade();
        }
      }
    }
    translate(cols/2*shapeSize, rows/2*shapeSize, slots/2*shapeSize);
  }
}

class Scene2Cell {
  float hitVal;

  Scene2Cell(float newHitVal) {
    hitVal = newHitVal;
  }

  float getHitVal() {
    return hitVal;
  }
}