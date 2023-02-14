function [CheckpointCounter,TimeMilli,M] = MCU_Simulator (C,Vmin,Vmax,Vsupply,InstructionCC,DVFS_Cycles,Cycles_16MHz,Cycles_12MHz,Cycles_8MHz,Cycles_1MHz,opt)

global voltagefrequencyCurrent1MHz;
global voltagefrequencyCurrent8MHz;
global voltagefrequencyCurrent12MHz;
global voltagefrequencyCurrent16MHz;

traceSize = size(Vsupply,1);
VCurrentLog = zeros(traceSize,1);
N = size(InstructionCC,1);

%%
N = size(InstructionCC,1);
energy_per_byte = 0.172838; %uJ //0.18ms*(360uA*3.3)
time_per_byte = 0.00018;
checkpoint_size = 576;
ChkpHibernus = (checkpoint_size)*energy_per_byte;%uJ FRAM
ChkpTime = checkpoint_size*time_per_byte;
Time=0;


I_16 = 4725;
P_16 =  4725*3.6;
F_16 = 15796892;
EnergyPerCycle_16 = (1/F_16)*P_16;

I_12 = 3692;
P_12 =  3692*3.6;
F_12 = 12176872;
EnergyPerCycle_12 = (1/F_12)*P_12;

I_8 = 2463;
P_8 =  2463*3.6;
F_8 = 7927340;
EnergyPerCycle_8 = (1/F_8)*P_8;

I_1 = 444.6;
P_1 = 444.6*3.6 ;
F_1 = 1007972;
EnergyPerCycle_1 = (1/F_1)*P_1;

Chkp_cycles_1MHz = ChkpHibernus/EnergyPerCycle_1;


