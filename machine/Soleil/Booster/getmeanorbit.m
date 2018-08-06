function [Xmean Zmean] = getmeanorbit(varargin)
% GETMEANORBIT - Compute mean orbit using turn by turn data
%
%  INPUTS
%  1.
%
%  OUPUTS
%  1. Xmean - Mean horizontal orbit 
%  2. Z mean - Mean vertical orbit
%

%
%  Written by Laurent S. Nadolski

DisplayFlag = 1;

% Option parser
for i = length(varargin):-1:1
    if strcmpi(varargin{i},'Display')
        DisplayFlag = 1;
        varargin(i) = [];
    elseif strcmpi(varargin{i},'NoDisplay')
        DisplayFlag = 0;
        varargin(i) = [];
    end
end


istart = 27;     % depart lecture BPM
iend = 400;      % fin lecture BPM

bpmdata  = getbpmrawdata([],'nodisplay','struct');

Xmean = mean(bpmdata.Data.X(:,istart:iend)');
Zmean = mean(bpmdata.Data.Z(:,istart:iend)');

if DisplayFlag
    figure(103);   
    posvect = getspos('BPMx');
    h1 = subplot(7,1,[1 3]);    
    plot(posvect, Xmean,'r.-');
    grid on
    ylabel('X (mm)');
    axis([0 getcircumference -11 11]);
    title(['Mean orbit between ' num2str(istart) ' and ' num2str(iend) ' turns']);
    ylim([-5 5])
    
    h2 = subplot(7,1,4);
    drawlattice; hold on;
    set(h2,'XTick',[],'YTick',[]);
    
    h3 = subplot(7,1,[5 7]);
    plot(posvect, Zmean,'b.-');
    grid on       
    xlabel('s (mm)')
    ylabel('Z (mm)'); 
    ylim([-5 5])

    % links axes
    linkaxes([h1 h2 h3],'x');           
end
