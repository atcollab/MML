#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define yyclearin (yychar=(-1))
#define yyerrok (yyerrflag=0)
#define YYRECOVERING (yyerrflag!=0)
static int yyparse(void);
#define YYPREFIX "yy"
/*-
 * Copyright (c) 1990 The Regents of the University of California.
 * All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Vern Paxson.
 * 
 * The United States Government has rights in this work pursuant
 * to contract no. DE-AC03-76SF00098 between the United States
 * Department of Energy and the University of California.
 *
 * Redistribution and use in source and binary forms are permitted provided
 * that: (1) source distributions retain this entire copyright notice and
 * comment, and (2) distributions including binaries display the following
 * acknowledgement:  ``This product includes software developed by the
 * University of California, Berkeley and its contributors'' in the
 * documentation or other materials provided with the distribution and in
 * all advertising materials mentioning features or use of this software.
 * Neither the name of the University nor the names of its contributors may
 * be used to endorse or promote products derived from this software without
 * specific prior written permission.
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
 */

#include "flexdef.h"

int pat, scnum, eps, headcnt, trailcnt, anyccl, lastchar, i, actvp, rulelen;
int trlcontxt, xcluflg, cclsorted, varlength, variable_trail_rule;
Char clower();

static int madeany = false;  /* whether we've made the '.' character class */
int previous_continued_action;	/* whether the previous rule's action was '|' */

