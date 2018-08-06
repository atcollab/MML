%==========================================================
function varargout = curlim(varargin)
%==========================================================
%check to see if element values are within limit
%varargin contains arrays
%1. delta (change in currents)                         COMPRESSED
%2  act (actual currents)                            UNCOMPRESSED
%3. indx (index of elements to check)                  COMPRESSED
%4. lim (current limits)                             UNCOMPRESSED
%5. name (element names)                             UNCOMPRESSED

delta=varargin{1};    %compressed
act  =varargin{2};
indx =varargin{3};    %indices for array compression
lim  =varargin{4};
name =varargin{5};


varargout{1}=0;
for ii=1:length(indx)
  if abs(act(indx(ii))+delta(ii))>=lim(indx(ii))
  disp(['Warning: element value out of range: ' name(indx(ii),:)]);
  varargout{1}=1;                %out of range value flag
  end
end