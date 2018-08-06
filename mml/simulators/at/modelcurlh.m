function [hx, hy] = modelcurlh
%MODELCURLH - Computes and plots the H-curl functions
%  [hx, hy] = modelcurlh
%
%  OUTPUTS
%  1. hx - Horizontal H-curl function
%  2. hy - Vertical   H-curl function
%
%  NOTES
%  1. H-curl is plotted is no outputs exist
%
%  See also modeltwiss


[betx, bety, Sx, Sy] = modeltwiss('beta');
[alfx, alfy] = modeltwiss('alpha');
[dx, dy    ] = modeltwiss('Eta');
[dxp,dyp   ] = modeltwiss('EtaPrime');

hx = (1+alfx.^2)./betx.*dx.^2 + 2*alfx.*dx.*dxp + dxp.^2.*betx;
hy = (1+alfy.^2)./bety.*dy.^2 + 2*alfy.*dy.*dyp + dyp.^2.*bety;

if nargout == 0
    figure
    subplot(2,1,1)
    plot(Sx,hx)
    title('Linear "Curly" H')
    xlabel('Position [m]')
    ylabel('H_x [m]')


    subplot(2,1,2)
    plot(Sy,hy)
    xlabel('Position [m]')
    ylabel('H_y [m]')
end
