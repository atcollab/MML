% HCM Step

QuadFamily = 'QFA';
QuadDevList = getlist('QFA');  %[6 1];

QuadDevList(10:end,:) = [];


for k = 1:size(QuadDevList,1)

    % stepsp WaitFlag=-2 test
    tic;
    x0 = getx;
    y0 = gety;
    setqfashunt(1, 1, QuadDevList(k,:), -2);
    setqfashunt(2, 1, QuadDevList(k,:), -2);
    T2 = toc;
    x1 = getx;
    y1 = gety;
    setqfashunt(1, 0, QuadDevList(k,:), -2);
    setqfashunt(2, 0, QuadDevList(k,:), -2);
    pause(1);


    % Model step
    %setsp('HCM',.1*randn(96,1), 'Model');
    %setsp('VCM',.1*randn(72,1), 'Model');

    p = getpvmodel('QFA','PolynomA',QuadDevList(k,:));
    p(1) = 1e-3;
    
    xm0 = getx('Model');
    ym0 = gety('Model');

    setpvmodel(QuadFamily, 'PolynomA', p, QuadDevList(k,:));
    xm1 = getx('Model');
    ym1 = gety('Model');
    p(1) = 0;
    setpvmodel(QuadFamily, 'PolynomA', p, QuadDevList(k,:));

    %setsp('HCM',0*randn(96,1), 'Model');
    %setsp('VCM',0*randn(72,1), 'Model');


    % Display
    figure;

    x  = x1 -x0;
    xm = xm1-xm0;

    y  = y1 -y0;
    ym = ym1-ym0;

    subplot(2,1,1);
    [tmp,i] = max(abs(xm));
    %plot([x (x(i)/xm(i))*xm], '.-');
    plot([x sign(xm(i)/x(i))*(std(x)/std(xm))*xm], '.-');

    title(sprintf('%s(%d,%d)  Time change shunt was %f seconds',QuadFamily, QuadDevList(k,1),QuadDevList(k,2), T2));

    subplot(2,1,2);
    [tmp,i] = max(abs(ym));
    %plot([y (y(i)/ym(i))*ym], '.-');
    plot([y sign(ym(i)/y(i))*(std(y)/std(ym))*ym], '.-');
    
    save(sprintf('%s_%d_%d',QuadFamily, QuadDevList(k,1),QuadDevList(k,2)))

    orient tall
    pause(0);

end