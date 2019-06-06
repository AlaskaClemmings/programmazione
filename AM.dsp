import("stdfaust.lib");

carrier = os.oscsin(frqc) : * (modulator)
  with{
    frqc = vslider("[01] C Freq [style:knob]", 440,100,20000,0.01) : si.smoo;
};

modulator = os.oscsin(frqm) : * (volm) : + (offsetm)
  with{
    frqm = vslider("[01] M Freq [style:knob]", 1,0.01,20000,0.01) : si.smoo;
    volm = vslider("[02] M Vol [style:knob]", 0,0,1,0.1) : si.smoo;
    offsetm = vslider("[03] M Offset [style:knob]", 0,0,10,0.01) : si.smoo;
};

process = carrier;
