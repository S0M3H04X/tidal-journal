import peasy.*;
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
PeasyCam cam;

PVector[][] globe;
int total = 25;

float offset = 0;

float _m = 1;
float _n1 = 1;
float _n2 = 1;
float _n3 = 1;
String thing;
float x = 1;
float y = 1;
float z = 1;
float w = 1;


void setup() {
  size(1600, 1600, P3D);
  cam = new PeasyCam(this, 500);

  oscP5 = new OscP5(this, 5000);
  myRemoteLocation = new NetAddress("127.0.0.1", 5000);

  globe = new PVector[total+1][total+1];
}


void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/proc_osc")==true) {

    thing = theOscMessage.get(1).stringValue();
    x = theOscMessage.get(2).floatValue();
    y = theOscMessage.get(3).floatValue();
    z = theOscMessage.get(4).floatValue();
    w = theOscMessage.get(5).floatValue();
  }
}

float a = 1;
float b = 1;

float supershape(float theta, float m, float n1, float n2, float n3) {
  float t1 = abs((1/a)*cos(m * theta / 4));
  t1 = pow(t1, n2);
  float t2 = abs((1/b)*sin(m * theta/4));
  t2 = pow(t2, n3);
  float t3 = t1 + t2;
  float r = pow(t3, - 1 / n1);
  return r;
}

void draw() {

  _m = x;
  _n1 = y;
  _n2 = z;
  _n3 = w;

  cam.rotateX(x/10000);
  cam.rotateY(y/10000);
  cam.rotateX(x/10000);

  background(0);
  noStroke();


 // Light the bottom of the sphere
  directionalLight(251, 102, 126, 0, -1, 0);
  
  // Orange light on the upper-right of the sphere
  spotLight(204, 153, 100, 360, 160, 600, 0, 0, -1, PI/2, 600); 
  
  // Moving spotlight that follows the mouse
  spotLight(102, 153, 204, 360, x, 600, 0, 0, -1, PI/2, 600); 

  fill(204);

  float r = 200;
  for (int i = 0; i < total+1; i++) {
    float lat = map(i, 0, total, -HALF_PI, HALF_PI);
    float r2 = supershape(lat, _m, _n1, _n2, _n3);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, -PI, PI);
      float r1 = supershape(lon, _m, _n1, _n2, _n3);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat);
      globe[i][j] = new PVector(x, y, z);
    }
  }

  offset += 5;
  for (int i = 0; i < total; i++) {
    beginShape(TRIANGLE_STRIP);
    for (int j = 0; j < total+1; j++) {
      PVector v1 = globe[i][j];
      vertex(v1.x, v1.y, v1.z);
      PVector v2 = globe[i+1][j];
      vertex(v2.x, v2.y, v2.z);
    }
    endShape();
  }
}