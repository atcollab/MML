function setrange(family)
%SETRANGE - read min and max value from TANGO static DB and set AO
%structure
%
%  INPUTS
%  1. family - FamilyName

%
%  Written by Laurent S. Nadolski

if isfamily(family)
    AO = getao;
    [s idx] = family2status(family);
    AO.(family).Monitor.Range(idx,1) = tango_get_attribute_property(family,'min_value','Double');
    AO.(family).Monitor.Range(idx,2) = tango_get_attribute_property(family,'max_value','Double');
    AO.(family).Setpoint.Range = AO.(family).Monitor.Range;
    AO.(family).Desired.Range = AO.(family).Monitor.Range;
    setao(AO);
else
    warning('%s is not a valid family',family)
end

