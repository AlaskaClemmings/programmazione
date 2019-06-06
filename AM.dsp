import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5))
  with{
    envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db; 
};

carrier = os.oscsin(frq) : * (modulator)
  with{
    frq = vslider("[01] FRQ [style:knob]", 440,100,20000,0.01) : si.smoo;
};

modulator = os.oscsin(frq) : * (vol)
  with{
    frq = vslider("[01] FRQ [style:knob]", 1,0.01,20000,0.01) : si.smoo;
    vol = vslider("[03] VOL [style:knob]", 0,0,1,0.1) : si.smoo;
};

process = carrier;
