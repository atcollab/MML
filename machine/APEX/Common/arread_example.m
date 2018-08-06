cd /tmp/matlabclient

addpath('./jsonlab')
addpath('./urlread2')

% this should be configurable from the outside somehow
serverurl = 'http://localhost:8888' ;

% subscribe to something
pvname = 'test:long1';
mode = struct('mode', 'Monitor', 'delta', 10);
subs_info = struct('pvname', pvname, 'mode', mode);
subs_info_json = strcat('[', savejson('', subs_info), ']') % ugly ugly hack
url = strcat(serverurl,'/subscriptions/')
[output, extras] = urlread2(url, 'POST', subs_info_json)

% unsubscribe
pvname = 'test:long1';
url = strcat(serverurl,'/subscriptions/', pvname)
[output, extras] = urlread2(url, 'DELETE')


%% get values
%pvname = 'test:long1';
%params = {'limit', '5'}
%[queryString, header] = http_paramsToString(params,1)
%url = strcat(serverurl,strcat('/values/', pvname))
%[output, extras] = urlread2([url '?' queryString], 'GET')
%output = loadjson(output)





addpath('./jsonlab')
addpath('./urlread2')
serverurl = 'http://localhost:8888' ;

serverurl = 'http://apex4.als.lbl.gov:8888' ;
pvname = 'Gun:RF:Cav_LCW_Supply_Temp'

pvname =

Gun:RF:Cav_LCW_Supply_Temp

params = {'limit', '2'}

params = 

    'limit'    '2'

[queryString, header] = http_paramsToString(params,1)

queryString =

limit=2


header = 

     name: 'Content-Type'
    value: 'application/x-www-form-urlencoded'

url = strcat(serverurl,strcat('/values/', pvname))

url =

http://apex4.als.lbl.gov:8888/values/Gun:RF:Cav_LCW_Supply_Temp

[output, extras] = urlread2([url '?' queryString], 'GET')

output =

{"status": {"message": "ok", "code": 200, "success": true, "codestr": "OK"}, "response": [{"count": 1, "access": "read/write", "lower_disp_limit": null, "upper_disp_limit": null, "severity": null, "timestamp": 1336414245.324203, "lower_alarm_limit": null, "precision": null, "value": 22.100000381469727, "upper_ctrl_limit": null, "archived_at_ts": 1336414245324444, "host": "apex3.als.lbl.gov:55102", "upper_alarm_limit": null, "status": 1, "lower_warning_limit": null, "upper_warning_limit": null, "archived_at": "2012-05-07 11:10:45.324449", "units": null, "lower_ctrl_limit": null, "type": "double", "pvname": "Gun:RF:Cav_LCW_Supply_Temp"}, {"count": 1, "access": "read/write", "lower_disp_limit": null, "upper_disp_limit": null, "severity": null, "timestamp": 1336414243.316571, "lower_alarm_limit": null, "precision": null, "value": 22.0, "upper_ctrl_limit": null, "archived_at_ts": 1336414243316823, "host": "apex3.als.lbl.gov:55102", "upper_alarm_limit": null, "status": 1, "lower_warning_limit": null, "upper_warning_limit": null, "archived_at": "2012-05-07 11:10:43.316828", "units": null, "lower_ctrl_limit": null, "type": "double", "pvname": "Gun:RF:Cav_LCW_Supply_Temp"}]}


extras = 

      allHeaders: [1x1 struct]
    firstHeaders: [1x1 struct]
          status: [1x1 struct]
             url: 'http://apex4.als.lbl.gov:8888/values/Gun:RF:Cav_LCW_Supply_Temp?limit=2'
          isGood: 1

output = loadjson(output)

output = 

      status: [1x1 struct]
    response: [1x2 struct]

params = {'limit', '2', 'field', 'value'}

params = 

    'limit'    '2'    'field'    'value'

[queryString, header] = http_paramsToString(params,1)

queryString =

limit=2&field=value


header = 

     name: 'Content-Type'
    value: 'application/x-www-form-urlencoded'

[output, extras] = urlread2([url '?' queryString], 'GET')

output =

{"status": {"message": "ok", "code": 200, "success": true, "codestr": "OK"}, "response": [{"value": 22.100000381469727}, {"value": 21.950000762939453}]}


extras = 

      allHeaders: [1x1 struct]
    firstHeaders: [1x1 struct]
          status: [1x1 struct]
             url: 'http://apex4.als.lbl.gov:8888/values/Gun:RF:Cav_LCW_Supply_Temp?limit=2&field=value'
          isGood: 1

output = loadjson(output)

output = 

      status: [1x1 struct]
    response: [1x2 struct]

params = {'limit', '2', 'field', 'value', 'field', 'timestamp'}

params = 

    'limit'    '2'    'field'    'value'    'field'    'timestamp'

[queryString, header] = http_paramsToString(params,1)

queryString =

limit=2&field=value&field=timestamp


header = 

     name: 'Content-Type'
    value: 'application/x-www-form-urlencoded'

[output, extras] = urlread2([url '?' queryString], 'GET')

output =

{"status": {"message": "ok", "code": 200, "success": true, "codestr": "OK"}, "response": [{"timestamp": 1336414571.036159, "value": 22.100000381469727}, {"timestamp": 1336414569.024683, "value": 22.0}]}


extras = 

      allHeaders: [1x1 struct]
    firstHeaders: [1x1 struct]
          status: [1x1 struct]
             url: 'http://apex4.als.lbl.gov:8888/values/Gun:RF:Cav_LCW_Supply_Temp?limit=2&field=value&field=timestamp'
          isGood: 1

output = loadjson(output)

output = 

      status: [1x1 struct]
    response: [1x2 struct]