#define CHAR 257
#define NUMBER 258
#define SECTEND 259
#define SCDECL 260
#define XSCDECL 261
#define WHITESPACE 262
#define NAME 263
#define PREVCCL 264
#define EOF_OP 265
#define YYERRCODE 256
static short yylhs[] = {                                        -1,
    0,    1,    2,    2,    2,    3,    6,    6,    7,    7,
    7,    4,    4,    5,    8,    8,    8,    8,    8,    8,
    8,    9,   11,   11,   11,   10,   10,   10,   10,   13,
   13,   12,   14,   14,   15,   15,   15,   15,   15,   15,
   15,   15,   15,   15,   15,   15,   16,   16,   18,   18,
   18,   17,   17,
};
static short yylen[] = {                                         2,
    5,    0,    5,    0,    2,    1,    1,    1,    3,    1,
    1,    4,    0,    0,    3,    2,    2,    1,    2,    1,
    1,    3,    3,    1,    1,    2,    3,    2,    1,    3,
    1,    2,    2,    1,    2,    2,    2,    6,    5,    4,
    1,    1,    1,    3,    3,    1,    3,    4,    4,    2,
    0,    2,    0,
};
static short yydefred[] = {                                      2,
    0,    0,    0,    0,    5,    6,    7,    8,   13,    0,
   14,    0,    0,   11,   10,    0,   21,   46,   43,   20,
    0,    0,   41,   53,    0,    0,    0,    0,   18,    0,
    0,    0,    0,   42,    0,    3,   17,   25,   24,    0,
    0,    0,   51,    0,   12,   19,    0,   16,    0,   28,
    0,   32,    0,   35,   36,   37,    0,    9,   22,    0,
   52,   44,   45,    0,    0,   47,   15,   27,    0,    0,
   23,   48,    0,    0,   40,   49,    0,   39,   38,
};
static short yydgoto[] = {                                       1,
    2,    4,    9,   11,   13,   10,   16,   27,   28,   29,
   40,   30,   31,   32,   33,   34,   41,   44,
};
static short yysindex[] = {                                      0,
    0, -231,   28, -186,    0,    0,    0,    0,    0, -221,
    0, -212,  -32,    0,    0,   -9,    0,    0,    0,    0,
  -28, -203,    0,    0,  -28,  -39,   47,  -30,    0,  -28,
  -15,  -28,    4,    0, -205,    0,    0,    0,    0,    8,
  -29,  -19,    0,  -86,    0,    0,  -28,    0,  -16,    0,
  -28,    0,    4,    0,    0,    0, -193,    0,    0, -194,
    0,    0,    0,  -84,   34,    0,    0,    0,  -28,  -21,
    0,    0, -177, -110,    0,    0,  -43,    0,    0,
};
static short yyrindex[] = {                                      0,
    0, -183,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   83,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  -82,    0,    0,    0,    0,
   75,    7,  -10,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   76,    0,
    0,    0,   -7,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,  -80,    0,    0,    0,    9,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,
};
static short yygindex[] = {                                      0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   21,
    0,    0,   41,   36,    3,    0,    0,   45,
};
#define YYTABLESIZE 257
static short yytable[] = {                                      34,
   36,   24,   33,   24,   62,   24,   66,   25,   72,   25,
   51,   25,   50,   23,   78,   23,   31,   23,   30,   68,
   50,   63,   74,   34,    3,   34,   33,   22,   33,   34,
   34,   52,   33,   33,   53,   34,   34,    5,   33,   33,
   12,   37,   31,   14,   30,   54,   55,   31,   48,   30,
   15,   60,   38,   31,   43,   30,   45,   58,   26,   39,
   26,   21,   26,   47,   70,   42,   56,   67,   71,   59,
   49,   53,    6,    7,    8,    4,    4,    4,   73,   76,
   34,   79,    1,   33,   29,   26,   69,   64,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   75,   51,    0,    0,   51,   51,    0,
    0,    0,    0,   34,    0,    0,   33,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   57,    0,    0,    0,
   31,    0,   30,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   77,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
   65,    0,   65,    0,   51,    0,   50,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,   17,   18,    0,   18,   61,   18,    0,
    0,   19,   20,   19,   46,   19,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,   34,    0,    0,   33,
    0,    0,   35,   34,    0,    0,   33,
};
static short yycheck[] = {                                      10,
   10,   34,   10,   34,   34,   34,   93,   40,   93,   40,
   93,   40,   93,   46,  125,   46,   10,   46,   10,   36,
   36,   41,   44,   34,  256,   36,   34,   60,   36,   40,
   41,   47,   40,   41,   32,   46,   47,   10,   46,   47,
  262,   21,   36,  256,   36,   42,   43,   41,   28,   41,
  263,   44,  256,   47,   94,   47,   10,  263,   91,  263,
   91,   94,   91,   94,  258,   25,   63,   47,  263,   62,
   30,   69,  259,  260,  261,  259,  260,  261,   45,  257,
   91,  125,    0,   91,   10,   10,   51,   43,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  125,  124,   -1,   -1,  124,  124,   -1,
   -1,   -1,   -1,  124,   -1,   -1,  124,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  123,   -1,   -1,   -1,
  124,   -1,  124,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  258,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  257,   -1,  257,   -1,  257,   -1,  257,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,  256,  257,   -1,  257,  257,  257,   -1,
   -1,  264,  265,  264,  265,  264,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  257,   -1,   -1,  257,
   -1,   -1,  262,  264,   -1,   -1,  264,
};
#define YYFINAL 1
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 265
#if YYDEBUG
static char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,"'\\n'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,"'\"'",0,"'$'",0,0,0,"'('","')'","'*'","'+'","','","'-'","'.'","'/'",0,0,
0,0,0,0,0,0,0,0,0,0,"'<'",0,"'>'","'?'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,"'['",0,"']'","'^'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,"'{'","'|'","'}'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"CHAR","NUMBER","SECTEND",
"SCDECL","XSCDECL","WHITESPACE","NAME","PREVCCL","EOF_OP",
};
static char *yyrule[] = {
"$accept : goal",
"goal : initlex sect1 sect1end sect2 initforrule",
"initlex :",
"sect1 : sect1 startconddecl WHITESPACE namelist1 '\\n'",
"sect1 :",
"sect1 : error '\\n'",
"sect1end : SECTEND",
"startconddecl : SCDECL",
"startconddecl : XSCDECL",
"namelist1 : namelist1 WHITESPACE NAME",
"namelist1 : NAME",
"namelist1 : error",
"sect2 : sect2 initforrule flexrule '\\n'",
"sect2 :",
"initforrule :",
"flexrule : scon '^' rule",
"flexrule : scon rule",
"flexrule : '^' rule",
"flexrule : rule",
"flexrule : scon EOF_OP",
"flexrule : EOF_OP",
"flexrule : error",
"scon : '<' namelist2 '>'",
"namelist2 : namelist2 ',' NAME",
"namelist2 : NAME",
"namelist2 : error",
"rule : re2 re",
"rule : re2 re '$'",
"rule : re '$'",
"rule : re",
"re : re '|' series",
"re : series",
"re2 : re '/'",
"series : series singleton",
"series : singleton",
"singleton : singleton '*'",
"singleton : singleton '+'",
"singleton : singleton '?'",
"singleton : singleton '{' NUMBER ',' NUMBER '}'",
"singleton : singleton '{' NUMBER ',' '}'",
"singleton : singleton '{' NUMBER '}'",
"singleton : '.'",
"singleton : fullccl",
"singleton : PREVCCL",
"singleton : '\"' string '\"'",
"singleton : '(' re ')'",
"singleton : CHAR",
"fullccl : '[' ccl ']'",
"fullccl : '[' '^' ccl ']'",
"ccl : ccl CHAR '-' CHAR",
"ccl : ccl CHAR",
"ccl :",
"string : string CHAR",
"string :",
};
#endif
#ifndef YYSTYPE
typedef int YYSTYPE;
#endif
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 500
#define YYMAXDEPTH 500
#endif
#endif
#if YYDEBUG
static int yydebug;
#endif
static int yynerrs;
static int yyerrflag;
static int yychar;
static short *yyssp;
static YYSTYPE *yyvsp;
static YYSTYPE yyval;
static YYSTYPE yylval;
static short yyss[YYSTACKSIZE];
static YYSTYPE yyvs[YYSTACKSIZE];
#define yystacksize YYSTACKSIZE


