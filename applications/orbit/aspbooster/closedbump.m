THERING{167}.KickAngle = [-0.001 0];
num2 = 100;
num3 = 110;
upper2 = 0.002;
lower2 = -0.002;
upper3 = 0.002;
lower3 = -0.002;
data = zeros(num2,num3);

inc2 = (upper2-lower2)/num2;
inc3 = (upper3-lower3)/num3;

for i = 1:num2
    for j = 1:num3
        THERING{196}.KickAngle = [lower2 + inc2*i 0];
        THERING{205}.KickAngle = [lower3 + inc3*j 0];
        Rout = linepass(THERING, [0;0;0;0;0;0],225);
        data(i,j) = Rout(1);
    end
end

surf(data);


