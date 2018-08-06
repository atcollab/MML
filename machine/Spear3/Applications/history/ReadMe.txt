In order for the history commands to work:
1.  The database toolbox must on the path
2.  The classpath.txt file in the local directory of Matlab
    must have the path to classes111.zip added to it.  For instance,
    R:\Controls\matlab\applications\history\classes111.zip
3.  The user must have access to the VMS oracle database
 

Database names for Spear2 can be found on the web at:
SSRL ->  Computing at SSRL
     ->  Accelerator Controls
     ->  Spear Online database parameters


Jim Sebeck comments:

"I have made a simple implementation of the matlab database toolbox.  There were
some startup problems because, although mathworks advertised that its database
toolbox is odbc compliant, it is really jdbc compliant and the Oracle RDB VMS
database is just odbc compliant.  Clemens implemented an Oracle wrapper that
allows the outside world to communicate with the wrapper via jdbc, while the
wrapper communicates with RDB via a protocol they both understand.  This
complication just requires me to use the explicit jdbc commands, which requires
me to download an oracle java class file and then to modify a matlab file
d:\matlab6p5\toolbox\local\classpath.txt
to tell matlab the location of that file.  Also the matlab visual query builder
cannot be used to obtain data, although it can be used to find the names of the
database fields.

The field names are rather obtuse and I have found no good way to find the value
other than searching through a spear specific tool called either dblook or
dbexam (Jeff and/or Andrei can help you with this feature.)  A very nice
addition would be to have a translation table that converts the spear database
names to english.  If you want to make some widely extensible product for
spear2, you may eventually want to do that.  I don't know how many legacy names
from spear2 will make it into spear3.  If there are a lot, then this job will
need to be done for spear3 as well.  Clemens should be able to answer this last
question.

I am including a file that I actually have used.  This demonstrates one of my
typical applications of the toolbox.  I have placed a number of comments in
there to remind myself of what certain steps do.  I have rerun the .m file this
morning to insure that it still works."

Jim


Greg Portmann comments:

rdb  - Digital then aquired by Oracle
jdbc - Sun/Jave (used by the Matlab toolbox)
odbc - Microsoft

Spear uses an rdb database "format."  Somehow the classes111.zip file provided
by Oracle tells Matlab how to convert from rdb to jdbc (I think). 
how to convert from rdb to jdbc.

The Spear2 database uses the "/" character.  This is a reserve character in the 
Oracle database.  Hence replace the "/" by "$" in all database names.
