function varargout = calcmisalign(varargin)
% CALCMISALIGN will load the misalign data from the base application user
% data area and calculate the actual misalignment to apply to THERING. This
% is then stored again in the misalignment data structure.
%
% CALCMISALIGN(N,DISTTYPE[,LATTICE]) where N is the number of error seeds to
% generate and DISTTYPE is the type of distribution:
%
% 'normal' -> Normally distributed
% 'equal'  -> Flat distribution +-sigma provided and cutoff not used.
% 'sho'    -> Simple harmonic oscillator distribution +-sigma (sharp edge)
%             and cutoff not used.
% 'abs'    -> No random number generated, use sigma as the misalignment.

global THERING

if ~exist('THERING','var')
    disp('Please load the model first');
    return
end

mis = getappdata(0,'MisalignData');

if isempty(mis)
    disp('No misalignment data found. See SETMISALIGN for more info');
    return
end

% Parse input data
n = 3;
if nargin >= n & iscell(varargin{n})
    LATTICE = varargin{n};
else
    disp('Using THERING');
    LATTICE = THERING;
end

n = n - 1;
if nargin >= n & ischar(varargin{n})
    disttype = varargin{n};
else
    disp('Default distribution: normal');
    disttype = 'normal';
end

n = n-1;
if nargin >= n & isnumeric(varargin{n})
    numseeds = varargin{n};
else
    disp('Defaulting number of seeds to 1.');
    numseeds = 1;
end
mis.numseeds = numseeds;
% Current seed being used on the ring
mis.currseed = 0;

% Set the 'used' parameter to 0 to initialise. Flag used to determine if
% misalignments have been calculated for that element.
for i=1:length(LATTICE)
    mis.data(i).name = LATTICE{i}.FamName;
    mis.data(i).used = 0;
    mis.data(i).val = [];
end

% Calculate the random misalignment values. At the moment the longitudinal
% shift component, ds, will be ignored as well as thetax, and thetay for
% the girders. These take more time to compute and at the moment or writing
% is not seen as being necessary.

% Calculate the individual misalignments.
for i=1:mis.nind
    indices = mis.ind(i).ATindex;
    for j=indices
        if isempty(mis.data(j).val)
            mis.data(j).val = zeros(6,numseeds);
        end
        mis.data(j).val = mis.data(j).val + generaterandom(mis.ind(i).sigma,...
            numseeds,mis.ind(i).cutoff,disttype);
        
        % Flaged for easier search of elements that have been misaligned
        mis.data(j).used = 1;
    end
end

% Calculate the girder misalignments.
for i=1:mis.ngird
    % For each of the repeated girders
    for j=1:length(mis.gird(i).ATindex_girder)
        temp = generaterandom(mis.gird(i).sigma,numseeds,mis.gird(i).cutoff,disttype);
        
        % Use a general rotation matrix for x and y rotations of the
        % girders. A different one for each seed of course.
        for k=1:numseeds
            xtheta = temp(2,k);
            ytheta = temp(4,k);
            M(:,:,k) = [1      0            0        ;...
                        0  cos(xtheta) -sin(xtheta)  ;...
                        0  sin(xtheta)  cos(xtheta)]* ...
                       [cos(ytheta)  0  sin(ytheta)  ;...
                             0       1      0        ;...
                        -sin(ytheta) 0  cos(ytheta)];
        end
         
        % Find the position of the centre of mass of the girder
        centregird = (findspos(LATTICE,mis.gird(i).ATindex_girder{j}(end)) + ...
            findspos(LATTICE,mis.gird(i).ATindex_girder{j}(1)))/2;

        for k=mis.gird(i).ATindex_girder{j}
            if isfield(LATTICE{k},'T1')
                if isempty(mis.data(k).val)
                    mis.data(k).val = zeros(6,numseeds);
                end

                % Add the shift components and only the s-axis roll.
                mis.data(k).val(:,:) = mis.data(k).val(:,:) + ...
                    temp(:,:);
                
                % Calculating the contribution to x,y and s shifts due to
                % the girder rotation about x and y axes.
                % Describe the position of the element as a vector from the
                % COM of the girder to the element.
                len = findspos(LATTICE,k) + LATTICE{k}.Length/2 - centregird;
                % Rotate this element position vector for each seed and
                % determine the vector that describes the movement from the
                % old position to the new rotated position.
                for l=1:numseeds
                    oldpos_vec = [0;0;len];
                    newpos_vec = M(:,:,l)*oldpos_vec;
                    change_vec = newpos_vec-oldpos_vec;
                    
                    % Apply the changes.
                    mis.data(k).val([1 3 5],l) = mis.data(k).val([1 3 5],l) + change_vec;
                end
                
                % Flaged for easier search of elements that have been
                % misaligned
                mis.data(k).used = 1;
            end
        end
    end
end

disp('Finished calculation the misalignments');
setappdata(0,'MisalignData',mis);



function randnum = generaterandom(sigma,num,cutoff,disttype)
% Expects sigma to be a 6 x 1 vector but will still handle it if its a 1 x
% 6 vector.

sigmatrix = repmat(reshape(sigma,6,1),1,num);

switch disttype
    case 'normal'
        % Normal distribution
        % randnum is a 6 x num matrix
        randnum = sigmatrix.*randn(6, num);
        % If cutoff == 0 then don't cut anything.
        if cutoff ~= 0
            ind = find(abs(randnum) > cutoff*sigmatrix);
            while ~isempty(ind)
                randnum(ind) = sigmatrix(ind).*randn(length(ind),1);
                ind = find(abs(randnum) > cutoff.*sigmatrix);
            end
        end
    case 'equal'
        % Equal/Flat distribution
        % Cutoff ignored completely
        randnum = sigmatrix.*(2*rand(6, num) - 1);
    case 'sho'
        % Simple harmonic oscillator distribution
        randnum = sigmatrix.*sin(rand(6, num)*2*pi);
    case 'abs'
        % Use the values provided. No randomness.
        randnum = sigmatrix;
    otherwise
        disp(['Unknown distribution: ' disttype]);
        randnum = [];
end