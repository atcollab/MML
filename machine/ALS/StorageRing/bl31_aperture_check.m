% bl31_aperture_check.m
%
% This routine shows that for BL 3.1, electrons cannot get past the 1 m
% point relevant for top-off, independent of initial conditions. All
% coordinates are in the longitudinal - vertical plane.
%
% Data received from Mike Kritscher on 20090106
% entered by Christoph Steier on 20090106

bl31_ap1 = [0.02545,  0.05064  ; 0.02545, -0.05064];

bl31_brems = [0.78283,  0.02067  ; 0.78283, -0.02067];

bl31_ap2 = [1.21539,  0.01305  ; 1.21539, -0.01305];

bl31_m1ap1 = [1.64944,  0.00470  ; 1.64944, -0.00470];

bl31_m1ap2 = [2.80296, -0.02565 ; 2.80093, -0.06439];

bl31_spool = [3.75120, -0.07547 ;  3.75120, -0.11407 ];

figure;
plot(bl31_ap1(:,1),bl31_ap1(:,2),'x');
hold on;
plot(bl31_brems(:,1),bl31_brems(:,2),'x');
plot(bl31_ap2(:,1),bl31_ap2(:,2),'x');
plot(bl31_m1ap1(:,1),bl31_m1ap1(:,2),'x');
plot(bl31_m1ap2(:,1),bl31_m1ap2(:,2),'x');
plot(bl31_spool(:,1),bl31_spool(:,2),'x');

a=polyfit([bl31_m1ap1(2,1) bl31_spool(1,1)],[bl31_m1ap1(2,2) bl31_spool(1,2)],1);

plot(0:4,polyval(a,0:4));
