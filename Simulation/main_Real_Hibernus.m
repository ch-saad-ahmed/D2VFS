load AR_Data.mat
load InstructionTrace_100.mat
load CapCycles.mat
load traces.mat
load Detection.mat;
load MSP430G2553_measurements.mat;

C=5;%uF
Chkpts = zeros(20,5);
Time = zeros(20,5);
M = zeros(20,5);

V_min = 1.8;
V_max = 3.6;
%i=1;
for i=1:20
fprintf("Cap: %d****************\n",C);
%[Chkpt_DVFS,Time_DVFS]= MCU_Simulator_Trace_Hibernus(C,Vmin,Vmax,V_RF,InstructionCC,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),1);
Vsupply = V_IR;
[Chkpt_DVFS,Time_DVFS,M_DVFS] = MCU_Simulator(C,V_min,V_max,Vsupply,InstructionCC,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),1);
[Chkpt_16,Time_16,M_16] = MCU_Simulator(C,V_min,V_max,Vsupply,InstructionCC,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),2);
[Chkpt_12,Time_12,M_12] = MCU_Simulator(C,V_min,V_max,Vsupply,InstructionCC,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),3);
[Chkpt_8,Time_8,M_8] = MCU_Simulator(C,V_min,V_max,Vsupply,InstructionCC,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),4);
[Chkpt_1,Time_1,M_1] = MCU_Simulator(C,V_min,V_max,Vsupply,InstructionCC,CapCycles.DVFS(i),CapCycles.Freq_16MHz(i),CapCycles.Freq_12MHz(i),CapCycles.Freq_8MHz(i),CapCycles.Freq_1MHz(i),5);
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

M(i,1) = M_16;
M(i,2) = M_12;
M(i,3) = M_8;
M(i,4) = M_1;
M(i,5) = M_DVFS;

C = C+5;
end