% Value to be set by FindFrequency Function
if(opt==1 && DVFS_Cycles <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    TimeMilli=0;
    M=0;
    fprintf('DVFS: %d : Cant run \n',C);
    return;
elseif(opt==2 && Cycles_16MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    TimeMilli=0;
    M=0;
    fprintf('16MHz: %d : Cant run \n',C);
    return;
elseif(opt==3 && Cycles_12MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    TimeMilli=0;
    M=0;
    fprintf('12MHz: %d : Cant run \n',C);
    return;
elseif(opt==4 && Cycles_8MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    TimeMilli=0;
    M=0;
    fprintf('8MHz: %d : Cant run \n',C);
    return;
elseif(opt==5 && Cycles_1MHz <= Chkp_cycles_1MHz)
    CheckpointCounter = 0;
    TimeMilli=0;
    M=0;
    fprintf('1MHz: %d : Cant run \n',C);
    return;
end

%%
R = 30000;  %30 Kohm load used in traces
doubler = 5;
Voltage=0;
Current=0;
Frequency=0;

% Value to be set by FindFrequency Function
if(opt==1)
    [Voltage,Current,Frequency, Vth]=Find_I_F(Vmax);
    [val,Index]=min(abs(Voltage - Vmax));
    F = Frequency(Index);
    I = Current(Index);
    T = (1/F);
    EnergyPerCycle = Vth*I*T;%uJ
elseif(opt==2)
    T = (1/F_16);
    EnergyPerCycle = EnergyPerCycle_16;
    Vmin = 3.3;
elseif(opt==3)
    T = (1/F_12);
    EnergyPerCycle = EnergyPerCycle_12;
    Vmin = 2.8;
elseif(opt==4)
    T = (1/F_8);
    EnergyPerCycle = EnergyPerCycle_8;
    Vmin = 2.2;
elseif(opt==5)
    T = (1/F_1);
    EnergyPerCycle = EnergyPerCycle_1;
    Vmin = 1.8;
end

MinimumE = 0.5*C*Vmin*Vmin;%uJ. min energy for remaining active
OperatingE = 0.5*C*Vmax*Vmax;%uJ. maximum energy


% Counters and Measurement Variables
CheckpointCounter=0;
enable = 0;
m=1;
s=1;
chkp_m=1;
chkFlag=0;
TimeMilli=1;
Vcurrent=0;
WindowTime=0;

while(TimeMilli <= traceSize && m <= N ) % loop with milli second interval trace
    TimeWindowExpires = 0;
    if doubler*Vsupply(TimeMilli) > Vcurrent
        Vcurrent = doubler*Vsupply(TimeMilli) +(Vcurrent-doubler*Vsupply(TimeMilli))*exp(-0.001/(R*C*0.000001));
    end
    
    Energy=0.5*C*Vcurrent^2;%uJ because C is in u
    VCurrentLog(TimeMilli) = Vcurrent;
    
    if (Energy >= OperatingE)
        enable = 1;
    else
        enable = 0;
    end
    while( enable &&~TimeWindowExpires && m <= N)
        if(~chkFlag)
            if(Energy>(MinimumE+ChkpHibernus))
                if(Energy>(MinimumE+ChkpHibernus+InstructionCC(m)*EnergyPerCycle))
                    Energy=Energy-InstructionCC(m)*EnergyPerCycle;
                    
                    if(WindowTime+InstructionCC(m)*T <= 0.001)
                        WindowTime = WindowTime + InstructionCC(m)*T;
                    else
                        WindowTime = InstructionCC(m)*T - ( 1 - WindowTime);
                        TimeWindowExpires = 1;
                    end
                    m=m+1;
                    Vcurrent=sqrt(2*Energy/C);
                    %Check if there is need to switch Frequency
                    if(opt==1)
                        %[Voltage,Current,Frequency,Vth] = Find_I_F(Vcurrent);
                        if(Vcurrent>=3.3)
                            I = I_16;
                            T = (1/F_16);
                            Vth = 3.3;
                            
                        elseif(Vcurrent>=2.8)
                            I = I_12;
                            T = (1/F_12);
                            Vth = 2.8;
                        elseif(Vcurrent >=2.2)
                            I = I_8;
                            T = (1/F_8);
                            Vth = 2.2;
                        else
                            I = I_1;
                            T = (1/F_1);
                            Vth = 1.8;
                        end
                        [D1,D2,D3,Reg_Pow] = Detect_I(Vcurrent);
                        EnergyPerCycle = Vth*I*T+(D1+D2+2*D3)*T+Reg_Pow*T+(8+20+0.9)*Vcurrent*T;
                    end
                else
                    chkFlag = 1;
                end
            elseif(Energy<(MinimumE+ChkpHibernus))
                chkFlag = 1;
            end
        else
            if(WindowTime+(1/F_1) <= 0.001)
                WindowTime = WindowTime + (1/F_1);
                Energy = Energy - EnergyPerCycle_1 ;
                Vcurrent=sqrt(2*Energy/C);
                if(opt==1)
                        if(Vcurrent>=3.3)
                            I = I_16;
                            T = (1/F_16);
                            Vth = 3.3;
                            
                        elseif(Vcurrent>=2.8)
                            I = I_12;
                            T = (1/F_12);
                            Vth = 2.8;
                        elseif(Vcurrent >=2.2)
                            I = I_8;
                            T = (1/F_8);
                            Vth = 2.2;
                        else
                            I = I_1;
                            T = (1/F_1);
                            Vth = 1.8;
                        end
                        [D1,D2,D3,Reg_Pow] = Detect_I(Vcurrent);
                        EnergyPerCycle = Vth*I*T+(D1+D2+2*D3)*T+Reg_Pow*T+(8+20+0.9)*Vcurrent*T;
                        %EnergyPerCycle = Vth*I*T;
                end
                s=s+1;
                if(s==checkpoint_size)
                    CheckpointCounter = CheckpointCounter+1;
                    s=1;
                    chkp_m = m;
                    chkFlag=0;
                    enable=0;
                    TimeWindowExpires = 0;
                end
            else
                WindowTime = 0;
                TimeWindowExpires = 1;
            end
        end
    end
    TimeMilli=TimeMilli+1;
end
M=m;
fprintf('M:\t%d Chkpts:\t%d\n',m,CheckpointCounter);






