import damkjer.ocd.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.opengl.*;
import processing.sound.*;

import supercollider.*;

import netP5.*;
import oscP5.*;

import controlP5.*;
import peasy.*;

Minim minim;
AudioInput in;
BeatDetect beat;
OscP5 osc;
Buffer buffer;
Synth synth;
PeasyCam cam;
Camera camera1;
Camera camera2;



ArrayList<Sound> sounds = new ArrayList<Sound>();
ArrayList<Cycle> cycles = new ArrayList<Cycle>();

float alturaBar;
float offsetSubdivision = 20;

int connectionTotal = 8; // set total tracks (Number of Tidal connections to represent)
float movSequenser= 2; // set grid speed (higher speed makes time wider)

float [][] history;

int history_pos = 0;

int xres = 8,
    yres = 24;
    
PVector[][] globe;
int total = 75;

float offset = 0;

float m = 0;
float mchange = 0;

void setup () {
  
  osc = new OscP5(this, 1818);  
  size(1024, 768, P3D);
  //fullScreen(P3D);
  background(0,0.1);
  colorMode(RGB,400);
  globe = new PVector[total+1][total+1];

  camera1 = new Camera(this, 0, -50, 200);
  camera2 = new Camera(this, -200, 20, 0);


   
  
  minim = new Minim(this);
  // get an AudioInput object
  in = minim.getLineIn(Minim.MONO, 256);
  beat = new BeatDetect();
  beat.setSensitivity(500);

  
  alturaBar = width / connectionTotal;
  
  
  background(0);
  stroke(1);
  //noStroke();
  frameRate(30);
 
  
  buffer = new Buffer(128, 1);
  buffer.alloc(this, "done");
  
  
  history = new float[36][width / xres];
  
  
  
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

void draw () {
  
  buffer.getn(0, buffer.frames, this, "getn");
  beat.detect(in.mix);
 
  
  
  
  m = map(sin(mchange), -1, 1, 0, 7);
  mchange += 0.05; 
  
  // draw
  background(0);   
  noStroke();
  lights();
  camera1.feed();
  
  
  if (beat.isOnset()){
    colorMode(HSB,0.2);
    //camera2.zoom(radians(mouseY - pmouseY) / 2.0);
    camera1.tumble(radians(PI/2), radians(-PI/4));
    background(255);  
    camera2.feed();
  } 
  
  
  float r = 50;
  for (int i = 0; i < total+1; i++) {
    
    float lat = map(i, 0, total, -HALF_PI/2, HALF_PI/2);
    //float r2 = supershape(lat, m, 0.2, 1.7, 1.7);
    float r2 = supershape(lat, 2, 10, 10, 10);
    for (int j = 0; j < total+1; j++) {
      float lon = map(j, 0, total, PI/2, -PI/2);
      float r1 = supershape(lon, m, 0.2, 1.7, 1.7);
      //float r1 = supershape(lon, 8, 60, 100, 30);
      float x = r * r1 * cos(lon) * r2 * cos(lat);
      float y = r * r1 * sin(lon) * r2 * cos(lat);
      float z = r * r2 * sin(lat) ;
      globe[i][j] = new PVector(x, y, z);
    }
    
  }

  offset += 5;
  for (int i = 0; i < total; i++) {
    float hu = map(i, 0, total, 0, 255*6);
    colorMode(RGB,200);
    //fill((hu + offset) % 255, 255, 255, (hu + offset) % 20);
    
    stroke((hu + offset) % 255, 255, 255, (hu + offset) % 20);
    beginShape(TRIANGLE_STRIP);
 
    for (int j = 0; j < total+1; j++) {
      PVector v1 = globe[i][j];
      vertex(v1.x/i, v1.y, v1.z/j);
      PVector v2 = globe[i+1][j];
      vertex(v2.x/j, v2.y, v2.z/i);
      
    }
    endShape();
    
    //rotateZ(PI);
    
   
  }
  

  
  translate(width/2, height/4, 500);
  rotateX(PI / 2.2);
  rotateZ(PI);

  
  int hip = history_pos;
  
  // also try LINES, TRIANGLES, or QUAD_STRIP  
  int shapeType = LINES;
 
  
  
 
  for (int h = 1; h < history.length; h++) {
    int hi = (history_pos + h) % (history.length);
    
    for(int i = 0; i < sounds.size() ; i++) {
      if ( sounds.get(i)!= null) { 
        sounds.get(i).draw();
      }
      
    }  
    for(int j = 0; j < cycles.size() ; j++) {
      if ( cycles.get(j)!= null) { 
        cycles.get(j).draw();
      }
    }
    
    for (int k = 0; k < (width / xres) - 1; k++) {
      float ratio = ((float) h / history.length);
      //noFill();
    
      
      stroke(0.1, 1 - ratio, 0.8 * ratio, ratio);
      beginShape(shapeType);
      vertex(k * xres, h * yres, history[hi][k] * 300.0);
      vertex(k * xres + xres, h * yres, history[hi][k + 1] *300.0);
      vertex(k * xres + xres, (h - 1) * yres, history[hip][k + 1] *300.0);
      vertex(k * xres, (h - 1) * yres, history[hip][k] * .0);
      endShape(); 
    }
    hip = hi;
    
  }

  
}

void done (Buffer buffer)
{
  synth = new Synth("recordbuf_1");
  synth.set("bufnum", buffer.index);
  synth.set("loop", 1);
  synth.create();
}

void getn (Buffer buffer, int index, float [] values)
{
  for (int i = 0; i < values.length; i++)
  {
    history[history_pos][i] = values[i];
  }
  
  if (++history_pos >= history.length)
     history_pos = 0;
}

void exit()
{
  buffer.free();
  synth.free();
  super.exit();
}

void mouseMoved() {
  camera1.tumble(radians(mouseX - pmouseX), radians(mouseY - pmouseY));
}