/* build_eof_action - build the "<<EOF>>" action for the active start
 *                    conditions
 */

void build_eof_action()

    {
    int i;

    for ( i = 1; i <= actvp; ++i )
	{
	if ( sceof[actvsc[i]] )
	    format_pinpoint_message(
		"multiple <<EOF>> rules for start condition %s",
		    scname[actvsc[i]] );

	else
	    {
	    sceof[actvsc[i]] = true;
	    fprintf( temp_action_file, "case YY_STATE_EOF(%s):\n",
		     scname[actvsc[i]] );
	    }
	}

    line_directive_out( temp_action_file );
    }


/* synerr - report a syntax error */

void synerr( str )
char str[];

    {
    syntaxerror = true;
    pinpoint_message( str );
    }


/* format_pinpoint_message - write out a message formatted with one string,
 *			     pinpointing its location
 */

void format_pinpoint_message( msg, arg )
char msg[], arg[];

    {
    char errmsg[MAXLINE];

    (void) sprintf( errmsg, msg, arg );
    pinpoint_message( errmsg );
    }


/* pinpoint_message - write out a message, pinpointing its location */

void pinpoint_message( str )
char str[];

    {
    fprintf( stderr, "\"%s\", line %d: %s\n", infilename, linenum, str );
    }


/* yyerror - eat up an error message from the parser;
 *	     currently, messages are ignore
 */

void yyerror( msg )
char msg[];

    {
    }

#include "scan.c"
#include "yylex.c"
#include "flex.c"

#define YYABORT goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR goto yyerrlab
static int
yyparse(void)
{
    int yym, yyn, yystate;
#if YYDEBUG
    char *yys;
    extern char *getenv();

    if ((yys = getenv("YYDEBUG")))
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = (-1);

    yyssp = yyss;
    yyvsp = yyvs;
    *yyssp = yystate = 0;

yyloop:
    if ((yyn = yydefred[yystate])) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yyssp >= yyss + yystacksize - 1)
        {
            goto yyoverflow;
        }
        *++yyssp = yystate = yytable[yyn];
        *++yyvsp = yylval;
        yychar = (-1);
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;
    yyerror("syntax error");
    ++yynerrs;
yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yyssp, yytable[yyn]);
#endif
                if (yyssp >= yyss + yystacksize - 1)
                {
                    goto yyoverflow;
                }
                *++yyssp = yystate = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yyssp);
#endif
                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = (-1);
        goto yyloop;
    }
yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    yyval = yyvsp[1-yym];
    switch (yyn)
    {
case 1:
{ /* add default rule */
			int def_rule;

			pat = cclinit();
			cclnegate( pat );

			def_rule = mkstate( -pat );

			finish_rule( def_rule, false, 0, 0 );

			for ( i = 1; i <= lastsc; ++i )
			    scset[i] = mkbranch( scset[i], def_rule );

			if ( spprdflt )
			    fputs( "YY_FATAL_ERROR( \"flex scanner jammed\" )",
				   temp_action_file );
			else
			    fputs( "ECHO", temp_action_file );

			fputs( ";\n\tYY_BREAK\n", temp_action_file );
			}
break;
case 2:
{
			/* initialize for processing rules */

			/* create default DFA start condition */
			scinstal( "INITIAL", false );
			}
break;
case 5:
{ synerr( "unknown error processing section 1" ); }
break;
case 7:
{
			/* these productions are separate from the s1object
			 * rule because the semantics must be done before
			 * we parse the remainder of an s1object
			 */

			xcluflg = false;
			}
break;
case 8:
{ xcluflg = true; }
break;
case 9:
{ scinstal( nmstr, xcluflg ); }
break;
case 10:
{ scinstal( nmstr, xcluflg ); }
break;
case 11:
{ synerr( "bad start condition list" ); }
break;
case 14:
{
			/* initialize for a parse of one rule */
			trlcontxt = variable_trail_rule = varlength = false;
			trailcnt = headcnt = rulelen = 0;
			current_state_type = STATE_NORMAL;
			previous_continued_action = continued_action;
			new_rule();
			}
break;
case 15:
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			for ( i = 1; i <= actvp; ++i )
			    scbol[actvsc[i]] =
				mkbranch( scbol[actvsc[i]], pat );

			if ( ! bol_needed )
			    {
			    bol_needed = true;

			    if ( performance_report )
				pinpoint_message( 
			    "'^' operator results in sub-optimal performance" );
			    }
			}
break;
case 16:
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			for ( i = 1; i <= actvp; ++i )
			    scset[actvsc[i]] =
				mkbranch( scset[actvsc[i]], pat );
			}
break;
case 17:
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			/* add to all non-exclusive start conditions,
			 * including the default (0) start condition
			 */

			for ( i = 1; i <= lastsc; ++i )
			    if ( ! scxclu[i] )
				scbol[i] = mkbranch( scbol[i], pat );

			if ( ! bol_needed )
			    {
			    bol_needed = true;

			    if ( performance_report )
				pinpoint_message(
			    "'^' operator results in sub-optimal performance" );
			    }
			}
break;
case 18:
{
			pat = yyvsp[0];
			finish_rule( pat, variable_trail_rule,
				     headcnt, trailcnt );

			for ( i = 1; i <= lastsc; ++i )
			    if ( ! scxclu[i] )
				scset[i] = mkbranch( scset[i], pat );
			}
break;
case 19:
{ build_eof_action(); }
break;
case 20:
{
			/* this EOF applies to all start conditions
			 * which don't already have EOF actions
			 */
			actvp = 0;

			for ( i = 1; i <= lastsc; ++i )
			    if ( ! sceof[i] )
				actvsc[++actvp] = i;

			if ( actvp == 0 )
			    pinpoint_message(
		"warning - all start conditions already have <<EOF>> rules" );

			else
			    build_eof_action();
			}
break;
case 21:
{ synerr( "unrecognized rule" ); }
break;
case 23:
{
			if ( (scnum = sclookup( nmstr )) == 0 )
			    format_pinpoint_message(
				"undeclared start condition %s", nmstr );

			else
			    actvsc[++actvp] = scnum;
			}
break;
case 24:
{
			if ( (scnum = sclookup( nmstr )) == 0 )
			    format_pinpoint_message(
				"undeclared start condition %s", nmstr );
			else
			    actvsc[actvp = 1] = scnum;
			}
break;
case 25:
{ synerr( "bad start condition list" ); }
break;
case 26:
{
			if ( transchar[lastst[yyvsp[0]]] != SYM_EPSILON )
			    /* provide final transition \now/ so it
			     * will be marked as a trailing context
			     * state
			     */
			    yyvsp[0] = link_machines( yyvsp[0], mkstate( SYM_EPSILON ) );

			mark_beginning_as_normal( yyvsp[0] );
			current_state_type = STATE_NORMAL;

			if ( previous_continued_action )
			    {
			    /* we need to treat this as variable trailing
			     * context so that the backup does not happen
			     * in the action but before the action switch
			     * statement.  If the backup happens in the
			     * action, then the rules "falling into" this
			     * one's action will *also* do the backup,
			     * erroneously.
			     */
			    if ( ! varlength || headcnt != 0 )
				{
				fprintf( stderr,
    "%s: warning - trailing context rule at line %d made variable because\n",
					 program_name, linenum );
				fprintf( stderr,
					 "      of preceding '|' action\n" );
				}

			    /* mark as variable */
			    varlength = true;
			    headcnt = 0;
			    }

			if ( varlength && headcnt == 0 )
			    { /* variable trailing context rule */
			    /* mark the first part of the rule as the accepting
			     * "head" part of a trailing context rule
			     */
			    /* by the way, we didn't do this at the beginning
			     * of this production because back then
			     * current_state_type was set up for a trail
			     * rule, and add_accept() can create a new
			     * state ...
			     */
			    add_accept( yyvsp[-1], num_rules | YY_TRAILING_HEAD_MASK );
			    variable_trail_rule = true;
			    }
			
			else
			    trailcnt = rulelen;

			yyval = link_machines( yyvsp[-1], yyvsp[0] );
			}
