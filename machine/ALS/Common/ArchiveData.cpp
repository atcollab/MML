// ArchiveData.cpp
//
// Interfaces the Channel Archiver's Network Data Server
// to Matlab and GNU Octave.
//
// See ArchiveData.txt for usage, Makefile for compilation.
//
// Yes, this code is very ugly, but so far there didn't seem
// any use on further modularization because it's nothing
// but extremely ugly back-and-forth conversions between
// Archiver data types and Matlab/Octave.
//
// kasemir@lanl.gov

// OCTAVE needs to be defined to get the code for Octave.
// You might have guessed that.

// Debug messages?
#undef DEBUG

// -----------------------------------------------------------------------
// Generic Stuff
// -----------------------------------------------------------------------
#include <epicsTimeHelper.h>
#include <ArchiveDataClient.h>

#ifdef OCTAVE
// For an unknown reason, octave has a ~1sec rounding problem.
#    define SplitSecondTweak      (1.0/24/60/60/2)
#else
#    define SplitSecondTweak      0.0
#endif

static void epicsTime2DateNum(const epicsTime &t, double &seconds, double &nanoseconds)
{
    xmlrpc_int32 secs, nano;
    epicsTime2pieces(t, secs, nano);
    if (!timezone) // either not set or we're in England
        tzset();
    time_t local_secs = secs - timezone;
    // From Paul Kienzle's collection of compatibility routines for Octave:
    // seconds since 1970-1-1 divided by sec/day plus datenum(1970,1,1):
    seconds = (double)local_secs/86400.0 + 719529.0 + SplitSecondTweak;
    nanoseconds = (double) nano/1e9;
}    

void DateNum2epicsTime(double num, epicsTime &t)
{
    xmlrpc_int32 secs, nano = 0;
    double local_secs = (num - 719529.0)*86400.0;
    secs = (xmlrpc_int32)local_secs + timezone;
    pieces2epicsTime(secs, nano, t);
}
// -----------------------------------------------------------------------
// Octave Stuff
// -----------------------------------------------------------------------
#ifdef OCTAVE
#include <octave/oct.h>
#include <octave/pager.h>
#include <octave/Cell.h>
#include <octave/lo-ieee.h>

// ValueInfo is used to temporarily store all the
// samples that we get from the network data server.
// It's allocated with 'count' samples,
// and after we get all the data, we'll check how
// many samples we actually received, so that
// we can then return that used portion as the
// result of the mex routine.
class ValueInfo
{
public:
    ValueInfo(size_t num_channels, size_t num_samples)
            : num_channels(num_channels), num_samples(num_samples)
    {
        data = (Matrix **) calloc(num_channels, sizeof(Matrix *));
        array_sizes = (size_t *)calloc(num_channels, sizeof(size_t));
        used_columns = (size_t *)calloc(num_channels, sizeof(size_t));
    }
    ~ValueInfo()
    {
        free(used_columns);
        free(array_sizes);
        size_t i;
        for (i=0; i<num_channels; ++i)
            if (data[i])
                delete data[i];
        free(data);
    }
    Matrix **data;        // One matrix per channel.
    size_t *array_sizes;  // .. per channel. ==1 for scalars.
    size_t *used_columns; // used matrix lines for each channel.
    size_t num_channels, num_samples;
};

static bool value_callback(void *arg,
                           const char *name,
                           size_t n, // channel index
                           size_t i, // value index
                           const CtrlInfo &info,
                           DbrType type, DbrCount count,
                           const RawValue::Data *value)
{
#ifdef DEBUG
    stdString t, v, s;
    RawValue::getTime(value, t);
    RawValue::getValueString(v, type, count, value, &info);
    RawValue::getStatus(value, s);
    octave_stdout << i << " : " << t.c_str() << " " << v.c_str()
                  << " " << s.c_str() << "\n";
#endif
    ValueInfo *vi = (ValueInfo *)arg;
    if (i == 0)
    {   // allocate storage
            vi->data[n] = new Matrix(2+count, vi->num_samples);
            vi->array_sizes[n] = count;
    }
    Matrix *m = vi->data[n];
    epicsTime2DateNum(RawValue::getTime(value), m->elem(0, i), m->elem(1, i));
    int ai;
    bool valid = true;
    if (RawValue::isInfo(value))
        valid = false;
    else
        for (ai=0; ai<count; ++ai)
            if (!RawValue::getDouble(type, count, value, m->elem(2+ai, i), ai))
            {
                valid = false;
                break;
            }
    if (!valid)
        for (ai=0; ai<count; ++ai)
            m->elem(2+ai, i) = octave_NaN;
    vi->used_columns[n] = i+1;
    return true;
}

