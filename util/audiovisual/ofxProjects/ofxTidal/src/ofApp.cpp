#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
	ofSetFrameRate(60);
	ofSetVerticalSync(true);
	ofSetCircleResolution(80);
	ofBackground(54,54,54);
	soundStream.printDeviceList();
	int bufferSize = 256;

	left.assign(bufferSize, 0.0);
	right.assign(bufferSize, 0.0);
	volHistory.assign(400, 0.0);

	bufferCounter = 0;
	drawCounter = 0;
	smoothedVol = 0.0;
	scaledVol = 0.0;

	// Set up sound stream
	ofSoundStreamSettings settings;

	auto devices = soundStream.getMatchingDevices("Existential Audio Inc.: BlackHole 2ch");
	if (!devices.empty()) {
		settings.setInDevice(devices[0]);
	} else {
		ofLogError() << "No sound input device found.";
		return;
	}

	settings.setInListener(this);
	settings.sampleRate = 48000;
	#ifdef TARGET_EMSCRIPTEN
		settings.numOutputChannels = 2;
	#else
		settings.numOutputChannels = 0; // No output channels needed
	#endif
	settings.numInputChannels = 2; // Stereo input
	settings.bufferSize = bufferSize;
	soundStream.setup(settings);


	fbo.allocate(ofGetWidth(), ofGetHeight());
	c = ofColor::red;

	// Set up OSC receiver
	receiver.setup(PORT);
	ofLog() << "Listening for OSC messages on port " << PORT;

	parameters.setName("parameters");
	parameters.add(size.set("size",10,0,100));
	parameters.add(number.set("number",10,0,100));
	parameters.add(check.set("check",false));
	parameters.add(color.set("color",ofColor(127),ofColor(0,0),ofColor(255)));
	gui.setup(parameters);
	// by now needs to pass the gui parameter groups since the panel internally creates it's own group
	sync.setup((ofParameterGroup&)gui.getParameter(),PORT,"localhost",PORT);
	ofSetVerticalSync(true);
	
	// Set up font
	// ofTrueTypeFont::setGlobalDpi(72);

	// verdana.load("verdana.ttf", 96, true, true);

	// Initialise counter
	// frame = 0;
	
	// Initialise Tidal parameters
	ofx = 0;
	vowel = "";

	// try to grab at this size
	camWidth = 400;
	camHeight = 300;
	
	vidGrabber.setVerbose(true);
	vidGrabber.setup(camWidth,camHeight);

	font.load("Courier New Bold.ttf", 9);
	
	// this set of characters comes from the Ascii Video Processing example by Ben Fry,
	// changed order slightly to work better for mapping
	asciiCharacters =  string("  ..,,,'''``--_:;^^**""=+<>iv%&xclrs)/){}I?!][1taeo7zjLunT#@JCwfy325Fp6mqSghVd4EgXPGZbYkOA8U$KHDBWNMR0Q");
	
	ofEnableAlphaBlending();
}

//--------------------------------------------------------------
void ofApp::update(){
	sync.update();

	// Lets scale the vol to a range from 0 to 1
	scaledVol = ofMap(smoothedVol, 0.0, 0.17, 0.0, 1.0, true);
	// record the volume into an array
	volHistory.push_back(scaledVol);
	// if we are bigger than the size we want to record, then drop the oldest element
	if (volHistory.size() >= 400) {
		volHistory.erase(volHistory.begin(), volHistory.begin() + 1);
	}

	// Update the video grabber
	vidGrabber.update();

	// while (receiver.hasWaitingMessages())
	// {
	// 	ofxOscMessage m;
	// 	receiver.getNextMessage(m);

	// 	// Get message arguments
	// 	float first = m.getArgAsFloat(0);
	// 	string second = m.getArgAsString(1);

	// 	ofLog() << "Values received from Tidal: " << first << ", " << second;

	// 	// Set Tidal parameters
	// 	ofx = first;
	// 	vowel = second;

	// 	// Reset counter
	// 	frame = 0;
	// }

	
}

