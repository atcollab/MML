function varargout = look4(varargin)

%LOOK4 Quick-search M-files with keywords using a database.
%   LOOK4 ABC XYZ ... looks through a database of help files (H1 lines
%   in m-files) for keywords ABC, XYZ, ... There can be as many keywords
%   as desired. For all files in which a match occurs, the H1 line is
%   displayed. CLASS METHODS will be indented by one space, and PRIVATE
%   function will be indented by two spaces.
%
%   LOOK4 is very similar to LOOKFOR, except that it searches through a
%   database file named mfileDatabase#.mat (where # is the version
%   number), so it is much faster.  Also, unlike LOOKFOR it accepts
%   multiple keywords. The search is case-insensitive.
%
%   mfileDatabase#.mat is created the first time LOOK4 is executed. It
%   catalogs help texts of all m-files in the MATLABPATH (including class
%   methods and private functions). The database file is stored in the same
%   directory as this file. The generation of the database file may take
%   a few minutes depending on the number of m-files and the speed of the
%   computer.
%
%   [H, P] = LOOK4('ABC', 'XYZ', ...) returns the H1 lines and the paths of
%   the corresponding m-files, respectively.
%
%   LOOK4 by itself invokes a GUI version of the search program. The GUI
%   incorporates a "key stroke" search feature. Each key stroke updates the
%   search result, but only after 0.5 seconds of non-keypress. This allows
%   fast, continuous typing. Only alphabets and numbers (and quotes) are
%   allowed in the GUI version. Click on results list, or use arrow keys to
%   navigate through results. The full help text is displayed in the bottom
%   panel.
%
%  Search options:
%   LOOK4 ABC XYZ ... -all  searches the entire first comment block of
%                           m-files.
%   LOOK4 ... -link         displays the results with hyperlinks to full
%                           help texts
%
%  Database creation/update:
%   LOOK4 -new              re-creates the database file.
%   LOOK4 -new -noverbose   does not show the name of the directory in
%                           progress.
%   LOOK4 -update           updates the database file for the current
%                           directory. This is useful for updating personal
%                           m-files.
%   LOOK4 -autoupdate       sets up auto-updating feature.
%
%   How Auto-Updating of Database Works:
%     The database can be set to automatically update (re-hash) daily or
%     weekly. LOOK4 accomplishes this by creating a function called
%     look4_autoUpdateFcn.m that gets run during startup (The function call
%     is appended to startup.m. If startup.m does not exist, it creates
%     one). look4_autoUpdateFcn creates a TIMER object (tagged
%     'look4AutoUpdateTimer') that gets executed at the appropriate time
%     and interval. Matlab needs to be running at the time of TimerFcn
%     execution. If Matlab is launched after the scheduled update time,
%     then the TimerFcn will be scheduled to execute at the next update
%     time.
%
%     Every time LOOK4 loads the database into memory (it saves as a
%     PERSISTENT variable), it also checks the age of the database file by
%     checking the modification date, and gives a warning when 2 weeks has
%     passed since the last modification. This feature creates a dummy file
%     "mfileDatabase#_vt.txt" which is used to store the time when the
%     warning was displayed.
%
%   Examples:
%     look4 root locus
%     look4 root locus -all
%
%
%   See also LOOKFOR, HELP, DOC.
%
%   e-mail bug reports/comments to <a href="mailto:jiro.doke@gmail.com">jiro</a>


%   VERSIONS:
%     v1.0 - first version
%     v1.1 - fix GUI window size (use normalized to fit to any screen)
%            (Feb 13, 2006)
%     v1.2 - fix the use of multi-word search (use single quotes)
%            (Feb 13, 2006)
%     v1.2.1 - always re-process CLASS and PRIVATE subdirectories.
%              (Feb 16, 2006)
%     v1.3 - added "key stroke" search feature. display hyperlink in
%            command line. (March 24, 2006)
%     v1.4 - added feature: auto-update of database. allow daily or weekly
%            update of the database file. display warning when the database
%            is old. (March 28, 2006)
%     v1.4.1 - minor help text and code change for elegance.
%              (March 29, 2006)
%     v1.4.2 - bug fix (March 30, 2006)
%
%   Jiro Doke
%   Feb 2, 2006

%--------------------------------------------------------------------------
% Error checking of input arguments
%--------------------------------------------------------------------------

% Check to see if input arguments are strings
iS = cellfun('isclass', varargin, 'char');
if ~all(iS)
  error('Arguments must be strings.');
end

% If no input argument, assign empty cell to VARARGIN (will start GUI)
if isempty(varargin)
  varargin = {''};
end

%--------------------------------------------------------------------------
% Check to see if database exists. If not, create one.
%--------------------------------------------------------------------------

% Determine the appropriate database file for this MATLAB version
v       = version;
v       = strrep(strtok(v), '.', '_');
datFile = fullfile(fileparts(which(mfilename)), ...
  sprintf('mfileDatabase%s.mat', v));

if ~exist(datFile, 'file') && ~strcmpi(varargin{1}, '-new')
  fprintf('Database file not found. Creating new database...\n');
  varargin = {'-new', '-noverbose'};
end

%--------------------------------------------------------------------------
% Perform appropriate process based on first argument
%--------------------------------------------------------------------------

switch lower(varargin{1})
  case ''         % Start GUI
    if nargout > 0
      error('Too many output arguments');
    end
    look4GUI(datFile);
    return;
    
  case '-update'  % Update database for this directory
    createDatabase(pwd, datFile, true);
    if nargout > 0
      error('Too many output arguments');
    end
    return;
    
  case '-new'     % (Re)Create new database
    if length(varargin) == 2 && strcmpi(varargin{2}, '-noverbose')
      createDatabase('', datFile, false)
    else
      createDatabase('', datFile, true);
    end
    if nargout > 0
      error('Too many output arguments');
    end
    return;
    
  case '-autoupdate'
    setupAutoUpdate;
    return;
    
  otherwise       % Perform keyword search
    varargin = lower(varargin);

    id1 = strmatch('-link', varargin, 'exact');
    if isempty(id1)
      showLink = false;
    else
      showLink = true;
      varargin(id1) = '';
    end
    
    id2 = strmatch('-all', varargin, 'exact');
    if isempty(id2)  % If no '-all' flag, perform H1 line search
      dat = look4Engine(datFile, 2, varargin{:});
      
    else             % Search through all help text
      varargin(id2) = ''; % Remove '-all' from search words
      dat = look4Engine(datFile, 3, varargin{:});
    end
end

%--------------------------------------------------------------------------
% Process output
%--------------------------------------------------------------------------

if nargout > 2
  error('Too many output arguments.');
elseif nargout
  varargout{1} = dat(:, 2);
  varargout{2} = dat(:, 1);
