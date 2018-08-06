% AMtoto = getbpmrawdata([],'Struct');
% save('chapeau_pointu','-mat','AMtoto')
%  sous home/operateur/mat
fileName = '/home/operateur/mat/chapeau_pointu';
load(fileName,'-mat');


% normalisation des signal somme
[dummy idx] = max(AMtoto.Data.Sum');
for k = 1:120
    Data(k,:) = AMtoto.Data.Sum(k,:)./dummy(k);
end


% % % plot des 15 premiers tours pour chacun des BPM des cellules  1, 2, etc..
%  figure(1)%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 
% cell = 1;
% k = 0
% for k = 1:7
%     plot(Data(k,1:15),'rs-'); hold on; % cellule 1  7 BPM    
% end
% 
% cell = 2;
% for k = 1:8
%     plot(Data(7+k,1:15),'bs-'); hold on; % cellule 2  8 BPM
% end
% 
% cell = 3;
% for k = 1:8
%     plot(Data(15+k,1:15),'ks-'); hold on; % cellule 3  8 BPM
% end
% set(gca,'FontSize',14)
% set(gcf,'Color','white')
% ylabel('normalized sum signal');xlim([4 11]);
% %set(handles.figure1,'MenuBar','None');
% xlabel('turn number');
% title('r = cell#1, b = cell#2,  k = cell#3')
% grid on; hold off ; grid minor 

figure(2) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cell = 4;
for k = 1:1
    plot(Data(23+k,1:50),'rs-'); hold on; % cellule 4  7 BPM
end

cell = 5;
for k = 3:3
    plot(Data(30+k,1:50),'bs-'); hold on; % cellule 5  7 BPM
end
% for k = 6:7
%     plot(Data(30+k,1:50),'bs-'); hold on; % cellule 5  7 BPM
% end

% cell = 6;
% for k = 1:2
%     plot(Data(37+k,1:50),'ks-'); hold on; % cellule 6  8 BPM
% end
% for k = 4:8
%     plot(Data(37+k,1:50),'ks-'); hold on; % cellule 6  8 BPM
% end
set(gca,'FontSize',18)
set(gcf,'Color','white')
ylabel('normalized sum signal');xlim([20 30]);
xlabel('turn number');
%xlim([4 11]);
%     10
%     11
%     29
%     30
%title('r = cell#4, b = cell#5,  k = cell#6')
grid on; hold off ; %grid minor 
% 

% figure(3) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% cell = 7;
% for k = 1:8
%     plot(Data(45+k,1:15),'rs-'); hold on; % cellule 7  8 BPM
% end
% 
% cell = 8;
% for k = 1:7
%     plot(Data(53+k,1:15),'bs-'); hold on; % cellule 8  7 BPM
% end
% 
%     10
%     11
%     29
%     30
% cell = 9;
% for k = 1:7
%     plot(Data(60+k,1:15),'ks-'); hold on; % cellule 9  7 BPM
% end
% set(gca,'FontSize',14)
% set(gcf,'Color','white')
% ylabel('normalized sum signal');xlim([4 11]);
% xlabel('turn number');
% title('r = cell#7, b = cell# 8,  k = cell#9')
% grid on; hold off ; grid minor 
% % 
% 
% figure(4) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% cell = 10;
% for k = 1:8
%     plot(Data(67+k,1:15),'rs-'); hold on; % cellule 10  8 BPM
% end
% 
% cell = 11;
% for k = 1:8
%     plot(Data(75+k,1:15),'bs-'); hold on; % cellule 11  8 BPM
% end
% 
% cell = 12;
% for k = 1:7
%     plot(Data(83+k,1:15),'ks-'); hold on; % cellule 12  7 BPM
% end
% set(gca,'FontSize',14)
% set(gcf,'Color','white')
% ylabel('normalized sum signal');xlim([4 11]);xlabel('turn number');
% title('r = cell#10, b = cell#11,  k = cell#12')
% grid on; hold off ; grid minor 
% 
% 
% figure(5) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% cell = 13;
% for k = 1:7
%     plot(Data(90+k,1:15),'rs-'); hold on; % cellule 10  7 BPM
% end
% 
% cell = 14;
% for k = 1:8
%     plot(Data(97+k,1:15),'bs-'); hold on; % cellule 11  8 BPM
% end
% 
% cell = 15;
% for k = 1:8
%     plot(Data(105+k,1:15),'ks-'); hold on; % cellule 12  8 BPM
% end
% 
% cell = 16;
% for k = 1:7
%     plot(Data(113+k,1:15),'gs-'); hold on; % cellule 12  7 BPM
% end
% set(gca,'FontSize',14)
% set(gcf,'Color','white')
% ylabel('normalized sum signal');xlim([4 11]);
% xlabel('turn number');
% title('r = cell#13, b = cell#14,  k = cell#15, g = cell#16')
% grid on; hold off ; grid minor 
% 
% % 
% % % figure(6) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % cell = 4;
% % % 
% % % %plot(Data(23+1,1:15),'rs-'); hold on; % cellule 4  7 BPM
% % % %plot(Data(23+2,1:15),'bs-'); hold on;
% % % %plot(Data(23+3,1:15),'ks-'); hold on;
% % % %plot(Data(23+4,1:15),'rs-'); hold on;
% % % %plot(Data(23+5,1:15),'bs-'); hold on;
% % % plot(Data(23+6,1:15),'ks-'); hold on;
% % % plot(Data(23+7,1:15),'rs-'); hold on;
% % % 
% % % ylabel('signal somme normalisé');xlim([4 11]);
% % % title('cellule 4')
% % % grid on; hold off ; grid minor 
% % 
% % % % figure(8) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % % cell = 4;
% % % % 
% % % %plot(Data(97+1,1:15),'rs-'); hold on; % cellule 14  8 BPM
% % % %plot(Data(97+2,1:15),'bs-'); hold on;
% % % %plot(Data(97+3,1:15),'ks-'); hold on;
% % % %plot(Data(97+4,1:15),'rs-'); hold on;
% % % %plot(Data(97+5,1:15),'bs-'); hold on;
% % % plot(Data(97+6,1:15),'ks-'); hold on;
% % % plot(Data(97+7,1:15),'rs-'); hold on;
% % % plot(Data(97+8,1:15),'rs-'); hold on;
% % % 
% % % 
% % % ylabel('signal somme normalisé');xlim([4 11]);
% % % title('cellule 14')
% % % grid on; hold off ; grid minor 
% 
% % figure(7)  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % disp('he oui !')
% % % trouver le numero du tour ou le signal est superieur à N% du max
% % irfirst = [];
% % icfirst = [];
% % [K L] = find(Data>0.1); % seuil à 10% du max
% % for k = 1:120
% %     val = min(find(K==k));
% %   if isempty(val)
% %       fprintf('BPM number %d with no data\n', k);
% %   else
% %       Kfirst(k) = K(val) ;
% %       Lfirst(k) = L(val) ;
% %   end
% % end
% % plot(Kfirst,Lfirst,'rs');
% % title('seuil à 10% du signal max');
% % xlabel('numero du BPM')
% % ylabel('numero du tour')
% % ylim([6 9])
% % %xlim([1 10])
% % hold on
% % 
% % hold off
% % figure(8)  
% % [K L] = find(Data>0.2); % seuil à 20% du max
% % for k = 1:120
% %     val = min(find(K==k));
% %   if isempty(val)
% %       fprintf('BPM number %d with no data\n', k);
% %   else
% %       Kfirst(k) = K(val) ;
% %       Lfirst(k) = L(val) ;
% %   end
% % end
% % plot(Kfirst,Lfirst,'bs');
% % ylim([6 9])
% % title('seuil à 20% du signal max');
% % xlabel('numero du BPM')
% % ylabel('numero du tour')
% % hold on
% % 
% % hold off
% % figure(9) 
% % [K L] = find(Data>0.3); % seuil à 30% du max
% % for k = 1:120
% %     val = min(find(K==k));
% %   if isempty(val)
% %       fprintf('BPM number %d with no data\n', k);
% %   else
% %       Kfirst(k) = K(val) ;
% %       Lfirst(k) = L(val) ;
% %   end
% % end
% % plot(Kfirst,Lfirst,'ks');
% % ylim([6 9])
% % title('seuil à 30% du signal max');
% % xlabel('numero du BPM')
% % ylabel('numero du tour')
% % 
% % ylim([6 9])
% % 
% % hold on
% % grid on;hold off
% % 
% % 
