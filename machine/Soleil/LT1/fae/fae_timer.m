function fae_timer(arg1,arg2,hObject, eventdata, handles)


% device_name = getappdata(handles.figure1,'device_name');
% dev=device_name.dipole;
% structure = tango_read_attribute(device_name.dipole,'current');
% Idip = structure.value(1);
% 
% B0 = getappdata(handles.figure1,'B0');
% B1 = getappdata(handles.figure1,'B1');
% 
% Integrale = B0 + B1 * Idip;
% angle = 15 * pi / 180;
% Bro = Integrale / angle;
% E0 = 0.512 ;
% energie = E0 * ( sqrt(1 + (Bro*0.29979)*(Bro*0.29979)/((E0*0.001)*(E0*0.001))) - 1 );
% set(handles.repositionner_edit3,'String',num2str(energie));
% 


E0 = 0.51099906 ;
% energie totale en GeV
energie = getenergy('online');
set(handles.repositionner_edit3,'String',num2str(energie*1e3 - E0));
%disp('on rentre dans fae_timer')