function devlist = getbpmlistbycell(argin);
%GETIDPMLIST - Return devicelist of BPM in a given cell
%
%  OUTPUT
%  1. cell number 
%

%
%  Written by Laurent S. Nadolski

cellNumber = argin;
elem = family2elem('BPMx');

switch cellNumber
    case 1
        elem = elem([1:6,120]);
    case 2
        elem = elem(7:14);
    case 3
        elem = elem(15:22);
    case 4
        elem = elem(23:29);
    case 5
        elem = elem(30:36);
    case 6
        elem = elem(37:44);
    case 7
        elem = elem(45:52);
    case 8
        elem = elem(53:59);
    case 9
        elem = elem(60:66);
    case 10
        elem = elem(67:74);
    case 11
        elem = elem(75:82);
    case 12
        elem = elem(83:89);
    case 13
        elem = elem(90:96);
    case 14
        elem = elem(97:104);
    case 15
        elem = elem(105:112);
    case 16
        elem = elem(113:119);
end

devlist = elem2dev('BPMx',elem);
