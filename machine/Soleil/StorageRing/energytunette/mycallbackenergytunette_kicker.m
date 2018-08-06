function mycallbackenergytunette_kicker(arg1,arg2,hObject, eventdata, handles)

% replot du bump kicker
h     = get(handles.axes1,'Children');
hline = findobj(h,'-regexp','Tag','line[1]');

val_HW14 = getsp('K_INJ1');
val_HW23 = getsp('K_INJ2');
val_ph1 = hw2physics('K_INJ1','Setpoint',val_HW14(1));
val_ph4 = hw2physics('K_INJ1','Setpoint',val_HW14(2));
val_ph2 = hw2physics('K_INJ2','Setpoint',val_HW23(1));
val_ph3 = hw2physics('K_INJ2','Setpoint',val_HW23(2));
teta1 = val_ph1(1)*1e3; % mrad
teta2 = val_ph2(1)*1e3;
teta3 = val_ph3(1)*1e3;
teta4 = val_ph4(1)*1e3;
% pas génial, il vaudrait mieux utiliser THERING en reperant les elements et
% deduire les espaces entre equipements
X1 = 0;X2 = 1;X3 = 4.002;X4 = 8.227;X5 = 11.229;X6 = 13;
Ymax = 20;Ymin = -25;
Xdata = [ X1 X2 X3 X4 X5 X6];
V1 = [0 0]';
V2 = [1 (X2-X1);0 1]*V1 + [0 teta1]';
V3 = [1 (X3-X2);0 1]*V2 + [0 teta2]';
V4 = [1 (X4-X3);0 1]*V3 + [0 teta3]';
V5 = [1 (X5-X4);0 1]*V4 + [0 teta4]';
V6 = [1 (X6-X5);0 1]*V5;
Ydata = [V1(1) V2(1) V3(1) V4(1) V5(1) V6(1)];
refreshdata(handles.axes1);

% linegraphes
set(hline(1),'XData',Xdata,'YData',Ydata,'Visible','On');