break;
case 27:
{ synerr( "trailing context used twice" ); }
break;
case 28:
{
			if ( trlcontxt )
			    {
			    synerr( "trailing context used twice" );
			    yyval = mkstate( SYM_EPSILON );
			    }

			else if ( previous_continued_action )
			    {
			    /* see the comment in the rule for "re2 re"
			     * above
			     */
			    if ( ! varlength || headcnt != 0 )
				{
				fprintf( stderr,
    "%s: warning - trailing context rule at line %d made variable because\n",
					 program_name, linenum );
				fprintf( stderr,
					 "      of preceding '|' action\n" );
				}

			    /* mark as variable */
			    varlength = true;
			    headcnt = 0;
			    }

			trlcontxt = true;

			if ( ! varlength )
			    headcnt = rulelen;

			++rulelen;
			trailcnt = 1;

			eps = mkstate( SYM_EPSILON );
			yyval = link_machines( yyvsp[-1],
				 link_machines( eps, mkstate( '\n' ) ) );
			}
break;
case 29:
{
		        yyval = yyvsp[0];

			if ( trlcontxt )
			    {
			    if ( varlength && headcnt == 0 )
				/* both head and trail are variable-length */
				variable_trail_rule = true;
			    else
				trailcnt = rulelen;
			    }
		        }
break;
case 30:
{
			varlength = true;
			yyval = mkor( yyvsp[-2], yyvsp[0] );
			}
break;
case 31:
{ yyval = yyvsp[0]; }
break;
case 32:
{
			/* this rule is written separately so
			 * the reduction will occur before the trailing
			 * series is parsed
			 */

			if ( trlcontxt )
			    synerr( "trailing context used twice" );
			else
			    trlcontxt = true;

			if ( varlength )
			    /* we hope the trailing context is fixed-length */
			    varlength = false;
			else
			    headcnt = rulelen;

			rulelen = 0;

			current_state_type = STATE_TRAILING_CONTEXT;
			yyval = yyvsp[-1];
			}
break;
case 33:
{
			/* this is where concatenation of adjacent patterns
			 * gets done
			 */
			yyval = link_machines( yyvsp[-1], yyvsp[0] );
			}
break;
case 34:
{ yyval = yyvsp[0]; }
break;
case 35:
{
			varlength = true;

			yyval = mkclos( yyvsp[-1] );
			}
break;
case 36:
{
			varlength = true;

			yyval = mkposcl( yyvsp[-1] );
			}
break;
case 37:
{
			varlength = true;

			yyval = mkopt( yyvsp[-1] );
			}
break;
case 38:
{
			varlength = true;

			if ( yyvsp[-3] > yyvsp[-1] || yyvsp[-3] < 0 )
			    {
			    synerr( "bad iteration values" );
			    yyval = yyvsp[-5];
			    }
			else
			    {
			    if ( yyvsp[-3] == 0 )
				yyval = mkopt( mkrep( yyvsp[-5], yyvsp[-3], yyvsp[-1] ) );
			    else
				yyval = mkrep( yyvsp[-5], yyvsp[-3], yyvsp[-1] );
			    }
			}
break;
case 39:
{
			varlength = true;

			if ( yyvsp[-2] <= 0 )
			    {
			    synerr( "iteration value must be positive" );
			    yyval = yyvsp[-4];
			    }

			else
			    yyval = mkrep( yyvsp[-4], yyvsp[-2], INFINITY );
			}
