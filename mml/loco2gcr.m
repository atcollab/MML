function [gx, gy, c, r] = loco2gcr(m)
%LOCO2GCR - Converts the LOCO BPM output to gain, crunch, and roll parameterization
%  [Gx, Gy, C, R] = loco2gcr(M)
%
%  INPUTS
%  1. M - LOCO output matrix (gain/coupling) 
%         [HBPMGain     HBPMCoupling
%          VBPMCoupling VBPMGain     ]
%
%  OUTPUTS
%  1. Gx - Horizontal gain
%  2. Gy - Vertical gain
%  3. C - Crunch
%  4. R - Roll [radians]
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
%  LOCO Matrix for the ith BPM  = [BPMData.HBPMGain(i)     BPMData.HBPMCoupling(i)
%                                  BPMData.VBPMCoupling(i) BPMData.VBPMGain(i)     ];
%
%  inv(LOCO Matrix) = Rotation Matrix  *  Crunch Matrix        *  Gain Matrix
%                    | cos(R) sin(R) |   | 1  C |                 | Gx  0  |
%                    |-sin(R) cos(R) |   | C  1 | / sqrt(1-C^2)   | 0   Gy |
% 
%  See also gcr2loco, getgain, getroll, getcrunch

%  Written by Greg Portmann


m = inv(m);

% Roll
r = .5 * atan( (m(2,2)*m(2,1)-m(1,1)*m(1,2)) / (m(1,1)*m(2,2)+m(1,2)*m(2,1)) );


a = m(1,1)*cos(r) + m(2,1)*sin(r);
b = m(2,2)*cos(r) - m(1,2)*sin(r);


% Crunch
c = (-m(1,1)*sin(r)+m(2,1)*cos(r)) / a;
%c_also = (m(2,2)*sin(r)+m(1,2)*cos(r)) / b


% Gain
s = sqrt(1-c^2);
gx = s * a;
gy = s * b;


