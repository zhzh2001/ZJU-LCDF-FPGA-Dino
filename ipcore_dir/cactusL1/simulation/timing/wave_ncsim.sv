
 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"


      waveform add -signals /cactusL1_tb/status
      waveform add -signals /cactusL1_tb/cactusL1_synth_inst/bmg_port/CLKA
      waveform add -signals /cactusL1_tb/cactusL1_synth_inst/bmg_port/ADDRA
      waveform add -signals /cactusL1_tb/cactusL1_synth_inst/bmg_port/DOUTA
console submit -using simulator -wait no "run"
