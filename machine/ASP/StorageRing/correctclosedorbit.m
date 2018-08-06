function correctclosedorbit(varargin)

switch2hardware;

horizontal = 1;
if nargin > 0 && ischar(varargin{1})
   if strcmpi(varargin{1},'y') 
       horizontal = 0;
   end
end

niterations = 1;
if horizontal
    bpmx = getam('BPMx','Struct');
    hcm = getsp('HCM','Struct');
    setorbit(zeros(length(bpmx.Data),1),bpmx,hcm,niterations,'Display');
else
    bpmy = getam('BPMy','Struct');
    vcm = getsp('VCM','Struct');
    setorbit(zeros(length(bpmy.Data),1),bpmy,vcm,niterations,'Display','ModelDisp');
end