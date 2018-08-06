% 1. Email
%    To send email inside Matlab first set the preference for whos
%    is send the email and server, then use sendmail:
%    >> setpref('Internet','E_mail','gjportmann@lbl.gov');
%    >> % Old: setpref('Internet','SMTP_Server','smtp.lbl.gov');
%    >> setpref('Internet','SMTP_Server','csg.lbl.gov');
%    >> sendmail('gjportmann@lbl.gov','subject test', 'body test');
%
% 2. Text to an ATT phone
%    setpref('Internet','E_mail','5108120447@txt.att.net');  % ALS operator
%    setpref('Internet','SMTP_Server','csg.lbl.gov')
%    sendmail('5108120447@txt.att.net','ALERT','Beam is off!!!');
