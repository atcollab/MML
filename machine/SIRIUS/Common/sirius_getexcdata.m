function ExcData = sirius_getexcdata(CommonNames)
%SIRIUS_GETEXCDATA - Reads excitation curves for various magnets.
%
%2015-09-02

AD = getad;

for i=1:length(CommonNames(:,1))  
    
    CName = lower(CommonNames(i,:));
    file = fopen([AD.Directory.ExcDataDir, filesep, deblank(CName), '.txt']);
    j = 1;
    ExcData.skew{i} = false;
    try
        while ~feof(file)
            line = fgetl(file);
            if ~isempty(strfind(line, '#'))
                if ~isempty(regexpi(line, 'main_harmonic', 'match'))
                   main_harmonic = regexpi(line, 'main_harmonic', 'split');
                   ExcData.main_harmonic{i} = sscanf(main_harmonic{end}, '%f');
                   if ~isempty(regexpi(line, 'skew', 'match'))
                      ExcData.skew{i} = true;
                   end
                elseif ~isempty(regexpi(line, 'harmonics', 'match'))
                   harmonics = regexpi(line, 'harmonics', 'split');
                   ExcData.harmonics{i} = sscanf(harmonics{end}, '%f');
                end
            elseif ~isempty(line)
                data(j, :) = sscanf(line, '%e');
                j = j+1;
            end
        end 
        fclose(file);

        if size(data, 2) ~= (2*length(ExcData.harmonics{i})+1)
            error('Mismatch between number of columns and size of harmonics list in excitation curve');
        end

        ind = 2*find(ExcData.harmonics{i} == ExcData.main_harmonic{i}) + 1*ExcData.skew{i};
        ExcData.data{i} = data(:, [1, ind]);
        ExcData.multipoles_data{i} = data;
    catch
        ExcData = [];
    end
    
    
end

if isempty(ExcData)
    fprintf('\n   WARNING: Problem with %s excitation curve.\n', CommonNames(1,:));
end

end