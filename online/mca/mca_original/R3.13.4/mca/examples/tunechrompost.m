function tunechrompost
global THERING txh tyh cxh cyh
[t,c] = tunechrom(THERING,0,'chrom');
mcaput(txh, t(1), tyh, t(2), cxh, c(1), cyh, c(2));
