function [D1,D2,D3,Reg_Pow]= Detect_I(Vcc)
load Detection.mat detect1MHz detect8MHz detect12MHz detect16MHz
%global data_1MHz data_8MHz data_12MHz data_16MHz;
%load('Detection.mat');
if(Vcc>=3.3)
   Voltage=detect16MHz.Voltage;
   [val,id]=min(abs(Voltage - Vcc)); 
   D1 = detect16MHz.Detector3(id);
   D2 = detect16MHz.Detector1(id);
   D3 = detect16MHz.Detector2(id);
   Reg_Pow = (3.3*10*0.1111);   
elseif(Vcc>=2.8)
   Voltage=detect12MHz.Voltage;
   [val,id]=min(abs(Voltage - Vcc)); 
   D1 = detect12MHz.Detector3(id);
   D2 = detect12MHz.Detector1(id);
   D3 = detect12MHz.Detector2(id);
   Reg_Pow = (2.8*30*0.1111);
elseif(Vcc >=2.2)
   Voltage=detect8MHz.Voltage;
   [val,id]=min(abs(Voltage - Vcc)); 
   D1 = detect8MHz.Detector3(id);
   D2 = detect8MHz.Detector1(id);
   D3 = detect8MHz.Detector2(id);
   Reg_Pow = (2.2*100*0.1111); 
else
   Voltage=detect1MHz.Voltage;
   [val,id]=min(abs(Voltage - Vcc)); 
   D1 = detect1MHz.Detector3(id);
   D2 = detect1MHz.Detector1(id);
   D3 = detect1MHz.Detector2(id);
   Reg_Pow = (1.8*100*0.1111); 
end
D1=D1*Vcc;
D2=D2*Vcc;
D3=D3*Vcc;
end
