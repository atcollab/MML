function Answer = isradiationon
%ISRADIATIONON - 1 if a radiation passmethod is found
%
%  See also setradiation, getcavity, setcavity

%  Written by Greg Portmann



global THERING

Answer = 0;

localindex = findcells(THERING,'PassMethod','StrMPoleSymplectic4RadPass');
if ~isempty(localindex)
    Answer = 1;
    return;
end

localindex = findcells(THERING,'PassMethod','BndMPoleSymplectic4RadPass');
if ~isempty(localindex)
    Answer = 1;
end

