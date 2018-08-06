function varargout = loadorbit(varargin)
%LOADORBIT -  Loads orbit by file/directory specification - or - Golden %orbit by default
%[X,Y] = loadorbit(BPMxList,BPMyList,DirSpec,FileName,<'x'/'z'/'b'>,<'struct'>,<'auto'>,)
%
%  Inputs: 
%          1a.  varargin = If varargin contains keyword 'struct' return entire matrix structure
%          1b.  varargin = If varargin contains keyword 'auto' do not use file browser
%          1c.  varargin = If varargin contains keyword 'x' or 'z' only return horizontal or vertical orbit
%                          [X]   = loadorbit(BPMxList,[],      DirSpec, FileName, 'x', 'Struct');
%                          [Z]   = loadorbit([],      BPMyList,DirSpec, FileName, 'z', 'Struct');
%                          [X,Z] = loadorbit(BPMxList,BPMyList,DirSpec, FileName, 'b', 'Struct','Auto');
%                          Dimension: 1, 'x' - return only horizontal coordinates
%                          Dimension: 2, 'z' - return only vertical coordinates
%                          Dimension: 3, 'b' - return both planes
%                          - defaults to both planes (Dimension 3)
%                          Assumes BPM families are 'BPMx' and 'BPMz'
%                          BPMlist ([Sector Device #] or [element #]) (default: all BPMs)
%          2.  DirSpec   = Directory name for orbit data file  
%          3.  FileName  = File name for orbit data
%
%   OUPUTS:
%   1. Beam position

% Written by J. Corbett 7/12/03
% Modified by Laurent S. Nadolski

% TODO clean up, a bit messy

% %remove [] from varargin
%   for k = length(varargin):-1:1
%     if isempty(varargin{k})
%             varargin(k) = [];
%     end
%   end


%Default input values - assign opsdata directory and golden file
BPMxFamily = gethbpmfamily;
BPMyFamily = getvbpmfamily;
BPMxList   = find(getfamilydata(BPMxFamily,'Status'));
BPMyList   = find(getfamilydata(BPMyFamily,'Status'));
DirSpec    = getfamilydata('Directory','BPMData');   %default to BPM data directory
FileName   =  [];                %no default file
XPlaneFlag = 0;
YPlaneFlag = 0;
XYPlaneFlag= 0;
StructOutputFlag = 0;       %default numeric output (not structure)
AutoReadFlag     = 0;       %default pop file read browser

%Check for structure output request
   [varargin, StructOutputFlag] = findkeyword(varargin,'struct');

%Check for auto read request
  % [varargin, AutoReadFlag] = findkeyword(varargin,'auto');
   
%Check for plane request
   [varargin, XPlaneFlag] = findkeyword(varargin,'x');
   [varargin, YPlaneFlag] = findkeyword(varargin,'z');
   [varargin, XYPlaneFlag]= findkeyword(varargin,'b');

%Evaluate the dimension (default 3=both)
   Dim = 0;   %unspecified
   if XPlaneFlag
      Dim = 1;
   elseif  YPlaneFlag
      Dim = 2;
   elseif  XYPlaneFlag
      Dim = 3;
   end

%assign values specified by varargin
   if nargin>=1
     if  size(varargin,2) >= 1  
         BPMxList=varargin{1}; 
     end
     if  size(varargin,2) >= 2  
         BPMyList=varargin{2}; 
     end
     if     size(varargin,2) >= 3  DirSpec=varargin{3}; end
     if     size(varargin,2) == 4  FileName=[varargin{4} '.mat']; end
   end
   
   X=[];
   Z=[];

if AutoReadFlag == 0    %browse for file
[FileName, DirSpec,FilterIndex]=uigetfile('*.mat','Select Orbit Archive File',[DirSpec FileName]);
    if FilterIndex==0
    disp('   Warning: No orbit loaded');
    if     Dim==1
    varargout{1}=[];
    elseif Dim==2
    varargout{1}=[];
    elseif Dim==0 | Dim==3
    varargout{1}=[];
    varargout{2}=[];
    end
    return
    end
end
    
FileSpec=[DirSpec FileName];
if exist(FileSpec,'file')==0 | exist(FileSpec,'file')==7
    error(['File not found in loadorbit: ' FileSpec]);
    disp('   Warning: No orbit loaded');
    if     Dim==1
    varargout{1}=[];
    elseif Dim==2
    varargout{1}=[];
    elseif Dim==0 | Dim==3
    varargout{1}=[];
    varargout{2}=[];
    end
  return
end

orbitdata = load(FileSpec);          %load orbit archive file - always a structure in archive

structnames = fieldnames(orbitdata);

%Note that structure names can be any string (not just X, Z)
for ii=1:size(structnames,1)
    DataStruct=orbitdata.(structnames{ii});
    if iscell(DataStruct)  DataStruct=DataStruct{1}; end
    if      DataStruct.FamilyName==BPMxFamily    
      X = DataStruct;
    elseif  DataStruct.FamilyName==BPMyFamily    
      Z = DataStruct;
    end
end

%check requested data exists
if (Dim==1 | Dim==3) & isempty(X)  error(['horizontal data not available in orbit file: ' FileSpec]); end
if (Dim==2 | Dim==3) & isempty(Z)  error([  'vertical data not available in orbit file: ' FileSpec]); end

if ~isempty(X.DeviceList) BPMxList=dev2elem(BPMxFamily,X.DeviceList); end
if ~isempty(Z.DeviceList) BPMyList=dev2elem(BPMyFamily,Z.DeviceList); end
[ierror]=checkdevicelist(X,BPMxList,Z,BPMyList,Dim);
if ierror==1 return; end

if     Dim==0   %no specific plane request
   if size(structnames,1)==1 && ~isempty(X)  Dim=1; end  %put data into X=varargout{1}
   if size(structnames,1)==1 && ~isempty(Z)  Dim=2; end  %put data into Z=varargout{2}
   if size(structnames,1)==2   Dim=3; end  %put data into X=varargout{1}, Z=varargout{1}
end
      
%Reduce orbit if necessary
if Dim == 1 | Dim == 3
X.Data = X.Data;
X.DeviceList=elem2dev(BPMxFamily,BPMxList);
end
if Dim == 2 | Dim == 3
Z.Data = Z.Data;
Z.DeviceList=elem2dev(BPMyFamily,BPMyList);
end

X.FileName = FileSpec;
Z.FileName = FileSpec;

if StructOutputFlag == 0   %caller wants numeric output
X = X.Data;
Z = Z.Data;
end

%Output requested planes
if     Dim==1
    varargout{1}=X;
    if nargout==2 varargout{2}=[]; end  %Dim=0 (unspecified) but caller expects two outputs 
elseif Dim==2                           
    if nargout==2                       %Dim=0 (unspecified) but caller expects two outputs
        varargout{1}=[]; 
        varargout{2}=Z;
    else  
        varargout{1}=Z;
    end
elseif Dim==3
    varargout{1}=X;
    varargout{2}=Z;
end


%==========================================================
function ierror=checkdevicelist(X,BPMxList,Z,BPMyList,Dim);
%==========================================================
ierror=0;
%check for BPMs requested but not supplied
if     Dim==1
  [ElemListNotFound, iNotFound]=setdiff(BPMxList, dev2elem(BPMxFamily,X.DeviceList));
  if iNotFound>0
    ierror=1;
    for ii=1:iNotFound
        disp(['Warning: BPM value not in Archive Orbit: ' getfamilydata(BPMxFamily,'CommonNames',ElemListNotFound(ii))]);
    end
   return
   end

elseif Dim==2
  [ElemListNotFound, iNotFound]=setdiff(BPMyList, dev2elem(BPMyFamily,Z.DeviceList));
    if iNotFound>0
    ierror=1;
    for ii=1:iNotFound
        disp(['Warning: BPM value not in Archive Orbit: ' getfamilydata(BPMyFamily,'CommonNames',ElemListNotFound(ii))]);
    end
   return
   end

elseif Dim==3
  [ElemListNotFound, iNotFound]=setdiff(BPMxList, dev2elem(BPMxFamily,X.DeviceList));
    if iNotFound>0
    ierror=1;
    for ii=1:iNotFound
        disp(['Warning: BPM value not in Archive Orbit: ' getfamilydata(BPMyFamily,'CommonNames',ElemListNotFound(ii))]);
    end
   return
   end

  [ElemListNotFound, iNotFound]=setdiff(BPMyList, dev2elem(BPMyFamily,Z.DeviceList));
    if iNotFound>0
    ierror=1;
    for ii=1:iNotFound
        disp(['Warning: BPM value not in Archive Orbit: ' getfamilydata(BPMyFamily,'CommonNames',ElemListNotFound(ii))]);
    end
   return
   end

end
