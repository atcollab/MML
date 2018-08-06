% 1. Email
%    To send email inside Matlab first set the preference for whos
%    is send the email and server, then use sendmail:
%    setpref('Internet','E_mail','apexoper@lbl.gov');
%    setpref('Internet','SMTP_Server','csg.lbl.gov');   % Old: setpref('Internet','SMTP_Server','smtp.lbl.gov');
%    sendmail('gjportmann@lbl.gov','apex: subject test', {'body test','Line 2'});

% EmailBody = {
%     'It might be nice to send an email from Matlab as apexoper on an error conditon.  This is a test.'
%     ' '
%     'Let gportmann@lbl.gov know if you got it.'
%     'see HowToSendEmail.m as an example.'
%     };
% setpref('Internet','E_mail','apexoper@lbl.gov');
% setpref('Internet','SMTP_Server','csg.lbl.gov');
% %sendmail('gjportmann@lbl.gov','apex: subject test', {'body test','Line 2'});
% sendmail('fsannibale@lbl.gov','APEX: email test', EmailBody);

% 2. Text to an ATT phone
%    setpref('Internet','E_mail','5108120447@txt.att.net');  % ALS operator
%    setpref('Internet','E_mail','5103750114@txt.att.net');  % Fernando 
%    setpref('Internet','SMTP_Server','csg.lbl.gov')
%    sendmail('5103750114@txt.att.net','APEX','Have a nice weekend!');

% 3. Text to a Verizon phone
% setpref('Internet','E_mail','4155770282@vtext.com');  % Greg Portmann cell (note: he pays 25cents/txt)
% setpref('Internet','SMTP_Server','csg.lbl.gov')
% sendmail('4155770282@vtext.com','APEX calling','What''s Up?');

% 4. Text to a T-mobile phone
%    Same idea, just uses @tmomail.net