DEFUN_DLD(ArchiveData, args, nargout, "ArchiveData: See ArchiveData.txt")
{
    size_t i, num;
    octave_value_list retval;
    int nargin = args.length();
    if (nargin < 2)
    {
        error("At least two arguments (URL, CMD) required\n");
        return retval;
    }
    if (!(args(0).is_string() && args(1).is_string()))
    {
        error("URL & CMD must be strings");
        return retval;
    }
    const std::string &url = args(0).string_value();
    const std::string &cmd = args(1).string_value();
    int key = 0;
    if (nargin >= 3)
    {
        if (!args(2).is_real_scalar())
        {
            error("KEY must be a number");
            return retval;
        }
        key = args(2).int_value();
    }
#ifdef DEBUG
    octave_stdout << "URL='" << url << "'\n";
    octave_stdout << "CMD='" << cmd << "'\n";
    octave_stdout << "KEY='" << key << "'\n";
#endif
    ArchiveDataClient client(url.c_str());
    if (cmd == "info")
    {
        int                  version;
        stdString            description;
        stdVector<stdString> how_strings, stat_strings;
        stdVector<ArchiveDataClient::SeverityInfo> sevr_infos;
        if (client.getInfo(version, description, how_strings,
                           stat_strings, sevr_infos))
        {
            num = how_strings.size();
            string_vector hows(num);
            for (i=0; i<num; ++i)
                hows[i] = how_strings[i].c_str();
            retval.append(octave_value((double)version));
            retval.append(octave_value(description.c_str()));
            retval.append(octave_value(hows));
        }
        else
            error("'%s' failed\n", cmd.c_str());
    }
    else if (cmd == "archives")
    {
        stdVector<ArchiveDataClient::ArchiveInfo> archives;
        if (client.getArchives(archives))
        {
            num = archives.size();
            ColumnVector  keys(num);
            string_vector names(num);
            string_vector paths(num);
            for (i=0; i<num; ++i)
            {
                keys(i) = (double)archives[i].key;
                names[i] = archives[i].name.c_str();
                paths[i] = archives[i].path.c_str();
            }
            retval.append(octave_value(keys));
            retval.append(octave_value(names));
            retval.append(octave_value(paths));
        }
        else
            error("'%s' failed\n", cmd.c_str());
    }
    else if (cmd == "names")
    {
        if (nargin < 3 || nargin > 4)
        {
            error("Need URL, CMD, KEY [, PATTERN]\n");
            return retval;
        }
        stdString pattern;
        if (nargin == 4)
        {
            if (!args(3).is_string())
            {
                error("PATTERN must be a string");
                return retval;
            }
            pattern = args(3).string_value().c_str();
        }
        stdVector<ArchiveDataClient::NameInfo> name_infos;
        if (client.getNames(key, pattern, name_infos))
        {
            num = name_infos.size();
            string_vector names(num);
            ColumnVector  start(num);
            ColumnVector  end(num);
            for (i=0; i<num; ++i)
            {
                names[i] = name_infos[i].name.c_str();
                double secs, nano;
                epicsTime2DateNum(name_infos[i].start, secs, nano);
                start(i) = secs;
                epicsTime2DateNum(name_infos[i].end, secs, nano);
                end(i) = secs;
            }
            retval.append(octave_value(names));
            retval.append(octave_value(start));
            retval.append(octave_value(end));
        }
        else
            error("'%s' failed\n", cmd.c_str());
    }
    else if (cmd == "values")
    {
        if (nargin < 6)
        {
            error("Need URL, CMD, KEY, NAME, START, END [, COUNT[, HOW]]\n");
            return retval;
        }
        stdVector<stdString> names;
        if (args(3).is_string())
            names.push_back(stdString(args(3).string_value().c_str()));
        else if (args(3).is_cell())
        {
            int rows = args(3).cell_value().rows();
            int cols = args(3).cell_value().cols();
            int j;
            for (i=0; i<rows; ++i)
                for (j=0; j<cols; ++j)
                {
                    const octave_value &v = args(3).cell_value().elem(i, j);
                    names.push_back(stdString(v.string_value().c_str()));
                }
        }
        else
        {
            error("NAME must be string or cell array of strings\n");
            return retval;
        }
        double start_datenum = args(4).double_value();
        double end_datenum = args(5).double_value();
        epicsTime start, end;
        DateNum2epicsTime(start_datenum, start);
        DateNum2epicsTime(end_datenum,   end);
        int count = 100;
        int how = 0;
        if (nargin > 6)
            count = (int)args(6).double_value();
        if (nargin > 7)
            how = (int)args(7).double_value();
        size_t num = names.size();
        size_t data_count = count;
        if (how == HOW_PLOTBIN)
            data_count *= 4;
#ifdef DEBUG
        {
            stdString txt;
            for (i=0; i<num; ++i)
                octave_stdout << "Name: '" << names[i].c_str() << "'\n";
            epicsTime2string(start, txt);
            octave_stdout << "Start: " << txt.c_str() << "\n";
            epicsTime2string(end, txt);
            octave_stdout << "End  : " << txt.c_str() << "\n";
            octave_stdout << "Count: " << count << "\n";
            octave_stdout << "How  : " << how << "\n";
        }
#endif
        ValueInfo val_info(num, data_count);
        if (client.getValues(key, names, start, end, count, how,
                             value_callback, (void *)&val_info))
        {
            for (i=0; i<num; ++i)
            {
                val_info.data[i]->resize(2+val_info.array_sizes[i],
                                         val_info.used_columns[i]);
                retval.append(octave_value(*val_info.data[i]));
            }
        }
        else
            error("'%s' failed\n", cmd.c_str());
    }
    else
        error("Unknown command '%s'\n", cmd.c_str());
    return retval;
}

