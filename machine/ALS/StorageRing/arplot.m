function [yout, ivecout] = arplot(ChanName, LineType);
% function [y, ivec] = arplot(ChanName, LineType);
%
%   ChanName = EPICS channel name (automatically places a wild card at the end)
%   LineType = 0 color plot, solid line type {default}
%            = 1 (else) BW plot, differend line types 
%                         {for printing on BW printer}
%
%   Outputs:  y = raw data (each row is a channel)
%             ivec = indices in the ARChanNames matrix which match ChannelName
%
%   Some Interesting Channels:   SR05S___DCCTLP
%                                SR07U___GDS1
%                                SR01C___B
%                                SR01C___BPM?


global ARt ARData ARChanNames ARDate


if nargin == 1
   LineType = 0;
end


% Get data
y=[]; ivec=[];
for i=1:size(ChanName,1)
   [ynew, ivecnew] = arselect(ChanName(i,:));
   y=[y; ynew];
   ivec=[ivec; ivecnew];
end


% For printing
if LineType ~= 0
   hfig = gcf;
   set(hfig, 'DefaultAxesColorOrder',[1 1 1]);
   set(hfig, 'DefaultAxesLineStyleOrder','-|--|-.|:');
else
   %hfig = gcf;
   %set(hfig, 'DefaultAxesColorOrder',[1 1 0;1 0 1;0 1 1;1 0 0;0 1 0;0 0 1]);
   %set(hfig, 'DefaultAxesLineStyleOrder','-');
end

if size(ivec) ~= [0 0]
   %clf
   if (size(y,1)==1)
      plot(ARt/60/60, y); grid on; legend off;
      title(ARDate);
      %xlabel('Time since midnight [hours]');
      xlabel('Time [hours]');
      k = find(ARChanNames(ivec,:)=='_');
      ylabelstr = ARChanNames(ivec,:);
      ylabelstr(k) = ' ';
      ylabel(ylabelstr);
      %  elseif (size(y,1)==2)
      %    plotyy(ARt/60/60, y(1,:), ARt/60/60, y(2,:)); grid on; legend off;
      %    title(ARDate);
      %    ylabel(ARChanNames(ivec(1),:));
      %    y2label(ARChanNames(ivec(2),:));
   else 
      plot(ARt/60/60, y); grid on; legend off;
      title(ARDate);
      xlabel('Time [hours]');
      j = 0;
      for i = ivec'
         j=j+1;
         k = find(ARChanNames(i,:)=='_');
         M(j,:) = ARChanNames(i,:); 
         M(j,k) = ' ';
      end
      legend(M);
   end
end

if nargout >= 1
   yout = y;
end

if nargout == 2
   ivecout = ivec;
end

