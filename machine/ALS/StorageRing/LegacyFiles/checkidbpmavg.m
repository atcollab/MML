function checkidbpmavg(TestHz, list)
% checkidbpmavg(TestHz {2 Hz}, IDBPMlist {default: all IDBPMs returned by getlist})
%
%   This function checks that the number of averages for the IDBPMs in IDBPMlist
%   is set so that the data rate is greater than TestHz Hertz.  The assumption
%   is that 2700 averages is 2 Hz.  If not, this function will prompt the user
%   to change the number of averages.
%

if nargin < 1
   TestHz = 2;
end

if nargin < 2
   list = getlist('IDBPMx');
end
if size(list,2) == 1
   list = elem2dev('IDBPMx', list);
end

TestHz = abs(TestHz(1,1));
if TestHz < .001
   return
end


Avg = getidbpmavg;
TestAvg = floor(2*2700/TestHz);
if TestAvg < 1
   TestAvg = 1;
   disp('  WARNING:  the requested IDBPM data rate is too high.');
   disp('            10 Hz is about all the control system is capable of doing.');
end

if any(Avg > TestAvg)
   % Prompt to change the number of averages
   titlestr=sprintf('Change the number of IDBPM averages.');
   prompt={strvcat( ...
         sprintf('At least one of the IDBPM averages is set too high (%d averages).',  max(Avg)),  ...
         sprintf('The IDBPM data rate is crucial for many functions to work properly.'), ...
         sprintf('5400 averages corresponds to 1 Hz data rate.'), ...
         sprintf('%.1f Hertz -> %d averages recommended.', TestHz, TestAvg), ...
         sprintf(' '), ...
         sprintf('Enter the new IDBPM averages:'))};
   def={num2str(TestAvg)};
   lineNo=1;
   answer=inputdlg(prompt,titlestr,lineNo,def);
   
   if isempty(answer)
      disp('  No changes made to the number of IDBPM averages.  You''re on your own!');
      return
   end
   AvgNew = str2num(answer{1});
   if isempty(AvgNew)
      disp('  No changes made to the number of IDBPM averages.  You''re on your own!');
      return
   end
   if AvgNew > TestAvg
      fprintf('  I think %d IDBPM averages is too high, but you''re the boss.\n', AvgNew);
   end
   setidbpmavg(AvgNew);
end
