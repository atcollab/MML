function correctclosedorbit(varargin)

switch2physics;

horizontal = 1;
if nargin > 0 && ischar(varargin{1})
   if strcmpi(varargin{1},'y') 
       horizontal = 0;
   end
end
       
if nargin > 1 && isnumeric(varargin{2})
    turns = varargin{2};
else
    turns = 10;
end

closedorbit = plotturnorbit(turns);


niterations = 1;
if ~isempty(closedorbit) && ...
        strcmpi(questdlg('Correct this orbit?','Closed Orbit Correction with TBT data','Yes','No','Yes'),'Yes')
    if horizontal
        bpmx = getam('BPMx','Struct');
        bpmx.Data(:) = 0;
        hcm = getsp('HCM','Struct');
        setorbit(-closedorbit(:,1),bpmx,hcm,niterations,'Display','ModelResp','ModelDisp');
    else
        bpmy = getam('BPMy','Struct');
        bpmy.Data(:) = 0;
        vcm = getsp('VCM','Struct');
        setorbit(-closedorbit(:,2),bpmy,vcm,niterations,'Display','ModelResp','ModelDisp');        
    end
end