function eff_inj_ans(varargin)
% Mesure efficacité injection anneau
% Mesure dose moniteur de perte lent (MPL)

entete    ='injection';
commentaire='no comment';
if length(varargin)>0 && ischar(varargin{1})
    commentaire=varargin{1};
end  

% Stoke courant anneau avant injection
temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur0=temp.value;
q1=0;q2=0;n=0;
%Injection sur quart 1, 3 coups
for i=1:3
   tango_command_inout('ANS/SY/CENTRAL','FireSoftEvent');pause(1.3)
   [q1,q2,n]=getcharge(q1,q2,n);
end


% lecture MPL
temp=tango_read_attribute2('ANS/DG/MPLManager','doseRate');mpl_doserate=temp.value;
temp=tango_read_attribute2('ANS/DG/MPLManager','dose')    ;mpl_dose    =temp.value;

% calcul rendement inj anneau
pause(2)
temp=tango_read_attribute2('ANS-C03/DG/DCCT','current');anscur=temp.value;dcur=anscur-anscur0;
rend_boo=0;if (q1~=0);rend_boo=(q2+0.09)/q1*100;end
rend_ans=0;if (q2~=0);rend_ans=dcur/q2*0.524*416/184*100;end

% plot
figure(1)
plot(mpl_doserate,'-or')

% sauvegarde fichier
file=appendtimestamp(entete);file=strcat(file,'.mat');
save(file,'commentaire','rend_boo', 'rend_ans', 'mpl_doserate', 'mpl_dose')
fprintf('Efficacité BOO = %5.2f   ANS=%5.2f,   doserate max = % 7.0f    %s    %s\n',rend_boo,rend_ans,max(mpl_doserate),file,commentaire)
