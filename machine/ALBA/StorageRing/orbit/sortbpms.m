function varargout = sortbpms(varargin)
%SORTBPMS - Compares vectors for several cases:
%(1) available electronically (BPM.status)
%(2) available in reference orbit (BPM.iref)
%(3) available in response matrix (RSP.ib)
%*** BPM.avail requires reference, response matrix, status
%
% INPUTS
% 1. Bpm structure
% 2. Response matrix structure
%
% OUTPUTS
% 1. Updated BPM structure

% 
% Written by Jeff Corbett
% Modified by Laurent S. Nadolski

BPM = varargin{1};
RSP = varargin{2};

% [C,IA,IB] = INTERSECT(A,B) returns index vectors IA and IB
% such that C = A(IA) and C = B(IB)
% [C,I] = SETDIFF(...) returns an index vector I such that C = A(I)

for ip = 1:2
    % compare status with reference orbit
    [BPM(ip).avail,IA,IB] = intersect(BPM(ip).iref,BPM(ip).status); %BPM.iref and BPM.status are compressed
    [C,IA] = setdiff(BPM(ip).iref,BPM(ip).iref(IA));                %check for rejected reference BPMs
    if ~isempty(IA)
        disp('SortBPMs Warning 1A: BPMs in reference orbit do not have valid status');
        for ii = IA
            disp(BPM(ip).name(ii,:));
        end
    end

    % compare result with response matrix
    [BPM(ip).avail,IA,IB] = intersect(BPM(ip).avail,RSP(ip).ib);  %BPM.avail and RSP.ib are compressed
    [C,IA] = setdiff(BPM(ip).avail,BPM(ip).avail(IA));            %check for rejected available BPMs
    if ~isempty(IA)
        disp('SortBPMs Warning 2A: BPMs with valid status and in reference orbit not in response matrix');
        for ii=IA
            disp(BPM(ip).name(ii,:));
        end
    end

    % compare result with fit selection
    [BPM(ip).ifit,IA,IB] = intersect(BPM(ip).avail,BPM(ip).ifit); %BPM.avail and BPM.ifit are compressed
    [C,IA] = setdiff(BPM(ip).avail,BPM(ip).avail(IA));            %check for rejected available BPMs   
    if ~isempty(IA)
        disp('SortBPMs Warning 3A: BPMs with valid status, in reference orbit, and in response matrix not in fit');
        for ii = IA
            disp(BPM(ip).name(ii,:));
        end
    end

end  %end of plane loop

varargout{1} = BPM;