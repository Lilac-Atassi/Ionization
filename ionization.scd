// Ionization - 12 speakers
// Lilac Atassi, 2018
// lilac.atassi@gmail.com

// prepare the server to output 12 channels
(
s.quit;
o = Server.local.options;
o.numOutputBusChannels = 12;
s.boot;
)

// define synth
(
~synth = SynthDef(\noiseGrain,
	{|low_range, high_range, rate, amp=0.0, density_base=1, density=0, rq=0.02, out|
	Out.ar(out,
			RLPF.ar(Dust.ar(density_base + (density*20)),
		    LFNoise1.ar(rate).range(low_range, high_range),
		    rq,
			amp)
    )}).add;
)

// main control
(
~noise = Array.fill(12);

// 25 secs, Subwoofer (speaker 12)
~noise[0] = Synth(\noiseGrain, [\low_range, 20, \high_range, 300, \rate, 0.5, \out, 11]);

// 30 secs, Front stand up middle (speaker 1)
~noise[1] = Synth(\noiseGrain, [\low_range, 60, \high_range, 600, \rate, 0.4, \out, 0]);

// 30 secs, Right up (speaker 11)
~noise[2] = Synth(\noiseGrain, [\low_range, 180, \high_range, 1800, \rate, 0.5, \out, 10, \density_base, 5]);

// 20 secs, Left low stand (speaker 7)
~noise[3] = Synth(\noiseGrain, [\low_range, 240, \high_range, 3600, \rate, 0.5, \out, 6, \density_base, 9]);

// 30 secs, Front (speaker  2)
~noise[4] = Synth(\noiseGrain, [\low_range, 420, \high_range, 4200, \rate, 0.5, \out, 1, \density_base, 11]);

// 20 secs, Back up left (speaker low 10)
~noise[5] = Synth(\noiseGrain, [\low_range, 500, \high_range, 6200, \rate, 0.5, \out, 9, \density_base, 13]);

// 35 secs, lowstand right (speaker low 4)
~noise[6] = Synth(\noiseGrain, [\low_range, 840, \high_range, 8600, \rate, 0.5, \out, 3, \density_base, 15]);

// 35 secs, lowstand right (speaker up 8)
~noise[7] = Synth(\noiseGrain, [\low_range, 700, \high_range, 11600, \rate, 0.5, \out, 7, \density_base, 17]);

// 25 secs, left up (speaker up 6)
~noise[8] = Synth(\noiseGrain, [\low_range, 1200, \high_range, 13600, \rate, 0.5, \out, 5, \density_base, 19]);

// 35 secs, back right (speaker 5)
~noise[9] = Synth(\noiseGrain, [\low_range, 260, \high_range, 15000, \rate, 0.5, \out, 4, \density_base, 20]);

// 20 secs, Front low stand (speaker 3)
~noise[10] = Synth(\noiseGrain, [\low_range, 300, \high_range, 16000, \rate, 0.5, \out, 2, \density_base, 21, \rq, 0.07]);

// 40 secs, Back low stand (speaker 9)
~noise[11] = Synth(\noiseGrain, [\low_range, 300, \high_range, 19000, \rate, 0.4, \out, 8, \density_base, 23, \rq, 0.07]);

// create the user interface window
~number_channels = 11;
~height = 50 + (~number_channels * 40);
~height.postln;
w = Window.new("Noise", Rect(900,0, 600,~height));

~amp_slider = Array.fill(12);
~density_slider = Array.fill(12);

~vertical_pos = 10;
for (1, 12, { arg i;
	          StaticText.new(w, Rect(20, ~vertical_pos, 150, 30)).string_("Channel "+i);

   	          ~amp_slider[i-1] = Slider.new(w, Rect(125, ~vertical_pos, 150, 30));
 	          ~amp_slider[i-1].action = { ~noise[i-1].set("amp", ~amp_slider[i-1].value); };

	          ~density_slider[i-1] = Slider.new(w, Rect(325, ~vertical_pos, 150, 30));
 	          ~density_slider[i-1].action = { ~noise[i-1].set("density", ~density_slider[i-1].value); };

	          ~vertical_pos = ~vertical_pos + 40;
});

w.front;
)