#else
// -----------------------------------------------------------------------
// Matlab Stuff
// -----------------------------------------------------------------------
#include "mex.h"

// Similar to the ValueInfo used for Octave.
// The octave case is a bit simpler because octave
// allows shrinking/resizing of a matrix.
class ValueInfo
{
public:
    ValueInfo(size_t num_channels, size_t num_samples)
            : num_channels(num_channels),
              num_samples(num_samples)
    {
        data = (mxArray **) mxCalloc(num_channels, sizeof(mxArray *));
        array_sizes = (size_t *)calloc(num_channels, sizeof(size_t));
        used_columns = (size_t *)calloc(num_channels, sizeof(size_t));
    }

    ~ValueInfo()
    {
        free(used_columns);
        free(array_sizes);
        size_t i;
        for (i=0; i<num_channels; ++i)
            if (data[i])
                mxDestroyArray(data[i]);
        mxFree(data);
    }
    
    mxArray *getUsedPortion(size_t n)
    {
        if (used_columns[n] <= 0)
            return 0;
        mxArray *sub = mxCreateDoubleMatrix(2+array_sizes[n],
                                            used_columns[n], mxREAL);
        const double *src = mxGetPr(data[n]);
        double *dst = mxGetPr(sub);
        memcpy(dst, src, sizeof(double)*(2+array_sizes[n])*used_columns[n]);
        return sub;
    }

    mxArray **data;       // One matrix per channel.
    size_t *array_sizes;  // .. per channel. ==1 for scalars.
    size_t *used_columns; // used matrix lines for each channel.
    size_t num_channels, num_samples;
};

