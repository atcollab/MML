function readwrite(action, varargin)
%READWRITE - Multipurpose read/write function for orbit correction applicaiton
% function varargout = readwrite(action, varargin)
% readwrite supplies a switchyard of routines
% to read and write data files in solorbit formats
% 
% ReadCorrectors
% WriteCorrectors
% ReadBPMReference
% ArchiveBPMOrbit
% DialogBox
% ReadResponse
% ProcessDialog
% 


%
% Written by William J. Corbett
% Modified by Laurent S. Nadolski

%% TODO NEED adaption for SOLEIL

% orbfig = findobj(0,'tag','orbfig');  %orbfig "global"
global BPM COR RSP SYS

[BPMxFamily, BPMzFamily] = BPM.AOFamily;

switch action

%     %=============================================================
%     case 'LogFdbkData'                       % *** LogFdbkData ***
%         %=============================================================
%         if strcmp(SYS.machine,'SPEAR2')
%             [SYS.energy,SYS.curr,SYS.lt,SYS.ahr] = getset('GetRingParams',SYS.mode);
%             setappdata(0,'SYS',SYS);
%         elseif strcmp(SYS.machine,'SOLEIL')
%            % TODO
%            disp('LogFdbckData TODO')
%         end
% 
%         BPMLog(SYS,BPM);
%         CORLog(SYS,COR);

        %=============================================================
    case 'ReadCorrectors'               % *** ReadCorrectors ***
        %=============================================================
        % read corrector strength files produced by this program
        FileName = char(varargin(1));
        auto     = char(varargin(2));    %cell array
        
        [fid,message] = fopen(FileName,'r');
        if fid == -1
            disp(['WARNING: Corrector file not found:' FileName]);
            disp(message);
            return
        end

        header    = fgetl(fid);
        disp(header);
        timestamp = fgetl(fid);
        disp(timestamp);
        comment   = fgetl(fid);
        disp(comment);

        if ~strcmp(auto,'auto') == 1
            answer = input('Read Corrector File? Y/N [Y]: ','s');
            if isempty(answer), answer = 'n'; end
            if answer=='n' || answer=='N'
                disp('WARNING: Corrector File NOT LOADED');
                fclose(fid);
                return
            end
        end

        disp(['Reading corrector file: ' FileName]);
        COR(1).ntcor = fscanf(fid,'%d\n',1);
        COR(2).ntcor = fscanf(fid,'%d\n',1);
        disp([COR(1).ntcor,COR(2).ntcor]);
        setappdata(0,'COR',COR);

        fscanf(fid,'%d %f %*s',[3,54]);  %ntbpm rows, 5 columns wide
        fclose(fid);

        %=============================================================
    case 'WriteCorrectors'               % *** WriteCorrectors ***
        %=============================================================
        % write reference orbit file in format of orbit program       
        FileName = char(varargin(1));
        comment  = char(varargin(2));

        [fid,message] = fopen(FileName,'w');
        if fid == -1
            disp(['WARNING: Unable to open file to write correctors :' FileName]);
            disp(message);
            return
        end
        disp(['Writing corrector file: ' FileName]);
        fprintf(fid,'%s\n','Correctors');
        fprintf(fid,'%s\n',['timestamp: ' datestr(now,0)]);
        fprintf(fid,'%s\n', comment);
        fprintf(fid,'%d %d\n', COR(1).ntcor, COR(2).ntcor);
      
        for ii = 1:COR(2).ntcor,
            fprintf(fid,'%3d %6.3f %s\n',...
                ii, COR(1).act(ii),COR(1).name(ii,:)); %3 columns wide
        end

        for ii = 1:COR(2).ntcor,
            fprintf(fid,'%3d %6.3f %s\n',...
                ii, COR(2).act(ii),COR(2).name(ii,:)); %3 columns wide
        end
        fclose(fid);

%         %=============================================================
%     case 'WriteResponse'                     % *** WriteResponse ***
%         %=============================================================
%         %read in terms of RSP, write in terms of BPM, COR
%         %readwrite('WriteSPEAR3Response','dummy','auto');
%         FileName = char(varargin(1));   
%         comment  = char(varargin(2));
% %         WriteSPEAR2Response(FileName,comment,BPM,BL,COR,RSP);
%         disp('WriteResponse TODO')

