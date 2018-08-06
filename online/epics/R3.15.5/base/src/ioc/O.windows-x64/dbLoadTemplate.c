#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define yyclearin (yychar=(-1))
#define yyerrok (yyerrflag=0)
#define YYRECOVERING (yyerrflag!=0)
static int yyparse(void);
#define YYPREFIX "yy"
#line 2 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"

/*************************************************************************\
* Copyright (c) 2006 UChicago, as Operator of Argonne
*     National Laboratory.
* EPICS BASE is distributed subject to a Software License Agreement found
* in file LICENSE that is included with this distribution. 
\*************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <stddef.h>
#include <string.h>

#include "osiUnistd.h"
#include "macLib.h"
#include "dbmf.h"

#include "epicsExport.h"
#include "dbAccess.h"
#include "dbLoadTemplate.h"

static int line_num;
static int yyerror(char* str);

static char *sub_collect = NULL;
static char *sub_locals;
static char **vars = NULL;
static char *db_file_name = NULL;
static int var_count, sub_count;

/* We allocate MAX_VAR_FACTOR chars in the sub_collect string for each
 * "variable=value," segment, and will accept at most dbTemplateMaxVars
 * template variables.  The user can adjust that variable to increase
 * the number of variables or the length allocated for the buffer.
 */
#define MAX_VAR_FACTOR 50

int dbTemplateMaxVars = 100;
epicsExportAddress(int, dbTemplateMaxVars);

