#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define yyclearin (yychar=(-1))
#define yyerrok (yyerrflag=0)
#define YYRECOVERING (yyerrflag!=0)
static int yyparse(void);
#define YYPREFIX "yy"
#line 10 "../../../src/ioc/dbStatic/dbYacc.y"
static int yyerror();
static int yy_start;
static long pvt_yy_parse(void);
static int yyFailed = 0;
static int yyAbort = 0;
#include "dbLexRoutines.c"
#line 27 "../../../src/ioc/dbStatic/dbYacc.y"
typedef union
{
    char	*Str;
} YYSTYPE;
#line 22 "dbYacc.tab.c"
#define tokenINCLUDE 257
#define tokenPATH 258
#define tokenADDPATH 259
#define tokenALIAS 260
#define tokenMENU 261
#define tokenCHOICE 262
#define tokenRECORDTYPE 263
#define tokenFIELD 264
#define tokenINFO 265
#define tokenREGISTRAR 266
#define tokenDEVICE 267
#define tokenDRIVER 268
#define tokenBREAKTABLE 269
#define tokenRECORD 270
#define tokenGRECORD 271
#define tokenVARIABLE 272
#define tokenFUNCTION 273
#define tokenSTRING 274
#define tokenCDEFS 275
#define YYERRCODE 256
static short yylhs[] = {                                        -1,
    0,    0,    1,    1,    2,    2,    2,    2,    2,    2,
    2,    2,    2,    2,    2,    2,    2,    2,    3,    4,
    5,    6,    7,   21,   21,   22,   22,    8,    9,    9,
   23,   23,   24,   24,   24,   25,   26,   27,   27,   28,
   28,   10,   11,   12,   13,   14,   14,   15,   16,   29,
   29,   29,   30,   19,   17,   18,   18,   18,   31,   31,
   32,   32,   32,   32,   20,
};
static short yylen[] = {                                         2,
    0,    1,    2,    1,    1,    1,    1,    3,    3,    1,
    1,    1,    1,    1,    3,    3,    3,    1,    2,    2,
    2,    3,    3,    2,    1,    6,    1,    3,    2,    3,
    2,    1,    3,    1,    1,    5,    3,    2,    1,    4,
    4,   10,    4,    4,    4,    4,    6,    3,    3,    3,
    2,    1,    1,    5,    5,    0,    2,    3,    2,    1,
    6,    6,    4,    1,    6,
};
static short yydefred[] = {                                      0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    4,    5,    6,    7,
   10,   11,   12,   13,   14,   18,   19,   20,   21,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    3,    0,    0,    0,    8,
    0,    0,    9,    0,    0,    0,    0,    0,   15,    0,
    0,   16,    0,   17,    0,    0,    0,   22,    0,   27,
    0,   25,   28,    0,   34,   29,   35,    0,   32,   44,
    0,   43,   48,   53,    0,   52,    0,    0,    0,    0,
   57,   64,    0,   60,    0,   46,    0,   45,    0,    0,
   23,   24,    0,    0,   30,   31,    0,   49,    0,   51,
    0,    0,    0,    0,   58,   59,    0,    0,   65,    0,
    0,    0,   33,    0,   50,   55,    0,    0,    0,   54,
   47,    0,    0,    0,    0,    0,   39,    0,   63,    0,
    0,    0,    0,    0,    0,   37,   38,    0,    0,    0,
   26,   36,    0,    0,    0,   61,   62,   41,   40,   42,
};
static short yydgoto[] = {                                      15,
   16,   17,   18,   19,   20,   32,   50,   34,   53,   21,
   22,   23,   24,   25,   39,   59,   41,   62,   43,   26,
   71,   72,   78,   79,  104,  123,  136,  137,   85,   86,
   93,   94,
};
static short yysindex[] = {                                   -215,
 -262, -255, -254,  -19,  -18,  -17,  -16,  -15,  -14,  -13,
  -11,  -10,   -9,   -7,    0, -215,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0, -240,
 -238,  -86, -236,  -84, -234, -233, -227, -225,  -64, -214,
  -62, -212,  -62, -211, -210,    0,   21,   25, -246,    0,
   26, -123,    0,   27,   28,   29,   30, -205,    0,   31,
 -120,    0,   32,    0,  -31,   33, -201,    0,   37,    0,
 -111,    0,    0,   38,    0,    0,    0, -122,    0,    0,
 -195,    0,    0,    0,  -44,    0, -194,   42,   43,   44,
    0,    0, -110,    0, -189,    0, -188,    0,   46, -186,
    0,    0, -185,  -33,    0,    0,   47,    0, -205,    0,
   51, -181, -180, -179,    0,    0,   55,   56,    0,   54,
   57, -257,    0, -175,    0,    0,   59,   58,   60,    0,
    0, -171, -169,   66,   67, -118,    0,   64,    0, -165,
 -164,   70,   71, -161, -160,    0,    0, -159,   75,   76,
    0,    0,   77,   78,   79,    0,    0,    0,    0,    0,
};
static short yyrindex[] = {                                    121,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,  122,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    1,    0,    1,    0,    0,    0,    0,    0,    0,    0,
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
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
};
static short yygindex[] = {                                      0,
    0,  107,  -43,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   81,    0,    0,
    0,   61,    0,   48,    0,    0,    0,   -8,    0,  -77,
    0,   34,
};
#define YYTABLESIZE 274
static short yytable[] = {                                     109,
   56,   76,  105,  134,   91,   70,  146,  110,   77,   96,
    1,   27,   97,  101,  115,   69,  135,   92,   28,   29,
   30,   31,   33,   35,   36,   37,   38,   70,   40,   42,
   44,  125,   45,   47,   77,   48,   49,   51,   52,   54,
   55,    1,    2,    3,    4,    5,   56,    6,   57,   92,
    7,    8,    9,   10,   11,   12,   13,   14,   58,   60,
   61,   63,   65,   66,   67,   68,   73,   80,   84,   82,
   83,   81,   99,   98,   87,   95,  100,  103,  107,  111,
  108,  112,  113,  114,  117,  118,  119,  120,  121,  122,
  124,  126,  127,  128,  129,  130,  131,  132,  138,  139,
  133,  140,  142,  141,  143,  144,  145,  148,  149,  150,
  151,  152,  153,  154,  155,  156,  157,  158,  159,  160,
    1,    2,   46,   64,    0,  106,  116,  147,    0,    0,
    0,  102,    0,    1,    1,    0,    1,    0,    0,   88,
   74,   74,  134,   89,   90,    1,    1,    0,    0,   88,
   69,   75,   75,   89,   90,  135,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,   84,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,   56,   56,   56,
   56,   56,    0,   56,    0,    0,   56,   56,   56,   56,
   56,   56,   56,   56,
};
static short yycheck[] = {                                      44,
    0,  125,  125,  261,  125,   49,  125,   85,   52,   41,
  257,  274,   44,  125,  125,  262,  274,   61,  274,  274,
   40,   40,   40,   40,   40,   40,   40,   71,   40,   40,
   40,  109,   40,  274,   78,  274,  123,  274,  123,  274,
  274,  257,  258,  259,  260,  261,  274,  263,  274,   93,
  266,  267,  268,  269,  270,  271,  272,  273,  123,  274,
  123,  274,  274,  274,   44,   41,   41,   41,  274,   41,
   41,   44,  274,   41,   44,   44,   40,   40,  274,  274,
  125,   40,   40,   40,  274,  274,   41,  274,  274,  123,
   44,   41,  274,  274,  274,   41,   41,   44,  274,   41,
   44,   44,  274,   44,  274,   40,   40,   44,  274,  274,
   41,   41,  274,  274,  274,   41,   41,   41,   41,   41,
    0,    0,   16,   43,   -1,   78,   93,  136,   -1,   -1,
   -1,   71,   -1,  257,  257,   -1,  257,   -1,   -1,  260,
  264,  264,  261,  264,  265,  257,  257,   -1,   -1,  260,
  262,  275,  275,  264,  265,  274,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  274,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,  257,  258,  259,
  260,  261,   -1,  263,   -1,   -1,  266,  267,  268,  269,
  270,  271,  272,  273,
};
#define YYFINAL 15
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 275
#if YYDEBUG
static char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,"'('","')'",0,0,"','",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"'{'",0,"'}'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
"tokenINCLUDE","tokenPATH","tokenADDPATH","tokenALIAS","tokenMENU",
"tokenCHOICE","tokenRECORDTYPE","tokenFIELD","tokenINFO","tokenREGISTRAR",
"tokenDEVICE","tokenDRIVER","tokenBREAKTABLE","tokenRECORD","tokenGRECORD",
"tokenVARIABLE","tokenFUNCTION","tokenSTRING","tokenCDEFS",
};
static char *yyrule[] = {
"$accept : database",
"database :",
"database : database_item_list",
"database_item_list : database_item_list database_item",
"database_item_list : database_item",
"database_item : include",
"database_item : path",
"database_item : addpath",
"database_item : tokenMENU menu_head menu_body",
"database_item : tokenRECORDTYPE recordtype_head recordtype_body",
"database_item : device",
"database_item : driver",
"database_item : registrar",
"database_item : function",
"database_item : variable",
"database_item : tokenBREAKTABLE break_head break_body",
"database_item : tokenRECORD record_head record_body",
"database_item : tokenGRECORD grecord_head record_body",
"database_item : alias",
"include : tokenINCLUDE tokenSTRING",
"path : tokenPATH tokenSTRING",
"addpath : tokenADDPATH tokenSTRING",
"menu_head : '(' tokenSTRING ')'",
"menu_body : '{' choice_list '}'",
"choice_list : choice_list choice",
"choice_list : choice",
"choice : tokenCHOICE '(' tokenSTRING ',' tokenSTRING ')'",
"choice : include",
"recordtype_head : '(' tokenSTRING ')'",
"recordtype_body : '{' '}'",
"recordtype_body : '{' recordtype_field_list '}'",
"recordtype_field_list : recordtype_field_list recordtype_field",
"recordtype_field_list : recordtype_field",
"recordtype_field : tokenFIELD recordtype_field_head recordtype_field_body",
"recordtype_field : tokenCDEFS",
"recordtype_field : include",
"recordtype_field_head : '(' tokenSTRING ',' tokenSTRING ')'",
"recordtype_field_body : '{' recordtype_field_item_list '}'",
"recordtype_field_item_list : recordtype_field_item_list recordtype_field_item",
"recordtype_field_item_list : recordtype_field_item",
"recordtype_field_item : tokenSTRING '(' tokenSTRING ')'",
"recordtype_field_item : tokenMENU '(' tokenSTRING ')'",
"device : tokenDEVICE '(' tokenSTRING ',' tokenSTRING ',' tokenSTRING ',' tokenSTRING ')'",
"driver : tokenDRIVER '(' tokenSTRING ')'",
"registrar : tokenREGISTRAR '(' tokenSTRING ')'",
"function : tokenFUNCTION '(' tokenSTRING ')'",
"variable : tokenVARIABLE '(' tokenSTRING ')'",
"variable : tokenVARIABLE '(' tokenSTRING ',' tokenSTRING ')'",
"break_head : '(' tokenSTRING ')'",
"break_body : '{' break_list '}'",
"break_list : break_list ',' break_item",
"break_list : break_list break_item",
"break_list : break_item",
"break_item : tokenSTRING",
"grecord_head : '(' tokenSTRING ',' tokenSTRING ')'",
"record_head : '(' tokenSTRING ',' tokenSTRING ')'",
"record_body :",
"record_body : '{' '}'",
"record_body : '{' record_field_list '}'",
"record_field_list : record_field_list record_field",
"record_field_list : record_field",
"record_field : tokenFIELD '(' tokenSTRING ',' tokenSTRING ')'",
"record_field : tokenINFO '(' tokenSTRING ',' tokenSTRING ')'",
"record_field : tokenALIAS '(' tokenSTRING ')'",
"record_field : include",
"alias : tokenALIAS '(' tokenSTRING ',' tokenSTRING ')'",
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
#line 267 "../../../src/ioc/dbStatic/dbYacc.y"
 
#include "dbLex.c"


static int yyerror(char *str)
{
    if (str)
        epicsPrintf("Error: %s\n", str);
    else
        epicsPrintf("Error");
    if (!yyFailed) {    /* Only print this stuff once */
        epicsPrintf(" at or before \"%s\"", yytext);
        dbIncludePrint();
        yyFailed = TRUE;
    }
    return(0);
}
static long pvt_yy_parse(void)
{
    static int	FirstFlag = 1;
    long	rtnval;
 
    if (!FirstFlag) {
	yyAbort = FALSE;
	yyFailed = FALSE;
	yyreset();
	yyrestart(NULL);
    }
    FirstFlag = 0;
    rtnval = yyparse();
    if(rtnval!=0 || yyFailed) return(-1); else return(0);
}
#line 333 "dbYacc.tab.c"
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
case 19:
#line 59 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("include : %s\n",yyvsp[0].Str);
	dbIncludeNew(yyvsp[0].Str); dbmfFree(yyvsp[0].Str);
}
break;
case 20:
#line 65 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("path : %s\n",yyvsp[0].Str);
	dbPathCmd(yyvsp[0].Str); dbmfFree(yyvsp[0].Str);
}
break;
case 21:
#line 71 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("addpath : %s\n",yyvsp[0].Str);
	dbAddPathCmd(yyvsp[0].Str); dbmfFree(yyvsp[0].Str);
}
break;
case 22:
#line 77 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("menu_head %s\n",yyvsp[-1].Str);
	dbMenuHead(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 23:
#line 83 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("menu_body\n");
	dbMenuBody();
}
break;
case 26:
#line 91 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("choice %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbMenuChoice(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 28:
#line 98 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("recordtype_head %s\n",yyvsp[-1].Str);
	dbRecordtypeHead(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 29:
#line 104 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("empty recordtype_body\n");
	dbRecordtypeEmpty();
}
break;
case 30:
#line 109 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("recordtype_body\n");
	dbRecordtypeBody();
}
break;
case 34:
#line 119 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("recordtype_cdef %s", yyvsp[0].Str);
	dbRecordtypeCdef(yyvsp[0].Str);
}
break;
case 36:
#line 126 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("recordtype_field_head %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbRecordtypeFieldHead(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 40:
#line 137 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("recordtype_field_item %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbRecordtypeFieldItem(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 41:
#line 142 "../../../src/ioc/dbStatic/dbYacc.y"
{

	if(dbStaticDebug>2) printf("recordtype_field_item %s (%s)\n","menu",yyvsp[-1].Str);
	dbRecordtypeFieldItem("menu",yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 42:
#line 151 "../../../src/ioc/dbStatic/dbYacc.y"
{ 
	if(dbStaticDebug>2) printf("device %s %s %s %s\n",yyvsp[-7].Str,yyvsp[-5].Str,yyvsp[-3].Str,yyvsp[-1].Str);
	dbDevice(yyvsp[-7].Str,yyvsp[-5].Str,yyvsp[-3].Str,yyvsp[-1].Str);
	dbmfFree(yyvsp[-7].Str); dbmfFree(yyvsp[-5].Str);
	dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 43:
#line 160 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("driver %s\n",yyvsp[-1].Str);
	dbDriver(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 44:
#line 166 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("registrar %s\n",yyvsp[-1].Str);
	dbRegistrar(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 45:
#line 172 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("function %s\n",yyvsp[-1].Str);
	dbFunction(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 46:
#line 178 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("variable %s\n",yyvsp[-1].Str);
	dbVariable(yyvsp[-1].Str,"int"); dbmfFree(yyvsp[-1].Str);
}
break;
case 47:
#line 183 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("variable %s, %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbVariable(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 48:
#line 189 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("break_head %s\n",yyvsp[-1].Str);
	dbBreakHead(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 49:
#line 195 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("break_body\n");
	dbBreakBody();
}
break;
case 53:
#line 205 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("break_item tokenSTRING %s\n",yyvsp[0].Str);
	dbBreakItem(yyvsp[0].Str); dbmfFree(yyvsp[0].Str);
}
break;
case 54:
#line 212 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("grecord_head %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbRecordHead(yyvsp[-3].Str,yyvsp[-1].Str,1); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 55:
#line 218 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("record_head %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbRecordHead(yyvsp[-3].Str,yyvsp[-1].Str,0); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 56:
#line 224 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("null record_body\n");
	dbRecordBody();
}
break;
case 57:
#line 229 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("empty record_body\n");
	dbRecordBody();
}
break;
case 58:
#line 234 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("record_body\n");
	dbRecordBody();
}
break;
case 61:
#line 243 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("record_field %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbRecordField(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 62:
#line 248 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("record_info %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbRecordInfo(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 63:
#line 253 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("record_alias %s\n",yyvsp[-1].Str);
	dbRecordAlias(yyvsp[-1].Str); dbmfFree(yyvsp[-1].Str);
}
break;
case 65:
#line 260 "../../../src/ioc/dbStatic/dbYacc.y"
{
	if(dbStaticDebug>2) printf("alias %s %s\n",yyvsp[-3].Str,yyvsp[-1].Str);
	dbAlias(yyvsp[-3].Str,yyvsp[-1].Str); dbmfFree(yyvsp[-3].Str); dbmfFree(yyvsp[-1].Str);
}
break;
#line 686 "dbYacc.tab.c"
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
