import supercollider.*;

import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import netP5.*;
import oscP5.*;

import controlP5.*;

Minim minim;
AudioInput in;
BeatDetect beat;
OscP5 osc;
Buffer buffer;
Synth synth;

ArrayList<Sound> sounds = new ArrayList<Sound>();
ArrayList<Cycle> cycles = new ArrayList<Cycle>();

float alturaBar;
float offsetSubdivision = 40;

int connectionTotal = 8; // set total tracks (Number of Tidal connections to represent)
float movSequenser= 2; // set grid speed (higher speed makes time wider)

float [][] history;

int history_pos = 0;

int xres = 4,
    yres = 16;

void setup() {
  osc = new OscP5(this, 1818);  
  size(1024, 768, OPENGL); 
  
  minim = new Minim(this);
  // get an AudioInput object
  in = minim.getLineIn(Minim.MONO, 256);
  beat = new BeatDetect();
  beat.setSensitivity(400);
  
  buffer = new Buffer(256, 1);
  buffer.alloc(this, "done");
  
  history = new float[48][width / xres];
  
  colorMode(HSB, 0.2);
  //background(255,255,255,1);
  stroke(1);
  //noStroke();
  frameRate(30);
  
}

void draw() {
  buffer.getn(0, buffer.frames, this, "getn");
  beat.detect(in.mix);
  
  background(0);
  stroke(1);
  strokeWeight(1);
  noFill();
  
  translate(width, width/1.8, 700);
  rotateX(PI / 2.2);
  rotateZ(PI);
  
  int hip = history_pos;
  
  // also try LINES, TRIANGLES, or QUAD_STRIP  
  int shapeType = TRIANGLES;
  
  if (beat.isOnset()){
     colorMode(HSB, 0.2);
     background(255,255,255,1);
  } 
  
  
  for(int j=0; j<cycles.size() ; j++) {
    if ( cycles.get(j)!= null) { cycles.get(j).draw(); }
  }
  
  for (int h = 1; h < history.length; h++) {
    int hi = (history_pos + h) % (history.length);
    for(int i=0; i<sounds.size() ; i++) {
      if ( sounds.get(i)!= null) { sounds.get(i).draw(); }
    }  
    for(int j=0; j<cycles.size() ; j++) {
      if ( cycles.get(j)!= null) { cycles.get(j).draw(); }
    }
    
    for (int k = 0; k < (width / xres) - 1; k++) {
      float ratio = ((float) h / history.length);
      
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
