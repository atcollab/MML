
        S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/Sauvegarde_beta_theorique_0_2_0_3.mat')
        betaXth = S.betatheorX ; betaZth = S.betatheorZ ;
        S = load('-mat','/home/matlabML/measdata/Ringdata/QUAD/Sauvegarde_beta_sept06.mat')
        betaXmeas = S.betameasX ; betaZmeas = S.betameasZ ;

        NameQ1 = '/home/matlabML/measdata/Ringdata/QUAD/Q1Beta_2006-10-01_20-51-33.mat';
        NameQ2 = '/home/matlabML/measdata/Ringdata/QUAD/Q2Beta_2006-10-01_20-59-24.mat';
        NameQ3 = '/home/matlabML/measdata/Ringdata/QUAD/Q3Beta_2006-10-01_21-08-17.mat';
        NameQ4 = '/home/matlabML/measdata/Ringdata/QUAD/Q4Beta_2006-10-01_21-14-55.mat';
        %NameQ5 ='/home/matlabML/measdata/Ringdata/QUAD/Q5Beta_2006-10-01_21-36-02.mat';% 1octobre 1 A
        NameQ5 = '/home/matlabML/measdata/Ringdata/QUAD/Q5Beta_2006-10-08_19-39-23.mat';% 8 octobre 0.5 A
        NameQ6 = '/home/matlabML/measdata/Ringdata/QUAD/Q6Beta_2006-10-01_21-46-20.mat';
        %NameQ7 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2006-10-01_22-00-27.mat'; % 1 octobre 1 A
        NameQ7 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2006-10-08_19-09-04.mat'; % 8 octobre 0.5 A
        %NameQ7 ='/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2006-10-08_16-54-54.mat'; % 8octobre 1.2 A
        NameQ8 = '/home/matlabML/measdata/Ringdata/QUAD/Q8Beta_2006-10-01_22-18-11.mat';
        NameQ9 ='/home/matlabML/measdata/Ringdata/QUAD/Q9Beta_2006-10-01_22-32-14.mat'; % 1er octobre 2A
        %NameQ9 = '/home/matlabML/measdata/Ringdata/QUAD/Q9Beta_2006-10-08_23-54-23.mat'; % 8 octobre 1A après nbvp35
        %NameQ10 = '/home/matlabML/measdata/Ringdata/QUAD/Q10Beta_2006-10-01_22-43-12.mat';% 1 octobre 2 A
        NameQ10 = '/home/matlabML/measdata/Ringdata/QUAD/Q10Beta_2006-10-08_20-10-45.mat';% 8 octobre 0.8 A
        %NameQ10 = '/home/matlabML/measdata/Ringdata/QUAD/Q10Beta_2006-10-08_23-37-43.mat'; % 8 octobre 0.8A après nbvp35

        betameasX_corr = [];betameasZ_corr= [];
        for k = 1:10
            %NameFile = strcat('NameQ',num2str(k));
            if k == 1 
                S = load('-mat',NameQ1);
                deltaI = 1.
                Ic = -127.62716
            elseif k == 2 
                S = load('-mat',NameQ2);
                deltaI = 1.
                Ic = 160.19762
            elseif k == 3 
                S = load('-mat',NameQ3);
                deltaI = 1.
                Ic = -76.83683
            elseif k == 4 
                S = load('-mat',NameQ4);
                deltaI = 1.
                Ic = -150.21718
            elseif k == 5 
                S = load('-mat',NameQ5);
                deltaI = 0.5
                Ic = 203.38887
            elseif k == 6 
                S = load('-mat',NameQ6);
                deltaI = 1.5
                Ic = -119.41052
            elseif k == 7
                S = load('-mat',NameQ7);
                deltaI = 0.5
                Ic = 212.73391
            elseif k == 8 
                S = load('-mat',NameQ8);
                deltaI = 1.
                Ic = -185.21158
            elseif k == 9
                S = load('-mat',NameQ9);
                deltaI = 2.
                Ic = -181.76481
            elseif k ==10 
                S = load('-mat',NameQ10);
                deltaI = 0.8
                Ic = 211.05605
            end

            QX = strcat('Q',num2str(k));

            %Ic = getam(QX); % attnetion si machine pas chargée ..
            k0 = hw2physics(QX,'Setpoint',Ic);
            k1 =  hw2physics(QX,'Setpoint',Ic+deltaI);
            k2 = hw2physics(QX,'Setpoint',Ic-deltaI);

            BETA = S.AO.FamilyName.(QX).beta
            betax = BETA(:,1)';betaz = BETA(:,2)';
            DTUNE = S.AO.FamilyName.(QX).dtune
            dtunex = DTUNE(:,1);dtunez = DTUNE(:,2);
            Leff = getleff(QX);
            k
            % calcul des beta avec les gradient "exactement" calculé
            betax_bis = 4 * pi *dtunex ./ ((k1-k2).*Leff);betaz_bis = 4 * pi *dtunez ./ (-(k1-k2).*Leff);
            betameasX_corr = [betameasX_corr  betax_bis'] ; betameasZ_corr = [betameasZ_corr  betaz_bis'] ;
        end
        %%%%%%%%%%%%%%%%%%%%%% statistique
        %X = betameasX_corr(129:144);
        X = betameasX_corr(145:160);
        moyX = mean(X);
        X = X-moyX;
        rmsX = norm(X)/sqrt(length(X))
        minX = min(X)
        maxX = max(X)

        %Z = betameasZ_corr(129:144);
        Z = betameasZ_corr(145:160);
        moyZ = mean(Z);
        Z = Z - moyZ;
        rmsZ = norm(Z)/sqrt(length(Z))
        minZ = min(Z)
        maxZ = max(Z)