static bool value_callback(void *arg,
                           const char *name,
                           size_t n, // channel index
                           size_t i, // value index
                           const CtrlInfo &info,
                           DbrType type, DbrCount count,
                           const RawValue::Data *value)
{
#ifdef DEBUG
    stdString t, v, s;
    RawValue::getTime(value, t);
    RawValue::getValueString(v, type, count, value, &info);
    RawValue::getStatus(value, s);
    mexPrintf("%d : %s %s %s\n", i, t.c_str(), v.c_str(), s.c_str());
#endif
    ValueInfo *vi = (ValueInfo *)arg;
    if (i == 0)
    {   // allocate storage
        vi->data[n] = mxCreateDoubleMatrix(2+count, vi->num_samples, mxREAL);
        vi->array_sizes[n] = count;
    }
    else
    {   // check for changes in size
        mxAssert(mxGetM(vi->data[n]) == 2+count, "Dimensions don't match");
        mxAssert(mxGetN(vi->data[n]) > i, "Too much data");
    }
    double *data = mxGetPr(vi->data[n]);
#define elem(c,r)  data[(c)+(r)*(2+count)]
    epicsTime2DateNum(RawValue::getTime(value), elem(0, i), elem(1, i));
    int ai;
    bool valid = true;
    if (RawValue::isInfo(value))
        valid = false;
    else
        for (ai=0; ai<count; ++ai)
            if (!RawValue::getDouble(type, count, value, elem(2+ai, i), ai))
            {
                valid = false;
                break;
            }
    if (!valid)
        for (ai=0; ai<count; ++ai)
            elem(2+ai, i) = mxGetNaN();
#undef elem
    vi->used_columns[n] = i+1;
    return true;
}

static bool get_string(const mxArray *arg, char **buf, const char *name)
{
    if (!mxIsChar(arg))
    {
        mexErrMsgIdAndTxt("ArchiveData", "%s must be a string", name);
        return false;
    }   
    int buflen = mxGetNumberOfElements(arg) + 1;
    *buf = (char *)mxCalloc(buflen, sizeof(char));
    if (mxGetString(arg, *buf, buflen) != 0)
    {
        mexErrMsgIdAndTxt("ArchiveData", "Could not fetch %s", name);
        return false;
    }
    return true;
}

