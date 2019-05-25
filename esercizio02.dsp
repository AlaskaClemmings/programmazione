import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5));

envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;

maingroup(x) = hgroup("[02] OSCILLATORS", x);
 
fad1group(x) = maingroup(hgroup("[01] f1", x));
osc1group(x) = fad1group(vgroup("[01]", x));
fad2group(x) = maingroup(hgroup("[02] f2", x));
osc2group(x) = fad2group(vgroup("[01]", x));
fad3group(x) = maingroup(hgroup("[03] f3", x));
osc3group(x) = fad3group(vgroup("[01]", x));
fad4group(x) = maingroup(hgroup("[04] f4", x));
osc4group(x) = fad4group(vgroup("[01]", x));

frq = vslider("[01] f1 [style:knob]", 440,100,20000,1); 

pan1 = osc1group(vslider("[01] pan [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo);
pan2 = osc2group(vslider("[01] pan [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo); 
pan3 = osc3group(vslider("[01] pan [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo);
pan4 = osc4group(vslider("[01] pan [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo);

vol1 = osc1group(vslider("[02] vol1 [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo);
vol2 = osc2group(vslider("[02] vol2 [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo);
vol3 = osc3group(vslider("[02] vol3 [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo);
vol4 = osc4group(vslider("[02] vol4 [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo); 

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
