function daxis(aksis,dateform,startdate) 
% Simplified version of the Financial Toolbox's 'dateaxis' command
startdate = 0;

% Get axis tick values and add appropriate start date. 
Lim = get(gca,[aksis,'lim']); 
xl = get(gca,[aksis,'tick'])'+datenum(startdate); 
set(gca,[aksis,'tickmode'],'manual',[aksis,'limmode'],'manual') 
 
n = length(xl); 
 
% To guarantee that the day, month, and year strings have the 
% the same number of characters after the integer to string  
% conversion, add 100 to the day and month numbers and 10000 to 
% the year numbers for proper padding.  This also allows for 
% padding numbers with zeros.  For example, the first day of a  
% given month will be printed as 01 instead of 1.  The tick values 
% are converted into one long concatenated string by int2str. 
% Reshape matrix so each column is a single value plus the  
% appropriate padding number.  Transpose so each row is now this 
% single value and the needed columns can be extracted. 
 
[mnum,mstring] = month(xl); % Get month number and string from values 
ds = int2str(day(xl)+100); % Build day of month matrix 
ms = int2str(mnum+100); % Build month number matrix 
ys = int2str(abs(year(xl))+10000); % Build year matrix 
hs = int2str(100); % Dummy hour matrix 
mins = int2str(100); % Dummy minute matrix 
ss = int2str(100); % Dummy second matrix 
 
dstr = [char(mstring'),ys(:,4:5)]; 

% Set axis tick labels 
set(gca,[aksis,'ticklabel'],dstr)