%         %=============================================================
%     case 'ReadBPMxReference'         % *** ReadBPMxReference ***
%         %=============================================================
%         %read archive orbit as reference
% 
%         [X,Z] = loadorbit([],[],'struct');     %select file from browser
% 
%         %process for orbit program
%         if isempty(X)
%             orbgui('LBox','X-Reference orbit not available');
%         else
%             BPM(1).iref = dev2elem(BPMxFamily,X.DeviceList);
%             BPM(1).ref  = X.Data;
%             BPM(1).des  = X.Data;
%             BPM(1).abs  = X.Data;
%             orbgui('LBox','X-Reference orbit loaded');
%         end
% 
%         if SYS.relative == 1   %absolute mode
%             ntbpm      = length(BPM(1).name(:,1));
%             BPM(1).abs = zeros(1,ntbpm)';
%         end
% 
%         [BPM] = SortBPMs(BPM,RSP);
% 
%         setappdata(0,'BPM',BPM);
% 
%         bpmgui('RePlot');        %reference, desired, absolute
%         orbgui('RefreshOrbGUI');
% 
        %=============================================================
    case 'ReadBPMReference'             % *** ReadBPMReference ***
        %=============================================================
        %read archive orbit as reference
        refplane = varargin{1};
        [varargin, GoldenFlag] = findkeyword(varargin,'Golden');

        if GoldenFlag
            %retrieve data from PhysData Structure
%             physdatafile = getfamilydata('OpsData', 'PhysDataFile');
%             datastruct   = load(physdatafile);
%             X = datastruct.PhysData.BPMx.Golden;
%             Z = datastruct.PhysData.BPMz.Golden;
            %datastruct = getphysdata({BPMxFamily,BPMzFamily});
            %X          = datastruct{1}.Golden;
            %Z          = datastruct{2}.Golden;            
             X = getgolden(BPMxFamily,'Struct');
             Z = getgolden(BPMzFamily, 'Struct');
            %   DirSpec  = getfamilydata('Directory','OpsData');
            %   FileName = getfamilydata('OpsData', 'BPMGoldenFile');
            %   [X,Z] = loadorbit([],[],DirSpec,FileName,'b','Struct','Auto');  %both planes, structure, automatic read
        else
            [X,Z] = loadorbit([],[],'struct');     %select file from browser
        end

        %process for orbit program
        switch upper(refplane)
            case 'X' % Horizontal plane
                if isempty(X)
                    orbgui('LBox','X-Reference orbit not available');
                    return
                else
                    BPM(1).iref=dev2elem(BPMxFamily,X.DeviceList);
                    %decompress data
                    temp        = getfamilydata(BPMxFamily,'Status');
                    status      = find(temp);
                    temp(status)= X.Data;
                    BPM(1).ref  = temp;
                    BPM(1).des  = temp;
                    BPM(1).abs  = temp;
                    orbgui('LBox','X-Reference orbit loaded');
                    if isfield(X,'FileName'), orbgui('LBox',X.FileName);
                    else
                        orbgui('LBox','Horizontal reference orbit loaded');
                    end
                end

            case 'Z' % Vertical plane
                if isempty(Z)
                    orbgui('LBox','Z-Reference orbit not available');
                    return
                else
                    BPM(2).iref = dev2elem(BPMzFamily,Z.DeviceList);
                    %decompress data
                    temp        = getfamilydata(BPMzFamily,'Status');
                    status      = find(temp);
                    temp(status)= Z.Data;
                    BPM(2).ref  = temp;
                    BPM(2).des  = temp;
                    BPM(2).abs  = temp;
                    orbgui('LBox','Z-Reference orbit loaded');
                    if isfield(Z,'FileName'), orbgui('LBox',Z.FileName);
                    else
                        orbgui('LBox','Vertical reference orbit loaded');
                    end
                end

            case 'XZ' % both planes
                if isempty(X)
                    orbgui('LBox','X-Reference orbit not available');
                else
                    BPM(1).iref = dev2elem(BPMxFamily,X.DeviceList);
                    %decompress data
                    temp        = getfamilydata(BPMxFamily,'Status');
                    status      = find(temp);
                    temp(status)= X.Data;
                    BPM(1).ref  = temp;
                    BPM(1).des  = temp;
                    BPM(1).abs  = temp;
                    orbgui('LBox','X-Reference orbit loaded');
                    if isfield(X,'FileName'), orbgui('LBox',X.FileName);
                    else
                        orbgui('LBox','Horizontal reference orbit loaded');
                    end
                end
                if isempty(Z)
                    orbgui('LBox','Z-Reference orbit not available');
                else
                    BPM(2).iref = dev2elem(BPMzFamily,Z.DeviceList);
                    %decompress data
                    temp        = getfamilydata(BPMzFamily,'Status');
                    status      = find(temp);
                    temp(status)= Z.Data;
                    BPM(2).ref  = temp;
                    BPM(2).des  = temp;
                    BPM(2).abs  = temp;
                    orbgui('LBox','Z-Reference orbit loaded');
                    if isfield(Z,'FileName'), orbgui('LBox',Z.FileName);
                    else
                        orbgui('LBox','Vertical reference orbit loaded');
                    end
                end

        end %end case

        if SYS.relative==1   %absolute mode
            ntbpm      = length(BPM(1).name(:,1));
            BPM(1).abs = zeros(1,ntbpm)';
            ntbpm      = length(BPM(2).name(:,1));
            BPM(2).abs = zeros(1,ntbpm)';
        end

        [BPM] = SortBPMs(BPM,RSP);

        setappdata(0,'BPM',BPM);

        bpmgui('RePlot');        %reference, desired, absolute
        orbgui('RefreshOrbGUI');

        %===============================================================
    case 'ArchiveBPMOrbit'                 % *** ArchiveBPMOrbit ***
        %===============================================================
        %archive present orbit as reference orbitref
        %'X','Z','XZ' options
        %'Golden' option

        refplane              = varargin{1};
        [varargin,GoldenFlag] = findkeyword(varargin,'Golden');

        if GoldenFlag
