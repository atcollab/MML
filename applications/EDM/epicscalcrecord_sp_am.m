function [visPV, Tol] = epicscalcrecord_sp_am(Family, DeviceList)
%EPICSCALCRECORD_SP_AM - Create an EPICS Calc Record string for setpoint minus monitor differences
%  visPV = epicscalcrecord_sp_am(Family, DeviceList)
%
%  NOTE
%  1. visPV is a cell if DeviceList has more than one row.
%  2. Use by,
%     WriteEDMFile(fid, EDMRectangle(x, y, 'VisibleIf',    visPV{i}, 'Range', [Tol 1000000], 'LineColor', 20, 'FillColor', 20, 'Width', ColumnWidth{j}-12-15, 'Height', 18));
%     WriteEDMFile(fid, EDMRectangle(x, y, 'NotVisibleIf', visPV{i}, 'Range', [Tol 1000000], 'LineColor', 15, 'FillColor', 15, 'Width', ColumnWidth{j}-12-15, 'Height', 18));

% Written by Greg Portmann


for i = 1:size(DeviceList,1)
    ChanName_Monitor  = family2channel(Family, 'Monitor',  DeviceList(i,:));
    if ismachine('ALS') && (strcmpi(Family,'HCM') || strcmpi(Family,'VCM'))
        ChanName_Setpoint = deblank(family2channel(Family, 'Setpoint', DeviceList(i,:)));
        ChanName_FF1      = deblank(family2channel(Family, 'FF1',      DeviceList(i,:)));
        ChanName_FF2      = deblank(family2channel(Family, 'FF2',      DeviceList(i,:)));
        ChanName_Trim     = deblank(family2channel(Family, 'Trim',     DeviceList(i,:)));
        %FFMultiplier      = getpv(Family, 'FFMultiplier');
        
        % Increase tolerance because the FOFB does not report setpoints
        % But it does flush if the setpoint is larger than a flush value (see srcontrol)
        if DeviceList(i,2) == 1 || DeviceList(i,2) == 8
            if strcmpi(Family,'HCM')
                Tol(i,1) = 0.5 + family2tol(Family, 'Setpoint', DeviceList(i,:));
            else
                Tol(i,1) = 1.0 + family2tol(Family, 'Setpoint', DeviceList(i,:));
            end
        else
            Tol(i,1) = family2tol(Family, 'Setpoint', DeviceList(i,:));
        end
        
        if isempty(ChanName_FF1) && isempty(ChanName_FF2) && isempty(ChanName_Trim)
            visPV{i} = sprintf('CALC\\\\{ABS(A-B)}(%s,%s)', ChanName_Setpoint, ChanName_Monitor);
        elseif isempty(ChanName_FF1) && isempty(ChanName_FF2)
            visPV{i} = sprintf('CALC\\\\{ABS(A+B-C)}(%s,%s,%s)', ChanName_Setpoint, ChanName_Trim, ChanName_Monitor);
        else
            if isempty(ChanName_FF1)
                ChanName_FF1 = '0';
            end
            if isempty(ChanName_FF2)
                ChanName_FF2 = '0';
            end
            if isempty(ChanName_Trim)
                ChanName_Trim = '0';
            end
            visPV{i} = sprintf('CALC\\\\{ABS(A+B+C+D-E)}(%s,%s,%s,%s,%s)', ChanName_Setpoint, ChanName_FF1, ChanName_FF2, ChanName_Trim, ChanName_Monitor);
        end
    elseif ismachine('ALS') && (strcmpi(Family,'QF') || strcmpi(Family,'QD') || strcmpi(Family,'SQEPU'))
        ChanName_Setpoint = deblank(family2channel(Family, 'Setpoint', DeviceList(i,:)));
        ChanName_FF       = deblank(family2channel(Family, 'FF',       DeviceList(i,:)));
        %FFMultiplier      = getpv(Family, 'FFMultiplier');
        
        Tol(i,1) = family2tol(Family, 'Setpoint', DeviceList(i,:));
        
        if isempty(ChanName_FF)
            visPV{i} = sprintf('CALC\\\\{ABS(A-B)}(%s,%s)', ChanName_Setpoint, ChanName_Monitor);
        else
            if isempty(ChanName_FF)
                ChanName_FF = '0';
            end
            visPV{i} = sprintf('CALC\\\\{ABS(A+B-C)}(%s,%s,%s)', ChanName_Setpoint, ChanName_FF, ChanName_Monitor);
        end
    else
        ChanName_Setpoint = family2channel(Family, 'Setpoint', DeviceList(i,:));
        ChanName_Monitor  = family2channel(Family, 'Monitor',  DeviceList(i,:));
        Tol(i,1) = family2tol(Family, 'Setpoint', DeviceList(i,:));
        if iscell(ChanName_Setpoint)
            visPV{i} = sprintf('CALC\\\\{ABS(A-B)}(%s,%s)', ChanName_Setpoint{1}, ChanName_Monitor{1});
        else
            visPV{i} = sprintf('CALC\\\\{ABS(A-B)}(%s,%s)', ChanName_Setpoint, ChanName_Monitor);
        end
    end
end

% Remove cell if one device
if length(visPV) == 1
    visPV = visPV{1};
    %fprintf('%s\n', visPV);
end
