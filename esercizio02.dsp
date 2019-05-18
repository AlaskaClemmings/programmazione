import("stdfaust.lib");

frq = vslider("f1 [style:knob] [unit:Hz]", 440,100,20000,1); 
pan1 = vslider("p1 [style:knob]", 0.5,0,1,0.01);
pan2 = vslider("p2 [style:knob]", 0.5,0,1,0.01);
pan3 = vslider("p3 [style:knob]", 0.5,0,1,0.01);
pan4 = vslider("p4 [style:knob]", 0.5,0,1,0.01);

vol1 = vslider("vol1", 0.0,0,1,0.01);
vol2 = vslider("vol2", 0.0,0,1,0.01);
vol3 = vslider("vol3", 0.0,0,1,0.01);
vol4 = vslider("vol4", 0.0,0,1,0.01);

process = os.oscsin(frq*1), os.oscsin(frq*2),
          os.oscsin(frq*3), os.oscsin(frq*4):
          _ * (vol1), _ * (vol2), _ * (vol3), _ * (vol4) <:
          _ * (sqrt(1-pan1)), _ * (sqrt(1-pan2)),
          _ * (sqrt(1-pan3)), _ * (sqrt(1-pan4)),
          _ * (sqrt(pan1)), _ * (sqrt(pan2)),
	      _ * (sqrt(pan3)), _ * (sqrt(pan4)) : 
          _+_, _+_, _+_, _+_ : _+_, _+_ :
          _ *(0.25), _ *(0.25);

