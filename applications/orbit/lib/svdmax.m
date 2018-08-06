function varargout=SVDMax(varargin)
%==========================================================
%reduce number of singular values until correctors in range

SYS=varargin(1);  SYS=SYS{1};
BPM=varargin(2);  BPM=BPM{1};
BL= varargin(3);  BL = BL{1};
COR=varargin(4);  COR=COR{1};
RSP=varargin(5);  RSP=RSP{1};

plane=SYS.plane;
lim_flag=0;
%lim_flag=CurLim(COR(plane).fit, COR(plane).act, COR(plane).ifit, COR(plane).lim, COR(plane).name);
if lim_flag==1
  while lim_flag==1;
    disp('Warning: Correctors out of range - reduce number of eigenvectors');
    RSP(plane).nsvd=RSP(plane).nsvd-1;
    if RSP(plane).nsvd==0
        error('Number of singular values reduced to zero');
    end
    [BPM,BL,COR]=BackSubSystem(plane,SYS,BPM,BL,COR,RSP);
    %lim_flag=CurLim(COR(plane).ifit, COR(plane).act,COR(plane).fit,COR(plane).lim,COR(plane).name);
    lim_flag=checklimits(COR(plane).AOFamily, COR(plane).ifit, COR(plane).act(COR(plane).ifit), COR(plane).fit);
  end
end
%disp(['Max number of singular values for correctors in range: ', num2str(RSP(plane).nsvd)]);

varargout{1}=RSP(SYS.plane).nsvd;
