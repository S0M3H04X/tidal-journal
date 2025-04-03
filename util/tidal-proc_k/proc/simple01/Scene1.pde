class Scene1 extends Scene {

  int rows = 10;
  int cols = 40;
  int minCols = 1;
  int maxCols = 50;
  int minRows = 1;
  int maxRows = 50;
  int currentRow = 0, currentCol = 0, rectWidth, rectHeight;
  float stroke, fadeRate;
  int red1 = 255, green1 = 0, blue1 = 255, red2 = 0, green2 = 255, blue2 = 255;
  Scene1Cell[][] table;

  Scene1() {
    name = "scene1";
    buildTable();
  }

  void init(String oldSceneName) {
    if (oldSceneName != "scene1b") {
      cam.reset(0);
    }
  }

  void buildTable() {
    currentRow = 0;
    currentCol = 0;
    rectWidth = width/cols;
    rectHeight = height/rows;
    table = new Scene1Cell[cols][rows];
  }

  void hit(float hitVal, float a, float b, float c, float d, float fade) {

    stroke = 5;
    fadeRate = map(fade, 0, 1, 0, 10);

    int newCols = int(map(a, 1, 0, minCols, maxCols));
    int newRows = int(map(b, 1, 0, minRows, maxRows));

    if (newCols != cols || newRows != rows) {
      rows = newRows;
      cols = newCols;
      buildTable();
    }

    if (currentRow == 0 && currentCol == 0) {
      buildTable();
    }

    table[currentCol][currentRow] = new Scene1Cell(hitVal, stroke, fadeRate);

    currentRow++;

    if (currentRow >= rows) {
      currentRow = 0;
      currentCol++;
    }

    if (currentCol >= cols) {
      currentCol = 0;
    }
  }


  void draw() {

    preDraw2d();

    float hitVal, strokeVal, opacity;
    Scene1Cell cell;

    if (table == null) {
      return;
    }

    stroke(0);

    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {

        // safety!
        if (col >= cols || row >= rows) return;

        cell = table[col][row];
        if (cell != null) {
          hitVal = cell.getHitVal();
          strokeVal = cell.getStroke();
          opacity = cell.getOpacity();
        } else {
          hitVal = 0;
          strokeVal = 1;
          opacity = 0;
        }

        strokeWeight(strokeVal);
        if (hitVal > 0.5) {
          fill(red2, green2, blue2, opacity);
        } else {
          fill(red1, green1, blue1, opacity);
        } 

        rect(col * rectWidth, row * rectHeight, rectWidth, rectHeight);
        if (cell != null) cell.fade();
      }
    }

    postDraw2d();
  }
}

class Scene1Cell {
  float stroke;
  float hitVal;
  float fadeRate;
  float opacity;

  Scene1Cell(float newHitVal, float newStroke, float newFadeRate) {
    stroke = newStroke;
    hitVal = newHitVal;
    fadeRate = newFadeRate;
    opacity = 255;
  }

  float getStroke() {
    return stroke;
  }

  float getHitVal() {
    return hitVal;
  }

  float getFadeRate() {
    return fadeRate;
  }

  void fade() {
    opacity -= fadeRate;
    if (opacity <= 0) {
      opacity = 0;
    }
  }

  float getOpacity() {
    return opacity;
  }
}