else
  if isempty(dat)
    fprintf('\nNone found.\n\n');
  else
    fprintf('\n');
    if showLink
      ddat=dat(:,[1, 1, 2])';
      fprintf('<a href="matlab:help(''%s'');disp(''%s'')">?</a> %s\n', ...
              ddat{:});
      fprintf('\nClick on ? to get full help.\n');
    else
      fprintf('%s\n', dat{:, 2});
      fprintf('\n');
    end
    fprintf('%d found.\n\n', size(dat, 1));
  end
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% createDatabase - create/update m-file database for quick-searching
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function createDatabase(d, datFile, isVerbose)
% d         - directory name. '' for creating new database.
% datFile   - full path to database file.
% isVerbose - TRUE to display the directory names.

% Database file is a n-by-3 cell array:
%   Column 1: m-file paths
%   Column 2: H1 lines
%   Column 3: Full help text

if isempty(d)
  createNew = true;
else
  createNew = false;
end

fprintf('Running %s...\n', upper(mfilename));

if createNew  % (Re)Create new database
  tic;
  % Retrieve directories in the path
  fprintf('Retrieving path... ');
  w = what('');
  fprintf('Done\n');
  [idx, idx] = unique(lower({w.path}));
  w = w(idx);
  
  % Total number of m-files
  numFiles = sum(cellfun('length', {w.m}));
  iFile = 1;
  
  % Preallocate
  dat = cell(numFiles, 3);
  
  fprintf('Creating database...\n');
  
else          % Update database

  dat = load(datFile);
  dat = dat.dat;
  
  w = what(d); w = w(1);
  
  %------------------------------------------------------------------------
  % Remove entries from the database before updating
  %------------------------------------------------------------------------
  
  idM = strmatch([lower(w.path) filesep], lower(dat(:, 1)));
  
  if ~isempty(idM)
    % Ignore subdirectories
    tmp = char(lower(dat(idM, 1)));
    tmp(:, 1:length(w.path)+1) = '';
    rmID = sum(tmp == filesep, 2) > 0;
    idM(rmID) = [];
    
    %----------------------------------------------------------------------
    % Reprocess CLASSES and PRIVATE sub-directories
    %----------------------------------------------------------------------
    
    % Find PRIVATE directories in the database
    idP = strmatch(fullfile(lower(w.path), 'private', filesep), ...
      lower(dat(:, 1)));
    
    % If PRIVATE directory exists, then add it to 'w'
    if isdir(fullfile(w.path, 'private'))
      ww = what(fullfile(w.path, 'private'));
      w(end + 1) = ww(1);
    end
    
    % Loop through CLASSES
    idC = [];
    for iC = 1:length(w(1).classes)
      % Add CLASS directory to 'w'
      ww = what(fullfile(w(1).path, ['@' w(1).classes{iC}]));
      w(end + 1) = ww(1);
      
      % Find CLASS directory in the database
      idC = [idC; strmatch(fullfile(lower(w(1).path), ...
          ['@' w(1).classes{iC}], filesep), lower(dat(:, 1)))];
      
      % Find PRIVATE directory under CLASS in the database
      idP = [idP; strmatch(fullfile(lower(w(1).path), ...
          ['@' w(1).classes{iC}], 'private', filesep), lower(dat(:, 1)))];
      
      % if @CLASS/PRIVATE exists, then add it to 'w'
      if isdir(fullfile(w(1).path, ['@' w(1).classes{iC}], 'private'))
        ww = what(fullfile(w(1).path, ['@' w(1).classes{iC}], 'private'));
        w(end + 1) = ww(1);
      end
      
    end
    
    % These are ideces of entries to be deleted from the database
    idM = [idM; idC; idP];
  end
  
  % Delete entries from database
  dat(idM, :) = '';
  
  % Total number of m-files
  numFiles = sum(cellfun('length', {w.m}));
  iFile = size(dat, 1) + 1;
  
  % Preallocate
  dat = [dat; cell(numFiles, 3)];
  
  fprintf('Updating database...\n');
end

%--------------------------------------------------------------------------
% Get help text for each m-file
%--------------------------------------------------------------------------

% Prepare for commandline progress display
%c = max(cellfun('length', {w.path}));
%delChar = repmat(char(8), 1, c+9);
%fmtStr = ['%5.1f %% %-' num2str(c) 's\n'];

newlineChar = sprintf('\n');

hCancel = msgbox(sprintf('%s: Click OK to stop', upper(mfilename)), '0 %');

% Loop through each directory
for ii = 1:length(w)
  drawnow;
  if ~ishandle(hCancel)
    fprintf('Canceled.\n');
    return;
  end
  if createNew
    set(hCancel, 'name', sprintf('%0.1f %%', iFile/numFiles*100));
    if isVerbose
      disp(w(ii).path);
    end
  else
    fprintf('%s ...\n', w(ii).path);
  end
  
  % Loop through each m-file in the directory
  for id = 1:length(w(ii).m)
    dat{iFile, 1} = [w(ii).path filesep w(ii).m{id}];
    
    % Retrieve help text
    s = help(dat{iFile, 1});
    
    if ~isempty(s)
      % Removing leading spaces
      letterID = find(~isspace(s));
      if ~isempty(letterID) % empty means there's no help text!!
        % Full help text
        s_Full = s(letterID(1):end);
        
        % Find new line characters
        nID    = strfind(s_Full, newlineChar);
        
        if isempty(nID) % there's only one line
          s    = s_Full;
        else            % get the first line
          s    = s_Full(1:nID(1));
        end
        
        % Remove trailing spaces
        letterID = find(~isspace(s));
        if ~isempty(letterID)
          s = s(1:letterID(end));
          
          [p, n] = fileparts(w(ii).path);
          if isempty(n) % in case path name ends in FILESEP
            [n, n] = fileparts(p);
          end
          if ~isempty(n)  % if still empty, means root (e.g. c:\)
            if n(1) == '@'
              % Class Method
              s = [' ', s];
            elseif strcmpi(n, 'private')
              % Private Function
              s = ['  ', s];
            end
          end
          
          dat{iFile, 2} = s;
          dat{iFile, 3} = s_Full;
        end
      end
    end
    
    iFile = iFile + 1;
  end

%   if createNew
%     fprintf('%s', delChar);
%   end
end

delete(hCancel);

% Convert [] empty cells to '' empty cells
iE = cellfun('isempty', dat(:, 2));
dat(iE, 2:3) = {''};

% Save database file. Save as V6 format (no compression) for faster loading
[p, n, e] = fileparts(datFile);
verifiedTimeFile = fullfile(p, [n '_vt.txt']);
v = version;
if str2double(v(1)) > 6
  save(datFile, 'dat', '-v6');
else
  save(datFile, 'dat');
end  
touchFile(verifiedTimeFile);

% Update PERSISTENT variable
look4Engine(dat);

if createNew
  fprintf('Elapsed time: %d sec ...', round(toc));
end
fprintf('Done\n');


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% loadData - loads database. this is subfunction of look4Engine because it
%            is called twice.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [dat, dat2_char, len] = loadData(datFile)

dat = load(datFile);
dat = dat.dat;

