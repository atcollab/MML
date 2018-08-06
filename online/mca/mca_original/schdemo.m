C = {'mcaput(H,0.1)','mcaput(H,0.2)','mcaput(H,0.3)','mcaput(H,0.4)',...
        'mcaput(H,0.5)','mcaput(H,0.6)','mcaput(H,0.7)','mcaput(H,0.8)',...
        'mcaput(H,0.9)','mcaput(H,1)'};
I = cell(1,10);
D = num2cell(2000*ones(1,10));
RAMPSEQ = sch(C,I,D)
    