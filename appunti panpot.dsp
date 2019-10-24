import("stdfaust.lib");
panpot = vslider("[1]panpot [style:knob]", 0.5, 0.0, 1.0, 0.01); 
vmeter(x) = attach(x, envelop(x) : vbargraph("[99][unit:dB]", -70, +5))
with {
    envelop = abs : max ~ -(1.0/ma.SR) : max(ba.db2linear(-70)) : ba.linear2db;
};
process = _ <: * (1-panpot), * (panpot) : hgroup("meters [2]", vmeter, vmeter);

//attach interrompe il flusso di un segnale, ma non chiudendolo, processandolo (envelop) (x,y) x*1,y*0
//vmeter ci da i valori dell'onda, ma la parte negativa viene resa positiva
//abs da il valore assoluto
//max è il valore massimo che può essere espresso
//SR significa Sample Rate
//(1.0/ma.SR) esprime la divisione di uno per la frequenza di campionamento
//db2linear converte i dB in valori da 0 a 1
//tutti i valori di process a envelop vanno a vbargraph che ce li a in forma visiva
