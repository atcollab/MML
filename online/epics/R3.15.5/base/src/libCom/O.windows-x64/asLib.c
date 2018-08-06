#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define yyclearin (yychar=(-1))
#define yyerrok (yyerrflag=0)
#define YYRECOVERING (yyerrflag!=0)
static int yyparse(void);
#define YYPREFIX "yy"
#line 11 "../../../src/libCom/as/asLib.y"
static int yyerror(char *);
static int yy_start;
#include "asLibRoutines.c"
static int yyFailed = FALSE;
static int line_num=1;
static UAG *yyUag=NULL;
static HAG *yyHag=NULL;
static ASG *yyAsg=NULL;
static ASGRULE *yyAsgRule=NULL;
#line 29 "../../../src/libCom/as/asLib.y"
typedef union
{
    int	Int;
    char Char;
    char *Str;
    double Real;
} YYSTYPE;
#line 28 "asLib.tab.c"
#define tokenUAG 257
#define tokenHAG 258
#define tokenASG 259
#define tokenRULE 260
#define tokenCALC 261
#define tokenINP 262
#define tokenINTEGER 263
#define tokenSTRING 264
#define YYERRCODE 256
static short yylhs[] = {                                        -1,
    0,    0,    1,    1,    1,    1,    1,    1,    2,    3,
    8,    8,    9,    4,    5,   10,   10,   11,    6,    7,
   12,   12,   13,   13,   14,   15,   15,   16,   18,   19,
   19,   20,   17,   21,   21,   22,   22,   22,   23,   23,
   25,   24,   24,   26,
};
static short yylen[] = {                                         2,
    2,    1,    3,    2,    3,    2,    3,    2,    3,    3,
    3,    1,    1,    3,    3,    3,    1,    1,    3,    3,
    2,    1,    1,    1,    4,    3,    2,    2,    4,    1,
    1,    3,    3,    2,    1,    4,    4,    4,    3,    1,
    1,    3,    1,    1,
};
static short yydefred[] = {                                      0,
    0,    0,    0,    0,    2,    0,    0,    0,    0,    0,
    0,    1,    0,    0,    3,    0,    0,    5,    0,    0,
    7,    9,   13,    0,   12,   14,   18,    0,   17,   19,
    0,    0,    0,   22,   23,   24,   10,    0,   15,    0,
    0,    0,    0,    0,   20,   21,   11,   16,    0,    0,
   26,   30,    0,   28,   31,    0,    0,    0,    0,    0,
    0,   35,    0,   25,   29,    0,    0,    0,   33,   34,
   32,   41,    0,   40,   44,    0,   43,    0,   36,    0,
   37,    0,   38,   39,   42,
};
static short yydgoto[] = {                                       4,
    5,    7,   15,    9,   18,   11,   21,   24,   25,   28,
   29,   33,   34,   35,   36,   42,   51,   43,   54,   55,
   61,   62,   73,   76,   74,   77,
};
static short yysindex[] = {                                   -236,
  -22,  -21,  -16, -236,    0, -239,  -97, -237,  -95, -235,
  -93,    0,  -10, -232,    0,   -8, -230,    0,   -6, -254,
    0,    0,    0,  -42,    0,    0,    0,  -39,    0,    0,
   -4,   -3, -125,    0,    0,    0,    0, -232,    0, -230,
 -225,  -84,  -29, -224,    0,    0,    0,    0,   -2, -247,
    0,    0, -223,    0,    0,    2, -220,    5,    6,    8,
 -116,    0,    9,    0,    0, -217, -215, -213,    0,    0,
    0,    0,  -28,    0,    0,  -24,    0,   11,    0, -217,
    0, -215,    0,    0,    0,
};
static short yyrindex[] = {                                      0,
    0,    0,    0,    0,    0,    0,    1,    0,    4,    0,
    7,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0, -122,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,
};
static short yygindex[] = {                                      0,
   49,    0,    0,    0,    0,    0,    0,    0,   16,    0,
   15,    0,   23,    0,    0,    0,    0,    0,    0,    0,
    0,   -1,    0,    0,  -23,  -20,
};
#define YYTABLESIZE 266
static short yytable[] = {                                      45,
    4,   38,   27,    6,   40,   31,    8,   32,   69,   58,
   59,   52,   79,   60,   53,   80,   81,    6,    8,   82,
    1,    2,    3,   10,   13,   14,   16,   17,   19,   20,
   22,   23,   26,   27,   30,   41,   44,   49,   50,   56,
   63,   57,   64,   65,   66,   67,   72,   68,   75,   71,
   78,   83,   12,   47,   48,   46,   84,    0,    0,   70,
    0,   85,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,   37,    0,    0,   39,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,   31,    0,   32,   27,    0,   27,
   58,   59,    0,    0,   60,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    4,    4,    4,
    6,    6,    6,    8,    8,    8,
};
static short yycheck[] = {                                     125,
    0,   44,  125,    0,   44,  260,    0,  262,  125,  257,
  258,   41,   41,  261,   44,   44,   41,   40,   40,   44,
  257,  258,  259,   40,  264,  123,  264,  123,  264,  123,
   41,  264,   41,  264,   41,   40,   40,  263,  123,  264,
  264,   44,   41,  264,   40,   40,  264,   40,  264,   41,
  264,   41,    4,   38,   40,   33,   80,   -1,   -1,   61,
   -1,   82,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  125,   -1,   -1,  125,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,  260,   -1,  262,  260,   -1,  262,
  257,  258,   -1,   -1,  261,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,  259,
  257,  258,  259,  257,  258,  259,
};
#define YYFINAL 4
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 264
#if YYDEBUG
static char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,"'('","')'",0,0,"','",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"'{'",0,"'}'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"tokenUAG",
"tokenHAG","tokenASG","tokenRULE","tokenCALC","tokenINP","tokenINTEGER",
"tokenSTRING",
};
static char *yyrule[] = {
"$accept : asconfig",
"asconfig : asconfig asconfig_item",
"asconfig : asconfig_item",
"asconfig_item : tokenUAG uag_head uag_body",
"asconfig_item : tokenUAG uag_head",
"asconfig_item : tokenHAG hag_head hag_body",
"asconfig_item : tokenHAG hag_head",
"asconfig_item : tokenASG asg_head asg_body",
"asconfig_item : tokenASG asg_head",
"uag_head : '(' tokenSTRING ')'",
"uag_body : '{' uag_user_list '}'",
"uag_user_list : uag_user_list ',' uag_user_list_name",
"uag_user_list : uag_user_list_name",
"uag_user_list_name : tokenSTRING",
"hag_head : '(' tokenSTRING ')'",
"hag_body : '{' hag_host_list '}'",
"hag_host_list : hag_host_list ',' hag_host_list_name",
"hag_host_list : hag_host_list_name",
"hag_host_list_name : tokenSTRING",
"asg_head : '(' tokenSTRING ')'",
"asg_body : '{' asg_body_list '}'",
"asg_body_list : asg_body_list asg_body_item",
"asg_body_list : asg_body_item",
"asg_body_item : inp_config",
"asg_body_item : rule_config",
"inp_config : tokenINP '(' tokenSTRING ')'",
"rule_config : tokenRULE rule_head rule_body",
"rule_config : tokenRULE rule_head",
"rule_head : rule_head_manditory rule_head_options",
"rule_head_manditory : '(' tokenINTEGER ',' tokenSTRING",
"rule_head_options : ')'",
"rule_head_options : rule_log_options",
"rule_log_options : ',' tokenSTRING ')'",
"rule_body : '{' rule_list '}'",
"rule_list : rule_list rule_list_item",
"rule_list : rule_list_item",
"rule_list_item : tokenUAG '(' rule_uag_list ')'",
"rule_list_item : tokenHAG '(' rule_hag_list ')'",
"rule_list_item : tokenCALC '(' tokenSTRING ')'",
"rule_uag_list : rule_uag_list ',' rule_uag_list_name",
"rule_uag_list : rule_uag_list_name",
"rule_uag_list_name : tokenSTRING",
"rule_hag_list : rule_hag_list ',' rule_hag_list_name",
"rule_hag_list : rule_hag_list_name",
"rule_hag_list_name : tokenSTRING",
};
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
#line 206 "../../../src/libCom/as/asLib.y"
 
