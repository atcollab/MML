function m = gcr2loco(gx, gy, c, r)
%LOCO2GCR - Converts the LOCO BPM output to gain, crunch, and roll parameterization
%  M = gcr2loco(Gx, Gy, C, R)
%
%  INPUTS
%  1. Gx - Horizontal gain
%  2. Gy - Vertical gain
%  3. C - Crunch
%  4. R - Roll [radians]
%
%  OUTPUTS
%  1. M - LOCO output matrix (gain/coupling) 
%     Note: for vector inputs the output will have rows [Gx Gy C R]
%
%  ALGORITHM
%  The LOCO matrix for a BPM converts the model BPM data to the
%  coordinate system of the actual BPM measurement.  The new BPM is   
%  is defined as the calibrated BPM data.  The middle layer applies
%  the coordinate conversion from the measured data to the model gcr2loco splits this matrix up
%  into a Gain, Crunch, and Roll term.
%
%  [Measured Coordinate System] = LOCO Matrix * [Model]                          (LOCO coordinate transform)
%  [Calibrated to Model Coordinate System] = inv(LOCO Matrix) * [Measured Data]  (Middle layer coordinate transform)
%
%  The middle layer stores the coordinate transform in terms of gain, crunch, and roll.
%  The gain terms are use in real2raw/raw2real (hence hw2physics/physics2hw) and the 
%  crunch and roll are used in programs like getpvmodel/setpvmodel.  That is, hw2physics/physics2hw
%  does not make a coordinate rotation, it just corrects the gain.
%
%  inv(LOCO Matrix) = Rotation Matrix  *  Crunch Matrix        *  Gain Matrix
%                    | cos(R) sin(R) |   | 1  C |                 | Gx  0  |
%                    |-sin(R) cos(R) |   | C  1 | / sqrt(1-C^2)   | 0   Gy |
%
%  See also loco2gcr, getgain, getroll, getcrunch

%  Written by Greg Portmann


if nargin == 0
    error('At least one input required.');
end


if length(gx) > 1
    for i = 1:size(gx,1)
        if nargin < 2
            mm = gcr2loco(gx(i));
        elseif nargin < 3
            mm = gcr2loco(gx(i), gy(i));
        elseif nargin < 4
            mm = gcr2loco(gx(i), gy(i), c(i));
        else
            mm = gcr2loco(gx(i), gy(i), c(i), r(i));
        end
        m(i,:) = [mm(1) mm(2) mm(3) mm(4)];
    end
    return
end


% Roll term
if nargin == 1
    m = [1/gx 0; 0 0];
    return
else
    m = [1/gx 0; 0 1/gy];
end


% Crunch term
if nargin >= 3
    m = m * [1 -c; -c 1] / sqrt(1-c^2);
end


% Roll term
if nargin >= 4
    m = m * [cos(r) sin(r); -sin(r) cos(r)];
end

