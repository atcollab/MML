function checkbpmavg(TestHz, list)
% checkbpmavg(TestHz {2 Hz}, BPMlist {default: all BPMs returned by getlist})
%
%   This function checks that the number of averages for the BPMs in BPMlist
%   is set so that the data rate is at least TestHz Hertz.  The assumption
%   is that 190 averages is 2 Hz.  If not, this function will prompt the user
%   to change the number of averages.
%

if nargin < 1
   TestHz = 2;
end

if nargin < 2
   list = family2dev('BPMx');
end
if size(list,2) == 1
   list = elem2dev('BPMx', list);
end

TestHz = abs(TestHz(1,1));
if TestHz < .001
   return
end


Avg = getbpmaverages;
TestAvg = floor(2*190/TestHz);
if TestAvg < 1
   TestAvg = 1;
   disp('  WARNING:  the requested BPM data rate is too high.');
   disp('            10 Hz is about all the control system is capable of doing.');
end

if any(Avg > TestAvg)
   % Prompt to change the number of averages
   titlestr=sprintf('Change the number of BPM averages.');
   prompt={strvcat( ...
         sprintf('At least one of the BPM averages is set too high (%d averages).',  max(Avg)),  ...
         sprintf('The BPM data rate is crucial for many functions to work properly.'), ...
         sprintf('380 averages corresponds to 1 Hz data rate.'), ...
         sprintf('%.1f Hertz -> %d averages recommended.', TestHz, TestAvg), ...
         sprintf(' '), ...
         sprintf('Enter the new BPM averages:'))};
   def={num2str(TestAvg)};
   lineNo=1;
   answer=inputdlg(prompt,titlestr,lineNo,def);
   
   if isempty(answer)
      disp('  No changes made to the number of BPM averages.  You''re on your own!');
      return
   end
   AvgNew = str2num(answer{1});
   if isempty(AvgNew)
      disp('  No changes made to the number of BPM averages.  You''re on your own!');
      return
   end
   if AvgNew > TestAvg
      fprintf('  I think %d BPM averages is too high, but you''re the boss.\n', AvgNew);
   end
   setbpmaverages(AvgNew);
end