% Check modified time of $$_vt.txt file.
% This variable stores the last time out-of-date-database warning was
% displayed. This prevents the warning from showing everytime this is run.
% After a week, it will display the warning again if the database has not
% be updated
[p, n, e] = fileparts(datFile);
verifiedTimeFile = fullfile(p, [n '_vt.txt']);
if exist(verifiedTimeFile, 'file')
  dd1 = dir(verifiedTimeFile);

else
  touchFile(verifiedTimeFile);

  dd1.date = datestr(0, 0);
end

% check the age of the database
dd2 = dir(datFile);
tt = etime(clock, datevec(dd2.date))/(24*60*60);
if tt > 14  % give warning after 14 days
  tt2 = etime(clock, datevec(dd1.date));
  if tt2 > 7*24*60*60 % has been a week since last warning
    warndlg(...
      {sprintf('It has been %d days since the database has been updated', ...
      round(tt)), ...
      'You may want to update the database.', ...
      '', ...
      sprintf('%s(''-new'')   OR    %s(''-update'')', ...
      mfilename, mfilename)}, ...
      sprintf('%s: Old Database Warning', upper(mfilename)));

    touchFile(verifiedTimeFile);

  end
end

% sort alphabetically
[ii, ii] = sortrows(strjust(char(dat(:, 2)), 'left'));
dat = dat(ii, :);

dat2_char=char(lower(dat(:, 2)));
dat2_char=[blanks(size(dat, 1))', dat2_char, blanks(size(dat, 1))'];

len = size(dat2_char, 2);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% touchFile
%    Subfunction for 'touching' a file to update its file modification time
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function touchFile(fname)

[p, n, e] = fileparts(fname);
fid = fopen(fname, 'w');
if fid > 0
  fclose(fid);
else
  fprintf('Warning: Could not create %s.', [n, e]);
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% look4Engine
%    Main engine for searching
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function [datout, ids] = look4Engine(datFile, searchType, varargin)
% datFile    - file name of database
% searchType - 2 for H1 line only, 3 for full help search
% varargin   - search keywords

persistent dat dat2_char len

if nargin == 0 % check whether persistent variable exists
  if isempty(dat)
    datout = false;
  else
    datout = true;
  end
  return;
elseif nargin == 1
  switch class(datFile)
    case 'cell'
      dat = datFile;
      
      % sort alphabetically
      [ii, ii] = sortrows(strjust(char(dat(:, 2)), 'left'));
      dat = dat(ii, :);

      dat2_char=char(lower(dat(:, 2)));
      dat2_char=[blanks(size(dat, 1))', dat2_char, blanks(size(dat, 1))'];

      len = size(dat2_char, 2);

    case 'char'
      [dat, dat2_char, len] = loadData(datFile);

    case 'double'
      datout = dat(datFile, :);

    otherwise
      error('Bad use of look4Engine');

  end
  
  return;
  
end

% If 'dat' not defined, load it from file (may have been cleared)
if isempty(dat)
  [dat, dat2_char, len] = loadData(datFile);
end


%--------------------------------------------------------------------------
% Perform keyword search
%--------------------------------------------------------------------------

% For empty search words
allEmpty = true;

% Start off with all non-empty entries
ids = 1:size(dat, 1);
ids(cellfun('isempty', dat(:, 2))) = [];

