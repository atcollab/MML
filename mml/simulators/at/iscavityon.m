function Test = iscavityon
%ISCAVITYON - True is there is a powered cavity in THERING
%  Boolean = iscavityon
%
%  See also getcavity, setcavity, setradiation

%  Written by Greg Portmann


CavityState = getcavity;

if strcmpi(CavityState, 'Off')
    Test = 0;
else
    Test = 1;
end
