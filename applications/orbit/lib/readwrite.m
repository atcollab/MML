%=============================================================
function varargout = readwrite(action, varargin)
%=============================================================
% readwrite supplies a switchyard of routines
% to read and write data files in SPEAR formats
%WriteReference
%ReadDispersion
%ReadBResponse

orbfig = findobj(0,'tag','orbfig');  %orbfig "global"
global BPM BL COR RSP SYS
% SYS=getappdata(0,'SYS');
% BPM=getappdata(0,'BPM');
% COR=getappdata(0,'COR');
% RSP=getappdata(0,'RSP');
% BL =getappdata(0,'BL' );
switch action

    %=============================================================
    case 'LogFdbkData'                       % *** LogFdbkData ***
        %=============================================================
        if strcmp(SYS.machine,'SPEAR2')
            [SYS.beam, SYS.engy,SYS.curr,SYS.lt,SYS.ahr]=getset('GetSPEAR2Params',SYS.mode);
            setappdata(0,'SYS',SYS);
        elseif strcmp(SYS.machine,'SPEAR3')
        end
        BPMLog(SYS,BPM);
        CORLog(SYS,COR);

        %=============================================================
    case 'ReadBPMReference'             % *** ReadBPMReference ***
        %=============================================================
        %read archive orbit as reference
        refplane=varargin{1};
        [varargin,GoldenFlag]=findkeyword(varargin,'Golden');

        families={gethbpmfamily; getvbpmfamily};
        if GoldenFlag   %retrieve data from PhysData Structure

            X = getgolden(families{1},'struct');
            Y = getgolden(families{2},'struct');

        else

            [X,Y] = loadorbit([],[],'struct');     %select file from browser

        end

        if isempty(X) && isempty(Y)
            disp('   Warning: No orbit loaded')
            return
        end

        x{1}=X;
        x{2}=Y;

        %process for orbit program
        for k=1:2
            struct=x{k};
            family=families{k};
            status=getfamilydata(family,'Status');
            BPM(k).ref=zeros(length(status),1);
            BPM(k).des=zeros(length(status),1);
            BPM(k).abs=zeros(length(status),1);

            [BPM(k).iref,istat,idev]=intersect(find(status),(1:length(status))');   %good status and in orbit structure

  %          if strcmpi(SYS.datamode,'REAL')  %convert to REAL coordinates
  %              struct.Data(idev)=BPM(k).gain(BPM(k).iref).*(struct.Data(idev)-BPM(k).offset(BPM(k).iref));
  %          end

%             BPM(k).ref(BPM(k).iref)=struct.Data(idev);
%             BPM(k).des(BPM(k).iref)=struct.Data(idev);
%             BPM(k).abs(BPM(k).iref)=struct.Data(idev);

            if SYS.relative==1   %display mode
                ntbpm=length(BPM(k).name(:,1));
                BPM(k).abs=zeros(1,ntbpm)';
            end

            [BPM]=sortbpms(BPM,RSP);

        end

        setappdata(0,'BPM',BPM);

        orbgui('LBox','Reference orbit loaded');
        orbgui('RefreshOrbGUI');

        %===============================================================
    case 'ArchiveBPMOrbit'                 % *** ArchiveBPMOrbit ***
        %===============================================================
        %archive present orbit as reference orbitref
        %'X','Y','B' options
        %'Golden' option

        refplane=varargin{1};
        [varargin,GoldenFlag]=findkeyword(varargin,'Golden');

        BPMxData = getx('struct');         %raw data for archive
        BPMxData.CreatedBy='OrbitControl';
        BPMxData.iFit=BPM(1).ifit;         %BPMs on for fitting (contstraint)

        BPMyData = gety('struct');         %raw data for archive
        BPMyData.CreatedBy='OrbitControl';
        BPMyData.iFit=BPM(2).ifit;

        if GoldenFlag
            tmp = questdlg('Save Golden Reference Orbit (solid blue line)?','Golden Orbit','YES','NO','YES');

            if strcmpi(tmp,'NO')
                orbgui('LBox', ' Golden orbit save aborted');
                return
            end

            needs work!!!!

            physdata.BPMx.Golden=BPMxData;
            physdata.BPMy.Golden=BPMyData;
            save GoldenPhysData physdata
            orbgui('LBox', ' Golden orbit saved');
            %bpmgui('UpdateRef');%establish new reference orbit, refreshorbgui

        else

            DirStart = pwd;
            DirectoryName = getfamilydata('Directory','BPMData');
            [DirectoryName, ErrorFlag] = gotodirectory(DirectoryName);
            FileName = appendtimestamp(getfamilydata('Default', 'BPMArchiveFile'), clock);
            save(FileName, 'BPMxData', 'BPMyData');
            cd(DirStart);
            orbgui('LBox',[' Archive file: ' FileName]);

        end

        %=============================================================
    case 'ReadDispersion'                % *** ReadDispersion ***
        %=============================================================
        %read dispersion orbit
        refplane=varargin{1};
        [varargin,GoldenFlag]=findkeyword(varargin,'Golden');

        families={gethbpmfamily; getvbpmfamily};

        if GoldenFlag   %retrieve data from PhysData Structure

            X = getdisp(families{1},'struct');
            Y = getdisp(families{2},'struct');

        else

            [X,Y] = loadorbit([],[],'struct');     %select file from browser

        end

        x{1}=X;
        x{2}=Y;

        %process for orbit program
        for k=1:2
            struct=x{k};
            family=families{k};
            status=getfamilydata(family,'Status');

            % RSP(1).eta=rsp(1).eta;
            % RSP(1).drf=rsp(1).drf;


            BPM(k).ref=zeros(length(status),1);
            BPM(k).des=zeros(length(status),1);
            BPM(k).abs=zeros(length(status),1);

            [BPM(k).iref,istat,idev]=intersect(find(status),(1:length(status))');   %good status and in orbit structure

 %           if strcmpi(SYS.datamode,'REAL')  %convert to REAL coordinates
 %               struct.Data(idev)=BPM(k).gain(BPM(k).iref).*(struct.Data(idev)-BPM(k).offset(BPM(k).iref));
 %           end

        end

        setappdata(0,'BPM',BPM);

        orbgui('LBox','Dispersion orbit loaded');
        orbgui('RefreshOrbGUI');

        %=============================================================
    case 'DialogBox'               % *** DialogBox ***
        %=============================================================
        figtitle=varargin(1);    %cell array
        figtitle=char(figtitle);
        ftype=varargin(2);     		%type of file, eg ReadReference: must be case in readwrite
        ftype=char(ftype);

        %read file options
        extype='*.dat';
        if strcmp(ftype,'ReadDispersion')

            [FileName,DirSpec]=uigetfile(extype,[ftype, ' - please supply .m extension']);

            ts = datestr(now,0);
            if isequal(FileName,0)|isequal(DirSpec,0)
                disp('File ',[DirSpec FileName],' not found');
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
        extype='*.dat';
        if strcmp(ftype,'WriteResponse')

            [FileName,DirSpec]=uiputfile(extype,ftype);
            if isempty(findstr(FileName,'.m'))
                FileName = [FileName,'.m'];
            end

            ts = datestr(now,0);
            if isequal(FileName,0)|isequal(DirSpec,0)
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

        DirectoryName = getfamilydata('Directory', 'BPMResponse');
        [FileName, DirectoryName] = uigetfile('*.mat', 'Select a configuration file to load', DirectoryName);
        FileName = [DirectoryName FileName];

        t=load(FileName);

        temp=t.Rmat;

        %temp=getbpmresp('BPMx',[],'BPMy',[],'HCM',[],'VCM',[],FileName,'struct');

        if isempty(temp)
            return
        end

        for k=1:2
            RSP(k)=response2rsp(temp(k,k),RSP(k),k);
        end

        if strcmpi(SYS.datamode,'REAL')   %convert to REAL units
            for k=1:2
                ib=RSP(k).ib;
                ic=RSP(k).ic;
                RSP(k).c(ib,ic)=diag(BPM(k).gain(ib))*RSP(k).c(ib,ic);
            end
        end

        BPM=SortBPMs(BPM,RSP);       %sort for avail, ifit
        COR=SortCORs(COR,RSP);       %sort for avail, ifit

        setappdata(0,'BPM',BPM);
        setappdata(0,'COR',COR);
        setappdata(0,'RSP',RSP);

        orbgui('RefreshOrbGUI');

        %==============================================================
    case 'ProcessDialog'                    % *** ProcessDialog ***
        %==============================================================
        ftype=varargin(1);       ftype=char(ftype);
        DirSpec=varargin(2);     DirSpec=char(DirSpec);
        FileName=varargin(3);    FileName=char(FileName);


        switch ftype

            %===================
            case 'ReadDispersion'
                %===================
                [fid,message]=fopen(FileName,'r');
                if fid==-1
                    disp(['WARNING: Dispersion orbit file not found:' [DirSpec FileName]]);
                    disp(message);
                    return
                end
                timestamp=fgetl(fid)
                fclose(fid);

                if     SYS.machine=='SPEAR2'
                    rsp=ReadSPEAR2Dispersion(SYS.etafil,'auto');
                elseif SYS.machine=='SPEAR3'
                    rsp=ReadSPEAR3Dispersion(SYS.etafil,'auto');
                end
                RSP(1).eta=rsp(1).eta;
                RSP(1).drf=rsp(1).drf;
                RSP(2).eta=rsp(2).eta;
                RSP(2).drf=rsp(2).drf;
                setappdata(0,'RSP',RSP);

                if strcmpi(SYS.datamode,'REAL')
                    for k=1:2
                        status=BPM(k).status;
                        RSP(k).eta(status)=BPM(k).gain(status).*RSP(k).eta(status);   %scale by gain
                    end
                end


                clear rsp;

            otherwise
                disp(['Warning: no CASE found in SPEAR 3 readwrite/Dialog Box: ' action]);
        end   %end of ProcessDialog switch yard
        %pause(3);    delete(gcf);

        %=============================================================
    case 'OpenHelp'                            % *** OpenHelp ***
        %==============================================================
        FileName = 'HelpD.m';
        fid = fopen(FileName, 'r');

        if fid < 0
            disp(['**Warning: Help file "', FileName, '" cannot be found.']);
            return
        end

        while feof(fid) == 0
            t = fgetl(fid);
            disp(t);
        end

        fclose(fid);

        %==============================================================
    otherwise
        disp(['Warning: no CASE found in readwrite: ' action]);
end  %end switchyard