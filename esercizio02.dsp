import("stdfaust.lib");

vmeter(x) = fadgroup(attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5)));

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;

maingroup(x) = hgroup("[2] OSC IL LATORS", x);

fadgroup (x) = maingroup(hgroup("[1]", x));
osc1group(x) = fadgroup(hgroup ("[2] f1", x));
osc2group(x) = fadgroup(hgroup ("[3] f2", x));
osc3group(x) = fadgroup(hgroup ("[4] f3", x));
osc4group(x) = fadgroup(hgroup ("[5] f4", x));

frq = vslider("[1] f1 [style:knob] [unit:Hz]", 440,100,20000,1);

pan1 = osc1group(vslider("[1] p1 [style:knob]", 0.5,0,1,0.01));
pan2 = osc2group(vslider("[1] p2 [style:knob]", 0.5,0,1,0.01));
pan3 = osc3group(vslider("[1] p3 [style:knob]", 0.5,0,1,0.01));
pan4 = osc4group(vslider("[1] p4 [style:knob]", 0.5,0,1,0.01));

vol1 = osc1group(vslider("[1] vol1", 0.0,0,1,0.01) : vmeter);
vol2 = osc2group(vslider("[1] vol2", 0.0,0,1,0.01) : vmeter);
vol3 = osc3group(vslider("[1] vol3", 0.0,0,1,0.01) : vmeter);
vol4 = osc4group(vslider("[1] vol4", 0.0,0,1,0.01) : vmeter);

process = os.oscsin(frq*1), os.oscsin(frq*2),
          os.oscsin(frq*3), os.oscsin(frq*4):
          _ * (vol1), _ * (vol2), _ * (vol3), _ * (vol4) <:
          _ * (sqrt(1-pan1)), _ * (sqrt(1-pan2)),
          _ * (sqrt(1-pan3)), _ * (sqrt(1-pan4)),
          _ * (sqrt(pan1)), _ * (sqrt(pan2)),
	      _ * (sqrt(pan3)), _ * (sqrt(pan4)) : 
          _+_, _+_, _+_, _+_ : _+_, _+_ :
          _ *(0.25), _ *(0.25);

