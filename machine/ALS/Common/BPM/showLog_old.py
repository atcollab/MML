#!/usr/bin/env python

#
# Simple-minded script to dump log file contents
#

import argparse
import bz2
import struct
import calendar
import time
import datetime
import re
import os
import sys

#
# Convert log file name to time structure
#
def filenameToTime(name):
    try:
        t = time.strptime(name, '%Y-%m-%d_%H:%M:%S')
    except:
        t = None
    return t

#
# Create list of log file name/time pairs
#
def logfiles(logdir):
    fileList = []
    for dirname, dirnames, filenames in os.walk(logdir):
        for filename in filenames:
            tm = filenameToTime(filename)
            if (tm):
                path = os.path.join(dirname, filename)
                seconds = calendar.timegm(tm) 
                fileList.append( { 'seconds' : seconds,  \
                                   'path'    : path } )

    #
    # Sort oldest first
    #
    fileList.sort(key=lambda x: x['seconds'])
    return fileList

#######################################################################

#
# Parse arguments
#
epilog = "To avoid ambiguity at the autumnal DST change the 'begin' time\n" \
         'may be followed by a time zone specifier (PST, PDT or UTC).\n'    \
         '\n'                                                               \
         'Columns:\n'                                                       \
         '     1 - ISO-format date YYYY-MM-DD\n'                            \
         '     2 - ISO-format time HH:MM:SS.xxx\n'                          \
         '     3 - X position\n'                                            \
         '     4 - Y position\n'                                            \
         '     5 - Q (skew)\n'                                              \
         '     6 - Button sum\n'                                            \
         '  7-10 - ADC peak\n'                                              \
         ' 11-14 - RF magnitude\n'                                          \
         ' 15-18 - Low pilot tone magnitude\n'                              \
         ' 19-22 - High pilot tone magnitude\n'                             \
         ' 23-26 - Gain trim factors\n'                                     \
         '    27 - Wideband X RMS motion\n'                                 \
         '    28 - Wideband Y RMS motion\n'                                 \
         '    29 - Narrowband X RMS motion\n'                               \
         '    30 - Narrowband Y RMS motion'
parser = argparse.ArgumentParser(description='Show BPM slow acquisition log as ASCII table.',
                        formatter_class=argparse.RawDescriptionHelpFormatter,
                        epilog=epilog)
parser.add_argument('-b', '--begin', help='Begin date/time (YYY-MM-DD HH:MM[:SS] [TZ]), default=beginning of time')
parser.add_argument('-d', '--duration', type=float, default=1, help='duration (seconds), default=1')
parser.add_argument('-s', '--sparse', type=int, default=1, help='sparsing factor, default=1')
parser.add_argument('-U', '--UTC', action='store_true', help='Show times in UTC rather than local time zone')
parser.add_argument('-M', '--MATLAB', action='store_true', help='First columns are seconds and delta seconds.  Easier to read into MATLAB/Octave')
parser.add_argument('filenames', nargs='*')

args = parser.parse_args()

sparse = args.sparse
if (args.begin == None):
    startSeconds = 0;
    endSeconds = 1e99;
else:
    begin = None
    bString = re.sub('[_-]', ' ', args.begin)
    isUTC = (re.search('UTC$', args.begin, re.I) != None)
    for fmt in ('%y %m %d %H:%M:%S %Z', \
                '%y %m %d %H:%M %Z',    \
                '%Y %m %d %H:%M:%S %Z', \
                '%Y %m %d %H:%M %Z',    \
                '%y %m %d %H:%M:%S',    \
                '%y %m %d %H:%M',       \
                '%Y %m %d %H:%M:%S',    \
                '%Y %m %d %H:%M'):
        try:
            begin = time.strptime(bString, fmt)
            break
        except: continue
    if (begin == None):
        sys.stderr.write('%s: begin time argument "%s" is invalid.\n' % (parser.prog, args.begin))
        sys.exit(1)
    if (isUTC == True):
        startSeconds = calendar.timegm(begin) 
    else:
        startSeconds = time.mktime(begin) 
    endSeconds = startSeconds + args.duration

#
# Process the log files.
#
rawPacketSize = 32 * 4
EVG_FREQUENCY = 499.64e6 / 4
oldSeconds = -1
firstSeconds = None
saStruct = struct.Struct('<4I5B3B4H4i4i4i4i4i4i')
for filename in args.filenames:
    f = bz2.BZ2File(filename, 'r', rawPacketSize*1024)
    while (True):
        #
        # Read and unpack packet
        #
        buf = f.read(rawPacketSize);
        if (buf == ""): break
        packet = saStruct.unpack(buf)
        try:
            packet = saStruct.unpack(buf)
        except:
            break
        if (packet[0] != 0xCAFE0004):
            print "Bad magic number (%#X)" % (packet[0])
            sys.exit(1)

        #
        # Determine POSIX time
        #
        seconds = packet[2] + (packet[3] / EVG_FREQUENCY)
        if (oldSeconds != -1):
            interval = seconds - oldSeconds
        #    if ((interval < 0.05) or (interval > 0.15)):
        #        packetTime = datetime.datetime.fromtimestamp(seconds)
        #        sys.stderr.write('Unexpected sample interval %g seconds at %s\n' \
        #          % (interval, packetTime.strftime('%Y-%m-%d %H:%M:%S.%f')))
        oldSeconds = seconds

        #
        # Print requested values
        #
        if (seconds < startSeconds): continue
        if (seconds >= endSeconds): break
        if (sparse >= args.sparse):
            sparse = 0
            if (args.MATLAB):
                if (firstSeconds == None): firstSeconds = seconds
                print "%.5f %.5f" % (seconds, seconds-firstSeconds),
            else:
                if (args.UTC):
                    sampleTime = datetime.datetime.utcfromtimestamp(seconds)
                else:
                    sampleTime = datetime.datetime.fromtimestamp(seconds)
                print sampleTime.strftime('%Y-%m-%d %H:%M:%S.%f'),
            # X, Y, Q, S
            print "%.6g %.6g %.6g %.6g" % (packet[32]/1.0e6, packet[33]/1.0e6, packet[34], packet[35]),
            # ADC peaks
            print "%d %d %d %d" % (packet[12], packet[13], packet[14], packet[15]),
            # RF magnitude
            print "%d %d %d %d" % (packet[16], packet[17], packet[18], packet[19]),
            # Low pilot tone magnitude
            print "%d %d %d %d" % (packet[20], packet[21], packet[22], packet[23]),
            # High pilot tone magnitude
            print "%d %d %d %d" % (packet[24], packet[25], packet[26], packet[27]),
            # Gain trim factors
            s = 1.0 / (1 << 24)
            print "%.5g %.5g %.5g %.5g" % (packet[28]*s, packet[29]*s, packet[30]*s, packet[31]*s),
            # RMS motion (microns)
            s = 1.0e-3
            print "%.5g %.5g %.5g %.5g" % (packet[36]*s, packet[37]*s, packet[38]*s, packet[39]*s),
            print
        sparse += 1
    f.close()
