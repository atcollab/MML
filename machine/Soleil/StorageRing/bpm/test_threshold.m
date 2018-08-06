%%

Threshold = 1.5e7;

[ir ic] = find(AM.Data.Sum > Threshold);

irfirst = [];
icfirst = [];
for k=1:120,
  val = min(find(ir==k));
  if isempty(val)
      fprintf('BPM number %d with no data\n', k);
  else
      irfirst(k) = ir(val) ;
      icfirst(k) = ic(val) ;
  end
end

figure
plot(ir,ic,'.'); hold on;
plot(irfirst,icfirst,'xr'); hold off
grid on
xlabel('BPM number')
ylabel('Turn number above Threshold');
title(sprintf('Threshold is %e',Threshold));

%%
figure
h1 = subplot(7,1,[1 3]);
plot(spos, AM.Data.X(sub2ind(size(AM.Data.X),irfirst,icfirst)),'Color',nxtcolor)
hold on

nturn = 10;
for k=2:nturn,
    plot(spos, AM.Data.X(sub2ind(size(AM.Data.X),irfirst,icfirst+k)),'Color',nxtcolor)
end
ylabel('X (mm)')

h2 = subplot(7,1,[5 7]);
plot(spos, AM.Data.Z(sub2ind(size(AM.Data.Z),irfirst,icfirst)),'Color',nxtcolor)
hold on

for k=2:nturn,
    plot(spos, AM.Data.Z(sub2ind(size(AM.Data.Z),irfirst,icfirst+k)),'Color',nxtcolor)
end

str = eval(['{', sprintf('''Turn # %d'',',(1:nturn)), '}']);

legend(str,'Position',[0.915 0.4514 0.08195 0.1244])
xlabel('s (m)')
ylabel('Z (mm)')

h3 = subplot(7,1,4);
drawlattice;

linkaxes([h1,h2,h3],'x');
set([h1,h2,h3],'Xgrid','On', 'Ygrid','On');
addlabel(1,0,datestr(AM.TimeStamp,21));
