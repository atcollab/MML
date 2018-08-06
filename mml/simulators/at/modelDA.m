function [DA, Data] = modelDA( r0, nsteps, nturns, dp, res)
% modelDA( r0, nsteps, nturns, dp, res)
% Evalutes the Dynamic Aperture by tracking
% required arguments
% r0:     Inital amplitude X to search ~ 0.015 m
% nsteps: Number of points to find     ~ 20
% nturns: Numbers of turns to track    ~ 256
% dp:     Energy deviation             ~ 0.0%
% res:    Resolution to find the DA    ~ 0.0005 m
% Returns the Dynamic aperture in DA and the Data for the tracking


% Written by M. Munoz

r_stable=0;
angle_step=pi/nsteps;

angle=0;
global THERING;
r=r0;
%Evaluate the Chromatic orbit
twiss=  gettwiss(THERING, 0.0);
x0=twiss.etax(1)*dp;
%Check that the chromatic orbit is stable
[T, loss]=ringpass(THERING,[x0 0.0 0 0.0 dp 0.0]',nturns);
if (loss)
    disp('The chromatic closed orbit is not stable. No DA found');
    DA(1,1)=0;
    DA(1,2)=0;
    Data=0;
else
    for i=1:nsteps+1,
        look=true; r_stable=0;
        fprintf('Tracing step %ld of %ld\n', i, nsteps);
        while (look)

            x= x0+r*cos(angle);
            y= r*sin(angle);
            [T, loss]=ringpass(THERING,[x 0.0 y 0.0 dp 0.0]',nturns);
            %fprintf('%s %d %d   \n','Tracked',r, angle);

            if (loss)
                if ((r-r_stable) < res)
                    look=false; % we have found the limit of the DA
                    DA(i,1)=r_stable*cos(angle);
                    DA(i,2)=r_stable*sin(angle);
                    r=r_stable;
                else
                    r=(r+r_stable)/2;
                end
            else
                r_stable=r;
                r=r*2;
                Data{i}=T;
            end
        end
        angle=angle+angle_step;
    end
end