#include "asLib_lex.c"
 
static int yyerror(char *str)
{
    if (strlen(str)) epicsPrintf("%s\n", str);
    epicsPrintf("Access Security file error at line %d\n",
	line_num);
    yyFailed = TRUE;
    return(0);
}
static int myParse(ASINPUTFUNCPTR inputfunction)
{
    static int	FirstFlag = 1;
    int		rtnval;
 
    my_yyinput = &inputfunction;
    if (!FirstFlag) {
	line_num=1;
	yyFailed = FALSE;
	yyreset();
	yyrestart(NULL);
    }
    FirstFlag = 0;
    rtnval = yyparse();
    if(rtnval!=0 || yyFailed) return(-1); else return(0);
}
#line 271 "asLib.tab.c"
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
case 9:
#line 51 "../../../src/libCom/as/asLib.y"
{
		yyUag = asUagAdd(yyvsp[-1].Str);
		if(!yyUag) yyerror("");
		free((void *)yyvsp[-1].Str);
	}
break;
case 10:
#line 59 "../../../src/libCom/as/asLib.y"
{
		 ;
	}
break;
case 13:
#line 69 "../../../src/libCom/as/asLib.y"
{
		if (asUagAddUser(yyUag,yyvsp[0].Str))
			yyerror("");
		free((void *)yyvsp[0].Str);
	}
