function outStruct = idGetGeomParamForUndSOLEIL(idName)

outStruct.sectLenBwBPMs = 2.*3.14155; %[m] straight section length between BPMs
outStruct.idCenPos = 1.333; %[m] center longitudinal position of the ID with respect to the straight section center
outStruct.idLen = 1.8; %[m] ID length
outStruct.idKickOfst = 0.2; %[m] offset from ID edge to effective position of a "kick"
outStruct.indUpstrBPM = 54; %absolute index of BPM at the upstream edge of the straight section where the ID is located

if strncmp(idName, 'U20', 3)
    %To be checked by Chams and Pascale B.
	outStruct.sectLenBwBPMs = 2.4; %[m] straight section length between BPMs
	outStruct.idCenPos = 0; %[m] center longitudinal position of the ID with respect to the straight section center
	outStruct.idLen = 2; %[m] ID length
	outStruct.idKickOfst = 0.1; %[m] offset from ID edge to effective position of a "kick"

    if strcmp(idName, 'U20_PROXIMA1')
        outStruct.indUpstrBPM = 72; %to check ! absolute index of BPM at the upstream edge of the straight section where the ID is located
    elseif strcmp(idName, 'U20_SWING')
        outStruct.indUpstrBPM = 80; %to check ! absolute index of BPM at the upstream edge of the straight section where the ID is located
    end
elseif strncmp(idName, 'HU80', 4)
    outStruct.sectLenBwBPMs = 2.*3.14155; %[m] straight section length between BPMs
    outStruct.idCenPos = 1.333; %[m] center longitudinal position of the ID with respect to the straight section center
    outStruct.idLen = 1.8; %[m] ID length
    outStruct.idKickOfst = 0.2; %[m] offset from ID edge to effective position of a "kick"

    if strcmp(idName, 'HU80_TEMPO')
        outStruct.indUpstrBPM = 54; %absolute index of BPM at the upstream edge of the straight section where the ID is located
    elseif strcmp(idName, 'HU80_PLEIADES')
        %outStruct.indUpstrBPM = 72; %to check ! absolute index of BPM at the upstream edge of the straight section where the ID is located
    end

elseif strncmp(idName, 'HU256', 5)
    outStruct.sectLenBwBPMs = 2.*3.14155; %[m] straight section length between BPMs
    outStruct.idCenPos = 0.8945; %[m] center longitudinal position of the ID with respect to the straight section center
    outStruct.idLen = 3.392; %[m] ID length
	outStruct.idKickOfst = 0; %[m] offset from ID edge to effective position of a "kick"
    if strcmp(idName, 'HU256_CASSIOPEE')
        outStruct.indUpstrBPM = 106; %absolute index of BPM at the upstream edge of the straight section where the ID is located
    elseif strcmp(idName, 'HU256_PLEIADES')
        outStruct.indUpstrBPM = 24;
    elseif strcmp(idName, 'HU256_ANTARES')
        outStruct.indUpstrBPM = 84;
    end

elseif strcmp(idName, 'HU640_DESIRS')
    %To be checked by Olivier and Pascale B.
	outStruct.sectLenBwBPMs = 11.318; %to check ! [m] straight section length between BPMs
    outStruct.idCenPos = 0; %[m] center longitudinal position of the ID with respect to the straight section center
    outStruct.idLen = 10.4; %to check ! [m] ID length
    outStruct.idKickOfst = 0.32; %[m] offset from ID edge to effective position of a "kick"
	outStruct.indUpstrBPM = 30; %absolute index of BPM at the upstream edge of the straight section where the ID is located
end
