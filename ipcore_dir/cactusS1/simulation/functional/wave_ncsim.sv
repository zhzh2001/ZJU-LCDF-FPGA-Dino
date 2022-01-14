

 
 
 

 



window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /cactusS1_tb/status
      waveform add -signals /cactusS1_tb/cactusS1_synth_inst/bmg_port/CLKA
      waveform add -signals /cactusS1_tb/cactusS1_synth_inst/bmg_port/ADDRA
      waveform add -signals /cactusS1_tb/cactusS1_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
