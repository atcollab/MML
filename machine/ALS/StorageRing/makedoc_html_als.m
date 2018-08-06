function makedoc_html_als
%MAKEDOC_HTML_ALS - Generate new MML help files for the ALS
%  makedoc_html
%
%  Written by Greg Portmann


% Make ALS HTML help

DirectoryStart = pwd;
[DirectoryName, FileName, ExtentionName] = fileparts(mfilename('fullpath'));

cd(DirectoryName);
cd ..


try
    if isdir('doc_html')
        rmdir('doc_html','s');
    end
catch
end
cd ..
try
    if isdir('doc_html')
        rmdir('doc_html','s');
    end
catch
end

MMLDirectory = {...
    fullfile('ALS','StorageRing'), ...
    fullfile('ALS','Booster'), ...
    fullfile('ALS','BTS'), ...
    fullfile('ALS','LTB'), ...
    };

m2html('mfiles', MMLDirectory, 'htmldir','doc_html', 'recursive','off', 'graph','Off');


% Move doc_html directory to ALS
movefile('doc_html', 'ALS');


cd(DirectoryStart);

