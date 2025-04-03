class Scene2b extends Scene2 {
  Scene2b() {
    name = "scene2b";
    red1 = 0; 
    green1 = 255; 
    blue1 = 0;
    red2 = 255; 
    green2 = 255; 
    blue2 = 0;
  }

  void init(String oldSceneName) {
    if (oldSceneName != "scene2"){
        cam.reset(0);
    }
  }

  void doRotation() {
    cam.rotateY(0.01);
  }
}