function [CheckpointCounter,Time] = MCU_Simulator_Trace_Hibernus (C,Vmin,Vmax,Vsupply, InstructionCC,DVFS_Cycles,Cycles_16MHz,Cycles_12MHz,Cycles_8MHz,Cycles_1MHz, opt)

N = size(InstructionCC,1);
energy_per_byte = 0.172838; %uJ //0.18ms*(360uA*3.3)
time_per_byte = 0.00018;
checkpoint_size = 576;
ChkpHibernus = (checkpoint_size)*energy_per_byte;%uJ FRAM
ChkpTime = checkpoint_size*time_per_byte;
Time=0;

F_16 = 15796892;
F_12 = 12176872;
F_8 = 7927340;

P_16 =  4725*3.6;
F_16 = 15796892;
EnergyPerCycle_16 = (1/F_16)*P_16;

P_12 =  3692*3.6;
F_12 = 12176872;
EnergyPerCycle_12 = (1/F_12)*P_12;

P_8 =  2463*3.6;
F_8 = 7927340;
EnergyPerCycle_8 = (1/F_8)*P_8;

P_1 = 444.6*3.6 ;
F_1 = 1007972;
EnergyPerCycle_1 = (1/F_1)*P_1;

Chkp_cycles_1MHz = ChkpHibernus/EnergyPerCycle_1;

OperatingE = 0.5*C*Vmax*Vmax;%uJ. maximum energy
MinimumE = 0.5*C*Vmin*Vmin;%uJ.


C1 = (OperatingE - 0.5*C*3.3*3.3)/EnergyPerCycle_16;
C2 = (0.5*C*3.29*3.29 - 0.5*C*2.8*2.8)/EnergyPerCycle_12;
C3 =  (0.5*C*2.79*2.79 - 0.5*C*2.2*2.2)/EnergyPerCycle_8;
C4 =  (0.5*C*2.19*2.19 - 0.5*C*1.8*1.8)/EnergyPerCycle_1;

% Value to be set by FindFrequency Function
if(opt==1)
    T = (1/F_16);
    Total_Cap_Cycles = DVFS_Cycles;
elseif(opt==2)
    T = (1/F_16);
    Total_Cap_Cycles = Cycles_16MHz;
elseif(opt==3)
    T = (1/F_12);
    Total_Cap_Cycles = Cycles_12MHz;
elseif(opt==4)
    T = (1/F_8);
    Total_Cap_Cycles = Cycles_8MHz;
elseif(opt==5)
    T = (1/F_1);
    Total_Cap_Cycles = Cycles_1MHz;
end

if(opt==1 && DVFS_Cycles <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    Time=0;
    fprintf('DVFS: %d : Cant run \n',C);
    return;
elseif(opt==2 && Cycles_16MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    Time=0;
    fprintf('16MHz: %d : Cant run \n',C);
    return;
elseif(opt==3 && Cycles_12MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    Time=0;
    fprintf('12MHz: %d : Cant run \n',C);
    return;
elseif(opt==4 && Cycles_8MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    Time=0;
    fprintf('8MHz: %d : Cant run \n',C);
    return;
elseif(opt==5 && Cycles_1MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    Time=0;
    fprintf('1MHz: %d : Cant run \n',C);
    return;
end

CheckpointCounter=0;
Cycles=0;
m=1;
Total_Cycles = Total_Cap_Cycles;
single_powercycle_CC = 0;
timeMilli = 0;
while( m < N )
    if(opt==1)
        if (single_powercycle_CC <= C1)
            T = (1/F_16);
        elseif (single_powercycle_CC <= C1+C2)
            T = (1/F_12);
        elseif (single_powercycle_CC <= C1+C2+C3)
            T = (1/F_8);
        else
            T = (1/F_1);
        end
    end    
    if (Total_Cycles > Chkp_cycles_1MHz + InstructionCC(m))
        Total_Cycles = Total_Cycles - InstructionCC(m);
        Cycles=Cycles+InstructionCC(m);
        timeMilli = timeMilli+ InstructionCC(m)*T;
        single_powercycle_CC = single_powercycle_CC + InstructionCC(m);
        Time = Time + InstructionCC(m)*T;
    else
        CheckpointCounter=CheckpointCounter+1;
        Total_Cycles = Total_Cap_Cycles;
        single_powercycle_CC = 0;
        Cycles=Cycles+InstructionCC(m)+Chkp_cycles_1MHz;
        timeMilli = timeMilli+ InstructionCC(m)*T;
        Time = Time + InstructionCC(m)*T+Chkp_cycles_1MHz*(1/F_1);%ChkpTime;
    end
    
    
    
    m=m+1;
end
%fprintf('Checkpoints: %d , Time: %f, M: %d\n',CheckpointCounter,Time,m);
end

