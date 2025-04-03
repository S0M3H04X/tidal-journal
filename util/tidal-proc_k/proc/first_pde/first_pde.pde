import peasy.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
PeasyCam cam;

String setting;
float view, a, b, c, d, e, f, g, camx, camy, camz, reset;
boolean dirty = false;

void setup() {
  size(1600, 1600, P3D);
  cam = new PeasyCam(this, 500);

  oscP5 = new OscP5(this, 5000);
  myRemoteLocation = new NetAddress("127.0.0.1", 5000);
}

void oscEvent(OscMessage msg) {

  if (msg.checkAddrPattern("/proc_osc")==true) {

    setting = msg.get(1).stringValue();
    view = msg.get(2).floatValue();
    a = msg.get(3).floatValue();
    b = msg.get(4).floatValue();
    c = msg.get(5).floatValue();
    d = msg.get(6).floatValue();
    e = msg.get(7).floatValue();
    f = msg.get(8).floatValue();
    g = msg.get(9).floatValue();
    camx = msg.get(10).floatValue();
    camy = msg.get(11).floatValue();
    camz = msg.get(12).floatValue();
    reset = msg.get(13).floatValue();

    msg.print();

    dirty = true;
  }
}

float radius = 30;

void draw() {

  int rows = 5;
  int cols = 5;
  int planes = 5;
  float unit = 60;

  sphereDetail(7);

  if (dirty) {
    radius = 20;
    cam.reset(0);
    dirty = false;

    if (view > 0) {
      unit += 5;
      radius += 5;
    }
  }
  
  radius -= 0.4;

  cam.rotateY(0.02);
  cam.rotateX(0.005);
  cam.rotateZ(-0.012);
  
  background(0);
  noStroke();
  ambientLight(25, 25, 25);

  if (view > 0) {
    directionalLight(0, 200, 200, -0.4, -1, 0.3);
  } else {
    directionalLight(200, 0, 200, 0.4, 1, 0.3);
  }

  translate(-rows/2*unit, -cols/2*unit, -planes/2*unit);

  for (int x = 0; x < rows; x++) {
    for (int y = 0; y < cols; y++) {
      for (int z = 0; z < planes; z++) {
        translate(x * unit, y * unit, z * unit);
        if (view > 0){
          box(radius);
        } else{
          sphere(radius);
        }
        translate(-x*unit, -y*unit, -z*unit);
      }
    }
  }

  translate(rows/1.5*unit, cols/2*unit, planes/2*unit);

}