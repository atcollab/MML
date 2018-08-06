function sts = mcaput(varargin)
%MCAPUT Write values to EPICS Process Variables
%
% MCAPUT(HANDLE1, VALUE1) - one handle, one value
% MCAPUT(HANDLE1,VALUE1, ... , HANDLEN, VALUEN) - handles and values in pairs
%    EPICS STRING values are passed as MATLAB strings. For example:
%    >> mcaput(H,'MATLAB')
%    or cell arrays of strings
%    >> mcaput(H1,'MATLAB',H2,'EPICS')
%
% MCAPUT(HANDLES_CELL_ARRAY,VALUES_CELL_ARRAY) - arguments are grouped
%    in cell array of integer handles and a cell array of values
%    of equal length
% 
% Returns an array of status values: 1-success, 0-failure
% 
% Note (Advanced): MCAPUT is implemented as a call to ca_put_array_callback function
%    in CA client library. MCAPUT returns zero if the server does not confirm the 'put'
%    within the MCA_PUT_TIMEOUT. !!! HOWEVER the 'put' may still go through after that.
%    MCA_PUT_TIMEOUT can be set with MCATIMEOUT
%    
% See also MCAGET, MCATIMEOUT.


if nargin==2
    
    if iscell(varargin{1}) & iscell(varargin{2})
        if length(varargin{1})~=length(varargin{2})
            error('Cell array of MCA handles and cell array of values must be the same length')
        else
            HANDLES = varargin{1}; VALUES = varargin{2};
            ARGS = reshape([HANDLES(:)';VALUES(:)'],1,2*length(varargin{1}));
        end
        sts = mca(70,ARGS{:});
    elseif isnumeric(varargin{1})
        if length(varargin{1})>1
            if length(varargin{1})~=length(varargin{2})
                error('Array of handles and array of values must be the same length');
            end
            sts = mca(80,varargin{1},varargin{2});
        else
            ARGS = varargin;
            sts = mca(70,ARGS{:});
        end
    end
elseif ~rem(nargin,2)
    ARGS = varargin; 
    sts = mca(70,ARGS{:});
else
    error('Incorrect number of inputs')
end
