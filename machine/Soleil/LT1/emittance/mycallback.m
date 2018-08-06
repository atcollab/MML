 function mycallback(arg1,arg2,hObject, eventdata, handles)

axes1=findobj(allchild(handles.figure1),'Tag','axes1');
rowmax=513;
columnmax=701;
%toto=faisceau_sansimage(rowmax,columnmax,rowmax/10,columnmax/5,rowmax/2,columnmax/2,20);
%image(toto,'CDataMapping','scaled','Parent',handles.axes1)

    %dev='lt1/dg/emit-vg';

    device_name = getappdata(handles.figure1,'device_name');

    axes1=findobj(allchild(handles.figure1),'Tag','axes1');

    %axes(handles.axes1);

    %disp('on rentre dans mycallback')
    dev=device_name.videograbber;

    toto=tango_read_attribute(dev,'image');
    %image(toto.value,'CDataMapping','scaled');
    image(toto.value,'CDataMapping','scaled','Parent',handles.axes1)

    %imagesc(toto.value,'Parent',handles.axes1);
    colormap(gray);

% 
%     %     xdata=1:columnmax+1;
%     %     ValMaxc=max(sumcolumn);ValMinc=min(sumcolumn);
%     %     x0=[10 250 ValMaxc];
%     %     %plot du r�sultat
%     %     F=ac(3)*exp(-(xdata-ac(2)).*(xdata-ac(2))/(2*ac(1)*ac(1)));
%     %     name=['axes' num2str(2)];
%     %     axes(handles.(name));
%     %     plot(xdata,sumcolumn,'k-');
%     %     xlim([0 length(sumcolumn)])
%     %     hold on
%     %     plot(xdata,F,'b-')
%     %     hold off
% 
% 
