function [cents, overall_centroid] = detect_beam(I, roi)
% Returns the centroid for the estimated position of the beam as well as 
% its bounding box
roi_bbox = getPosition(roi);
% delete(roi);
cropped = imcrop(I, roi_bbox);
II = wiener2(cropped, [3 3]);

%calculate centroids over filtered ROI
cents = centroids(II);

%get absolute coordinates
cents(:,1) = cents(:,1) + roi_bbox(1);
cents(:,2) = cents(:,2) + roi_bbox(2);
overall_centroid = sum(cents) / size(cents,1);


end




