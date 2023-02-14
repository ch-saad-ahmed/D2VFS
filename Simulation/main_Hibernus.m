load InstructionTrace_100.mat
load CapCycles.mat

V_min=1.8;
V_max=3.6;

% C=17;%uF
% Chkpts = zeros(20,5);
% Time = zeros(20,5);
% fprintf("Cap: %d****************\n",C);
% i=1;
% %[Chkpt_DVFS,Time_DVFS]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,Dijkstra.Cycles,CapCycles.DVFS(i),1);
% %[Chkpt_16,Time_16]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,Dijkstra.Cycles,CapCycles.Freq_16MHz(i),2);
% %[Chkpt_12,Time_12]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,Dijkstra.Cycles,CapCycles.Freq_12MHz(i),3);
% %[Chkpt_8,Time_8]=MCU_Simulator_Decay_Hibernus(C,FFT.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(3),CapCycles.Freq_12MHz(3),97103,CapCycles.Freq_1MHz(3),4);
% %[Chkpt_1,Time_1]=MCU_Simulator_Decay_Hibernus(C,FFT.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(3),CapCycles.Freq_12MHz(3),CapCycles.Freq_8MHz(3),98991,5);
% 
% [Chkpt_8,Time_8]=MCU_Simulator_Decay_Hibernus(C,FFT.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(3),CapCycles.Freq_12MHz(3),CapCycles.Freq_8MHz(3),CapCycles.Freq_1MHz(3),4);
% [Chkpt_1,Time_1]=MCU_Simulator_Decay_Hibernus(C,FFT.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(3),CapCycles.Freq_12MHz(3),CapCycles.Freq_8MHz(3),CapCycles.Freq_1MHz(3),5);
% 
% %[Chkpt_1,Time_1]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,FFT.Cycles,98991,5);
% 
% Chkpts(i,1) = Chkpt_16;
% Chkpts(i,2) = Chkpt_12;
% Chkpts(i,3) = Chkpt_8;
% Chkpts(i,4) = Chkpt_1;
% Chkpts(i,5) = Chkpt_DVFS;
% 
% Time(i,1) = Time_16;
% Time(i,2) = Time_12;
% Time(i,3) = Time_8;
% Time(i,4) = Time_1;
% Time(i,5) = Time_DVFS;
% C = C+5;
% 


C=5;%uF
Chkpts = zeros(20,5);
Time = zeros(20,5);
%i=1;
for i=1:20;
fprintf("Cap: %d****************\n",C);
[Chkpt_DVFS,Time_DVFS]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,RSA.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),1);
[Chkpt_16,Time_16]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,RSA.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),2);
[Chkpt_12,Time_12]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,RSA.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),3);
[Chkpt_8,Time_8]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,RSA.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),4);
[Chkpt_1,Time_1]=MCU_Simulator_Decay_Hibernus(C,V_min,V_max,RSA.Cycles,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),5);

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

% C=5;%uF
% for i=1:20;
% fprintf("Cap: %d****************\n",C);
% [Chkpt_DVFS,Time]=MCU_Simulator_Decay_test(C,V_min,V_max,Dijkstra.Cycles,1);
% [Chkpt_16,Time_16]=MCU_Simulator_Decay_test(C,V_min,V_max,Dijkstra.Cycles,2);
% [Chkpt_12,Time_12]=MCU_Simulator_Decay_test(C,V_min,V_max,Dijkstra.Cycles,3);
% [Chkpt_8,Time_8]=MCU_Simulator_Decay_test(C,V_min,V_max,Dijkstra.Cycles,4);
% [Chkpt_1,Time_1]=MCU_Simulator_Decay_test(C,V_min,V_max,Dijkstra.Cycles,5);
% 
% C = C+5;
% end
