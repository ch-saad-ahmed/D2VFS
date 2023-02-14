function [CheckpointCounter,Time]=MCU_Simulator_Decay_MementOS (C,Vmin,Vmax,InstructionCC,DVFS_Cycles,Cycles_16MHz,Cycles_12MHz,Cycles_8MHz,Cycles_1MHz,checkpoint_size, max_cycles,opt)

N = size(InstructionCC,1);
energy_per_byte = 0.172838; %uJ //0.18ms*(360uA*3.3)
time_per_byte = 0.00018;
%checkpoint_size = 512;
ChkpMementOS = (checkpoint_size)*energy_per_byte;%uJ FRAM
ChkpTime = checkpoint_size*time_per_byte;
Time=0;

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

Chkp_cycles_1MHz = ChkpMementOS/EnergyPerCycle_1;

OperatingE = 0.5*C*Vmax*Vmax;%uJ. maximum energy
MinimumE = 0.5*C*Vmin*Vmin;%uJ.

C1 = (OperatingE - 0.5*C*3.3*3.3)/EnergyPerCycle_16;
C2 = (0.5*C*3.29*3.29 - 0.5*C*2.8*2.8)/EnergyPerCycle_12;
C3 =  (0.5*C*2.79*2.79 - 0.5*C*2.2*2.2)/EnergyPerCycle_8;
C4 =  (0.5*C*2.19*2.19 - 0.5*C*1.8*1.8)/EnergyPerCycle_1;


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


if(opt==1 && DVFS_Cycles <= Chkp_cycles_1MHz + max_cycles)
    CheckpointCounter = 0;
    Time=0;
    fprintf('DVFS: %d : Cant run \n',C);
    return;
elseif(opt==2 && Cycles_16MHz <= Chkp_cycles_1MHz + max_cycles)
    CheckpointCounter = 0;
    Time=0;
    fprintf('16MHz: %d : Cant run \n',C);
    return;
elseif(opt==3 && Cycles_12MHz <= Chkp_cycles_1MHz + max_cycles)
    CheckpointCounter = 0;
    Time=0;
    fprintf('12MHz: %d : Cant run \n',C);
    return;
elseif(opt==4 && Cycles_8MHz <= Chkp_cycles_1MHz + max_cycles)
    CheckpointCounter = 0;
    Time=0;
    fprintf('8MHz: %d : Cant run \n',C);
    return;
elseif(opt==5 && Cycles_1MHz <= Chkp_cycles_1MHz + max_cycles)
    CheckpointCounter = 0;
    Time=0;
    fprintf('1MHz: %d : Cant run \n',C);
    return;
end

CheckpointCounter=0;
Cycles=0;
m=1;
Total_Cycles = Total_Cap_Cycles;
single_power_CC=0;
t=0;
if(opt==1)
    while( m < N )
        if (Cycles <= C1)
            T = (1/F_16);
        elseif (Cycles <= C1+C2)
            T = (1/F_12);
        elseif (Cycles <= C1+C2+C3)
            T = (1/F_8);
        else
            T = (1/F_1);
        end

%         if (single_power_CC <= C1)
%             T = (1/F_16);
%         elseif (single_power_CC <= C1+C2)
%             T = (1/F_12);
%         elseif (single_power_CC <= C1+C2+C3)
%             T = (1/F_8);
%         else
%             T = (1/F_1);
%         end
        
        if (InstructionCC(m)==-99)
            m=m+1;
            if( (Total_Cycles - Chkp_cycles_1MHz) > max_cycles )
                if (Total_Cycles > Chkp_cycles_1MHz + max_cycles + InstructionCC(m))
                    Total_Cycles = Total_Cycles - InstructionCC(m);
                    Cycles=Cycles+InstructionCC(m);
                    %single_power_CC = single_power_CC+ InstructionCC(m);
                    Time = Time + InstructionCC(m)*T;
                else
                    CheckpointCounter=CheckpointCounter+1;
                    
                    Total_Cycles = Total_Cap_Cycles;
                    Total_Cycles = Total_Cycles - InstructionCC(m);
                    %single_power_CC = InstructionCC(m);
                    Cycles=Cycles+InstructionCC(m)+Chkp_cycles_1MHz;
                    Time = Time + InstructionCC(m)*T+Chkp_cycles_1MHz*(1/F_1);%ChkpTime;
                end
            else
                CheckpointCounter=CheckpointCounter+1;
                Total_Cycles = Total_Cap_Cycles;
                single_power_CC = 0;
                Total_Cycles = Total_Cycles - InstructionCC(m);
                Cycles=Cycles+InstructionCC(m)+Chkp_cycles_1MHz;
                Time = Time + InstructionCC(m)*T+Chkp_cycles_1MHz*(1/F_1);%ChkpTime;
            end
        else
            %temp_cycles = temp_cycles + InstructionCC(m);
            if (Total_Cycles > Chkp_cycles_1MHz +  InstructionCC(m))
                Total_Cycles = Total_Cycles - InstructionCC(m);
                Cycles=Cycles+InstructionCC(m);
                Time = Time + InstructionCC(m)*T;
            else
                %System unable to execute with current trigger call placement
                fprintf("Cant Run\n");
                return;
            end
        end
        m=m+1;
    end
else
    
    while( m < N )
        if (InstructionCC(m)==-99)
            m=m+1;
            if( (Total_Cycles - Chkp_cycles_1MHz) > max_cycles )
                if (Total_Cycles > Chkp_cycles_1MHz + max_cycles + InstructionCC(m))
                    Total_Cycles = Total_Cycles - InstructionCC(m);
                    Cycles=Cycles+InstructionCC(m);
                    Time = Time + InstructionCC(m)*T;
                else
                    CheckpointCounter=CheckpointCounter+1;
                    Total_Cycles = Total_Cap_Cycles;
                    Total_Cycles = Total_Cycles - InstructionCC(m);
                    Cycles=Cycles+InstructionCC(m)+Chkp_cycles_1MHz;
                    Time = Time + InstructionCC(m)*T+Chkp_cycles_1MHz*(1/F_1);%ChkpTime;
                end
            else
                CheckpointCounter=CheckpointCounter+1;
                Total_Cycles = Total_Cap_Cycles;
                Total_Cycles = Total_Cycles - InstructionCC(m);
                Cycles=Cycles+InstructionCC(m)+Chkp_cycles_1MHz;
                Time = Time + InstructionCC(m)*T+Chkp_cycles_1MHz*(1/F_1);%ChkpTime;
            end
        else
            %temp_cycles = temp_cycles + InstructionCC(m);
            if (Total_Cycles > Chkp_cycles_1MHz +  InstructionCC(m))
                Total_Cycles = Total_Cycles - InstructionCC(m);
                Cycles=Cycles+InstructionCC(m);
                Time = Time + InstructionCC(m)*T;
            else
                %System unable to execute with current trigger call placement
                fprintf("Cant Run\n");
                return;
            end
        end
        m=m+1;
    end
    
    
end
fprintf('Checkpoints: %d , Time: %f, M: %d\n',CheckpointCounter,Time,m);
end