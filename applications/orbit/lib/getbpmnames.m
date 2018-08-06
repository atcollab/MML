%=============================================================
function [varargout] = getbpmnames
%=============================================================
%Return BPM names in varargout{1}

families={'BPMx'; 'BPMy'};

for k=1:2
  family=families{k};
  bpm(k).name=getfamilydata(family,'CommonNames');   
  bpm(k).z=getfamilydata(family,'Position');   
end
   
varargout{1}=bpm;
