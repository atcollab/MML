%pure sector dipole case

BEND.FamName = 'BEND';
BEND.BendingAngle= 0.184799567858223;
BEND.Length = 1.5048; 
% BEND.BendingAngle= 0.1e-5;
% BEND.Length = 1e-5; 
BEND.EntranceAngle= 0.092399783929112;
BEND.ExitAngle=  0.092399783929112;
BEND.K= -0.31537858; 
BEND.R1= eye(6);
BEND.R2= eye(6);
BEND.T1= [0 0 0 0 0 0];
BEND.T2= [0 0 0 0 0 0];
BEND.PolynomA= [0 0 0 0];
BEND.PolynomB= [0 BEND.K 0 0];
BEND.MaxOrder=3;
BEND.NumIntSteps=20;
BEND.Energy= 3.0000e+009;
BEND.PassMethod = 'BndMPoleSymplectic4E2Pass';
BEND.FringeInt1=0.6;
BEND.FringeInt2=0.6;
BEND.FullGap=0.034;
BEND.H1=0.1;
BEND.H2=0.1;

[R2,T2] = findTransportMap({BEND},1E-8);
[eR,eT] = testSymplecticity(R2,T2);

map=readsectmap('secmap.out');
[eRmad] = testSymplecticity(map(2).map);

%convert AT convention to MAD convention
tmp = R2(5,:); R2(5,:) = -R2(6,:); R2(6,:) = tmp;
tmp = R2(:,5); R2(:,5) = -R2(:,6); R2(:,6) = tmp;


R2
map(2).map
fprintf('norm diff(R) = %e\n',norm(R2-map(2).map));

tmp = T2(:,5,:); T2(:,5,:) = -T2(:,6,:); T2(:,6,:) = tmp;
tmp = T2(:,:,5); T2(:,:,5) = -T2(:,:,6); T2(:,:,6) = tmp;
tmp = T2(5,:,:); T2(5,:,:) = -T2(6,:,:); T2(6,:,:) = tmp;

for ii=1:6
	Tmad=reshape(map(2).Tmat(ii,:,:),6,6);
	Tmad-squeeze(T2(ii,:,:));
	fprintf('norm diff(T2(%d,:,:)) = %e\n',ii, norm(squeeze(T2(ii,:,:))-Tmad));
%     pause;
end

%squeeze(T2(:,6,6))
