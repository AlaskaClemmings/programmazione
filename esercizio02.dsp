import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5));

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;

maingroup(x) = hgroup("[02] OSCILLATORS", x);
 
fad1group(x) = maingroup(hgroup("[01]", x));
osc1group(x) = fad1group(vgroup("[01] f1", x));
fad2group(x) = maingroup(hgroup("[02]", x));
osc2group(x) = fad2group(vgroup("[01] f2", x));
fad3group(x) = maingroup(hgroup("[03]", x));
osc3group(x) = fad3group(vgroup("[01] f3", x));
fad4group(x) = maingroup(hgroup("[04]", x));
osc4group(x) = fad4group(vgroup("[01] f4", x));

frq = vslider("[01] f1 [style:knob]", 440,100,20000,1); 

pan1 = osc1group(vslider("[01] p1 [style:knob]", 0.5,0,1,0.01));
pan2 = osc2group(vslider("[01] p2 [style:knob]", 0.5,0,1,0.01)); 
pan3 = osc3group(vslider("[01] p3 [style:knob]", 0.5,0,1,0.01));
pan4 = osc4group(vslider("[01] p4 [style:knob]", 0.5,0,1,0.01)); 

vol1 = osc1group(vslider("[02] vol1", 0.0,0,1,0.01));
vol2 = osc2group(vslider("[02] vol2", 0.0,0,1,0.01));
vol3 = osc3group(vslider("[02] vol3", 0.0,0,1,0.01));
vol4 = osc4group(vslider("[02] vol4", 0.0,0,1,0.01)); 

process = os.oscsin(frq*1), os.oscsin(frq*2),
          os.oscsin(frq*3), os.oscsin(frq*4):
          _ * (vol1), _ * (vol2), _ * (vol3), _ * (vol4) <:
          _ * (sqrt(1-pan1)), _ * (sqrt(1-pan2)),
          _ * (sqrt(1-pan3)), _ * (sqrt(1-pan4)),
          _ * (sqrt(pan1)), _ * (sqrt(pan2)),
	      _ * (sqrt(pan3)), _ * (sqrt(pan4)) :
          fad1group(vmeter), fad2group(vmeter), fad3group(vmeter), fad4group(vmeter),
          fad1group(vmeter), fad2group(vmeter), fad3group(vmeter), fad4group(vmeter) :
          _+_, _+_, _+_, _+_ : _+_, _+_ :       
          _ *(0.25), _ *(0.25); 
