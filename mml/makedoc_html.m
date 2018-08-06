function makedoc_html
%MAKEDOC_HTML - Generate new MML and AT HTML help files
%  makedoc_html

%  Written by Greg Portmann


DirectoryStart = pwd;

[DirectoryName, FileName, ExtentionName] = fileparts(mfilename('fullpath'));

cd(DirectoryName);


% Delete old directory first
try
    if isdir('doc_html')
        rmdir('doc_html', 's');
    end
catch
end
cd ..
try
    if isdir('doc_html')
        rmdir('doc_html', 's');
    end
catch
end


MMLDirectory = {...
    'mml', ...
    fullfile('mml','at'), ...
    fullfile('mml','links','labca'), ...
    fullfile('links','mca_asp'), ...
    fullfile('links','labca','bin','linux-x86','labca'), ...
    fullfile('applications','common'), ...
    fullfile('applications','loco'), ...
    fullfile('applications','mysql'), ...
    fullfile('applications','orbit'), ...
    fullfile('machine','VUV','800MeV'), ...
    };

%m2html('mfiles', MMLDirectory, 'htmldir','doc_html', 'recursive','off', 'graph','On');
m2html('mfiles', MMLDirectory, 'htmldir','doc_html', 'recursive','off', 'graph','Off');


% Move doc_html directory to MML
movefile('doc_html', 'mml');



% Make AT HTML help
cd at
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
    'at', ...
    fullfile('at','atdemos'), ...
    fullfile('at','atdemos'), ...
    fullfile('at','atgui'), ...
    fullfile('at','atphysics'), ...
    fullfile('at','lattice'), ...
    fullfile('at','simulator','element'), ...
    fullfile('at','simulator','element','user'), ...
    fullfile('at','simulator','track'), ...
    };

m2html('mfiles', MMLDirectory, 'htmldir','doc_html', 'recursive','off', 'graph','Off');

% Move doc_html directory to AT
movefile('doc_html', 'at');


cd(DirectoryStart);


