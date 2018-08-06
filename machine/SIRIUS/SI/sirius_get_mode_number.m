function mode = sirius_get_mode_number(mode_label)

if strcmpi(mode_label, {'S05'})
    mode = 1;
elseif strcmpi(mode_label, {'S10'})
    mode = 2;
end