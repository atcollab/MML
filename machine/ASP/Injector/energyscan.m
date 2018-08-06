energyscale = 1;

bendamp = [27.526 27.132 27.125];
setsp('BEND',[bendamp(1) bendamp(2) bendamp(3)]'*energyscale,'Hardware'); 
qfamp = 12.277;
setsp('QF',energyscale*qfamp,'Hardware');
qdamp = 1.662;
setsp('QD',energyscale*qdamp,'Hardware');


return
% 
% 
% mev = 97.66;
% bd1scale = 1.0;
% bd2scale = 1.0;
% bfscale = 1.0;
% qfscale = 1.0;
% qdscale = 1.0;
% 
% 
% 
% if 0
%     bd1scale = 0.99521855263875;
%      bd2scale = 0.99409072317551;
%     bfscale = 0.96758916287438;
%     qfscale = 1;
%     qdscale = 1;
% 
%     % setenergy(mev/1000);
%     setsp('BEND',[mev/1000*bd1scale mev/1000*bd2scale mev/1000*bfscale]','Physics'); 
%     pause(0.5);
% %    setsp('QD',0.4*1.4,'Physics');
% %    setsp('QF',2.350742*1,'Physics');
%     setsp('QD',0.4*qdscale,'Physics');
%     setsp('QF',2.350742*qfscale,'Physics');
% 
% else
%     
%     read = 1;
% 
%     if read
%        [energy BD1 BD2 BF QD QF] = textread('S:\tane\rampingcurve_yes_now_its_not_so_wrong3.txt',...
%             '%f %f %f %f %f %f','headerlines',2);
%     end
% 
%     setsp('BEND',[interp1(energy,BF,mev)*bd1scale interp1(energy,BD1,mev)*bd2scale interp1(energy,BD2,mev)*bfscale]');
% %    setsp('QD',interp1(energy,QD,mev)*0.93);
% %    setsp('QF',interp1(energy,QF,mev)*0.85);
%     setsp('QD',interp1(energy,QD,mev)*qdscale);
%     setsp('QF',interp1(energy,QF,mev)*qfscale);
% 
% end
% 
%     
% pause(0.2);
% disp('');
% fprintf('Bends (set/readback): %7.4f/%7.4f  %7.4f/%7.4f  %7.4f/%7.4f\n',...
%     getsp('BEND',1),getam('BEND',1),getsp('BEND',2),getam('BEND',2),...
%     getsp('BEND',3),getam('BEND',3));
% fprintf('QF and QD           : %7.4f/%7.4f  %7.4f/%7.4f\n',...
%     getsp('QF'),getam('QF'),getsp('QD'),getam('QF'));