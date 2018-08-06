orbfig = findobj(allchild(0),'tag','FTsetup'); 

if ~isempty(orbfig), delete(orbfig); end
orbfig = findobj(allchild(0),'tag','FTsetup'); 

if ~isempty(orbfig), delete(orbfig); end

kmax = 8; % button number

height = 10 + kmax*30 + 30; %670;
a = figure('Color',[0.8 0.8 0.8], ...
    'Interruptible', 'on', ...   
    'HandleVisibility','off', ...
    'MenuBar','none', ...
    'Name', 'First Turn Orbit correction (experimental interface)', ...
    'NumberTitle','off', ...
    'Units','pixels', ...
    'Position',[5 70 210*2 height], ...
    'Resize','off', ...
    'Tag','FTsetup');

height = height - 35;

for k = 1:kmax,
    b1(k) = uicontrol('Parent',a, ...
        'Position',[3 height-(k-1)*30 204 27], ...
        'Interruptible', 'off', ...
        'Tag','button22');
end

for k = 1:kmax,
    b2(k) = uicontrol('Parent',a, ...
        'Position',[3 + 210 height-(k-1)*30 204 27], ...
        'Interruptible', 'off', ...
        'Tag','button22');
end

set(b1(1), 'String','H plane','BackGroundColor','b');
set(b1(2), 'Callback','firstturnscorrection(Xcod,''Horizontal'',''NoDisplay'');', 'String','H Correction (No Display)');
set(b1(3), 'Callback','firstturnscorrection(Xcod,''Horizontal'');', 'String','H Correction');
set(b1(4), 'Callback','setsp(''HCOR'',0);disp(''zeroing HCOR'');', 'String','HCOR to zero');
set(b1(5), 'Callback','HCOR0_ = getam(''HCOR'');disp(''HCOR saved'');', 'String','Save HCOR (1-depth buffer)');
set(b1(6), 'Callback','setsp(''HCOR'',HCOR0_);disp(''HCOR restored'');', 'String','Set back HCOR (1-depth buffer)');
set(b1(7), 'Callback','figure; plot(getspos(''BPMx''),Xcod); grid on;', 'String','plot H-cod');
set(b1(8), 'Callback','', 'String','Compute COD');

set(b2(1), 'String','V plane','BackGroundColor','r');
set(b2(2), 'Callback','firstturnscorrection(Zcod,''Vertical'',''NoDisplay'');', 'String','V Correction (No Display)');
set(b2(3), 'Callback','firstturnscorrection(Zcod,''Vertical'');', 'String','V Correction');
set(b2(4), 'Callback','setsp(''VCOR'',0);disp(''zeroing VCOR'');', 'String','VCOR to zero');
set(b2(5), 'Callback','VCOR0_ = getam(''VCOR'');disp(''VCOR saved'');', 'String','Save VCOR (1-depth buffer)');
set(b2(6), 'Callback','setsp(''VCOR'',VCOR0_);disp(''VCOR restored'');', 'String','Set back VCOR (1-depth buffer)');
set(b2(7), 'Callback','figure; plot(getspos(''BPMz''),Zcod); grid on;', 'String','plot V-cod');
set(b2(8), 'Callback','', 'String','Compute COD');
