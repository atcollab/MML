function [roi] = get_roi(I, threshold, margin)
    %estimates the ROI based on the shape inferred from the BW image
    %expand the detected bounding box by a factor of 'margin'  
    b_box = get_maximal_bounding_box(I, threshold);
    
    b_box = b_box + [ -margin/2 -margin/2 margin margin];
    
    roi = imrect(gca, b_box);

function [bbox] = get_maximal_bounding_box(I, level)
    bw = im2bw(I, level);
    
    % use bwareaopen to remove objects smaller than n pixels
    bw = bwareaopen(bw,5);
    
    reg_props = regionprops(bw, 'BoundingBox');
    min_y = inf;
    min_x = inf;
    max_x = 0;
    max_y = 0;
    for i=1:numel(reg_props)
        reg_prop = reg_props(i);
        bbox_src = num2cell(reg_prop.BoundingBox);
        [xmin, ymin, width, height] = bbox_src{:};
        if xmin < min_x
            min_x = xmin;
        end
        if ymin < min_y
            min_y = ymin;
        end
        if (xmin+width) > max_x
            max_x = (xmin+width);
        end
        if (ymin+height) > max_y
            max_y = (ymin+height);
        end
    end
    
    bbox = [min_x, min_y, max_x-min_x, max_y-min_y]; 
    