#line 54 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
typedef union
{
    int Int;
    char Char;
    char *Str;
    double Real;
} YYSTYPE;
#line 59 "dbLoadTemplate.tab.c"
#define WORD 257
#define QUOTE 258
#define DBFILE 259
#define PATTERN 260
#define GLOBAL 261
#define EQUALS 262
#define COMMA 263
#define O_PAREN 264
#define C_PAREN 265
#define O_BRACE 266
#define C_BRACE 267
#define YYERRCODE 256
static short yylhs[] = {                                        -1,
    0,    0,    1,    1,    2,    2,    3,    3,    5,    5,
    6,    6,    7,    7,    7,    7,   10,   10,   10,   11,
    9,    9,   12,   12,   12,   12,   13,   13,   13,   14,
   14,    8,    8,   15,   15,   15,   15,    4,    4,    4,
   16,   16,
};
static short yylen[] = {                                         2,
    1,    2,    1,    1,    3,    4,    3,    4,    2,    2,
    1,    1,    3,    4,    4,    5,    1,    2,    2,    1,
    1,    2,    1,    2,    3,    4,    1,    2,    2,    1,
    1,    1,    2,    1,    2,    3,    4,    1,    2,    2,
    3,    3,
};
static short yydefred[] = {                                      0,
    0,    0,    0,    1,    3,    4,    0,    9,   10,    0,
    2,    0,    0,    5,    0,   38,    0,    0,    0,    7,
   34,    0,   11,    0,   32,    0,   39,    6,   40,    0,
    0,   35,    0,    8,   33,   41,   42,    0,   20,    0,
    0,   17,   36,   37,    0,    0,   23,    0,   21,   18,
    0,   19,    0,   31,   30,   24,    0,   27,   22,    0,
    0,   28,   25,   29,   26,
};
static short yydgoto[] = {                                       3,
    4,   47,    6,   15,    7,   22,   23,   24,   48,   41,
   42,   49,   57,   58,   25,   16,
};
static short yysindex[] = {                                   -253,
 -196, -255, -253,    0,    0,    0, -242,    0,    0, -245,
    0, -240, -230,    0, -227,    0, -231, -216, -211,    0,
    0, -200,    0, -208,    0, -194,    0,    0,    0, -198,
 -210,    0, -226,    0,    0,    0,    0, -224,    0, -206,
 -215,    0,    0,    0, -197, -213,    0, -206,    0,    0,
 -206,    0, -192,    0,    0,    0, -248,    0,    0, -206,
 -229,    0,    0,    0,    0,
};
static short yyrindex[] = {                                      0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0, -199,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0, -195,
    0,    0,    0,    0,    0,    0,    0, -193,    0,    0,
 -191,    0,    0,    0,    0,    0,    0,    0,    0, -190,
    0,    0,    0,    0,    0,
};
static short yygindex[] = {                                      0,
   67,    1,    0,  -14,    0,    0,    0,    0,   20,    0,
   32,  -46,   22,  -54,   54,  -15,
};
#define YYTABLESIZE 78
static short yytable[] = {                                      29,
    5,   59,   64,    5,   33,    1,   64,    2,   54,   55,
   10,   13,   21,   59,   62,   38,   17,   29,   63,   18,
    2,   14,   29,   12,   21,   19,   20,   54,   55,   13,
   13,   26,   13,   62,   30,   27,   27,   65,   27,   28,
   43,   39,   44,   54,   55,   13,   39,   50,   17,   31,
   45,   51,    2,   56,    2,   32,   40,   19,   13,   46,
    8,    9,   36,   37,   54,   55,   34,   12,   53,   11,
   60,   13,   52,   14,   61,   15,   16,   35,
};
static short yycheck[] = {                                      15,
    0,   48,   57,    3,   19,  259,   61,  261,  257,  258,
  266,  257,   12,   60,  263,   30,  257,   33,  267,  260,
  261,  267,   38,  266,   24,  266,  267,  257,  258,  257,
  257,  262,  257,  263,  266,  263,  263,  267,  263,  267,
  267,  257,  267,  257,  258,  257,  257,  263,  257,  266,
  257,  267,  261,  267,  261,  267,  267,  266,  257,  266,
  257,  258,  257,  258,  257,  258,  267,  267,  266,    3,
   51,  267,   41,  267,   53,  267,  267,   24,
};
#define YYFINAL 3
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 267
#if YYDEBUG
static char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"WORD","QUOTE","DBFILE","PATTERN",
"GLOBAL","EQUALS","COMMA","O_PAREN","C_PAREN","O_BRACE","C_BRACE",
};
static char *yyrule[] = {
"$accept : substitution_file",
"substitution_file : global_or_template",
"substitution_file : substitution_file global_or_template",
"global_or_template : global_definitions",
"global_or_template : template_substitutions",
"global_definitions : GLOBAL O_BRACE C_BRACE",
"global_definitions : GLOBAL O_BRACE variable_definitions C_BRACE",
"template_substitutions : template_filename O_BRACE C_BRACE",
"template_substitutions : template_filename O_BRACE substitutions C_BRACE",
"template_filename : DBFILE WORD",
"template_filename : DBFILE QUOTE",
"substitutions : pattern_substitutions",
"substitutions : variable_substitutions",
"pattern_substitutions : PATTERN O_BRACE C_BRACE",
"pattern_substitutions : PATTERN O_BRACE C_BRACE pattern_definitions",
"pattern_substitutions : PATTERN O_BRACE pattern_names C_BRACE",
"pattern_substitutions : PATTERN O_BRACE pattern_names C_BRACE pattern_definitions",
"pattern_names : pattern_name",
"pattern_names : pattern_names COMMA",
"pattern_names : pattern_names pattern_name",
"pattern_name : WORD",
"pattern_definitions : pattern_definition",
"pattern_definitions : pattern_definitions pattern_definition",
"pattern_definition : global_definitions",
"pattern_definition : O_BRACE C_BRACE",
"pattern_definition : O_BRACE pattern_values C_BRACE",
"pattern_definition : WORD O_BRACE pattern_values C_BRACE",
"pattern_values : pattern_value",
"pattern_values : pattern_values COMMA",
"pattern_values : pattern_values pattern_value",
"pattern_value : QUOTE",
"pattern_value : WORD",
"variable_substitutions : variable_substitution",
"variable_substitutions : variable_substitutions variable_substitution",
"variable_substitution : global_definitions",
"variable_substitution : O_BRACE C_BRACE",
"variable_substitution : O_BRACE variable_definitions C_BRACE",
"variable_substitution : WORD O_BRACE variable_definitions C_BRACE",
"variable_definitions : variable_definition",
"variable_definitions : variable_definitions COMMA",
"variable_definitions : variable_definitions variable_definition",
"variable_definition : WORD EQUALS WORD",
"variable_definition : WORD EQUALS QUOTE",
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
#line 310 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
 
#include "dbLoadTemplate_lex.c"
 
static int yyerror(char* str)
{
    if (str)
        fprintf(stderr, "Substitution file error: %s\n", str);
    else
        fprintf(stderr, "Substitution file error.\n");
    fprintf(stderr, "line %d: '%s'\n", line_num, yytext);
    return 0;
}

static int is_not_inited = 1;

int dbLoadTemplate(const char *sub_file, const char *cmd_collect)
{
    FILE *fp;
    int i;

    line_num = 1;

    if (!sub_file || !*sub_file) {
        fprintf(stderr, "must specify variable substitution file\n");
        return -1;
    }

    if (dbTemplateMaxVars < 1)
    {
        fprintf(stderr,"Error: dbTemplateMaxVars = %d, must be +ve\n",
                dbTemplateMaxVars);
        return -1;
    }

    fp = fopen(sub_file, "r");
    if (!fp) {
        fprintf(stderr, "dbLoadTemplate: error opening sub file %s\n", sub_file);
        return -1;
    }

    vars = malloc(dbTemplateMaxVars * sizeof(char*));
    sub_collect = malloc(dbTemplateMaxVars * MAX_VAR_FACTOR);
    if (!vars || !sub_collect) {
        free(vars);
        free(sub_collect);
        fclose(fp);
        fprintf(stderr, "dbLoadTemplate: Out of memory!\n");
        return -1;
    }
    strcpy(sub_collect, ",");

    if (cmd_collect && *cmd_collect) {
        strcat(sub_collect, cmd_collect);
        sub_locals = sub_collect + strlen(sub_collect);
    } else {
        sub_locals = sub_collect;
        *sub_locals = '\0';
    }
    var_count = 0;
    sub_count = 0;

    if (is_not_inited) {
        yyin = fp;
        is_not_inited = 0;
    } else {
        yyrestart(fp);
    }

    yyparse();

    for (i = 0; i < var_count; i++) {
        dbmfFree(vars[i]);
    }
    free(vars);
    free(sub_collect);
    vars = NULL;
    fclose(fp);
    if (db_file_name) {
        dbmfFree(db_file_name);
        db_file_name = NULL;
    }
    return 0;
}
#line 312 "dbLoadTemplate.tab.c"
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
case 6:
#line 74 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "global_definitions: %s\n", sub_collect+1);
    #endif
        sub_locals += strlen(sub_locals);
    }
