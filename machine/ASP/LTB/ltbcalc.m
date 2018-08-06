convfactor = -19.44/2;

vcmpos = [1.41; 4.83; 10.5; 11.2; 13];
ltbamps = [0.23 0.23; 0.91 0.91; -0.8 0.64; 1.8 0.7];
mrad = ltbamps*convfactor;
dy1 = diff(vcmpos).*mrad(:,1);
dy2 = diff(vcmpos).*mrad(:,2);