break;
case 40:
{
			/* the singleton could be something like "(foo)",
			 * in which case we have no idea what its length
			 * is, so we punt here.
			 */
			varlength = true;

			if ( yyvsp[-1] <= 0 )
			    {
			    synerr( "iteration value must be positive" );
			    yyval = yyvsp[-3];
			    }

			else
			    yyval = link_machines( yyvsp[-3], copysingl( yyvsp[-3], yyvsp[-1] - 1 ) );
			}
break;
case 41:
{
			if ( ! madeany )
			    {
			    /* create the '.' character class */
			    anyccl = cclinit();
			    ccladd( anyccl, '\n' );
			    cclnegate( anyccl );

			    if ( useecs )
				mkeccl( ccltbl + cclmap[anyccl],
					ccllen[anyccl], nextecm,
					ecgroup, csize, csize );

			    madeany = true;
			    }

			++rulelen;

			yyval = mkstate( -anyccl );
			}
break;
case 42:
{
			if ( ! cclsorted )
			    /* sort characters for fast searching.  We use a
			     * shell sort since this list could be large.
			     */
			    cshell( ccltbl + cclmap[yyvsp[0]], ccllen[yyvsp[0]], true );

			if ( useecs )
			    mkeccl( ccltbl + cclmap[yyvsp[0]], ccllen[yyvsp[0]],
				    nextecm, ecgroup, csize, csize );

			++rulelen;

			yyval = mkstate( -yyvsp[0] );
			}
break;
case 43:
{
			++rulelen;

			yyval = mkstate( -yyvsp[0] );
			}
break;
case 44:
{ yyval = yyvsp[-1]; }
break;
case 45:
{ yyval = yyvsp[-1]; }
break;
case 46:
{
			++rulelen;

			if ( caseins && yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
			    yyvsp[0] = clower( yyvsp[0] );

			yyval = mkstate( yyvsp[0] );
			}
break;
case 47:
{ yyval = yyvsp[-1]; }
break;
case 48:
{
			/* *Sigh* - to be compatible Unix lex, negated ccls
			 * match newlines
			 */
#ifdef NOTDEF
			ccladd( yyvsp[-1], '\n' ); /* negated ccls don't match '\n' */
			cclsorted = false; /* because we added the newline */
#endif
			cclnegate( yyvsp[-1] );
			yyval = yyvsp[-1];
			}
break;
case 49:
{
			if ( yyvsp[-2] > yyvsp[0] )
			    synerr( "negative range in character class" );

			else
			    {
			    if ( caseins )
				{
				if ( yyvsp[-2] >= 'A' && yyvsp[-2] <= 'Z' )
				    yyvsp[-2] = clower( yyvsp[-2] );
				if ( yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
				    yyvsp[0] = clower( yyvsp[0] );
				}

			    for ( i = yyvsp[-2]; i <= yyvsp[0]; ++i )
			        ccladd( yyvsp[-3], i );

			    /* keep track if this ccl is staying in alphabetical
			     * order
			     */
			    cclsorted = cclsorted && (yyvsp[-2] > lastchar);
			    lastchar = yyvsp[0];
			    }

			yyval = yyvsp[-3];
			}
break;
case 50:
{
			if ( caseins )
			    if ( yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
				yyvsp[0] = clower( yyvsp[0] );

			ccladd( yyvsp[-1], yyvsp[0] );
			cclsorted = cclsorted && (yyvsp[0] > lastchar);
			lastchar = yyvsp[0];
			yyval = yyvsp[-1];
			}
break;
case 51:
{
			cclsorted = true;
			lastchar = 0;
			yyval = cclinit();
			}
break;
case 52:
{
			if ( caseins )
			    if ( yyvsp[0] >= 'A' && yyvsp[0] <= 'Z' )
				yyvsp[0] = clower( yyvsp[0] );

			++rulelen;

			yyval = link_machines( yyvsp[-1], mkstate( yyvsp[0] ) );
			}
break;
case 53:
{ yyval = mkstate( SYM_EPSILON ); }
break;
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yyssp = YYFINAL;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
            if (yydebug)
            {
                yys = 0;
                if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
                if (!yys) yys = "illegal-symbol";
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yyssp, yystate);
#endif
    if (yyssp >= yyss + yystacksize - 1)
    {
        goto yyoverflow;
    }
    *++yyssp = yystate;
    *++yyvsp = yyval;
    goto yyloop;
yyoverflow:
    yyerror("yacc stack overflow");
yyabort:
    return (1);
yyaccept:
    return (0);
}
