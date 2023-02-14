load InstructionTrace_100_Mem.mat
load CapCycles.mat

V_min=1.8;
V_max=3.6;

C=5;%uF
Chkpts = zeros(20,5);
Time = zeros(20,5);
%i=1;
for i=1:20;
fprintf("Cap: %d****************\n",C);
% checkpoint_size= 200;
% max_cycles = 1209;
% [Chkpt_DVFS,Time_DVFS]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,Dijkstra_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,1);
% [Chkpt_16,Time_16]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,Dijkstra_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,2);
% [Chkpt_12,Time_12]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,Dijkstra_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,3);
% [Chkpt_8,Time_8]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,Dijkstra_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,4);
% [Chkpt_1,Time_1]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,Dijkstra_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,5);

% checkpoint_size= 160;
% max_cycles = 68774;
% [Chkpt_DVFS,Time_DVFS]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,RSA_Mem.VarName1,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,1);
% [Chkpt_16,Time_16]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,RSA_Mem.VarName1,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,2);
% [Chkpt_12,Time_12]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,RSA_Mem.VarName1,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,3);
% [Chkpt_8,Time_8]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,RSA_Mem.VarName1,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,4);
% [Chkpt_1,Time_1]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,RSA_Mem.VarName1,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,5);

checkpoint_size= 160;
max_cycles = 3969;
[Chkpt_DVFS,Time_DVFS]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,FFT_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,1);
[Chkpt_16,Time_16]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,FFT_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,2);
[Chkpt_12,Time_12]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,FFT_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,3);
[Chkpt_8,Time_8]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,FFT_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,4);
[Chkpt_1,Time_1]=MCU_Simulator_Decay_MementOS(C,V_min,V_max,FFT_Mem.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),checkpoint_size,max_cycles,5);

Chkpts(i,1) = Chkpt_16;
Chkpts(i,2) = Chkpt_12;
Chkpts(i,3) = Chkpt_8;
Chkpts(i,4) = Chkpt_1;
Chkpts(i,5) = Chkpt_DVFS;

Time(i,1) = Time_16;
Time(i,2) = Time_12;
Time(i,3) = Time_8;
Time(i,4) = Time_1;
Time(i,5) = Time_DVFS;
C = C+5;
end
