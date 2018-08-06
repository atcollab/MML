Setpoint_machine=machset;
Setpoint_design=v81set;
Setpoint_new=lbyset;

multi_families={'QF'; 'QD'};
single_families={'BEND'; 'QFC'; 'QDX'; 'QFX'; 'QDY'; 'QFY'; 'QDZ'; 'SF'; 'SD'; 'SFM'; 'SDM'};


fprintf('%50s\n', 'family   device  design    machine   lowbety     delta (%)');

for k=1:length(multi_families)
   family=multi_families{k};
   fprintf('%s \n',family);
   for j=1:length(Setpoint_machine.(family).Data)
        DeviceList=Setpoint_machine.(family).DeviceList;
        d=Setpoint_design.(family).Data(j);
        m=Setpoint_machine.(family).Data(j);
        l=Setpoint_new.(family).Data(j);
        delta1=100*(m-d)/d;
        delta2=100*(l-m)/m;
        fprintf('%s %d %s %d %s  %12.3f %12.3f %12.3f %12.3f  %12.3f %s\n','[',DeviceList(j,1),' ,',DeviceList(j,2),']', d, m,l,delta1,delta2,' %');
   end

end

for k=1:length(single_families)
   family=single_families{k};
   d=Setpoint_design.(family).Data(1);
   m=Setpoint_machine.(family).Data(1);
   l=Setpoint_new.(family).Data(1);
   delta1=100*(m-d)/d;
   delta2=100*(l-m)/m;
   fprintf('%5s %12.3f %12.3f %12.3f %12.3f  %12.3f %s\n', family,d, m,l,delta1,delta2,' %');
end