% Loop through each keyword
for iVar = 1:length(varargin)

  % Break out of loop if 'ids' is empty, meaning that there are no matching
  % entries. -> No need to continue.
  if isempty(ids)
    break;
  end

  wd = varargin{iVar};
  if isempty(wd)
    continue;
  else
    allEmpty = false;
  end

  if searchType == 3
    % Preallocate
    a = false(length(ids), 1);

    % Loop through each database entry
    for id = 1:length(ids)
      a(id) = ~isempty(strfind([' ', lower(dat{ids(id), searchType}), ' '], wd));
    end

    % Update 'ids' to ones that only contain current keyword, so that the
    % next loop will be a smaller subset
    ids = ids(a);

  else  % searchType == 2. This is faster for smaller search

    temp_str=reshape(dat2_char(ids,:)',1,[]);
    id_files=strfind(temp_str,lower(wd));
    id_files=unique(ceil(id_files/len));
    ids=ids(id_files);

  end
end

if allEmpty
  ids = [];
end  

% Return results
datout = dat(ids, 1:2);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% look4GUI - GUI initialization
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function look4GUI(datFile)

figH = findobj('type', 'figure', 'tag', 'look4MainGUI');
if ishandle(figH)
  close(figH);
end

bgcolor1 = [.85 .85 .85];
bgcolor2 = [1 1 1];
bgcolor3 = [.7 .7 1];
fgcolor1 = [0 0 0];
fgcolor2 = [.5 .5 .5];

% Normalized figure size
figSize  = [.1 .05 .8 .9];

figH = figure(                                                         ...
  'name'                               , sprintf('%s: M-File Search',  ...
                                         upper(mfilename)), ...
  'units'                              , 'normalized',                 ...
  'position'                           , figSize,                      ...
  'resize'                             , 'off',                        ...
  'color'                              , bgcolor1,                     ...
  'menubar'                            , 'none',                       ...
  'tag'                                , 'look4MainGUI',               ...
  'interruptible'                      , 'off',                        ...
  'numbertitle'                        , 'off',                        ...
  'visible'                            , 'off',                        ...
  'deletefcn'                          , 'delete(get(gcbf, ''us''));', ...
  'defaultuicontrolbackgroundcolor'    , bgcolor1,                     ...
  'defaultuicontrolforegroundcolor'    , fgcolor1,                     ...
  'defaultuicontrolfontname'           , 'verdana',                    ...
  'defaultuicontrolfontunits'          , 'points',                     ...
  'defaultuicontrolfontsize'           , 9,                            ...
  'defaultuicontrolhorizontalalignment', 'center',                     ...
  'defaultuicontrolunits'              , 'points',                     ...
  'defaultuicontrolenable'             , 'on');

% Convert and get figure position in POINTS
set(figH, 'units', 'points');
figSizePt = get(figH, 'position');
fw        = figSizePt(3);
fh        = figSizePt(4);
fr        = round(fh/2);

uicontrol(                                                       ...
  'style'               , 'frame',                               ...
  'position'            , [0 0 fw fh]);
uicontrol(                                                       ...
  'style'               , 'text',                                ...
  'position'            , [150 fh-30 80 18],                     ...
  'string'              , 'Search:',                             ...
  'fontsize'            , 10,                                    ...
  'fontweight'          , 'bold',                                ...
  'horizontalalignment' , 'right');

uicontrol(                                                       ...
  'style'               , 'edit',                                ...
  'tag'                 , 'SearchField',                         ...
  'position'            , [235 fh-30 fw-290 18],                 ...
  'string'              , '_',                                   ...
  'buttondownfcn'       , @activateKeyPressMode,                 ...
  'backgroundcolor'     , bgcolor3,                              ...
  'horizontalalignment' , 'left',                                ...
  'fontname'            , 'FixedWidth',                          ...
  'fontsize'            , 10,                                    ...
  'enable'              , 'inactive',                            ...
  'tooltipstring'       , sprintf('%s\n%s',                      ...
                          'Type in search keywords. Use single', ...
                          'quotes to group multiple words.'));

uicontrol(                                                       ...
  'style'               , 'pushbutton',                          ...
  'tag'                 , 'ClearSearchField',                    ...
  'position'            , [fw-55 fh-30 34 18],                   ...
  'buttondownfcn'       , @clearSearchFieldFcn,                  ...
  'fontsize'            , 8,                                     ...
  'string'              , 'Clear',                               ...
  'enable'              , 'inactive',                            ...
  'tooltipstring'       , 'Clear search field. (<ESC>)');
                        
uicontrol(                                                       ...
  'style'               , 'frame',                               ...
  'tag'                 , 'SearchScopeFrame',                    ...
  'position'            , [20 fh-65 120 50]);

uicontrol(                                                       ...
  'style'               , 'text',                                ...
  'tag'                 , 'SearchScopeLabel',                    ...
  'position'            , [25 fh-25 110 15],                     ...
  'fontweight'          , 'bold',                                ...
  'horizontalalignment' , 'center',                              ...
  'string'              , 'Search Scope');

uicontrol(                                                       ...
  'style'               , 'radiobutton',                         ...
  'tag'                 , 'H1Search',                            ...
  'position'            , [25 fh-40 110 18],                     ...
  'string'              , 'H1 Line Only (F1)',                   ...
  'value'               , true,                                  ...
  'buttondownfcn'       , @GUIradioButtonCallback,               ...
  'enable'              , 'inactive',                            ...
  'horizontalalignment' , 'left');

uicontrol(                                                       ...
  'style'               , 'radiobutton',                         ...
  'tag'                 , 'FullSearch',                          ...
  'position'            , [25 fh-60 110 18],                     ...
  'string'              , 'Full Help (F2)',                      ...
  'buttondownfcn'       , @GUIradioButtonCallback,               ...
  'enable'              , 'inactive',                            ...
  'horizontalalignment' , 'left');

uicontrol(                                                       ...
  'style'               , 'text',                                ...
  'tag'                 , 'SearchWordsCaption',                  ...
  'position'            , [150 fh-50 80 15],                     ...
  'string'              , 'Search Words:',                       ...
  'fontname'            , 'FixedWidth',                          ...
  'horizontalalignment' , 'right');

uicontrol(                                                       ...
  'style'               , 'text',                                ...
  'tag'                 , 'SearchWords',                         ...
  'position'            , [235 fh-65 fw-255 30],                 ...
  'string'              , '',                                    ...
  'fontname'            , 'FixedWidth',                          ...
  'horizontalalignment' , 'left');

uicontrol(                                                       ...
  'style'               , 'text',                                ...
  'tag'                 , 'SearchFoundCaption',                  ...
  'position'            , [20 fh-102 fw-40 12],                  ...
  'string'              , 'Entries Found: 0',                    ...
  'fontname'            , 'FixedWidth',                          ...
  'horizontalalignment' , 'left');

uicontrol(                                                       ...
  'style'               , 'listbox',                             ...
  'tag'                 , 'SearchResults',                       ...
  'position'            , [20 fr-20 fw-40 fh-fr-82],             ...
  'backgroundcolor'     , bgcolor2,                              ...
  'interruptible'       , 'off',                                 ...
  'fontname'            , 'FixedWidth',                          ...
  'fontsize'            , 8,                                     ...
  'callback'            , @GUIsearchResultCallback,              ...
  'max'                 , 1,                                     ...
  'min'                 , 1,                                     ...
  'tooltipstring'       , 'Double-click to view file in Editor.');

uicontrol(                                                       ...
  'style'               , 'Text',                                ...
  'tag'                 , 'HelpTextCaption',                     ...
  'position'            , [20 fr-40 fw-40 12],                   ...
  'string'              , 'Full Help:',                          ...
  'horizontalalignment' , 'left');

uicontrol(                                                       ...
  'style'               , 'listbox',                             ...
  'tag'                 , 'HelpText',                            ...
  'position'            , [20 20 fw-40 fr-60],                   ...
  'backgroundcolor'     , bgcolor2,                              ...
  'buttondownfcn'       , @activateKeyPressMode,                 ...
  'fontname'            , 'FixedWidth',                          ...
  'fontsize'            , 8,                                     ...
  'horizontalalignment' , 'left',                                ...
  'enable'              , 'inactive',                            ...
  'visible'             , 'on');

uiCmenuH = uicontextmenu;
uimenu(                                                          ...
  'parent'              , uiCmenuH,                              ...
  'label'               , 'Change directory',                    ...
  'tag'                 , 'ChangeDirMenu',                       ...
  'callback'            , @GUIuimenuCallback);
uimenu(                                                          ...
  'parent'              , uiCmenuH,                              ...
  'label'               , 'Copy to Clipboard',                   ...
  'tag'                 , 'ClipboardMenu',                       ...
  'callback'            , @GUIuimenuCallback);

uicontrol(                                                       ...
  'style'               , 'text',                                ...
  'tag'                 , 'FileLocation',                        ...
  'position'            , [20 fh-90 fw-40 12],                   ...
  'string'              , 'File location:',                      ...
  'fontsize'            , 8,                                     ...
  'horizontalalignment' , 'left',                                ...
  'foregroundcolor'     , 'blue',                                ...
  'uicontextmenu'       , uiCmenuH,                              ...
  'tooltipstring'       , sprintf('%s\n%s',                      ...
                          'Right-click to change directory',     ...
                          'or copy file path to clipboard.'));

% Get handles structure
handles          = guihandles(figH);
handles.datFile  = datFile;
handles.bgcolor1 = bgcolor1;
handles.bgcolor2 = bgcolor2;
handles.bgcolor3 = bgcolor3;
handles.fgcolor1 = fgcolor1;
handles.fgcolor2 = fgcolor2;

pos = get(handles.SearchResults, 'position');
handles.numLines = round(pos(4) / ...
  (get(handles.SearchResults, 'fontsize')+2));

handles.endKeyTimer = timer(...
  'name'      , 'look4Timer', ...
  'startdelay', 0.5, ...
  'tag'       , 'look4Timer');

guidata(figH, handles);
set(handles.endKeyTimer, ...
  'timerfcn', {@endKeyTimerFcn, handles}, ...
  'errorfcn', {@timerErrorFcn, handles});
set(figH, ...
  'keypressfcn' , {@keyPressFcn, handles}, ...
  'userdata'    , handles.endKeyTimer);

% Make GUI visible
set(figH, 'visible', 'on');

% Load datFile as PERSISTENT in look4Engine (if not already defined)
if ~look4Engine
  look4Engine(datFile);
  GUIsearchResultCallback([]);
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% clearSearchFieldFcn
%    Clears the search field.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function clearSearchFieldFcn(varargin)

obj     = varargin{1};
handles = guidata(obj);

set(handles.SearchField, 'string', '_');
endKeyTimerFcn([], [], handles);
activateKeyPressMode(obj);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% activateKeyPressMode
%    When clicked on the search field or help window, it changes the
%    background color and adds '_' (if not already present) to indicate
%    that key input is allowed.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function activateKeyPressMode(varargin)

handles = guidata(varargin{1});

str = get(handles.SearchField, 'string');
if isempty(strmatch('_', fliplr(str)))
  str = [str, '_'];
end
set(handles.SearchField, ...
  'string'          , str, ...
  'backgroundcolor' , handles.bgcolor3, ...
  'foregroundcolor' , handles.fgcolor1);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% keyPressFcn
%    Pressing alpha-numeric keys results in appending the character to the
%    search text in the search field. <ESC> clears the search field. <DEL>
%    <BACKSPACE> deletes previous character. Arrow keys navigates through
%    search results, displaying the full text in the bottom field.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function keyPressFcn(varargin)

obj = varargin{1};
handles = varargin{3};
stop(handles.endKeyTimer);

k = get(obj, 'currentkey');
k_d = double(k);

str = get(handles.SearchField, 'string');
if isempty(strmatch('_', fliplr(str)))
  str = [str, '_'];
end
set(handles.SearchField, ...
  'backgroundcolor', handles.bgcolor3, ...
  'foregroundcolor', handles.fgcolor1);

if length(k) == 1 && ismember(k_d, [48:57, 97:122])
  str = [str(1:end-1), k, '_'];
else
  switch k
    case 'space'
      str = [str(1:end-1), ' _'];
      
    case 'quote'
      str = [str(1:end-1), '''_'];
      
    case {'delete', 'backspace'}
      if ~strcmp(str, '_')
        str = [str(1:end-2), '_'];
      end
      
    case 'hyphen'
      str = [str(1:end-1), '-_'];
      
    case 'period'
      str = [str(1:end-1), '._'];
      
    case 'escape'
      set(handles.SearchField, 'string', '_');
      endKeyTimerFcn([], [], handles);
      return;
      
    case 'uparrow'
      if GUIsearchResultCallback
        val = get(handles.SearchResults, 'value');
        set(handles.SearchResults, 'value', max([1, val-1]));
        set(handles.look4MainGUI, 'selectiontype', 'normal');
        GUIsearchResultCallback(handles.SearchResults);
      end
      return;
    
    case 'downarrow'
      ln = GUIsearchResultCallback;
      if ln
        val = get(handles.SearchResults, 'value');
        set(handles.SearchResults, 'value', min([ln, val+1]));
        set(handles.look4MainGUI, 'selectiontype', 'normal');
        GUIsearchResultCallback(handles.SearchResults);
      end
      return;
    
    case 'return'
      set(handles.look4MainGUI, 'selectiontype', 'open');
      GUIsearchResultCallback(handles.SearchResults);
      return;
    
    case 'f1'
      GUIradioButtonCallback(handles.H1Search);
      return;
      
    case 'f2'
      GUIradioButtonCallback(handles.FullSearch);
      return;
      
    otherwise
      return;
  
  end
end

set(handles.SearchField, 'string', str);

start(handles.endKeyTimer);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% endKeyTimerFcn
%    This function gets called a preset time (t sec) after a key stroke.
%    It performs the search using the words in the search field. The timer
%    is used to prevent searching after each key stroke. It would only get
%    executed when there is a pause (t sec) in key inputs. Everytime a key
%    is pressed, the timer is stopped. Only when t seconds have passed
%    without key presses, does this function get executed.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function endKeyTimerFcn(varargin)

handles = varargin{3};
set(handles.FileLocation, 'string', 'Searching ...');
drawnow;

str = get(handles.SearchField, 'string');
if ~isempty(str) && strcmp(str(end), '_')
  str = str(1:end-1);
end

% initialize
words = {};
dat = cell(0, 2);
idx = [];

if ~isempty(str)
  
  try
    words=parseWords(deblank(str));
  catch
    % possibly a mis-matching quotes. In that case, append a quote at the
    % end
    words=parseWords([deblank(str) '''']);
  end
  
  if ~isempty(words)
    % perform appropriate search based on search type
    if get(handles.H1Search, 'value')
      [dat, idx] = look4Engine(handles.datFile, 2, words{:});
    else
      [dat, idx] = look4Engine(handles.datFile, 3, words{:});
    end

  end
end

% update the indices
GUIsearchResultCallback(idx);

if isempty(dat)
  set(handles.SearchResults , 'string', '', ...
                              'value' , 0);
  set(handles.FileLocation  , 'string', 'File location:');
  set(handles.HelpText      , 'string', '');

  if isempty(words)
    set(handles.SearchWords       , 'string', '');
    set(handles.SearchFoundCaption, 'string', 'Entries Found: 0');
  else
    searchwords = sprintf('[%s], ', words{:});
    set(handles.SearchWords, ...
      'string', sprintf('%s', searchwords(1:end-2)));
    set(handles.SearchFoundCaption, ...
      'string', 'Entries Found: 0');
  end
else
  if size(dat, 1) > handles.numLines
    set(handles.SearchResults, ...
      'string', [dat(1:handles.numLines-1, 2); {'<show all...>'}], ...
      'value' , 1);
  else
    set(handles.SearchResults, ...
      'string', dat(:, 2), ...
      'value' , 1);
  end
  
  searchwords = sprintf('[%s], ', words{:});
  set(handles.SearchWords, ...
    'string', sprintf('%s', searchwords(1:end-2)));
  set(handles.SearchFoundCaption, ...
    'string', sprintf('Entries Found: %d', size(dat, 1)));
  
  set(handles.look4MainGUI, 'SelectionType', 'normal');
  GUIsearchResultCallback(handles.SearchResults);
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% timerErrorFcn
%    This is called when an error occurs during timer fcn calls. It resets
%    all properties.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function timerErrorFcn(varargin)

handles = varargin{3};
errordlg(sprintf('Sorry, an internal error occurred.\nResetting GUI...'), ...
  'error', 'modal');

set(handles.SearchField, ...
  'string'          , '_', ...
  'backgroundcolor' , handles.bgcolor3, ...
  'foregroundcolor' , handles.fgcolor1);
set(handles.SearchResults     , 'string', '', ...
                                'value' , 0);
set(handles.FileLocation      , 'string', 'File location:');
set(handles.HelpText          , 'string', '');
set(handles.SearchWords       , 'string', '');
set(handles.SearchFoundCaption, 'string', 'Entries Found: 0');
look4Engine(handles.datFile);
GUIsearchResultCallback([]);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% parseWords
%    This parses a string into words. It calls parseWords_Int.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function words=parseWords(blah)

eval(sprintf('parseWords_Int %s;', blah));
% the above line will create 'ans'
words = ans;

% delete empty words
words(cellfun('isempty', words)) = '';

if length(words) == 1 && isempty(words{1})
  words = {};
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% parseWords_Int
%    This is a dummy function that just converts multiple string inputs
%    into cell array of words.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function varargin = parseWords_Int(varargin)


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% GUIsearchResultCallback
%    This function is called when an entry in the results listbox is
%    clicked. It recalls the full help text (from the database) and
%    displays it in the help window (bottom). If double-clicked, it will
%    open the file in the editor.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function ln = GUIsearchResultCallback(varargin)

persistent idx tmp

if nargin == 0
  ln = length(idx);
  return;
  
elseif nargin == 1
  obj = varargin{1};
  if isempty(obj) || length(obj) > 1
    idx = obj;
    tmp = true;
    return;

  elseif ~ishandle(obj)
    idx = obj;
    tmp = true;
    return;
  
  end

  handles = guidata(obj);
  
else % nargin==2 (listbox callback)
  obj     = varargin{1};
  handles = guidata(obj);
  sf      = get(handles.SearchField, 'string');
  if isempty(sf)
    sf    = '_';
  elseif ~strcmp(sf(end), '_')
    sf    = [sf, '_'];
  end
  set(handles.SearchField, ...
    'string'          , sf(1:end-1), ...
    'backgroundcolor' , handles.bgcolor1, ...
    'foregroundcolor' , handles.fgcolor2);
  
  if isempty(tmp) % persistent not defined
    
    set(handles.SearchField, 'string', sf);
    try
      endKeyTimerFcn([], [], handles);
    catch
      timerErrorFcn([], [], handles);
    end
    set(handles.SearchField, 'string', sf(1:end-1));
    
  end
  
end

str = get(obj, 'string');
if ~isempty(str)
  if ischar(str)
    str = {str};
  end
  val = get(obj, 'value');
  if strcmp(str{val}, '<show all...>')
    dat = look4Engine(idx);
    set(obj, 'string', dat(:,2));
  end
  dat = look4Engine(idx(val));
  
  switch get(handles.look4MainGUI, 'selectiontype')
    
    case 'normal' % Single-click
      % Get help text
      tmp = dat{3};
      if ~isempty(tmp)
        % Convert to | delimited string
        tmp = strrep(tmp, sprintf('\n'), '|');
      end
      set(handles.HelpText, ...
        'string', tmp, ...
        'value' , 1);
      set(handles.FileLocation, ...
        'string', sprintf('File location: %s', dat{1}));
      
    case 'open'   % Double-click
      try
        open(dat{1});
      catch
        errordlg('Error opening file.');
      end
      
  end
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% GUIuimenuCallback
%    This is the callback for UI context menu.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function GUIuimenuCallback(varargin)

obj     = varargin{1};
handles = guidata(obj);

str = get(handles.FileLocation, 'string');
if strcmp(str, 'File location:')
  str = '';
else
  str = str(16:end);
end
if ~isempty(str)
  switch get(obj, 'tag')
    case 'ChangeDirMenu'
      pathname = fileparts(str);
      cd(pathname);
    
    case 'ClipboardMenu'
      clipboard('copy', str);
  end
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% GUIradioButtonCallback
%    This is the callback for the search scope radio buttons
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function GUIradioButtonCallback(varargin)

obj     = varargin{1};
handles = guidata(obj);

if ~get(obj, 'value')

  set([handles.FullSearch, handles.H1Search], 'value', false);
  set(obj, 'value', true);

  % Perform new search
  try
    endKeyTimerFcn(handles.SearchField, [], handles);
  catch
    timerErrorFcn([], [], handles);
  end

end

% make sure key press mode is active
activateKeyPressMode(obj);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% setupAutoUpdate
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function setupAutoUpdate

un = get(0, 'units');
set(0, 'units', 'pixels');
screenSize = get(0, 'ScreenSize');
set(0, 'units', un);
wd = 300;
ht = 160;

bgcolor1 = [.7, .7, .7];
bgcolor2 = [ 1,  1,  1];
bgcolor3 = [.9, .9, .9];
bgcolor4 = [ 1, .5, .5];
bgcolor5 = [.4, .4,  1];

fH = figure(...
  'integerHandle'                   , 'off', ...
  'name'                            , 'Auto Update', ...
  'numbertitle'                     , 'off', ...
  'menubar'                         , 'none', ...
  'units'                           , 'pixels', ...
  'position'                        , [round((screenSize(3)-wd)/2), ...
                                       round((screenSize(4)-ht)/2), ...
                                       wd, ht], ...
  'color'                           , bgcolor1, ...
  'resize'                          , 'off', ...
  'windowstyle'                     , 'modal', ...
  'tag'                             , 'autoUpdateMain', ...
  'defaultaxesunits'                , 'pixels', ...
  'defaultuicontrolbackgroundcolor' , bgcolor3, ...
  'defaultuicontrolunits'           , 'pixels', ...
  'defaultuicontrolfontname'        , 'verdana', ...
  'defaultuicontrolfontsize'        , 8, ...
  'defaultuicontrolfontweight'      , 'normal');

uicontrol(...
  'style'              , 'text', ...
  'backgroundcolor'    , bgcolor1, ...
  'position'           , [5, ht-25, wd-5, 20], ...
  'string'             , 'Specify database update interval:', ...
  'horizontalalignment', 'left');

uicontrol(...
  'style'              , 'pushbutton', ...
  'position'           , [105, ht-50, 84, 22], ...
  'string'             , 'Weekly', ...
  'fontweight'         , 'bold', ...
  'enable'             , 'inactive', ...
  'buttondownfcn'      , {@autoUpdateBtnCallback, 2}, ...
  'tag'                , 'wkT');
uicontrol(...
  'style'              , 'pushbutton', ...
  'position'           , [20, ht-47, 84, 19], ...
  'string'             , 'Daily', ...
  'enable'             , 'inactive', ...
  'buttondownfcn'      , {@autoUpdateBtnCallback, 1}, ...
  'tag'                , 'daT');

uicontrol(...
  'style'              , 'frame', ...
  'enable'             , 'inactive', ...
  'backgroundcolor'    , bgcolor3, ...
  'foregroundcolor'    , bgcolor3, ...
  'position'           , [5, ht-125, wd-10, 77], ...
  'tag'                , 'panel1');

uicontrol(...
  'style'              , 'text', ...
  'backgroundcolor'    , bgcolor3, ...
  'position'           , [10, ht-75, 140, 15], ...
  'string'             , 'What time? (HH:MM)  ', ...
  'horizontalalignment', 'right', ...
  'tag'                , 'DailyQuestionCaption');
uicontrol(...
  'style'              , 'edit', ...
  'position'           , [150, ht-75, wd-160, 20], ...
  'backgroundcolor'    , bgcolor4, ...
  'horizontalalignment', 'left', ...
  'callback'           , @autoUpdateEditCallback, ...
  'tag'                , 'DailyUpdateTimeEdit');

uicontrol(...
  'style'              , 'text', ...
  'backgroundcolor'    , bgcolor3, ...
  'position'           , [10, ht-100, wd-20, 15], ...
  'string'             , 'Which day of the week?', ...
  'horizontalalignment', 'left', ...
  'visible'            , 'on', ...
  'tag'                , 'WeeklyQuestionCaption');

days = {'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'};
btnW = round((280-2*6)/7);
for id = 1:7
  uicontrol(...
    'style'            , 'pushbutton', ...
    'position'         , [10+(id-1)*(btnW+2), ht-120, btnW, 20], ...
    'string'           , days{id}, ...
    'enable'           , 'inactive', ...
    'backgroundcolor'  , bgcolor4, ...
    'buttondownfcn'    , {@autoUpdateBtnCallback, 3}, ...
    'tag'              , 'dayBtns');
end

callbackOpt = [4, 5, 0];
stringVals  = {'OK', 'No Update', 'Cancel'};
tagNames    = {'OKBtn', 'NoUpdateBtn', 'CancelBtn'};
btnW        = round((280-5*2)/3);
for id = 1:3
uicontrol(...
  'style'              , 'pushbutton', ...
  'position'           , [10+(id-1)*(btnW+5), ht-150, btnW, 20], ...
  'string'             , stringVals{id}, ...
  'backgroundcolor'    , bgcolor1, ...
  'callback'           , {@autoUpdateBtnCallback, callbackOpt(id)}, ...
  'tag'                , tagNames{id});
end

handles             = guihandles(fH);
handles.result.type = 'weekly';
handles.result.val  = {[], ''};
handles.bgcolor1    = bgcolor1;
handles.bgcolor2    = bgcolor2;
handles.bgcolor3    = bgcolor3;
handles.bgcolor4    = bgcolor4;
handles.bgcolor5    = bgcolor5;

if exist('startup.m', 'file')
  fname   = which('startup.m');
  result  = modifyStartupFile(fname, [], 'retrieve');
  if ~isempty(result)
    switch result.type
      case 'daily'
        set(handles.panel1  , 'position', [5, 80, 290, 32]);
        
        set([handles.wkT, handles.daT], ...
          {'fontweight', 'position'}, ...
          {'normal', [105, 113, 84, 19]; ...
            'bold', [20, 110, 84, 22]});
        set(handles.WeeklyQuestionCaption, ...
          'visible'         , 'off');
        set(handles.dayBtns, ...
          'visible'         , 'off');
        set(handles.DailyUpdateTimeEdit, ...
          'visible'         , 'on', ...
          'string'          , sprintf('%d:%02d', result.val{1}), ...
          'backgroundcolor' , bgcolor2);
        
      case 'weekly'
        set(handles.panel1  , 'position', [5, 35, 290, 77]);

        set([handles.wkT, handles.daT], ...
          {'fontweight', 'position'}, ...
          {'bold', [105, 110, 84, 22]; ...
            'normal', [20, 113, 84, 19]});
        set(handles.DailyUpdateTimeEdit, ...
          'visible'         , 'on', ...
          'string'          , sprintf('%d:%02d', result.val{1}), ...
          'backgroundcolor' , bgcolor2);
        set(handles.dayBtns, ...
          'visible'         , 'on', ...
          'backgroundcolor' , bgcolor1);
        set(handles.WeeklyQuestionCaption, ...
          'visible'         , 'on');
        set(findobj(handles.dayBtns, 'string', result.val{2}), ...
          'fontweight'      , 'bold');
        
    end
    
    handles.result = result;
    
  end
end

guidata(fH, handles);
setappdata(0, 'look4_autoUpdateResults', []);

% wait until the dialog box is closed
waitfor(fH);

result = getappdata(0, 'look4_autoUpdateResults');
rmappdata(0, 'look4_autoUpdateResults');

if isempty(result)
  return;
else
  if exist('startup.m', 'file')
    fname = which('startup.m');
    modifyStartupFile(fname, result, 'modify');
  else
    if strcmp(result.type, 'reset')
      return;
    else
      p = lower(strread(path, '%s', 'delimiter', pathsep));
      [sel, ok] = listdlg(...
        'promptstring'  , {'STARTUP.m does not exist.', ...
                           'Select a directory to create STARTUP.m'}, ...
        'selectionmode' , 'single', ...
        'listsize'      , [500 500], ...
        'liststring'    , p);
      if isequal(ok, 0)
        errordlg('Canceled...');
        return;
      else
        fname = fullfile(p{sel}, 'startup.m');
      end
    end
    modifyStartupFile(fname, result, 'new');
  end
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% modifyStartupFile
%    This function creates the startup file. If one already exists, it
%    modifies it. If it doesn't, it creates one.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function out = modifyStartupFile(fname, result, opt)

switch opt
  case 'new'
    str = {};
    
  case 'modify'
    str = textread(fname, '%s', 'delimiter', '\n');
    [p, n] = fileparts(fname);
    copyfile(fname, fullfile(p, [n '_backup.m']));
    
  case 'retrieve'
    str = textread(fname, '%s', 'delimiter', '\n');
    id = strmatch(sprintf('%s_autoUpdateFcn;', mfilename), str, 'exact');
    if isempty(id)
      out = [];
    else
      update_fname = fullfile(fileparts(fname), ...
        sprintf('%s_autoUpdateFcn.m', mfilename));
      if exist(update_fname, 'file')
        str = textread(update_fname, '%s', 'delimiter', '\n');
        id = strmatch('% out.', str);
        if length(id) == 2
          eval(str{id(1)}(3:end));
          eval(str{id(2)}(3:end));
        else
          out = [];
        end
      else
        out = [];
      end
    end
    return;
    
end

% open startup file for writing (create if necessary)
fid = fopen(fname, 'w');
if fid < 0
  errordlg('Could not open or create startup.m');
  return;
end

% wrap everything by try ... catch, in case an error occurs. then restore
% startup file.
try

  % first part of the text
  tmp1 = {
    sprintf('function %s_autoUpdateFcn', mfilename)
    ''
    sprintf('%% %s_AUTOUPDATEFCN Auto-Update Function for %s', ...
      upper(mfilename), mfilename)
    sprintf('%%   This is auto generated by %s.', ...
      upper(mfilename))
    sprintf('%%   Do not modify manually. Use %s(''-autoupdate'') to change.', ...
      upper(mfilename))
    '%'
    '%   Jiro Doke'
    '%   Mar 2006'
    ''
    'tm = timerfind(''tag'', ''look4AutoUpdateTimer'');'
    'if ~isempty(tm)'
    '  disp(''deleting old update timer...'');'
    '  stop(tm);'
    '  delete(tm);'
    'end'
    ''
    'c = clock;'
    ''
    };

  tmp3 = {
    ''
    'delayTime = round(delayTime);'
    ''
    'tm = timer(...'
    '  ''name''          , sprintf(''Next database update: %s'', ...'
    '                            datestr(now+delayTime/86400)), ...'
    '  ''tag''           , ''look4AutoUpdateTimer'', ...'
    '  ''startdelay''    , delayTime, ...'
    '  ''executionmode'' , ''fixedrate'', ...'
    '  ''timerfcn''      , {@databaseUpdateTimerFcn, periodVal}, ...'
    '  ''period''        , periodVal);'
    ''
    'start(tm);'
    ''
    '%--------------------------------------------------------------------------'
    'function databaseUpdateTimerFcn(obj, edata, periodVal)'
    ''
    'set(obj, ''name'', ...'
    '  sprintf(''Next database update: %s'', datestr(now+periodVal/86400)));'
    sprintf('%s(''-new'', ''-noverbose'');', mfilename)
    ''
    };
  
  switch result.type
    case 'daily'
      tmp2 = {
        sprintf('c2 = [0, 0, 0, %d, %d, 0];', result.val{1})
        'if datenum([0, 0, 0, c(4:end)]) > datenum(c2)  % go to next day'
        '  c3 = datevec(datenum([c(1:3), c2(4:end)])+1);'
        'else'
        '  c3 = [c(1:3), c2(4:end)];'
        'end'
        'delayTime = etime(c3, c);'
        'periodVal = 24*60*60; % update daily'
        };

      tmp4 = {
        '% out.type = ''daily'';'
        sprintf('%% out.val = {[%d, %d], ''''};', result.val{1})
        };

    case 'weekly'
      days  = {'sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'};
      wd2   = strmatch(lower(result.val{2}), days, 'exact');
      tmp2  = {
        sprintf('updateTime = [%d, %d, 0];', result.val{1})
        'wd  = weekday(datenum(c));'
        sprintf('wd2 = %d; %% update weekday: %s', wd2, result.val{2})
        'wd3 = wd2 - wd;'
        'if (wd3 == 0 && ...'
        '    datenum([0, 0, 0, c(4:end)]) > datenum([0, 0, 0, updateTime])) || ...'
        '    wd3 < 0'
        '  wd3 = wd3 + 7;'
        'end'
        'delayTime = etime(datevec(datenum([c(1:3), updateTime])+wd3), c);'
        'periodVal = 7*24*60*60; % update weekly'
        };

      tmp4 = {
        '% out.type = ''weekly'';'
        sprintf('%% out.val = {[%d, %d], ''%s''};', result.val{1}, result.val{2})
        };

    case 'reset'

      tmp2 = {};

  end

  % see if the call to the auto update function exists in startup.m
  id = strmatch(sprintf('%s_autoUpdateFcn;', mfilename), str, 'exact');

  update_fname = fullfile(fileparts(fname), ...
    sprintf('%s_autoUpdateFcn.m', mfilename));

  if isempty(tmp2) % reset

    % delete current update timer
    tm = timerfind('tag', 'look4AutoUpdateTimer');
    if ~isempty(tm)
      disp('deleting old update timer...');
      stop(tm);
      delete(tm);
    end

    % delete call to auto update function
    str(id) = '';

    % if auto update function exists, delete it.
    if exist(update_fname, 'file')
      delete(update_fname);
    end

  else

    % create auto update function
    fid2 = fopen(update_fname, 'w');
    tmp = [tmp1; tmp2; tmp3; tmp4];
    fprintf(fid2, '%s\n', tmp{:});
    fclose(fid2);

    % get the name of the auto update function
    [fname, fname] = fileparts(update_fname);

    % flush from memory
    clear(fname);

    % run function
    feval(fname);

    % if the call to the function does not exist in startup.m, create one.
    if isempty(id)
      str = [str; {sprintf('%s_autoUpdateFcn;', mfilename)}];
    end
  end

  % create startup.m
  fprintf(fid, '%s\n', str{:});

  fclose(fid);

catch
  
  % if an error occurs, try to restore previouse startup files
  
  fclose all;
  
  fprintf('Error occurred. STARTUP files restored\n');
  switch opt
    case 'new'
      try
        delete(fname);
      catch
      end
    case 'modify'
      movefile(fullfile(p, [n '_backup.m']), fname);
  end

  rethrow(lasterror);
  
end


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% autoUpdateBtnCallback
%    This is called when one of the buttons in the auto update window is
%    pressed.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function autoUpdateBtnCallback(varargin)

obj = varargin{1};

handles = guidata(obj);
opt = varargin{3};
%fprintf('au_btn_%d\n', opt);
switch opt
  
  case 0  % cancel
    setappdata(0, 'look4_autoUpdateResults', []);
    close(handles.autoUpdateMain);
    return;
    
  case 1  % daily tab
    handles.result.type = 'daily';
    
    set(handles.panel1, 'position', [5, 80, 290, 32]);
    
    set([handles.wkT, handles.daT], ...
      {'fontweight', 'position'}, ...
      {'normal', [105, 113, 84, 19]; ...
        'bold', [20, 110, 84, 22]});
    set([handles.WeeklyQuestionCaption, ...
      handles.dayBtns], ...
      'visible'   , 'off');
    set(handles.DailyUpdateTimeEdit, ...
      'visible'   , 'on');
    
  case 2  % weekly tab
    handles.result.type = 'weekly';

    set(handles.panel1, 'position', [5, 35, 290, 77]);
    
    set([handles.wkT, handles.daT], ...
      {'fontweight', 'position'}, ...
      {'bold', [105, 110, 84, 22]; ...
        'normal', [20, 113, 84, 19]});
    set([handles.DailyUpdateTimeEdit, ...
      handles.dayBtns, ...
      handles.WeeklyQuestionCaption], ...
      'visible'   , 'on');
    
  case 3  % weekday button
    handles.result.val{2} = get(obj, 'string');
    
    set(handles.dayBtns, ...
      'backgroundcolor' , handles.bgcolor1, ...
      'fontweight'      , 'normal');
    set(obj, ...
      'fontweight'      , 'bold');
    
    
  case 4  % ok
    % check whether entry is valid
    isError = false;
    if strcmp(handles.result.type, 'daily')
      if isempty(handles.result.val{1})
        isError = true;
      end
    else
      if isempty(handles.result.val{1}) || isempty(handles.result.val{2})
        isError = true;
      end
    end
    
    if isError
      errordlg('Incomplete...');
    else
      setappdata(0, 'look4_autoUpdateResults', handles.result);
      close(handles.autoUpdateMain);
    end
    return;
    
  case 5 % no update
    handles.result.type = 'reset';
    handles.result.val  = [];
    setappdata(0, 'look4_autoUpdateResults', handles.result);
    close(handles.autoUpdateMain);
    return;
    
end

guidata(obj, handles);


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% autoUpdateEditCallback
%    This is called when the edit box (time) is entered. It checks the
%    validity of the entry.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
function autoUpdateEditCallback(varargin)

%fprintf('au_edit\n');

obj = varargin{1};
bgcolor1 = [1,  1,  1];
bgcolor2 = [1, .5, .5];

handles = guidata(obj);

str = get(obj, 'string');

isError = false;
try
  s = strread(str, '%d', 'delimiter', ':')';
  if length(s) == 2
    if s(1) < 0 || s(1) > 23 || s(2) < 0 || s(2) > 59
      isError = true;
    end
  else
    isError = true;
  end
catch
  isError = true;
end

if isError
  set(obj, 'string', '', 'backgroundcolor', bgcolor2);
  handles.result.val{1} = [];

else
  set(obj, 'string', sprintf('%d:%02d', s), 'backgroundcolor', bgcolor1);
  handles.result.val{1} = s;

end

guidata(obj, handles);