void mexFunction(int nresult, mxArray *result[],
                 int nargin, const mxArray *args[])
{
    size_t i, num;
    if (nargin < 2)
    {
        mexErrMsgTxt("At least two arguments (URL, cmd) required.");
        return;
    }
    char *url, *cmd;
    int key = 0;
    if (! (get_string(args[0], &url, "URL") &&
           get_string(args[1], &cmd, "CMD")))
        return;
    if (nargin >= 3)
        key = (int)mxGetScalar(args[2]);
#ifdef DEBUG
    mexPrintf("URL='%s'\n", url);
    mexPrintf("CMD='%s'\n", cmd);
    mexPrintf("KEY=%d\n", key);
#endif
    ArchiveDataClient client(url);
    if (!strcmp(cmd, "info"))
    {
        int                  version;
        stdString            description;
        stdVector<stdString> how_strings, stat_strings;
        stdVector<ArchiveDataClient::SeverityInfo> sevr_infos;
        if (client.getInfo(version, description, how_strings,
                           stat_strings, sevr_infos))
        {
            result[0] = mxCreateDoubleScalar((double)version);
            if (nresult > 1)
                result[1] = mxCreateStringFromNChars(description.c_str(),
                                                     description.length());
            if (nresult > 2)
            {
                num = how_strings.size();
                result[2] = mxCreateCellMatrix(num, 1);
                for (i=0; i<num; ++i)
                    mxSetCell(result[2], i,
                              mxCreateStringFromNChars(
                                  how_strings[i].c_str(),
                                  how_strings[i].length()));            
            }
        }
        else
            mexErrMsgIdAndTxt("ArchiveData", "'%s' failed\n", cmd);
    }
    else if (!strcmp(cmd, "archives"))
    {
        stdVector<ArchiveDataClient::ArchiveInfo> archives;
        if (client.getArchives(archives))
        {
            num = archives.size();
            result[0] = mxCreateDoubleMatrix(num, 1, mxREAL);
            double *keys = mxGetPr(result[0]);
            if (nresult > 1)
                result[1] = mxCreateCellMatrix(num, 1);
            if (nresult > 2)
                result[2] = mxCreateCellMatrix(num, 1);
            for (i=0; i<num; ++i)
            {
                keys[i] = (double)archives[i].key;
                if (nresult > 1)
                    mxSetCell(result[1], i,
                              mxCreateStringFromNChars(
                                  archives[i].name.c_str(),
                                  archives[i].name.length()));
                if (nresult > 2)
                    mxSetCell(result[2], i,
                              mxCreateStringFromNChars(
                                  archives[i].path.c_str(),
                                  archives[i].path.length()));
            }
        }
        else
            mexErrMsgIdAndTxt("ArchiveData", "'%s' failed\n", cmd);
    }
    else if (!strcmp(cmd, "names"))
    {
        if (nargin < 3 || nargin > 4)
        {
            mexErrMsgTxt("Need URL, CMD, KEY [, PATTERN]\n");
            return;
        }
        stdString pattern;
        if (nargin >= 4)
        {
            char *patt;
            if (!get_string(args[3], &patt, "PATTERN"))
                return;
            pattern = patt;
        }
        stdVector<ArchiveDataClient::NameInfo> name_infos;
        if (client.getNames(key, pattern, name_infos))
        {
            num = name_infos.size();
            double *start = 0, *end = 0, nano;
            result[0] = mxCreateCellMatrix(num, 1);
            if (nresult > 1)
            {
                result[1] = mxCreateDoubleMatrix(num, 1, mxREAL);
                start = mxGetPr(result[1]);
            }
            if (nresult > 2)
            {
                result[2] = mxCreateDoubleMatrix(num, 1, mxREAL);
                end = mxGetPr(result[2]);
            }
            for (i=0; i<num; ++i)
            {
                mxSetCell(result[0], i,
                          mxCreateStringFromNChars(
                              name_infos[i].name.c_str(),
                              name_infos[i].name.length()));
                if (start)
                    epicsTime2DateNum(name_infos[i].start, start[i], nano);
                if (end)
                    epicsTime2DateNum(name_infos[i].end, end[i], nano);
            }
        }
        else
            mexErrMsgIdAndTxt("ArchiveData", "'%s' failed\n", cmd);
    }
    else if (!strcmp(cmd, "values"))
    {
        if (nargin < 6)
        {
            mexErrMsgTxt("Need URL, CMD, KEY, NAME, START, END "
                         "[,COUNT[,HOW]]\n");
            return;
        }
        stdVector<stdString> names;
        char *name;
        if (mxIsChar(args[3]))
        {
            if (!get_string(args[3], &name, "NAME"))
                return;
            names.push_back(stdString(name));
        }
        else if (mxIsCell(args[3]))
        {
            num = mxGetM(args[3]) * mxGetN(args[3]);
            for (i=0; i<num; ++i)
            {
                mxArray *cell = mxGetCell(args[3], i);
                if (!get_string(cell, &name, "NAME from List"))
                    return;
                names.push_back(stdString(name));                
            }
        }
        double start_datenum = mxGetScalar(args[4]);
        double end_datenum = mxGetScalar(args[5]);
        epicsTime start, end;
        DateNum2epicsTime(start_datenum, start);
        DateNum2epicsTime(end_datenum,   end);
        int count = 100;
        int how = 0;
        if (nargin > 6)
            count = (int)mxGetScalar(args[6]);   
        if (nargin > 7)
            how = (int)mxGetScalar(args[7]);   
        num = names.size();
        size_t data_count = count;
        if (how == HOW_PLOTBIN)
            data_count *= 4;
#ifdef DEBUG
        {
            stdString txt;
            for (i=0; i<num; ++i)
                mexPrintf("Name: '%s'\n", names[i].c_str());
            mexPrintf("Start: %s\n", epicsTimeTxt(start,txt));
            mexPrintf("End  : %s\n", epicsTimeTxt(end,txt));
            mexPrintf("Count: %d\n", count);
            mexPrintf("How  : %d\n", how);
        }
#endif
        ValueInfo val_info(num, data_count);
        if (client.getValues(key, names, start, end, count, how,
                             value_callback, (void *)&val_info))
        {
            for (i=0; i<num; ++i)
            {
                if (nresult > i)
                    result[i] = val_info.getUsedPortion(i);
            }
        }
        else
            mexErrMsgIdAndTxt("ArchiveData", "'%s' failed\n", cmd);
    }
    else
        mexErrMsgIdAndTxt("ArchiveData", "Unknown command '%s'", cmd);
}

#endif

