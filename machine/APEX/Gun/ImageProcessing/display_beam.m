function display_beam(imageFile)
    figure;
    I = imread(imageFile);
    bottom = axes('Position', [0.05+0.01+0.1, 0.04, 0.8, 0.1]);
    left = axes('Position', [0.05, 0.15, 0.1, 0.8]');
    center = axes('Position', [0.05+0.1+0.01, 0.05+0.1, 0.8, 0.8]');
        
    [cents, overall_centroid] = detect_beam(I);
    hold on
    for i=1:size(cents,1)
        plot(center, cents(i,1), cents(i,2), '*w');
    end
    if size(cents,1) > 1
        overall_centroid = sum(cents) / size(cents,1)
    else
        overall_centroid = cents
    end
    plot(center, overall_centroid(1), overall_centroid(2), '+w');
    hold off
    
    

    
    horizontal = sum(I,2);
    plot( left, horizontal, 1:size(horizontal), '-r');
    axis(left, 'tight');
    set(left,'YDir','reverse', 'xticklabel',[]);
    
    vertical = sum(I,1);
    plot(bottom, vertical, '-r');
    axis(bottom,'tight');
    set(bottom,'yticklabel',[]);
    
    
end