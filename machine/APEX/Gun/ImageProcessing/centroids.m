function [centroids_coords] = centroids(I)
    bw_level = graythresh(I);
    bw = im2bw(I, bw_level);
    bw = imopen(bw, strel('disk',3));
    
    
    regions = regionprops(logical(bw), 'PixelIdxList', 'PixelList', 'Centroid');
    
    centroids_coords = zeros( numel(regions), 2 );
    for i = 1:numel(regions)
        regions(i).Centroid
        [x y] = centroid(I, regions(i));
        centroids_coords(i,:) = [x y];
    end
end


function [x y] = centroid(I, a_regionprops)
    idx = a_regionprops.PixelIdxList;
    total_mass = sum( I(idx) );
    xs = a_regionprops.PixelList(:,1);
    ys = a_regionprops.PixelList(:,2);
    
    weighted_masses_x = sum( xs .* double(I(idx)) );
    weighted_masses_y = sum( ys .* double(I(idx)) );
    
    x = weighted_masses_x / total_mass;
    y = weighted_masses_y / total_mass;
end
