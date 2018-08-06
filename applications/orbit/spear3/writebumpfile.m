function writebumpfile(varargin)
%write bump file to disk
%example
% ao=getao;
% 
% nqf=length(ao.QF.ElementList);
% nqd=length(ao.QD.ElementList);
% pvnames=char(ao.QF.Setpoint.ChannelNames,ao.QD.Setpoint.ChannelNames);
% scalefactor=[r(1,1)*ones(nqf,1);r(2,1)*ones(nqd,1)];
% 
% header=['dnu_x   [0.01/unit] '];
% directoryname=getfamilydata('Directory','BumpFiles');
% filename='xtune';
%writebumpfile(pvnames,scalefactor,header,directoryname,filename);

if isstruct(varargin)     %structure input
% pv           =varargin.pv;
% scalefactor  =varargin.scalefactor;
% header       =varargin.header;
% directoryname=varargin.pathname;
% filename     =varargin.filename;
else                     %not a structure

if nargin<2
  error('insufficient input to WriteBumpFile')
end

pv          =varargin{1};
scalefactor =varargin{2};

%default values
header='slider';
directoryname=getfamilydata('Directory','BumpFiles');
filename=appendtimestamp('bump', clock);

if nargin>2  header       =varargin{3};  end
if nargin>3  directoryname=varargin{4};  end
if nargin>4  filename     =varargin{5};  end
end
    
if isempty(findstr(filename,'.m')) filename=[filename '.m']; end
[fid,message]=fopen([directoryname filename],'w');

fprintf(fid,'%s\n',header);
fprintf(fid,'%d\n',size(pv,1));
for ii=1:size(pv,1)
    fprintf(fid,'%s %14.10f\n',pv(ii,:),scalefactor(ii));
end
fclose(fid);