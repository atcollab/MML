C1 = {'disp(''A'')','disp(''B'')','disp(''C'')'};
D1 = {3000 3000 3000};
I1 = {'delay','delay','delay'};
S1 = sch(C1,I1,D1);
 
 
C2 = {'disp(''1'')','disp(''2'')','disp(''3'')'};
D2 = {4000 4000 4000};
I2 = {'delay','delay','delay'};
S2 = sch(C2,I2,D2);

S1 = scheduler(S1);
S2 = scheduler(S2);