%             DirectoryName  = getfamilydata('Directory','OpsData');
%             FileName = getfamilydata('OpsData', 'BPMGoldenFile');
            tmp = questdlg('Save Golden Reference Orbit (solid blue line)?','Golden Orbit','YES','NO','YES');
            if strcmp(tmp,'NO')
                orbgui('LBox', ' Golden orbit save aborted');
                return
            end
        else %search for BPM directory
            DirStart      = pwd;
            DirectoryName = getfamilydata('Directory','BPMData');
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
        end

        switch refplane % Select plane to save
            case 'X' % Horizontal plane
                BPMxData           = getx('struct');
                % Modified creator field
                BPMxData.CreatedBy ='solorbit-readwrite';
%                 BPMxData.iFit      = BPM(1).ifit;         %on for fitting (contstraint)
                if GoldenFlag % Golden orbit
%                     physdatafile   = getfamilydata('OpsData', 'PhysDataFile');
%                     datastruct     = load(physdatafile); % read old one to get the right format
%                     PhysData             = getphysdata;
%                     PhysData.BPMx.Golden = BPMxData;                    
%                     save GoldenPhysData PhysData
                    setphysdata(BPMxFamily,'Golden',BPMxData);
                else % not a golden orbit
                    FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile'),'x'], clock);
                    save(FileName, 'BPMxData');
                end
                orbgui('LBox', ' BPMx-Reference orbit archived');

            case 'Z' % Vertical plane
                BPMzData           = getz('struct');
                BPMzData.CreatedBy = 'solorbit-readwrite';
%                 BPMzData.iFit      = BPM(2).ifit;         %on for fitting (contstraint)
                if GoldenFlag
%                     physdatafile=getfamilydata('OpsData', 'PhysDataFile');
%                     datastruct=load(physdatafile);
%                     PhysData             = getphysdata;
%                     PhysData.BPMz.Golden = BPMzData;                    
                    setphysdata(BPMzFamily,'Golden',BPMzData);
