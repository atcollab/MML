function plotbeamdump( fileName )
% function plotbeamdump( fileName )

if nargin < 1
    [FileName, DirectoryName] = uigetfile('R:\Controls\matlab\Shifts\sebek\orbitInterlockDumps\*.mat', 'Select a BPM dump file to load');
    load([DirectoryName FileName]);
else
    load( fileName );
end


% Adjust to the golden orbit
x = getoffset('BPMx', getlist('BPMx',0));
y = getoffset('BPMy', getlist('BPMy',0));

for i = 1:112
    bpm(1,i,:) = bpm(1,i,:) - x(i);
    bpm(2,i,:) = bpm(2,i,:) - y(i);
end


ind = find(~isnan(bpm(3,:,1)));

pInd = 1:4000;
% pInd = 1000:3500;
% pInd = 3751:3800;
figInd=0;
figInd=figInd+1; 
figure(figInd);
clf reset
for i1 = 1:6,
    for i2 = 1:9,
        ind1 = (i1-1)*9 + i2;
        subplot(6,9, ind1 );
        plot(pInd, squeeze(bpm(1,ind(ind1),pInd)), pInd, squeeze(bpm(2,ind(ind1),pInd)));
        title( ['bpm ', int2str(ind1)] );
    end
end
% yaxiss([-.2 .2]);
% yaxiss([-1 3]);
h=get(gcf,'children');
set(h(1:end-9),'xticklabel','');
%set(h,'xtick',get(h(1),'xlim'));
%set(h,'xtickmode','auto');


figInd=figInd+1; 
figure(figInd);
clf reset
for i1 = 1:6,
    for i2 = 1:9,
        ind1 = (i1-1)*9 + i2;
        subplot(6,9, ind1 );
        plot(pInd, squeeze(bpm(3,ind(ind1),pInd)));
        title( ['bpm ', int2str(ind1)] );
    end
end
h = get(gcf,'children');
set(h(10:end),'xticklabel','');
%set(h,'xtick',get(h(1),'xlim'));
%set(h,'xtickmode','auto');


figInd=figInd+1; 
figure(figInd); 
clf reset
for i1 = 1:6,
    for i2 = 1:9,
        ind1 = (i1-1)*9 + i2;
        subplot(6,9, ind1 );
        plot(pInd, squeeze(bpm(4,ind(ind1),pInd)));
        title( ['bpm ', int2str(ind1)] );
    end
end
h = get(gcf,'children');
set(h(10:end),'xticklabel','');
%set(h,'xtick',get(h(1),'xlim'));
%set(h,'xtickmode','auto');
