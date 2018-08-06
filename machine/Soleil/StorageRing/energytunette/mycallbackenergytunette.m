function mycallbackenergytunette(arg1,arg2,hObject, eventdata, handles)

%BPMx = getappdata(handles.figure1,'BPMx');
%BPMz = getappdata(handles.figure1,'BPMz');
BPMxList = getappdata(handles.figure1,'BPMxList');

% replot des orbites
h     = get(handles.axes2,'Children');
hline = findobj(h,'-regexp','Tag','line[1,2]');

s  = getspos('BPMx',BPMxList);
[X Z Sum] = anabpmfirstturn( BPMxList ,'MaxSum','NoDisplay');
orbite_x = X'; % mm
orbite_z = Z'; % en mm
setappdata(handles.figure1,'orbite_x',orbite_x);
setappdata(handles.figure1,'orbite_z',orbite_z);


% linegraphes
set(hline(2),'XData',s,'YData',orbite_x,'Visible','On');
set(hline(1),'XData',s,'YData',orbite_z,'Visible','On');


