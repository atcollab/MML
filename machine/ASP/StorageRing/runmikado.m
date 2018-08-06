plane = 1;

if plane == 1

    devlist = getlist('HCM');

    for i=1:size(devlist,1)
        horbit = getam('BPMx');
        measure_before = sum(horbit.^2);

        stepsp('HCM',10,devlist(i,:),-2,'Hardware');
        pause(0.2);

        horbit = getam('BPMx');
        measure_after = sum(horbit.^2);

        deltameasure(i) = measure_before - measure_after;

        stepsp('HCM',-10,devlist(i,:),-2,'Hardware');
    end

    figure;
    plot(deltameasure);
    [val ind] = max(abs(deltameasure));
    devind = devlist(ind,:);
    if deltameasure(ind) > 0
        directionstr = 'POSITIVE';
    else
        directionstr = 'NEGATIVE';
    end

    fprintf('Maximum influence from device [%d %d]. In %s direction.\n',devind(1),devind(2),directionstr);

else
    devlist = getlist('VCM');

    for i=1:size(devlist,1)
        horbit = getam('BPMy');
        measure_before = sum(horbit.^2);

        stepsp('VCM',5,devlist(i,:),-2,'Hardware');
        pause(0.2);

        horbit = getam('BPMy');
        measure_after = sum(horbit.^2);

        deltameasure(i) = measure_before - measure_after;

        stepsp('VCM',-5,devlist(i,:),-2,'Hardware');
    end

    figure;
    plot(deltameasure);
    [val ind] = max(abs(deltameasure));
    devind = devlist(ind,:);
    if deltameasure(ind) < 0
        directionstr = 'POSITIVE';
    else
        directionstr = 'NEGATIVE';
    end

    fprintf('Maximum influence from device [%d %d]. In %s direction.\n',devind(1),devind(2),directionstr);
end