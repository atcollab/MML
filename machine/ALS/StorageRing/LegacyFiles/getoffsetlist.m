function List = getoffsetlist(Family)


if strcmpi(Family, 'BPMx')
    List = getbpmlist('BPMx','2 3 8 9');
    List = [List; getbpmlist('BPMx',[4 8 12], '5 6')];
else
    List = getbpmlist('BPMy','2 3 8 9');
    List = [List; getbpmlist('BPMy',[4 8 12], '5 6')];
    List = [List; getbpmlist('BPMy', '4 7')];
end

List = sortrows(List);
