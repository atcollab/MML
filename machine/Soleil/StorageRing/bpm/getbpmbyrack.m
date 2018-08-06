function devlist = getbpmlistbyrack(argin);
%GETIDPMLIST - Return devicelist of BPM in a given cell
%
%  OUTPUT
%  1. rack number 
%

%
%  Written by Laurent S. Nadolski

cellNumber = argin;
elem = family2elem('BPMx');

switch cellNumber
    case 1
        elem = elem(1:7);
    case 2
        elem = elem(8:15);
    case 3
        elem = elem(16:23);
    case 4
        elem = elem(24:30);
    case 5
        elem = elem(31:37);
    case 6
        elem = elem(38:45);
    case 7
        elem = elem(46:53);
    case 8
        elem = elem(54:60);
    case 9
        elem = elem(61:67);
    case 10
        elem = elem(68:75);
    case 11
        elem = elem(76:83);
    case 12
        elem = elem(84:90);
    case 13
        elem = elem(91:97);
    case 14
        elem = elem(98:105);
    case 15
        elem = elem(106:113);
    case 16
        elem = elem(114:120);
end

devlist = elem2dev('BPMx',elem);
