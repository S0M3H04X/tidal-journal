abstract class Scene {
  String name;

  String getName() {
    return name;
  }

  void init(String oldSceneName) {
  }

  void draw() {
  }

  void hit(float hitVal, float a, float b, float c, float d, float fade) {
  }

  void preDraw2d() {
    //---- HUD

    camera(); 
    noLights();

    hint(DISABLE_DEPTH_TEST);
    noLights();
    textMode(MODEL);


    // ALL 2D stuff    ...................
  }


  void postDraw2d() {
    // prepare to return to 3D 
    hint(ENABLE_DEPTH_TEST);
  }
}