load AR_Data;
load traces;
load MSP430G2553_measurements.mat;
load Detection.mat;

C=1;
V_min=1.8;
V_max=3.6;

[DVFS_CC,DVFS_Time]=Cycles_DVFS(C,V_min,V_max,1);
[Freq_16_CC,Freq_16_Time]=Cycles_DVFS(C,V_min,V_max,2);
[Freq_12_CC,Freq_12_Time]=Cycles_DVFS(C,V_min,V_max,3);
[Freq_8_CC,Freq_8_Time]=Cycles_DVFS(C,V_min,V_max,4);
[Freq_1_CC,Freq_1_Time]=Cycles_DVFS(C,V_min,V_max,5);

%an=[DVFS_Time,Freq_16_Time,Freq_12_Time,Freq_8_Time,Freq_1_Time];

%MCU_Simulator(C,V_min,V_max,V_OR,InstructionCC,2)
%V_Hib=AR_Hib(V_min,V_max,V_OR,C,'Hib_SOM_50uF.txt',InstructionE,InstructionCC);

