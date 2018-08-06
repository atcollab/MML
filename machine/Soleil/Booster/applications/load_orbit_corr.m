function [orbit]=load_orbit_corr

istart=27;
iend  =200;
nbpmx=22;

clear Zm Xm


[Xm,Zm] = getboobpm(nbpmx,iend,istart);

orbit.x=Xm;
orbit.z=Zm;
orbit.corx=getam('HCOR');
orbit.corz=getam('VCOR');

%save 'orbit_23-Apr-2006_16:55:30_cor_on_foucault' 'Xm' 'Zm' 'Corr_X' 'Corr_Z'

