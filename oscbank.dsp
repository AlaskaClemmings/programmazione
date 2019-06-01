import("stdfaust.lib");

vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5))
  with{
    envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db; 
};

oscill(o) = vgroup("[02] OSC %ooo", os.oscsin(frq) : * (vol) <: * (sqrt(1-pan)), * (sqrt(pan)))
  with{
    ooo = o +(001);
    frq = vslider("[01] FRQ [style:knob]", 440,100,20000,0.01) : si.smoo;
    pan = vslider("[02] PAN [style:knob]", 0,-90,90,0.1) + 90 / 180 : si.smoo;
    vol = vslider("[03] VOL [style:knob]", 0,0,1,0.1) : si.smoo;
};

stereo = hgroup("[129] STEREO OUT", *(vol), *(vol) : vmeter, vmeter)
  with{
  vol = vslider("[01] [unit:dB]", 0,-96,0,1.0) : ba.db2linear : si.smoo;
};
  
process = hgroup("OSCILLATORS BANK", par(i, 64, oscill(i)) :> stereo);
//ordine oscillatori
