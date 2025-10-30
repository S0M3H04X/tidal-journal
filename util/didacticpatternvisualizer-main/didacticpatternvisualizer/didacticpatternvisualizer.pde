import supercollider.*;
import oscP5.*;
import netP5.*;
import controlP5.*;

OscP5 osc;

ArrayList<Sound> sounds = new ArrayList<Sound>();
ArrayList<Cycle> cycles = new ArrayList<Cycle>();
ArrayList<GShader> shaders;
GShader shader;
PGraphics pg;
int idxShader = -1;

float alturaBar;
float offsetSubdivision = 40;

int connectionTotal = 8; // set total tracks (Number of Tidal connections to represent)
float movSequenser= 2; // set grid speed (higher speed makes time wider)


void setup() {
  osc = new OscP5(this, 1818);  
  size(1280,840, P2D);
  //fullScreen(P3D, 2);
  alturaBar = height/connectionTotal;
  //setupShaders();
  //setupGui();  
  //setShader(0);
  pg = createGraphics(1280, 840, P2D);
}



void draw() {
  //shader.setShaderParameters();
  
  pg.beginDraw();
  //pg.shader(shader.shader);
  pg.rect(0, 0, pg.width, pg.height);
  pg.endDraw();
  
  noFill();
  rect(0, 0, width, height);
  image(pg, 0, 0); 
  for(int y=0; y<(connectionTotal*0.5); y++ ) {
    rect(0, y*alturaBar*2, width, alturaBar/2);
  }
  for(int i=0; i<sounds.size() ; i++) {
    if ( sounds.get(i)!= null) { sounds.get(i).draw(); }
  }  
  for(int i=0; i<cycles.size() ; i++) {
    if ( cycles.get(i)!= null) { cycles.get(i).draw(); }
  }
}