%         %%%%%%%%%%%%%%%%%%%%%% sauvegarde
%         DirStart = pwd;
%         DirectoryName = '/home/matlabML/measdata/Ringdata/QUAD/';
%         [DirectoryName, DirectoryErrorFlag] = gotodirectory(DirectoryName);
%         try
%             Nomfichier = 'Sauvegarde_beta_corr_2006_10_08';
%             save(Nomfichier,'betameasX_corr','betameasZ_corr');
%         catch
%             cd(DirStart);
%             return
%         end
%         cd(DirStart);

        %%%%%%%%%%%%%%%%%%%%%% plot
        figure(12)
        plot(betaXth,'k'); hold on ; plot(betaXmeas,'b') ; hold on ; plot(betameasX_corr,'r')
        title('Evaluation par 2 méthodes des betax mesurés ','FontSize',12)%ylim([0 22]);
        legend('betax théorique','betax mesuré - deltak proportionnel à deltaI','betax mesuré - correction du delta k')
        xlabel('numéro du quadrupole'); ylabel('betax (m)')
        %xlim([129 160]);ylim([0 20]);
        figure(13)
        plot(betaZth,'k'); hold on ; plot(betaZmeas,'b') ; hold on ; plot(betameasZ_corr,'r')
        title('Evaluation par 2 méthodes des betaz mesurés ','FontSize',12)
        %ylim([0 20]);xlim([129 160])
        legend('betaz théorique','betaz mesuré - deltak proportionnel à deltaI','betaz mesuré - correction du delta k')
        xlabel('numéro du quadrupole'); ylabel('betaz (m)')


