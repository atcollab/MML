%***********************
function test5
%***********************

%This function attempts to read from the file RESP99_13.DAT into
%the response matrix.



fid = fopen('resp99_13.dat','r');

for i = 1:4
	fgetl(fid);
end

a = fgetl(fid);
i = 1;

[ntbpm,i] = getWord(a,i);
ntbpm = str2num(ntbpm);
[nbpmx,i] = getWord(a,i);
nbpmx = str2num(nbpmx);
[nbpmy,i] = getWord(a,i);
nbpmy = str2num(nbpmy);
[nbl,i] = getWord(a,i);
nbl = str2num(nbl);

a = fgetl(fid);
i = 1;

for j = 1:nbpmx
    [sample,i] = getWord(a,i);
    ibpmx(j) = str2num(sample);
    if (i > length(a))
       a = fgetl(fid);
       i = 1;
    end
end

for j = 1:nbpmy
    [sample,i] = getWord(a,i);
    ibpmy(j) = str2num(sample);
    if (i > length(a))
       a = fgetl(fid);
       i = 1;
    end
end

for j = 1:nbl
    [sample,i] = getWord(a,i);
    ibl(j) = str2num(sample);
    if (i > length(a))
       a = fgetl(fid);
       i = 1;
    end
end

for j = 1:ntbpm
    [bpname{j},i] = getWord(a,i);
    j = j + 1;
    i = 1;
    a = fgetl(fid);
end

[ntcorx,i] = getWord(a,i);
ntcorx = str2num(ntcorx);
[ntcory,i] = getWord(a,i);
ntcory = str2num(ntcory);
[ncorx,i] = getWord(a,i);
ncorx = str2num(ncorx);
[ncory,i] = getWord(a,i);
ncory = str2num(ncory);

a = fgetl(fid);
i = 1;

for j = 1:ncorx
    [sample,i] = getWord(a,i);
    ixcor(j) = str2num(sample);
    if (i > length(a))
       a = fgetl(fid);
       i = 1;
    end
end

for j = 1:ntcorx
    [cxname{j},i] = getWord(a,i);
    j = j + 1;
    i = 1;
    a = fgetl(fid);
end

for j = 1:ncory
    [sample,i] = getWord(a,i);
    iycor(j) = str2num(sample);
    if (i > length(a))
       a = fgetl(fid);
       i = 1;
    end
end

for j = 1:ntcory
    [cyname{j},i] = getWord(a,i);
    j = j + 1;
    i = 1;
    a = fgetl(fid);
end

a = fgetl(fid);

[corrs,i] = getWord(a,i);
corrs = str2num(corrs);
[bpms,i] = getWord(a,i);
bpms = str2num(bpms);

xdata = [];
x_corr = [];

for i = 1:corrs
   a = fgetl(fid);
   k = 1;

   [dex,k] = getWord(a,k);
   dex = str2num(dex);
   [junk,k] = getWord(a,k);
   [xamps,k] = getWord(a,k);
   xamps = sci2num(xamps);

   x_corr(dex,1) = xamps;

   count = 0;
   linedata = [];
   while ~feof(fid)

	a = fgetl(fid);
	i = 1;
	for j = 1:5
		[index,value,i] = getElmnt(a,i);
		linedata(index,1) = value;
		
		count = count + 1;

		if count == bpms
			break;
		end
	end

	if count == bpms
		break;
	end

   end

xdata = [xdata linedata];

end

fgetl(fid);
a = fgetl(fid);

i = 1;

[corrs,i] = getWord(a,i);
corrs = str2num(corrs);
[bpms,i] = getWord(a,i);
bpms = str2num(bpms);

ydata = [];
y_corr = [];

for i = 1:corrs
   a = fgetl(fid);
   k = 1;

   [dex,k] = getWord(a,k);
   dex = str2num(dex);
   [junk,k] = getWord(a,k);
   [yamps,k] = getWord(a,k);
   yamps = sci2num(yamps);

   y_corr(dex,1) = yamps;

   count = 0;
   linedata = [];
   while ~feof(fid)

	a = fgetl(fid);
	i = 1;
	for j = 1:5
		[index,value,i] = getElmnt(a,i);
		linedata(index,1) = value;
		
		count = count + 1;

		if count == bpms
			break;
		end
	end

	if count == bpms
		break;
	end

   end

ydata = [ydata linedata];
end

fgetl(fid);
a = fgetl(fid);

i = 1;

[corrs,i] = getWord(a,i);
corrs = str2num(corrs);
[bpms,i] = getWord(a,i);
bpms = str2num(bpms);

pdata = [];
y_corr = [];

for i = 1:corrs
   a = fgetl(fid);
   k = 1;

   [dex,k] = getWord(a,k);
   dex = str2num(dex);
   [junk,k] = getWord(a,k);
   [pamps,k] = getWord(a,k);
   pamps = sci2num(pamps);

   y_corr(dex,1) = pamps;

   count = 0;
   linedata = [];
   while ~feof(fid)

	a = fgetl(fid);
	i = 1;
	for j = 1:5
		[index,value,i] = getElmnt(a,i);
		linedata(index,1) = value;
		
		count = count + 1;

		if count == bpms
			break;
		end
	end

	if count == bpms
		break;
	end

   end

pdata = [pdata linedata];
end

ydata
pdata


%*************************
function [index,num,k] = getElmnt(line,i)
%*************************

% getElmnt reads the values stored for a specific element in the file
% for use in the array.

% Input: line is the line of text from the file being read.
%        i is the index pointer in that line.

% Output:index and num are data returned to the main program.
%        index is the element index (ex: ibpmx)
%        num is the data for that element (ex: 1.83E-01).

%        k is the value of i returned to the main program 
%        to keep track of things. 

                  
while line(i) == ' '
	i = i + 1;
end

index = [];
while ~(line(i) == ' ') & ~(line(i) == '-')
	index = [index line(i)];
	i = i + 1;
end
index = str2num(index);

if line(i) == ' '
	i = i + 1;
end

num = [];
while line(i) ~= ' '
	num = [num line(i)];
	i = i + 1;

	if i > length(line)
		break;
	end
end
num = sci2num(num);

k = i;



%********************
function [word,k] = getWord(line, i)
%********************

%getWord reads one 'word' or token at a time from a line of char.

%Input: line is the line being read, i is the pointer to the index
%        within that line.

%Output:word is the token being returned to the main program.
%       k is the returned value of i for the main to keep track of.


word = [];

if ~isempty(line)

while line(i) == ' '
  i = i + 1;
end

while line(i) ~= ' ' 
  word = [word line(i)];
  i = i+1;

  if i > length(line)
	break;
  end
end

end

k = i;


%********************* 
function num = sci2num(str)
%*********************

%Transforms a number from scientific notation to standard form 
%for the program to manipulate.

a = [];

i = 1;
while str(i) ~= 'E'
	a = [a str(i)];
	i = i + 1;
end

a = str2num(a);

sign = str(i + 1);
i = i + 2;

p = [str(i) str(i + 1)];
p = str2num(p);

if sign == '+'
	num = a*(10^p);
else
	num = a*(10^(p * -1));
end

