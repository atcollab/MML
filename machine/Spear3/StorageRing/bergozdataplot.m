function bergozdataplot( x, y, s, q )
% function bergozdataplot( x, y, s, q )
% bergozdataplot creates a 4 by 1 plot of x, y, sum, and quad terms
% 
% x    x position of bpm data
% y    y position of bpm data
% s    sum of bpm button data
% q    quad term of bpm data

lenX = length(x);
t = (1:lenX)/lenX;
figure(1); clf;
subplot(4,1,1);
plot(t, 1000*x);
ylabel( 'x  (\mum)' );
title( 'BPM data' )
subplot(4,1,2);
plot(t, 1000*y);
ylabel( 'y  (\mum)' );
subplot(4,1,3);
plot(t, s);
ylabel( 'counts' );
subplot(4,1,4);
plot(t, q);
ylabel( 'quad' );
xlabel( 'time (s)' );
