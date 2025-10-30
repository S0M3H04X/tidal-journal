#pragma once

#include "ofMain.h"
#include "ofxOsc.h"
#include "ofxGui.h"
#include "ofxOscParameterSync.h"

// Listening port
#define PORT 2020

class ofApp : public ofBaseApp{

	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);
		float expImpulse(float x, float k);

		void audioIn(ofSoundBuffer & input);

		vector <float> left;
		vector <float> right;
		vector <float> volHistory;

		ofxOscParameterSync sync;

		ofParameter<float> size;
		ofParameter<int> number;
		ofParameter<bool> check;
		ofParameterGroup parameters;
		ofParameter<ofColor> color;
		ofxPanel gui;

		ofxOscReceiver receiver;
		ofFbo fbo;
		ofColor c;
		int frame;
		// ofTrueTypeFont verdana;

		// Parameters from Tidal
		float ofx;
		string vowel;

		// Audio Input Example
		int 	bufferCounter;
		int 	drawCounter;
		
		float smoothedVol;
		float scaledVol;
		
		ofSoundStream soundStream;

		ofVideoGrabber vidGrabber;
		int camWidth;
		int camHeight;
	
		string asciiCharacters;
		ofTrueTypeFont font;

};
