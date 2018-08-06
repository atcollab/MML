% mesure tune 2006

time = [0     20   40   60   80   100   150   200   220   240   260    280  281];
nux  = [0.56  0.54 0.56 0.58 0.59 0.60  0.59  0.624 0.637 0.642 0.644 0.659 0.666];
nuz  = [0.69  0.60 0.59 0.60 0.61 0.62 0.61  0.625  0.636 0.639  0.638 0.640 0.639];


plot(time,nux,'-or',time,nuz,'-ob')
ylim([0.5 0.8])