%                     datastruct.PhysData.BPMz.Golden=BPMzData;
%                     PhysData=datastruct.PhysData;
%                     save GoldenPhysData PhysData
                else % Not a golden orbit
                    FileName = appendtimestamp([getfamilydata('Default', 'BPMArchiveFile'),'z'], clock);
                    save(FileName, 'BPMzData');
                end
                orbgui('LBox', ' BPMz-Reference orbit archived');

            case 'XZ' % Both planes
                BPMxData           = getx('struct');
                BPMxData.CreatedBy = 'solorbit-readwrite';
%                 BPMxData.iFit      = BPM(1).ifit;         %on for fitting (contstraint)
                BPMzData           = getz('struct');
                BPMzData.CreatedBy = 'solorbit-readwrite';
%                 BPMzData.iFit      = BPM(2).ifit;
                if GoldenFlag
                    setphysdata({BPMxFamily, BPMzFamily},{'Golden', 'Golden'}, {BPMxData, BPMzData});
%                     physdatafile=getfamilydata('OpsData', 'PhysDataFile');
%                     datastruct=load(physdatafile);
%                     datastruct.PhysData.BPMx.Golden=BPMxData;
%                     datastruct.PhysData.BPMz.Golden=BPMzData;
%                     PhysData=datastruct.PhysData;
%                     PhysData             = getphysdata;
%                     PhysData.BPMx.Golden = BPMxData;                    
%                     PhysData.BPMx.Golden = BPMzData;                    
%                     save GoldenPhysData PhysData
                else % not a golden orbit
                    FileName = appendtimestamp(getfamilydata('Default', 'BPMArchiveFile'), clock);
                    save(FileName, 'BPMxData', 'BPMzData');
                end
                orbgui('LBox', ' BPMx/z-Reference orbit archived');
        end


        if GoldenFlag, bpmgui('UpdateRef');  %establish new reference orbit, refreshorbgui
        else
            cd(DirStart);
            orbgui('LBox',[' Archive file: ' FileName]);
        end
        
        %=============================================================
    case 'DialogBox'               % *** DialogBox ***
        %=============================================================       
