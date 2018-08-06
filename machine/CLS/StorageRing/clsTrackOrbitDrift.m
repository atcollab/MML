function [Xorbit,Yorbit] = clsTrackOrbitDrift(minutes)
% ----------------------------------------------------------------------------------------------
% $Header: MatlabApplications/acceleratorcontrol/cls/clsTrackOrbitDrift.m 1.2 2007/03/02 09:03:04CST matiase Exp  $
% ----------------------------------------------------------------------------------------------


Xorbit=zeros(minutes,48)';
Yorbit=zeros(minutes,48)';
fprintf('Tracking orbit for %d minutes:\nMinutes: ',minutes);
for i=1:minutes

    xav = zeros(1,48)';
    yav = zeros(1,48)';

    for j=1:60
        xav = xav + getx;
        yav = yav + gety;
        pause(1);
    end    
    Xorbit(:,i) = xav/60;
    Yorbit(:,i) = yav/60;
    fprintf('%d ',i);
end

fprintf('\n\nMeasurement complete ');
%for i=1:48
subplot(2,1,1);surf(Xorbit);xlabel('Xorbit (minutes)');
subplot(2,1,2);surf(Yorbit);xlabel('Yorbit (minutes)');
    %subplot(48,1,i);plot(Xorbit(i,:));buf=sprintf('X %d',i);xlabel(buf);     
    %subplot(48,2,i);plot(Yorbit(i,:));buf=sprintf('Y %d',i);xlabel(buf);     
     
    % end     

% ----------------------------------------------------------------------------------------------
% $Log: MatlabApplications/acceleratorcontrol/cls/clsTrackOrbitDrift.m  $
% Revision 1.2 2007/03/02 09:03:04CST matiase 
% Added header/log
% ----------------------------------------------------------------------------------------------
