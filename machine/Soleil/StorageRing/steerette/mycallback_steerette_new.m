function mycallback_steerette_new(arg1,arg2,hObject, eventdata, handles)

%set(handles.date_et_heure_text20,'String',datestr(clock,31));
handles.mode = getappdata(handles.figure1,'Mode');
% % % % replot des orbites  et correcteur H/V
% % % k = getappdata(handles.figure1,'n_selection_BPMx');
% % % h3     = get(handles.axes3,'Children');
% % % hline2 = findobj(h3,'-regexp','Tag','line[1,2,3]');
% % % h9     = get(handles.axes9,'Children');
% % % hbar9  = findobj(h9,'-regexp','Tag','bar[1]');
% % % h10     = get(handles.axes10,'Children');
% % % hbar10  = findobj(h10,'-regexp','Tag','bar[2]');
% % % [orbite_x,orbite_z] = getbpm;
% % % xdata = 1:length(orbite_x);
% % % ydata = 1:length(orbite_z);
% % % zdata = k;
% % % 
% % % liste_HCOR = getam('HCOR');
% % % liste_VCOR = getam('VCOR'); 
% % % 
% % % % linegraphes
% % % set(hline2(3),'XData',xdata,'YData',orbite_x,'Visible','On');
% % % set(hline2(2),'XData',ydata,'YData',orbite_z,'Visible','On');
% % % %set(hline2(1),'XData',zdata,'YData',orbite_x(zdata),'Visible','On');
% % % 
% % % % bargraphes
% % % set(hbar9(1),'YData',liste_HCOR,'Visible','On');
% % % set(hbar10(1),'YData',liste_VCOR,'Visible','On');

mycallback_steerette_point_H(1,1,hObject, eventdata, handles)
mycallback_steerette_point_V(1,1,hObject, eventdata, handles)
mycallback_steerette_orbites(1,1,hObject, eventdata, handles)
mycallback_steerette_corr(1,1,hObject, eventdata, handles)
disp('un coup')