%         figtitle = char(varargin(1));
        ftype    = char(varargin(2));    %type of file, eg ReadReference: must be case in readwrite
        
        %read file options
        
        cd(SYS.localdata);

        extype = '*.dat';
        if strcmp(ftype,'ReadDispersion')  ||...
           strcmp(ftype,'ReadCorrectors')  ||...
           strcmp(ftype,'RestoreSystem')
       
            if strcmp(ftype,'RestoreSystem')
                extype = '*.m'; 
            elseif strcmp(ftype,'ReadDispersion')
                extype = '*.mat';
                cd(SYS.etafile);                
            end

            [FileName,DirSpec] = uigetfile(extype,[ftype, ' - please supply .m extension']);

            ts = datestr(now,0);
            
            if isequal(FileName,0) || isequal(DirSpec,0)
                disp(['File ',[DirSpec FileName],' not found']);
                orbgui('LBox',[ ts ': File ',[DirSpec FileName],' not found']);
                return
            else
                disp(['File ', [DirSpec FileName], ' found']);
                orbgui('LBox',['File ', [DirSpec FileName], ' found']);
                readwrite('ProcessDialog',ftype,DirSpec,FileName);
                return
            end
        end

        %write file options
        extype = '*.dat';
        if strcmp(ftype,'WriteCorrectors')  ||...
                strcmp(ftype,'WriteResponse')    ||...
                strcmp(ftype,'SaveSystem')
            if strcmp(ftype,'SaveSystem'), extype = '*.m'; end

            [FileName,DirSpec] = uiputfile(extype,ftype);
            if isempty(findstr(FileName,'.m')) && strcmpi(ftype,'SaveSystem')
                FileName = [FileName,'.m'];
            elseif isempty(findstr(FileName,'.dat')) && ~strcmpi(ftype,'SaveSystem')
                FileName = [FileName,'.dat'];
            end

            ts = datestr(now,0);
            if isequal(FileName,0) || isequal(DirSpec,0)
                disp('File not open');
                orbgui('LBox',[ ts ': File not opened...']);
                return
            else
                disp(['File ', [DirSpec FileName], ' open']);
                orbgui('LBox',['File ', [DirSpec FileName], ' open']);
                readwrite('ProcessDialog',ftype,DirSpec,FileName);
                return
            end
        end

        %==================
    case 'ReadResponse'
        %==================

        FileName =''; %asks user to select Rmatrix
        
        temp = getbpmresp(BPM(1).AOFamily, BPM(2).AOFamily, COR(1).AOFamily, ...
            COR(2).AOFamily,FileName,'struct');

        if isempty(temp)
            disp('No Response matrix read');
            return
        end

        % Fils up matrix reponse structure
        RSP(1) = response2rsp(temp(1,1),RSP(1),1);
        RSP(2) = response2rsp(temp(2,2),RSP(2),2);

        BPM = sortbpms(BPM,RSP); %sort for avail, ifit
        COR = sortcors(COR,RSP); %sort for avail, ifit

        % Updates values into workspace
        setappdata(0,'BPM',BPM);
        setappdata(0,'COR',COR);
        setappdata(0,'RSP',RSP);

        orbgui('RefreshOrbGUI');

        %==============================================================
    case 'ProcessDialog'                    % *** ProcessDialog ***
        %==============================================================
        ftype    = char(varargin(1));
        DirSpec  = char(varargin(2));
        FileName = char(varargin(3));

        switch ftype

                %===================
            case 'ReadDispersion'
                %===================

                filename = [DirSpec FileName];
                
                %% load file
                temp = load(filename);
                
                %% Check data contents
                if ~isfield(temp,'BPMxDisp') && ~isfield(temp,'BPMyDisp')
                    disp(['WARNING: Dispersion orbit file not found:' ...
                        [DirSpec FileName]]);                   
                    return
                else % Load data (Dispersion in HW means frequency)
                    RSP(1).eta = temp.BPMxDisp.Data;
                    RSP(2).eta = temp.BPMyDisp.Data;
                end

                %Update RSP
                setappdata(0,'RSP',RSP);

                %===================
            case 'ReadCorrectors'
                %===================
                [fid,message] = fopen([DirSpec FileName],'r');
                if fid == -1
                    disp(['WARNING: Corrector file not found:' [DirSpec FileName]]);
                    disp(message);
                    return
                end
                fclose(fid);

                readwrite(ftype,[DirSpec FileName],'auto');

                %===================
            case 'WriteCorrectors'
                %===================
                comment = 'Write Correctors';
                readwrite(ftype,[DirSpec FileName],comment);

                %===================
            case 'WriteResponse'
                %===================
                comment = 'Write Response';
                readwrite(ftype,[DirSpec FileName],comment);

                %===================
            case 'RestoreSystem'
                %===================
                isok = exist([DirSpec FileName],'file');
                if ~isok == 2
                    disp(['WARNING: Restore file not found:' [DirSpec FileName]]);
                    return
                end
                orbgui(ftype,DirSpec,FileName,'auto');

                %===================
            case 'SaveSystem'
                %===================
                comment = 'Save System';
                orbgui(ftype,[DirSpec FileName],comment);

            otherwise
                disp(['Warning: no CASE found in readwrite/Dialog Box: ' action]);
        end   %end of ProcessDialog switch yard
        %pause(3);    delete(gcf);
        %=============================================================

%         %=============================================================
%     case 'OpenHelp'                            % *** OpenHelp ***
%         %==============================================================
%         FileName = 'HelpD.m';
%         fid = fopen(FileName, 'r');
% 
%         if fid < 0
%             disp(['**Warning: Help file "', FileName, '" cannot be found.']);
%             return
%         end
% 
%         while feof(fid) == 0
%             t = fgetl(fid);
%             disp(t);
%         end
% 
%         fclose(fid);
% 
        %==============================================================
    otherwise
        disp(['Warning: no CASE found in readwrite: ' action]);
end  %end switchyard
