function ffcopy(Sector, GeV)
%  function ffcopy(Sector, GeV)
%             or
%  function ffcopy(FileName)
%             or
%  function ffcopy
%
%    This function copies the feed forward tables to the proper Unix directories.
%
%    Sector = the storage ring sector number for that insertion device
%    GeV    = the storage ring energy (1.0, 1.3, 1.5, 1.9)
%
%    For example, ffcopy(7,1.5), copies the most recent feed forward table
%    for sector 7 at 1.5 GeV (directory /home/als/physdata/matlab/srdata/gatrack).
%
%    Note:  It is recommended to use this routine only on the Solaris machines!
%           On a PC, your login name must be in the .rhosts file on account idcomp for this
%           function to work! 
%		

DirStart = pwd;

if strcmp(computer,'PCWIN') == 1
   
   disp('  FFCOPY must be run from UNIX.');
   disp(' ');
   return
   
   
   % PC read
   
   % FTPFlag = 0 -> RCP
   %           1 -> FTP
   FTPFlag = 0;
   
   if nargin == 0
      gotodata
      cd gaptrack
      disp('  Choose the desired feed forward table.');
      disp(' ');
      drawnow;
      
      [FFFileName, DirName] = uigetfile('*.txt', 'Choose the desired feed forward file (Energy/Date).');
      
      if FFFileName == 0
         disp('  Feed forward table not changed.');
         eval(['cd ', DirStart]);
         return;
      end
      
      FFFileName = lower(FFFileName);
      
   elseif nargin == 2
      DirName    = sprintf('w:\\public\\matlab\\gaptrack\\');
      FFFileName = sprintf('id%02de%.0f.txt', Sector, 10*GeV);
      
   else
      error('  ffcopy: must have 0 or 2 input arguments.');
   end  
   
   
   eval(['cd ', DirName]);
   
   
   if FTPFlag == 1
      ScriptFileName = 'ftp_fs1.txt';
   else
      ScriptFileName = 'rcp_fs1.bat';
   end
   
   
   disp(['  The feed forward table ', DirName, FFFileName,' is being copied to']);
   disp(['  crconfs1.  Rerun ffcopy if errors occur.  See help ffcopy for details.  To force']);
   disp(['  the feed forward application to read the new tables, choose the "FF-table" button']);
   disp(['  on the Undulator Server Application (or ffread(Sector) in Matlab).']);
   disp([' ']);
   
   
   % Create file copy script
   [fid, message] = fopen(ScriptFileName,'wt');
   if size(message)~=[0 0]
      disp(['File open problem with ', ScriptFileName])
      disp(message)
      fclose(fid);
   else
      % FTP
      if FTPFlag == 1
         fprintf(fid,'user idcomp\n');
         fprintf(fid,'und789\n');
         fprintf(fid,'prompt off\n');
         fprintf(fid,'ascii\n');
         fprintf(fid,'put %s\n', FFFileName);
         fprintf(fid,'dir\n');
         fclose(fid);
      else 
         % RCP
         fprintf(fid,'rcp %s crconfs1.als.lbl.gov.idcomp:\n', FFFileName);
         fprintf(fid,'rsh crconfs1.als.lbl.gov -l idcomp INSTALL\n');
         fclose(fid);
      end
   end
   
   
   % Wait for file to exist (NT bug!)
   pause(5);
   if FTPFlag == 1
      % FTP
      FTPstr = sprintf('!ftp -n -s:%s crconfs1.als.lbl.gov', ScriptFileName);
      eval(FTPstr);
   else
      % RCP
      eval(['!', ScriptFileName]);
   end
   
else
   % Sun
   
   gotodata
   cd gaptrack
   
   FF_Table_Directory = '/home/crconfs1/prod/idcomp_prod_tables/';
   
   if nargin == 0
      disp('  Choose the desired feed forward table.');
      pause(0);
      
      [FFFileName, DirName] = uigetfile('*.txt', 'Choose the desired feed forward file (Energy/Date).');
      
      if FFFileName == 0
         disp('  Feed forward table not changed.');
         eval(['cd ', DirStart]);
         return;
      end
      
      FFFileName = lower(FFFileName);
      eval(['!cp ',DirName, FFFileName,' ',FF_Table_Directory, FFFileName]); 
      fprintf('  Copying %s to %s\n', [DirName FFFileName], FF_Table_Directory);
      
   elseif nargin == 1
      if isstr(Sector)
         FFFileName =  Sector;
         eval(['!cp ', FFFileName,' ',FF_Table_Directory, FFFileName]); 
         fprintf('  Copying %s to %s\n', [FFFileName], FF_Table_Directory);
      else
         disp('  Input must be a string (ffcopy(FileName)).  Feed forward table not changed.');
         eval(['cd ', DirStart]);
         return;
      end
      
   elseif nargin == 2
      FFFileName = sprintf('id%02de%.0f.txt', Sector, 10*GeV);
      eval(['!cp ', FFFileName,' ',FF_Table_Directory, FFFileName]); 
      fprintf('  Copying %s to %s\n', [pwd ,'/', FFFileName], FF_Table_Directory);
      
      if (Sector == 4) | (Sector == 11)
         FFFileName = sprintf('epu%02dm0e%.0f.txt', Sector, 10*GeV);
         eval(['!cp ', FFFileName,' ',FF_Table_Directory, FFFileName]); 
         fprintf('  Copying %s to %s\n', [pwd ,'/', FFFileName], FF_Table_Directory);
         FFFileName = sprintf('epu%02dm1e%.0f.txt', Sector, 10*GeV);
         eval(['!cp ', FFFileName,' ',FF_Table_Directory, FFFileName]); 
         fprintf('  Copying %s to %s\n', [pwd ,'/', FFFileName], FF_Table_Directory);
      end
   else
      error('  ffcopy: must have 0, 1, or 2 input arguments.');
   end       
end


% Return of original directory
eval(['cd ', DirStart]);
