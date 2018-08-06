%=============================================================
function [varargout] = getcornames
%=============================================================
%Return COR names in varargout{1}

families={'HCM'; 'VCM'};

for k=1:2
  family=families{k};
  cor(k).name=getfamilydata(family,'CommonNames');   
  cor(k).z=getfamilydata(family,'Position');   
end

varargout{1}=cor;
