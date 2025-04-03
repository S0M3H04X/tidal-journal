/*
This is an example startup file. You can load it from your startup file
(to be found in Platform.userAppSupportDir +/+ "startup.scd")
*/


(
// configure the sound server: here you could add hardware specific options
// see http://doc.sccode.org/Classes/ServerOptions.html
s.options.numBuffers = 1024 * 256; // increase this if you need to load more samples
s.options.memSize = 8192 * 32; // increase this if you get "alloc failed" messages
s.options.maxNodes = 1024 * 32; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numOutputBusChannels = 16; // set this to your hardware output channel size, if necessary
s.options.numInputBusChannels = 2; // set this to your hardware output channel size, if necessary
s.options.device = "BlackHole 16ch"
// boot the server and start SuperDirt
s.waitForBoot {
	~dirt = SuperDirt(2, s); // two output channels, increase if you want to pan across more channels
	s.sync;

	~dirt.loadSoundFiles;   // load samples (path containing a wildcard can be passed in)
	~dirt.loadSoundFiles("~/Desktop/SOMEHOAX/VEDAL/samples/*");
	// ~dirt.loadSynthDefs("~/Desktop/SOMEHOAX/VEDAL/synths/");
	~dirt.loadSoundFiles("~/Desktop/SOMEHOAX/VEDAL/samples-extra/*");
	~dirt.loadSoundFiles("~/Desktop/SOMEHOAX/VEDAL/solstice/*");
	// s.sync; // optionally: wait for samples to be rea
	~dirt.start(57120, [0, 2, 4, 6, 8, 10, 12, 14]);   // start listening on port 57120, create two busses each sending audio to channel 0





	// 8-channels MIDI routing
	// MIDIClient.init;

	// ~midiOut1 = MIDIOut.newByName("IAC Driver", "tidal1");
	// ~midiOut2 = MIDIOut.newByName("IAC Driver", "tidal2");
	// ~midiOut3 = MIDIOut.newByName("IAC Driver", "tidal3");
	// ~midiOut4 = MIDIOut.newByName("IAC Driver", "tidal4");
	// ~midiOut5 = MIDIOut.newByName("IAC Driver", "tidal5");
	// ~midiOut6 = MIDIOut.newByName("IAC Driver", "tidal6");
	// ~midiOut7 = MIDIOut.newByName("IAC Driver", "tidal7");
	// ~midiOut8 = MIDIOut.newByName("IAC Driver", "tidal8");

	// ~dirt.soundLibrary.addMIDI(\m1, ~midiOut1);
	// ~dirt.soundLibrary.addMIDI(\m2, ~midiOut2);
	// ~dirt.soundLibrary.addMIDI(\m3, ~midiOut3);
	// ~dirt.soundLibrary.addMIDI(\m4, ~midiOut4);
	// ~dirt.soundLibrary.addMIDI(\m5, ~midiOut5);
	// ~dirt.soundLibrary.addMIDI(\m6, ~midiOut6);
	// ~dirt.soundLibrary.addMIDI(\m7, ~midiOut7);
	// ~dirt.soundLibrary.addMIDI(\m8, ~midiOut8);

	// ~midiOut1.latency = 0.45;
	// ~midiOut2.latency = 0.45;
	// ~midiOut3.latency = 0.45;
	// ~midiOut4.latency = 0.45;
	// ~midiOut5.latency = 0.45;
	// ~midiOut6.latency = 0.45;
	// ~midiOut7.latency = 0.45;
	// ~midiOut8.latency = 0.45;



	};

s.latency = 1.5; // increase this if you get "late" messages


);
