function mycallback_steerette_point_V(arg1,arg2,hObject, eventdata, handles)

% replot des points BPM successifs aux correcteurs selectionn�s
h3     = get(handles.axes3,'Children');
hline4 = findobj(h3,'-regexp','Tag','line[4]');
BPMz = getappdata(handles.figure1,'BPMz');
VCOR = getappdata(handles.figure1,'VCOR');
valCV = getappdata(handles.figure1,'n_selection_CV');

%a% version anneau
%[orbite_x,orbite_z] = getbpm;

%t% version transport
% % % X0 = getappdata(handles.figure1,'orbite_entry');
% % % BPMindex = family2atindex('BPMx');
% % % global THERING
% % % nb = 1;
% % % X01 = zeros(nb, 6, length(THERING)+1);
% % % for k=1:nb,
% % %     X01(k,:,:) = linepass(THERING, X0, 1:length(THERING)+1);
% % %     %X0 = X01(k,:,end)';
% % % end
% % % orbite_x = squeeze(X01(:,1,BPMindex))'*1000;
% % % orbite_z = squeeze(X01(:,3,BPMindex))'*1000;



orbite_x = getappdata(handles.figure1,'orbite_x');
orbite_z = getappdata(handles.figure1,'orbite_z');


% X0 = getappdata(handles.figure1,'orbite_entry');
% nP = size(X0,2);
% BPMindex = family2atindex('BPMz');
% global THERING
% nbtour = 1;
% X01 = zeros(nbtour, 6, nP*length(BPMindex));
% 
% for k=1:nbtour,
%     X01(k,:,:) = linepass(THERING, X0, BPMindex);
%     %X0 = X01(k,:,end)';
% end
% Xa = squeeze(X01(1,1,:));
% Za = squeeze(X01(1,3,:));
% if nP>1
%     %X = [];
%     Z = [];
%     for nBPM = 1:length(BPMindex)
%         %X = [X mean(Xa((nP*(nBPM-1)+1):nP*nBPM))];
%         Z = [Z mean(Za((nP*(nBPM-1)+1):nP*nBPM))];
%     end
%     %orbite_x = X'*1000;
%     orbite_z = Z'*1000;
% else
%     %orbite_x = Xa*1000;
%     orbite_z = Za*1000;
% end

if valCV>0
    for k = valCV:length(BPMz.Position)
        if BPMz.Position(k) > VCOR.Position(valCV)
            setappdata(handles.figure1,'n_selection_BPMz',k)
            set(hline4(1),'XData', BPMz.Position(k), 'YData', orbite_z(k),'Visible','On');
            break
        end
    end
end