break;
case 14:
#line 77 "../../../src/libCom/as/asLib.y"
{
		yyHag = asHagAdd(yyvsp[-1].Str);
		if(!yyHag) yyerror("");
		free((void *)yyvsp[-1].Str);
	}
break;
case 18:
#line 92 "../../../src/libCom/as/asLib.y"
{
		if (asHagAddHost(yyHag,yyvsp[0].Str))
			yyerror("");
		free((void *)yyvsp[0].Str);
	}
break;
case 19:
#line 100 "../../../src/libCom/as/asLib.y"
{
		yyAsg = asAsgAdd(yyvsp[-1].Str);
		if(!yyAsg) yyerror("");
		free((void *)yyvsp[-1].Str);
	}
break;
case 20:
#line 108 "../../../src/libCom/as/asLib.y"
{
	}
break;
case 25:
#line 118 "../../../src/libCom/as/asLib.y"
{
		if (asAsgAddInp(yyAsg,yyvsp[-1].Str,yyvsp[-3].Int))
			yyerror("");
		free((void *)yyvsp[-1].Str);
	}
break;
case 29:
#line 131 "../../../src/libCom/as/asLib.y"
{
		asAccessRights	rights;

		if((strcmp(yyvsp[0].Str,"NONE")==0)) {
			rights=asNOACCESS;
		} else if((strcmp(yyvsp[0].Str,"READ")==0)) {
			rights=asREAD;
		} else if((strcmp(yyvsp[0].Str,"WRITE")==0)) {
			rights=asWRITE;
		} else {
			yyerror("Access rights must be NONE, READ or WRITE");
			rights = asNOACCESS;
		}
		yyAsgRule = asAsgAddRule(yyAsg,rights,yyvsp[-2].Int);
		free((void *)yyvsp[0].Str);
	}
break;
case 32:
#line 153 "../../../src/libCom/as/asLib.y"
{
                if((strcmp(yyvsp[-1].Str,"TRAPWRITE")==0)) {
                        long status;
                        status = asAsgAddRuleOptions(yyAsgRule,AS_TRAP_WRITE);
                        if(status) yyerror("");
                } else if((strcmp(yyvsp[-1].Str,"NOTRAPWRITE")!=0)) {
                        yyerror("Log options must be TRAPWRITE or NOTRAPWRITE");
                }
                free((void *)yyvsp[-1].Str);
        }
break;
case 38:
#line 175 "../../../src/libCom/as/asLib.y"
{
		if (asAsgRuleCalc(yyAsgRule,yyvsp[-1].Str))
			yyerror("");
		free((void *)yyvsp[-1].Str);
	}
break;
case 41:
#line 187 "../../../src/libCom/as/asLib.y"
{
		if (asAsgRuleUagAdd(yyAsgRule,yyvsp[0].Str))
			yyerror("");
		free((void *)yyvsp[0].Str);
	}
break;
case 44:
#line 199 "../../../src/libCom/as/asLib.y"
{
		if (asAsgRuleHagAdd(yyAsgRule,yyvsp[0].Str))
			yyerror("");
		free((void *)yyvsp[0].Str);
	}
break;
#line 519 "asLib.tab.c"
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
