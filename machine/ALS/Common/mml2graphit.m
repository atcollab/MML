ChannelNames = family2channel('BPMx');
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
GraphIt(1).ChannelNames = ChannelNames;
GraphIt(1).Offset = getgolden('BPMx');
GraphIt(1).Y.Range = [-3 3];
GraphIt(1).Y.Label = 'Horizontal Orbit [mm]';


ChannelNames = family2channel('BPMy');
ChannelNames = deblank(mat2cell(ChannelNames, ones(1,size(ChannelNames,1)),size(ChannelNames,2)));
GraphIt(2).ChannelNames = ChannelNames;
GraphIt(2).Offset = getgolden('BPMy');
GraphIt(2).Y.Range = [-3 3];
GraphIt(2).Y.Label = 'Vertical Orbit [mm]';

% xml_save('GraphItOn',  GraphIt,  'on');
% xml_save('GraphItOff', GraphIt, 'off');


Header.Title = 'Storage Ring Orbit';
Header.GlobalOffset = .1;
Header.Time.Start = datestr(now-1,31);
Header.Time.End = datestr(now,31);

aCell{1} = Header;
aCell{2} = GraphIt(1);
aCell{3} = GraphIt(2);
xml_save('GraphItOn',  aCell,  'on');
xml_save('GraphItOff',  aCell,  'off');
