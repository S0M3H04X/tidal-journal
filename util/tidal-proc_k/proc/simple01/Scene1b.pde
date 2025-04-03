class Scene1b extends Scene1 {
  Scene1b() {
    name = "scene1b";
    red1 = 255; 
    green1 = 0; 
    blue1 = 0;
    red2 = 255; 
    green2 = 255; 
    blue2 = 255;
  }

  void init(String oldSceneName) {
    if (oldSceneName != "scene1") {
      cam.reset(0);
    }
  }
}