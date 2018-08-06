% Map MML BPM index to FOFB (Hardware) index
% Call this script in functions that need this mapping (i.e. getbpmspear)
% Edit it to see examples (after 'return') 
%
% MML (AT) indexing is different from FOFB indexing
% FOFB indexing is set by the BPM processing hardware architecture.
% MML indexing is optimal for use in high level control and
%  modeling applications
% 
%  Mapping (Revised 30-Oct-2006)
% |      132      |      116        |       132      |   132    | Index
% ========================================================================
% |  36  to  61   |    1  to     61 |    1  to   30  | 31 to 35 | BPM/2
% |  36  to  61   |   62  to    122 |    1  to   30  | 31 to 35 | FOFB
% |   1  to  26   |   27  to    87  |   88  to   117 | None     | ML Elem
% |[1 1] to [5 1] | [5 2] to [14 1] |[14 2] to [18 7]| None     | ML Dev

%  116 orbit was split after position #30 to accomodate 
%  5 new 9S BPMs in slots 31:35
%  New BPMs in ML DeviceList: [9 8; 9 9; 9 10; 9 11; 9 12] 
%  132 slots 31:35 do not have BPMs attached  




mml2fofbi   = [36:61,62:122,1:30]; 
% Would like to build mml2fofbi from spear3init - implement later

% Useful indexes derived from mml2fofbi
mml2fofbix   = 2*mml2fofbi-1;
mml2fofbiy   = 2*mml2fofbi;
mml2fofbixy  = [mml2fofbix,mml2fofbiy];

% Reverse index
nbpmfofb = 122;
fofb2mmli = zeros(1,2*nbpmfofb);
for i=1:2*nbpmfofb
    temp = find(mml2fofbi==ceil(i/2));
    if ~isempty(temp)  
        fofb2mmli(i) = temp;
    else
        % Zeros in fofb2mmli correspond to elements in fofb arrays
        % that do NOT correspond to BPMs. 
        fofb2mmli(i)=0;
    end
end
clear nbpmfofb i temp

return 

% ==== Examples of using mml2fofbi and related indexes:


% 1. To find where x,y values for bpm #n_mml in mml list go in the fofb array:
n_mml = dev2elem('BPMx', [5 1; 5 4; 5 6]) % mml 'Element' index fom mml 'Device'
nx_fofb = mml2fofbix(n_mml)
ny_fofb = mml2fofbiy(n_mml) % ny_fofb = nx_fofb+1


% 2. To find which bpm/plane corresponds to element #n in fofb array:
 
fofb2mmli(nx_fofb) % = n_mml
rem(nx_fofb,2) % n_fofb odd  -> x plane 
rem(ny_fofb,2) % n_fofb even -> y plane 


% 3. To build fofb orbit from mml orbit 
dlx = getfamilydata('BPMx','DeviceList');
dly = getfamilydata('BPMy','DeviceList');
[x, y] = getbpm([],dlx,dly); % Get all mml bpms including Status==0
nbpmfofb = 122;
orbit_fofb = zeros(2*nbpmfofb,1); % preallocate
orbit_fofb(mml2fofbixy) = [x; y]; % orbit in fofb format
% or  separately for x and y
% orbit_fofb(mml2fofbix) = x;
% orbit_fofb(mml2fofbiy) = y;


% 4. To build fofb orbit response matrix (ORM) from mml ORM

dlx = getfamilydata('BPMx','DeviceList');
dly = getfamilydata('BPMy','DeviceList');
R = getbpmresp('BPMx', dlx, 'BPMy', dly, 'HCM', 'VCM');
R(find(isnan(R))) = 0;
nbpmfofb = 122;
R_fofb = zeros(2*nbpmfofb,size(R,2));
R_fofb(mml2fofbixy,:) = R; 


% 5. To build mml orbit from fofb orbit:
orbit_fofb = fofbgetorbit; %Orbit vector in fofb format
x_mml = orbit_fofb(mml2fofbix); % x in mml format 
y_mml = orbit_fofb(mml2fofbiy); % y in mml format 
xy_mml = orbit_fofb(mml2fofbixy); % 2-plane orbit in mml format





