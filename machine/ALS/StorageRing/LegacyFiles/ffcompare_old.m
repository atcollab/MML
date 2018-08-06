function ffcompare
% function ffcompare
% allows to compare several feed forward tables

BLeffHCM = 410;  % gauss cm / amp;
BLeffVCM = 171;  % gauss cm / amp; 
Leff = 55;       % cm
labelmat = [];

DirStart = pwd;
cd m:\matlab\srdata
cd gaptrack
cd archive

figure
ha=subplot(2,2,1);
hb=subplot(2,2,2);
hc=subplot(2,2,3);
hd=subplot(2,2,4);

SectorIn = menu('Which Sector?','4','5','7','8','9','10','11','12','Cancel');   
if SectorIn == 1
   Sector = 4;
elseif SectorIn == 2
   Sector = 5;
elseif SectorIn == 3
   Sector = 7;
elseif SectorIn == 4
   Sector = 8;
elseif SectorIn == 5
   Sector = 9;
elseif SectorIn == 6
   Sector = 10;
elseif SectorIn == 7
   Sector = 11;
elseif SectorIn == 8
   Sector = 12;
elseif SectorIn == 9
   return
end
if Sector == 0
   return;
end

for i = 1:100000
   % Load the table1
   [Datafn, DirStr] = uigetfile(sprintf('id%02d*.mat', Sector), 'Choose the desired feed forward file (Cancel to stop).');
   if Datafn == 0
      % Return of original directory
      eval(['cd ', DirStart]);
      
      %subplot(2,2,1);
      axes(ha);
      title('');
      hold off
      axis tight
      %subplot(2,2,2);
      axes(hb);
      title('');
      hold off
      axis tight
      %subplot(2,2,3);
      axes(hc);
      title('');
      hold off
      axis tight
      %subplot(2,2,4);
      axes(hd);
      title('');
      hold off
      axis tight
      orient landscape
      
      h=addlabel(.5,1,sprintf('Sector %d Feed Forward Tables', Sector1),12);
      set(h,'HorizontalAlignment','center');
      
      for j = 1:size(labelmat,1)
         h=addlabel(1,1-.02*(j-1),labelmat(j,:),7);
         set(h,'color',labelcmat(j,:));
         %set(h(j),'EraseMode','background');
         %set(h(j),'EraseMode','Normal');
         %set(h(j),'EraseMode','xor');
      end
      
      return
   end
   
   
   eval(['load ', DirStr, Datafn]);
   h1 = tableX;
   v1 = tableY;
   Sector1 = str2num(Datafn(3:4));
   GeVnum1 = str2num(Datafn(6:7))/10;
   
   
   cmat = get(gca,'ColorOrder');
   icolor=rem(i-1,size(cmat,1))+1;
   
   %ha=subplot(2,2,1);
   axes(ha);
   plot(h1(:,1),h1(:,2),'color',cmat(icolor,:));
   xlabel('Gap Position [mm]');
   ylabel(sprintf('HCM(%d,%d) [amps]',Sector1-1,4));
   title(sprintf('Sector %d Table at %.1f GeV', Sector1, GeVnum1));
   hold on
   
   %hb=subplot(2,2,3);
   axes(hb);
   plot(h1(:,1),h1(:,3),'color',cmat(icolor,:));
   xlabel('Gap Position [mm]');
   ylabel(sprintf('HCM(%d,%d) [amps]',Sector1,1));
   title(sprintf('Sector %d Table at %.1f GeV', Sector1, GeVnum1));
   hold on
   
   %hc=subplot(2,2,2);
   axes(hc);
   plot(v1(:,1),v1(:,2),'color',cmat(icolor,:));
   xlabel('Gap Position [mm]');
   ylabel(sprintf('VCM(%d,%d) [amps]',Sector1-1,4));
   title(sprintf('Sector %d Table at %.1f GeV', Sector1, GeVnum1));
   hold on
   
   %hd=subplot(2,2,4);
   axes(hd);
   plot(v1(:,1),v1(:,3),'color',cmat(icolor,:));
   xlabel('Gap Position [mm]');
   ylabel(sprintf('VCM(%d,%d) [amps]',Sector1,1));
   title(sprintf('Sector %d Table at %.1f GeV', Sector1, GeVnum1));
   hold on
   
   fprintf('  %d.  %s  Sector %d  %.1f GeV\n', i, FFDate, Sector1, GeVnum1);
   
   labelmat = strvcat(labelmat, sprintf('%s, Sector %d, %.1f GeV', FFDate, Sector1, GeVnum1));
   labelcmat(i,:) = cmat(icolor,:);
   %h(i)=addlabel(1,1-.03*i,sprintf('%s  Sector %d  %.1f GeV', FFDate, Sector1, GeVnum1),7);
   %set(h(i),'color',cmat(icolor,:));
   
   for j = 1:i
      h=addlabel(1,1-.02*(j-1),labelmat(j,:),7);
      set(h,'color',labelcmat(j,:));
      %set(h(j),'EraseMode','background');
      %set(h(j),'EraseMode','Normal');
      %set(h(j),'EraseMode','xor');
   end
   
   drawnow
end



return





% Load the table2
[Datafn, DirStr] = uigetfile('*.mat', 'Choose the desired feed forward file.');
eval(['load ', DirStr, Datafn]);
h1 = tableX;
v1 = tableY;
Sector2 = str2num(Datafn(3:4));
GeVnum2 = str2num(Datafn(6:7))/10;


subplot(2,1,1);
plot(h1(:,1),h1(:,2),'-.r', h1(:,1),h1(:,3),':g');
hold off;
xlabel('Gap Position [mm]');
ylabel('Horizontal Corrector Strength [amps]');
title(['Insertion Device Feedfoward Tables']);
legend(['HCM4, Sector ',num2str(Sector1-1),'  ', num2str(GeVnum1), ' GeV'], ...
       ['HCM1, Sector ',num2str(Sector1),'  ',   num2str(GeVnum1), ' GeV'], ...
       ['HCM4, Sector ',num2str(Sector2-1),'  ', num2str(GeVnum2), ' GeV'], ...
       ['HCM1, Sector ',num2str(Sector2),'  ',   num2str(GeVnum2), ' GeV']);


subplot(2,1,2);
plot(v1(:,1),v1(:,2),'-.r', v1(:,1),v1(:,3),':g');
hold off;
xlabel('Gap Position [mm]');
ylabel('Vertical Corrector Strength [amps]');
title(['Insertion Device Feedfoward Tables']);
legend(['VCM4, Sector ',num2str(Sector1-1),'  ', num2str(GeVnum1), ' GeV'], ...
       ['VCM1, Sector ',num2str(Sector1),'  ',   num2str(GeVnum1), ' GeV'], ...
       ['VCM4, Sector ',num2str(Sector2-1),'  ', num2str(GeVnum2), ' GeV'], ...
       ['VCM1, Sector ',num2str(Sector2),'  ',   num2str(GeVnum2), ' GeV']);