//--------------------------------------------------------------
void ofApp::draw(){
	gui.draw();
	ofSetColor(color);
	for(int i=0;i<number;i++){
		ofDrawCircle(ofGetWidth()*.5-size*((number-1)*0.5-i), ofGetHeight()*.5, size);
	}

	ofSetColor(225);
	ofDrawBitmapString("S0M3H04X", 32, 32);
	ofDrawBitmapString("Live-coding AV", 31, 92);
	
	ofNoFill();
	
	// draw the left channel:
	ofPushStyle();
		ofPushMatrix();
		ofTranslate(32, 170, 0);
			
		ofSetColor(225);
		ofDrawBitmapString("Left Channel", 4, 18);
		
		ofSetLineWidth(1);	
		ofDrawRectangle(0, 0, 256, 100);

		ofSetColor(245, 58, 135);
		ofSetLineWidth(3);
					
			ofBeginShape();
			for (unsigned int i = 0; i < left.size(); i++){
				ofVertex(i, 50 -left[i]*90.0f);
			}
			ofEndShape(false);
			
		ofPopMatrix();
	ofPopStyle();

	// draw the right channel:
	ofPushStyle();
		ofPushMatrix();
		ofTranslate(32, 270, 0);
			
		ofSetColor(225);
		ofDrawBitmapString("Right Channel", 4, 18);
		
		ofSetLineWidth(1);	
		ofDrawRectangle(0, 0, 256, 100);

		ofSetColor(245, 58, 135);
		ofSetLineWidth(3);
					
			ofBeginShape();
			for (unsigned int i = 0; i < right.size(); i++){
				ofVertex(i, 50 -right[i]*90.0f);
			}
			ofEndShape(false);
			
		ofPopMatrix();
	ofPopStyle();
	
	// draw the average volume:
	ofPushStyle();
		ofPushMatrix();
		ofTranslate(32, 370, 0);
			
		ofSetColor(225);
		ofDrawBitmapString("Scaled average vol (0-100): " + ofToString(scaledVol * 100.0, 0), 4, 18);
		ofDrawRectangle(0, 0, 256, 256);
		
		ofSetColor(245, 58, 135);
		ofFill();		
		ofDrawCircle(100, 200, 100 * 95.0f);
		
		//lets draw the volume history as a graph
		ofBeginShape();
		for (unsigned int i = 0; i < volHistory.size(); i++){
			if( i == 0 ) ofVertex(i, 200);

			ofVertex(i, 200 - volHistory[i] * 70);
			
			if( i == volHistory.size() -1 ) ofVertex(i, 200);
		}
		ofEndShape(false);		
			
		ofPopMatrix();
	ofPopStyle();
	
	drawCounter++;
	ofPushStyle();
		ofPushMatrix();
		ofTranslate(626, 370, 0);
			
		ofSetColor(225);
		ofDrawBitmapString("Public", 4, 18);
		
		ofSetLineWidth(1);	
		ofDrawRectangle(0, 0, 256, 256);


		ofSetColor(225);
		string reportString = "buffers received: "+ofToString(bufferCounter)+"\ndraw routines called: "+ofToString(drawCounter)+"\nticks: " + ofToString(soundStream.getTickCount());
		ofDrawBitmapString(reportString, 32, 589);
	
		// change background video alpha value based on the cursor's x-position
		// float videoAlphaValue = ofMap(mouseX, 0, ofGetWidth(), 0, 255);
	
		// set a white fill color with the alpha generated above
		// ofSetColor(0,0,0,20);

		// draw the raw video frame with the alpha value generated above
		vidGrabber.draw(0,0);

		ofPixelsRef pixelsRef = vidGrabber.getPixels();
	
		// ofSetHexColor(0x00ffde);

		for (int i = 0; i < camWidth; i+= 7){
			for (int j = 0; j < camHeight; j+= 9){
				// get the pixel and its lightness (lightness is the average of its RGB values)
				float lightness = pixelsRef.getColor(i,j).getLightness();
				
				// calculate the index of the character from our asciiCharacters array
				int character = powf( ofMap(lightness, 0, 255, 0, 1), 2.5) * asciiCharacters.size();
				
				// draw the character at the correct location
				font.drawString(ofToString(asciiCharacters[character]), i, j);
			}
		}
		ofPopMatrix();
	ofPopStyle();

	// Create a buffer to draw into
	// fbo.begin();
	// Clear background
	// ofSetColor(255);
	// Set gradient background
	// ofBackgroundGradient(ofColor(255), ofColor(128));

	// Change fill colour
	// float f = expImpulse(frame, 0.1);
	// c.setBrightness(200 * f * ofx);

	// Draw circle
	// float tx = ofGetWidth() / 2;
	// float ty = ofGetHeight() / 2;
	// float r = ofGetWidth() / 4;

	// ofPushMatrix();
	
	// ofTranslate(tx, ty);

	// ofSetColor(c);
	// ofFill();
	// ofSetCircleResolution(100);
	// ofDrawCircle(0, 0, r);
	
	// ofPopMatrix();

	// Draw character
	// ofSetColor(ofColor::dimGrey);
	// verdana.drawString(vowel, 30, 96);

	// fbo.end();

	// Draw buffer contents to screen
	// fbo.draw(0, 0);

	// Increment counter
	// frame += 1;
}

//--------------------------------------------------------------
float ofApp::expImpulse(float x, float k) {
	// Impulse function (maximum at x = 1/k)
	float h = k * x;
	return h * exp(1.0 - h);
}

//--------------------------------------------------------------
void ofApp::audioIn(ofSoundBuffer & input){
	
	float curVol = 0.0;
	
	// samples are "interleaved"
	int numCounted = 0;	

	//lets go through each sample and calculate the root mean square which is a rough way to calculate volume	
	for (size_t i = 0; i < input.getNumFrames(); i++){
		left[i]		= input[i*2]*0.5;
		right[i]	= input[i*2+1]*0.5;

		curVol += left[i] * left[i];
		curVol += right[i] * right[i];
		numCounted+=2;
	}
	
	//this is how we get the mean of rms :) 
	curVol /= (float)numCounted;
	
	// this is how we get the root of rms :) 
	curVol = sqrt( curVol );
	
	smoothedVol *= 0.93;
	smoothedVol += 0.07 * curVol;
	
	bufferCounter++;
	
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){
	if( key == 's' || key == 'S' ){
		soundStream.start();
	}
	
	if( key == 'e' || key == 'E' ){
		soundStream.stop();
	}

	if (key == 'v' || key == 'V'){
		vidGrabber.videoSettings();
	}

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}