break;
case 7:
#line 83 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "template_substitutions: %s unused\n", db_file_name);
    #endif
        dbmfFree(db_file_name);
        db_file_name = NULL;
    }
break;
case 8:
#line 91 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "template_substitutions: %s finished\n", db_file_name);
    #endif
        dbmfFree(db_file_name);
        db_file_name = NULL;
    }
break;
case 9:
#line 101 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "template_filename: %s\n", yyvsp[0].Str);
    #endif
        var_count = 0;
        db_file_name = dbmfMalloc(strlen(yyvsp[0].Str)+1);
        strcpy(db_file_name, yyvsp[0].Str);
        dbmfFree(yyvsp[0].Str);
    }
break;
case 10:
#line 111 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "template_filename: \"%s\"\n", yyvsp[0].Str);
    #endif
        var_count = 0;
        db_file_name = dbmfMalloc(strlen(yyvsp[0].Str)+1);
        strcpy(db_file_name, yyvsp[0].Str);
        dbmfFree(yyvsp[0].Str);
    }
break;
case 20:
#line 138 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "pattern_name: [%d] = %s\n", var_count, yyvsp[0].Str);
    #endif
        if (var_count >= dbTemplateMaxVars) {
            fprintf(stderr,
                "More than dbTemplateMaxVars = %d macro variables used\n",
                dbTemplateMaxVars);
            yyerror(NULL);
        }
        else {
            vars[var_count] = dbmfMalloc(strlen(yyvsp[0].Str)+1);
            strcpy(vars[var_count], yyvsp[0].Str);
            var_count++;
            dbmfFree(yyvsp[0].Str);
        }
    }
break;
case 24:
#line 163 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "pattern_definition: pattern_values empty\n");
        fprintf(stderr, "    dbLoadRecords(%s)\n", sub_collect+1);
    #endif
        dbLoadRecords(db_file_name, sub_collect+1);
    }
break;
case 25:
#line 171 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "pattern_definition:\n");
        fprintf(stderr, "    dbLoadRecords(%s)\n", sub_collect+1);
    #endif
        dbLoadRecords(db_file_name, sub_collect+1);
        *sub_locals = '\0';
        sub_count = 0;
    }
