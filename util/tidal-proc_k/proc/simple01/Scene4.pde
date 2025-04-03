class Scene4b extends Scene4{
  public Scene4b(){
    red1 = 152;
    green1 = 36;
    blue1 = 198;
    red2 = 255;
    green2 = 134;
    blue2 = 237;
  }
  
  String getName(){
    return "scene4b";
  }
}

class Scene4 extends Scene {

  int rows;
  int cols;
  int maxDim = 31;
  int minDim = 3;
  Scene4Cell[][] table;
  int currentX, currentY;
  int centerX, centerY;
  int currentSquareSize = 0;
  float cellWidth, cellHeight;
  
  int red2 = 255, green2 = 255, blue2 = 255;
  int red1 = 0, green1 = 255, blue1 = 255;

  String getName() {
    return "scene4";
  }

  void buildTable() {
    table = new Scene4Cell[cols][rows];
    centerX = cols/2;
    centerY = rows/2;
  }

  void hit(float hitVal, float a, float b, float c, float d, float fade) {

    int oldCols = cols;
    int oldRows = rows;
    fade = map(fade, 0, 1, 0, 10);

    cols = int(map(a, 0, 1, minDim, maxDim));
    rows = int(map(a, 0, 1, minDim, maxDim));

    // ONLY permit odd numbers of rows and cols
    if (cols % 2 == 0) cols++;
    if (rows % 2 == 0) rows++;

    cellWidth = width/cols;
    cellHeight = height/rows;

    if (table == null || cols != oldCols || rows != oldRows || (currentX == cols-1 && currentY == rows-1)) {
      buildTable();
      currentX = centerX;
      currentY = centerY;
      table[currentX][currentY] = new Scene4Cell(0, fade);
      currentSquareSize = 1;
      return;
    } 

    advance();
    table[currentX][currentY] = new Scene4Cell(hitVal, fade);
  }

  void advance() {

    int diffX = currentX - centerX;
    int diffY = currentY - centerY;

    // begin, center
    if (diffX == 0 && diffY == 0) {
      currentX++;
      return;
    }

    // end
    if (diffX == currentSquareSize && diffY == currentSquareSize) {
      currentX++;
      currentSquareSize++;
      return;
    }

    // right side
    if (diffX == currentSquareSize && (diffY > -currentSquareSize)) {
      currentY--;
      return;
    }

    // top side
    if (diffY == -currentSquareSize && (diffX > -currentSquareSize)) {
      currentX--;
      return;
    }

    // left side
    if (diffX == -currentSquareSize && diffY < currentSquareSize) {
      currentY++;
      return;
    }

    // bottom side
    if (diffY == currentSquareSize && diffX >= -currentSquareSize && diffX < currentSquareSize) {
      currentX++;
      return;
    }
  }


  void draw() {

    preDraw2d();

    fill(100);
    stroke(0);
    strokeWeight(5);

    for (int x = 0; x < cols; x++) {
      for (int y = 0; y < rows; y++) {
        Scene4Cell cell = table[x][y];        
        if (cell != null) {
          if (cell.hitVal == 1) {
            fill(red2, green2, blue2, cell.opacity);
          } else {
            fill(red1, green1, blue1, cell.opacity);
          }
          rect(cellWidth*x, cellHeight*y, cellWidth, cellHeight);
          cell.doFade();
        }
      }
    }


    postDraw2d();
  }
}

public class Scene4Cell {
  public float hitVal;
  public float fadeRate;
  public float opacity;

  public Scene4Cell(float val, float fadeRateVal) {
    hitVal = val;
    fadeRate = fadeRateVal;
    opacity = 255;
  }

  void doFade() {
    opacity -= fadeRate;
    if (opacity < 0) {
      opacity = 0;
    }
  }
}