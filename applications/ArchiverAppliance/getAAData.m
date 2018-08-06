function [ output_args ] = getAAData( pvname, startdate, enddate )
%getAAData Retrieves data from the archiver appliance
%   Archiver data are retrieved for a pv over a given
%   time range.
%   getAAData('mypv', '2008-01-01T00:00:00-08', '2008-12-31T23:59:59-08')
%      Retrieves data for the pv "mypv" for all of 2008, in Pacific
%      Standard Time
%
%   @param pvname the pv name
%   @param startdate a string representing the start date/time in ISO 8601
%   format
%   @param enddate a string representing the end date/time in ISO 8601
%   format
%   @output a 1x1 struct containing subelements header and data.  These are
%   each structs with the elements:
%       header:
%           source (e.g. "Archiver appliance")
%           pvName
%           from = startdate
%           to = enddate
%       data: (N = # samples)
%           values = Nx1 double, or NxM double if pv is a waveform
%           epochSeconds = Nx1 int64
%           nanos = Nx1 int64
%           isDST = Nx1 uint8
%
%   Formats for startdate, enddate: The ISO 8601 format is
%   YYYY-MM-DDTHH:MM:SS.UZ where:
%       YYYY-MM-DD = Year, month, date
%       T = Delimiter between date and time (a literal "T")
%       HH:MM:SS = Hour, minute, second
%       .F = Fractional part of second
%       Z = Optional timezone.  If not specified, local time is used.  If
%       specified and "Z", UTC time is used.  May also be specified as
%       +/-HH, where HH is hours, e.g. -08 for Pacific Standard Time.
%   Examples of valid date/time representations:
%       2000-07-04T00:00:00-07 July 4, 2000 midnight, PDT
%       2013-11-22T08:00:00Z Nov. 22, 2013 at 08:00 am UTC (=midnight PST)
%
% See also ArchAppliance.getData
%
%   Copyright (c) Lawrence Berkeley National Laboratory

	aa = ArchAppliance();
	output_args = aa.getData(pvname, startdate, enddate);

end