% X = [];Z = [];A = ones(8,7)*0;
% NameQ7_1 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_0-8A_2006-10-15_15-05-02.mat';
% NameQ7_2 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_1-2A_2006-10-15_15-18-46.mat';
% NameQ7_3 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_1-6A_2006-10-15_15-26-44.mat';
% NameQ7_4 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2A_2006-10-15_15-35-31.mat';
% NameQ7_5 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2-4A_2006-10-15_15-41-53.mat';
% NameQ7_6 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_2-8A_2006-10-15_15-47-15.mat';
% NameQ7_7 = '/home/matlabML/measdata/Ringdata/QUAD/Q7Beta_3-2A_2006-10-15_15-52-39.mat';
% 
% for k = 1:7
%     %NameFile = strcat('NameQ',num2str(k));
%     if k == 1
%         S = load('-mat',NameQ7_1);
%     elseif k == 2
%         S = load('-mat',NameQ7_2);
%     elseif k == 3
%         S = load('-mat',NameQ7_3);
%     elseif k == 4
%         S = load('-mat',NameQ7_4);
%     elseif k == 5
%         S = load('-mat',NameQ7_5);
%     elseif k == 6
%         S = load('-mat',NameQ7_6);
%     elseif k == 7
%         S = load('-mat',NameQ7_7);
%     end
%     QX = 'Q7';
%     Ic = getam(QX);
%     deltaI = S.AO.FamilyName.(QX).deltaI;
%     k0 =  hw2physics(QX,'Setpoint',Ic);
%     k1 =  hw2physics(QX,'Setpoint',Ic+deltaI);
%     k2 = hw2physics(QX,'Setpoint',Ic-deltaI);
%     deltak = -k2+k1; deltak_faux = 2 * deltaI * k0./ Ic;
%     dtune = S.AO.FamilyName.(QX).dtune;
%     for j = 1:8
%         A(j,k) = deltak(j:j)' ; X(j,k) = dtune(j:j,1)';  Z(j,k) = -dtune(j:j,2)'; W(j,k) = deltak_faux(j:j)'
%     end
% end
% figure(5)
% plot(A(1,:),X(1,:),'rs-') ;
% hold on ; plot(A(2,:),X(2,:),'rs-') ;
% hold on ; plot(A(3,:),X(3,:),'rs-') ;
% xlim([0 0.10]) ; ylim([0 0.04]);
% hold on ; plot(W(1,:),X(1,:),'ks-') ;
% hold on ; plot(W(2,:),X(2,:),'ks-') ;
% hold on ; plot(W(3,:),X(3,:),'ks-') ;
% 
% %hold on ; plot(A(4,:),X(4,:),'rs-') ;
% %hold on ; plot(A(5,:),X(5,:),'rs-') ;
% %hold on ; plot(A(6,:),X(6,:),'rs-') ;
% %hold on ; plot(A(7,:),X(7,:),'rs-') ;
% 
% %figure(6)
% hold on
% plot(A(1,:),Z(1,:),'bs-') ;
% hold on ; plot(A(2,:),Z(2,:),'bs-') ;
% hold on ; plot(A(3,:),Z(3,:),'bs-') ;
% 
% xlim([0 0.10]) ; ylim([0 0.04]);
% hold on ; plot(W(1,:),Z(1,:),'ks-') ;
% hold on ; plot(W(2,:),Z(2,:),'ks-') ;
% hold on ; plot(W(3,:),Z(3,:),'ks-') ;
%  
% %hold on ; plot(A(4,:),Z(4,:),'bs-') ;
% %hold on ; plot(A(5,:),Z(5,:),'bs-') ;
% %hold on ; plot(A(6,:),Z(6,:),'bs-') ;
% %hold on ; plot(A(7,:),Z(7,:),'bs-') ;
% 
% figure(7)
% plot(W(1,:),X(1,:),'rs-') ;
% hold on ; plot(W(2,:),X(2,:),'rs-') ;
% hold on ; plot(W(3,:),X(3,:),'rs-') ;
% hold on ; plot(W(4,:),X(4,:),'rs-') ;
% hold on ; plot(W(5,:),X(5,:),'rs-') ;
% hold on ; plot(W(6,:),X(6,:),'rs-') ;
% hold on ; plot(W(7,:),X(7,:),'rs-') ;
