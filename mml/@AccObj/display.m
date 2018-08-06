function display(DataObj)
%DISPLAY - Command window display of a middle layer object
%  display(AccObj)
%
%  Written by Greg Portmann


%     a = [DataObj.DeviceList DataObj.Data];
%     fprintf('%3d  %3d  %10.6f\n', a');


if any(size(DataObj) > 1)
    for i = 1:size(DataObj,1)
        for j = 1:size(DataObj,2)
            Families = fieldnames(DataObj(i,j));
            if isempty(Families)
                fprintf('%s(%d,%d) = []\n\n', inputname(1), i, j);
            else
                fprintf('%s(%d,%d) =\n', inputname(1), i, j);
                disp(DataObj(i,j));
            end
        end
    end
else
    Families = fieldnames(DataObj);
    Mat = [];
    for i = 1:size(DataObj,1)
        Row = [];
        for j = 1:size(DataObj,2)
            Col = [];
            for k = 1:length(Families)
                Col = [Col; DataObj(i,j).(Families{k}).Data];
            end
            Row = [Row Col];
        end
        Mat = [Mat; Row];
    end
    fprintf('\n%s = \n\n', inputname(1));
    if isempty(Mat)
        fprintf('     []\n\n');
    else
        disp(Mat);
    end
end