function curve=createcyclecurve(varargin)
% INPUTS
%1. Family
%2. Nominal current
%3. Maximum current

Family = varargin{1};
Inom = varargin{2};
Imax = varargin{3};

%% check if family is valid and return it in AO
[FamilyIndex, AO] = isfamily(Family);

if FamilyIndex
    if (ismemberof(Family,'Cyclage'))
       % for k=1:tango_group_size(AO.GroupId)
       k=1;
            curve = makecurve(Inom,Imax);
%            curve = makecurve(AO.Inom(k),AO.Imax(k));
%             setcyclecurve(dev_name, curve)
       % end
    end
end

function curve = makecurve(Inom,Imax)

% curve = [[0 10]
%         [Imax 180] 
%         [0.95*Inom 180]
%         [1.05*Inom 180]
%         [0.95*Inom 180]
%         [1.05*Inom 180]
%         [0.95*Inom 180]
%         [Inom 180] ];
curve = [[0 10]
        [Imax 10] 
        [0.95*Inom 10]
        [1.05*Inom 10]
        [0.95*Inom 10]
        [1.05*Inom 10]
        [0.95*Inom 10]
        [Inom 10] ];       