break;
case 26:
#line 181 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{   /* DEPRECATED SYNTAX */
        fprintf(stderr,
            "dbLoadTemplate: Substitution file uses deprecated syntax.\n"
            "    the string '%s' on line %d that comes just before the\n"
            "    '{' character is extraneous and should be removed.\n",
            yyvsp[-3].Str, line_num);
    #ifdef ERROR_STUFF
        fprintf(stderr, "pattern_definition:\n");
        fprintf(stderr, "    dbLoadRecords(%s)\n", sub_collect+1);
    #endif
        dbLoadRecords(db_file_name, sub_collect+1);
        dbmfFree(yyvsp[-3].Str);
        *sub_locals = '\0';
        sub_count = 0;
    }
break;
case 30:
#line 204 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "pattern_value: [%d] = \"%s\"\n", sub_count, yyvsp[0].Str);
    #endif
        if (sub_count < var_count) {
            strcat(sub_locals, ",");
            strcat(sub_locals, vars[sub_count]);
            strcat(sub_locals, "=\"");
            strcat(sub_locals, yyvsp[0].Str);
            strcat(sub_locals, "\"");
            sub_count++;
        } else {
            fprintf(stderr, "dbLoadTemplate: Too many values given, line %d.\n",
                line_num);
        }
        dbmfFree(yyvsp[0].Str);
    }
break;
case 31:
#line 222 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "pattern_value: [%d] = %s\n", sub_count, yyvsp[0].Str);
    #endif
        if (sub_count < var_count) {
            strcat(sub_locals, ",");
            strcat(sub_locals, vars[sub_count]);
            strcat(sub_locals, "=");
            strcat(sub_locals, yyvsp[0].Str);
            sub_count++;
        } else {
            fprintf(stderr, "dbLoadTemplate: Too many values given, line %d.\n",
                line_num);
        }
        dbmfFree(yyvsp[0].Str);
    }
break;
case 35:
#line 246 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "variable_substitution: variable_definitions empty\n");
        fprintf(stderr, "    dbLoadRecords(%s)\n", sub_collect+1);
    #endif
        dbLoadRecords(db_file_name, sub_collect+1);
    }
break;
case 36:
#line 254 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "variable_substitution:\n");
        fprintf(stderr, "    dbLoadRecords(%s)\n", sub_collect+1);
    #endif
        dbLoadRecords(db_file_name, sub_collect+1);
        *sub_locals = '\0';
    }
break;
case 37:
#line 263 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{   /* DEPRECATED SYNTAX */
        fprintf(stderr,
            "dbLoadTemplate: Substitution file uses deprecated syntax.\n"
            "    the string '%s' on line %d that comes just before the\n"
            "    '{' character is extraneous and should be removed.\n",
            yyvsp[-3].Str, line_num);
    #ifdef ERROR_STUFF
        fprintf(stderr, "variable_substitution:\n");
        fprintf(stderr, "    dbLoadRecords(%s)\n", sub_collect+1);
    #endif
        dbLoadRecords(db_file_name, sub_collect+1);
        dbmfFree(yyvsp[-3].Str);
        *sub_locals = '\0';
    }
break;
case 41:
#line 285 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "variable_definition: %s = %s\n", yyvsp[-2].Str, yyvsp[0].Str);
    #endif
        strcat(sub_locals, ",");
        strcat(sub_locals, yyvsp[-2].Str);
        strcat(sub_locals, "=");
        strcat(sub_locals, yyvsp[0].Str);
        dbmfFree(yyvsp[-2].Str); dbmfFree(yyvsp[0].Str);
    }
break;
case 42:
#line 296 "../../../src/ioc/dbtemplate/dbLoadTemplate.y"
{
    #ifdef ERROR_STUFF
        fprintf(stderr, "variable_definition: %s = \"%s\"\n", yyvsp[-2].Str, yyvsp[0].Str);
    #endif
        strcat(sub_locals, ",");
        strcat(sub_locals, yyvsp[-2].Str);
        strcat(sub_locals, "=\"");
        strcat(sub_locals, yyvsp[0].Str);
        strcat(sub_locals, "\"");
        dbmfFree(yyvsp[-2].Str); dbmfFree(yyvsp[0].Str);
    }
break;
#line 662 "dbLoadTemplate.tab.c"
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
