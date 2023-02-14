function [Cycles,Time]= Cycles_DVFS (C,Vmin,Vmax,opt)

global voltagefrequencyCurrent1MHz;
global voltagefrequencyCurrent16MHz;

MinimumE = 0.5*C*Vmin*Vmin;% uJ
OperatingE = 0.5*C*Vmax*Vmax;% uJ
TotalE = OperatingE;
Vcurrent = Vmax;
Cycles = 0;
cycle=0;
Time = 0;
Vth=0;
TE_16=0;
TE_12=0;
TE_8=0;
TE_1=0;
TE_DVFS=0;
%Volt=zeros(size,1);
%Energy=zeros(size,1);

[Voltage,Current,Frequency, Vth] = Find_I_F(3.6);
if(opt==1)
    while (Vcurrent > Vmin)
        pVth=Vth;
        if(abs(Vcurrent-3.3)<=0.0001 || abs(Vcurrent-2.8)<=0.0001|| abs(Vcurrent-2.2)<=0.0001 || abs(Vcurrent-1.8)<=0.0001)
            [Voltage,Current,Frequency, Vth] = Find_I_F(Vcurrent);
        end
        [D1,D2,D3,Reg_Pow] = Detect_I(Vcurrent);
        [val,Index]=min(abs(Voltage - Vth));
        F = Frequency(Index);
        I = Current(Index);
        T = (1/F);
        
        EnergyPerCycle = Vth*I*T+(D1+D2+2*D3)*T+Reg_Pow*T+(8+20+0.9)*Vcurrent*T;%uJ static power dissipation
        
        if(pVth~=Vth)
            transientEnergy = 0.15*Vcurrent^2;
            EnergyPerCycle=EnergyPerCycle+transientEnergy;
        end
        
        Cycles = Cycles + 1;
        cycle=cycle+1;
        Time=Time+T;
        TotalE = TotalE - EnergyPerCycle;
        Vcurrent=sqrt(2*TotalE/C);
    end
elseif(opt==2)
    %16MHz
    Vmin=3.3;
    [Voltage,Current,Frequency] = Find_I_F(3.3);
    while (Vcurrent > Vmin)
        [val,Index]=min(abs(Voltage - Vcurrent));
        F = Frequency(Index);
        I = Current(Index);
        T = (1/F);
        EnergyPerCycle = Vcurrent*I*T;%uJ
        
        TE_16=TE_16+EnergyPerCycle;
        Cycles = Cycles + 1;
        Time=Time+T;
        TotalE = TotalE - EnergyPerCycle;
        
        Vcurrent=sqrt(2*TotalE/C);
    end
elseif(opt==3)
    %12MHz
    Vmin=2.8;
    [Voltage,Current,Frequency] = Find_I_F(2.8);
    while (Vcurrent > Vmin)
        [val,Index]=min(abs(Voltage - Vcurrent));
        F =  Frequency(Index);
        I = Current(Index);
        T = (1/F);
        EnergyPerCycle = Vcurrent*I*T;%uJ
        
        Cycles = Cycles + 1;
        Time=Time+T;
        TotalE = TotalE - EnergyPerCycle;
        Vcurrent=sqrt(2*TotalE/C);
    end
elseif(opt==4)
    %8MHz
    Vmin=2.2;
    [Voltage,Current,Frequency] = Find_I_F(2.2);
    while (Vcurrent > Vmin)
        [val,Index]=min(abs(Voltage - Vcurrent));
        F =  Frequency(Index);
        I = Current(Index);
        T = (1/F);
        EnergyPerCycle = Vcurrent*I*T;%uJ
        
        Cycles = Cycles + 1;
        %Volt(Cycles) = Vcurrent;
        %Energy(Cycles) = EnergyPerCycle;
        Time=Time+T;
        TotalE = TotalE - EnergyPerCycle;
        TE_8=TE_8+EnergyPerCycle;
        Vcurrent=sqrt(2*TotalE/C);
    end
elseif(opt==5)
    %1MHz
    [Voltage,Current,Frequency] = Find_I_F(1.8);
    while (Vcurrent > Vmin)
        [val,Index]=min(abs(Voltage - Vcurrent));
        F =  Frequency(Index);
        I = Current(Index);
        T = (1/F);
        EnergyPerCycle = Vcurrent*I*T;%uJ
        Cycles = Cycles + 1;
        %Volt(Cycles) = Vcurrent;
        %Energy(Cycles) = EnergyPerCycle;
        Time=Time+T;
        TotalE = TotalE - EnergyPerCycle;
        Vcurrent=sqrt(2*TotalE/C);
    end
end
%TE_8
%TE_DVFS
end


















































































































































































































































































