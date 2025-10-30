#include "ofMain.h"
#include "ofApp.h"

//========================================================================
int main( ){
	// ofSetupOpenGL(1024,768,OF_WINDOW);			// <-------- setup the GL context

	ofGLWindowSettings settings;
	settings.setSize(1024, 768);
	settings.windowMode = OF_WINDOW; // or OF_FULLSCREEN

	auto window = ofCreateWindow(settings); // <-------- setup the GL context


	// this kicks off the running of my app
	// can be OF_WINDOW or OF_FULLSCREEN
	// pass in width and height too:
	ofRunApp(window, std::make_shared<ofApp>());
	ofRunMainLoop(); // <-------- start the app loop

}
