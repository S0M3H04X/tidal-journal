// SuperDirt.start;
b = NetAddr.new("127.0.0.1", 4000);

OSCdef(\test,  { |msg, time|
	var bass2 = false;
	var bd = false;
	var sd = false;
	var pluck = false;
	for(1, msg.size, {
		arg i;
		bass2 = if(msg[i] == 'bass2', true, bass2);
		bd = if(msg[i] == 'bd', true, bd);
		sd = if(msg[i] == 'sd', true, sd);
		pluck = if(msg[i] == 'pluck', true, pluck);
	});
	b.sendMsg("/tidal", bass2, bd, sd, pluck);
}, '/play2', n);
