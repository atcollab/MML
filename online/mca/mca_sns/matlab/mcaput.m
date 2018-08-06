function sts = mcaput(varargin)
%MCAPUT       - Write values to EPICS Process Variables
%
% MCAPUT(HANDLE1, VALUE1) - one handle, one value
% MCAPUT(HANDLE1, VALUE1, ... , HANDLE_N, VALUE_N) - handles and values in pairs
%
% EPICS STRING values are passed as MATLAB strings. For example:
%    >> mcaput(H, 'MATLAB')
%    >> mcaput(H1, 'MATLAB', H2, 'EPICS')
% or cell arrays of strings.
%
% MCAPUT(HANDLES_CELL_ARRAY, VALUES_CELL_ARRAY) - arguments are grouped
%    in cell array of integer handles and a cell array of values
%    of equal length.
% 
% Returns an array of status values: 1 success, 0 failure, -1 timeout
% 
% MCAPUT is implemented as a call to the ca_put_array_callback
% function in CA client library.
% MCAPUT returns 1 or 0 if we get an OK respectively error status within
% the timeout, or -1 if we don't get any response within the timeout.
%
% Note:
% The special case of MCAPUT([PV, PV, ...], [SCALAR, SCALAR, ...])
% will simply write the scalar values to the PVs without waiting for the
% callback.
%    
% See also MCAGET, MCATIMEOUT.

if nargin==2
    if iscell(varargin{1}) && iscell(varargin{2})
        % {pv, pv, pv, ...}, {value, value, value, ...}
        if length(varargin{1}) ~= length(varargin{2})
            error('Cell array of MCA handles and cell array of values must be the same length')
        end
        HANDLES = varargin{1}; VALUES = varargin{2};
        ARGS = reshape([HANDLES(:)';VALUES(:)'],1,2*length(varargin{1}));
        sts = mca(70,ARGS{:});
    elseif isnumeric(varargin{1})
        if length(varargin{1})>1
            if length(varargin{1}) ~= length(varargin{2})
                error('Array of handles and array of values must be the same length');
            end
	        % [pv, pv, pv, ...], [value, value, value, ...]
            sts = mca(80,varargin{1},varargin{2});
        else
            ARGS = varargin;
			% (pv, value)
            if (isnumeric(ARGS(2)))
                sts = mca(70,ARGS{:});
            else
                if(strcmp(mca(43,varargin{1}),'ENUM')&&~isnumeric(varargin{2}))
                    enumvalues=mca(40,varargin{1});
                    found = 0;
                    for ind = 1:numel(enumvalues)
                        if(strcmp(ARGS(2),enumvalues(ind)))
                            valueToPut=ind-1;
                            found=1;
                        end
                    end
                    if(found)
                        ARGS{2}=valueToPut;
                        sts = mca(70,ARGS{:});
                    else
                        strings = sprintf(' "%s" ',enumvalues{:});
                        error('mcaput:enumCheck','Invalid value for this channel. Try one of: [%s]',strings);
                    end
                else
                    sts = mca(70,ARGS{:});
                end
            end
        end
    else
    	error('Invalid mcaput args, need PV, VALUE');
    end
elseif mod(nargin,2) == 0
	% 'pv, value, pv, value, ...'
    sts = mca(70,varargin{:});
else
    error('Incorrect number of inputs, need a sequence of PV, VALUE')
end
