function [Voltage,Current,Frequency,Vth]= Find_I_F(Vcc)
global voltagefrequencyCurrent1MHz;
global voltagefrequencyCurrent8MHz;
global voltagefrequencyCurrent12MHz;
global voltagefrequencyCurrent16MHz;
    if(Vcc>=3.3)
        Frequency=voltagefrequencyCurrent16MHz.FrequencyHz;
        Current=voltagefrequencyCurrent16MHz.CurrentuA;
        Voltage = voltagefrequencyCurrent16MHz.VoltageV;
        Vth = 3.3;
    elseif(Vcc>=2.8)
        Frequency=voltagefrequencyCurrent12MHz.FrequencyHz;
        Current=voltagefrequencyCurrent12MHz.CurrentuA;
        Voltage = voltagefrequencyCurrent12MHz.VoltageV;
        Vth = 2.8;
    elseif(Vcc >=2.2)
        Frequency=voltagefrequencyCurrent8MHz.FrequencyHz;
        Current=voltagefrequencyCurrent8MHz.CurrentuA;
        Voltage = voltagefrequencyCurrent8MHz.VolatgeV;
        Vth = 2.2;
    else
        Frequency=voltagefrequencyCurrent1MHz.FrequencyHz;
        Current=voltagefrequencyCurrent1MHz.CurrentuA;
        Voltage = voltagefrequencyCurrent1MHz.VolatgeV;
        Vth = 1.8;
    end
end
