function [Version, Date, Release] = atversion
%ATVERSION - Returns the version information for AT
%  [Version, Date, Release] = atversion

%Version = 1.3;

a = ver;
Version = [];
for i = 1:length(a)
    if strcmpi(a(i).Name, 'Accelerator Toolbox')
        Version = a(i).Version;
        Release = a(i).Release;
        Date = a(i).Date;
    end
end

