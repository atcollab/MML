function [txt, color]=state_txt(txt)
% Manage state string from synchro

tf = isstrprop(txt, 'cntrl');
[C,I] = max(tf);
if I==1
    n=length(txt);
else
    n=I-1;
end
txt=txt(1:n);

if strcmp('Local board is up and running.', txt)
    color='green';
elseif strcmp('Linac system up and running.', txt)
    color='green';  
elseif     strcmp('Local board is up and running. be careful: there is at least 1 soft address', txt)
    color='green';
elseif     strcmp('Local board is no more declenching. all events are equal to 0', txt)
    color='yellow';
elseif     strcmp('Local board is no more declenching. try to execute Update', txt)
    color='magenta';
else
    color='red';
end
    

