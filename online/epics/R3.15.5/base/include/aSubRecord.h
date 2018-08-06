/* aSubRecord.h generated from aSubRecord.dbd */

#ifndef INC_aSubRecord_H
#define INC_aSubRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
struct aSubRecord;

typedef enum {
    aSubLFLG_IGNORE                 /* IGNORE */,
    aSubLFLG_READ                   /* READ */
} aSubLFLG;
#define aSubLFLG_NUM_CHOICES 2

typedef enum {
    aSubEFLG_NEVER                  /* NEVER */,
    aSubEFLG_ON_CHANGE              /* ON CHANGE */,
    aSubEFLG_ALWAYS                 /* ALWAYS */
} aSubEFLG;
#define aSubEFLG_NUM_CHOICES 3

typedef struct aSubRecord {
    char                name[61];   /* Record Name */
    char                desc[41];   /* Descriptor */
    char                asg[29];    /* Access Security Group */
    epicsEnum16         scan;       /* Scan Mechanism */
    epicsEnum16         pini;       /* Process at iocInit */
    epicsInt16          phas;       /* Scan Phase */
    char                evnt[40];   /* Event Name */
    epicsInt16          tse;        /* Time Stamp Event */
    DBLINK              tsel;       /* Time Stamp Link */
    epicsEnum16         dtyp;       /* Device Type */
    epicsInt16          disv;       /* Disable Value */
    epicsInt16          disa;       /* Disable */
    DBLINK              sdis;       /* Scanning Disable */
    epicsMutexId        mlok;       /* Monitor lock */
    ELLLIST             mlis;       /* Monitor List */
    epicsUInt8          disp;       /* Disable putField */
    epicsUInt8          proc;       /* Force Processing */
    epicsEnum16         stat;       /* Alarm Status */
    epicsEnum16         sevr;       /* Alarm Severity */
    epicsEnum16         nsta;       /* New Alarm Status */
    epicsEnum16         nsev;       /* New Alarm Severity */
    epicsEnum16         acks;       /* Alarm Ack Severity */
    epicsEnum16         ackt;       /* Alarm Ack Transient */
    epicsEnum16         diss;       /* Disable Alarm Sevrty */
    epicsUInt8          lcnt;       /* Lock Count */
    epicsUInt8          pact;       /* Record active */
    epicsUInt8          putf;       /* dbPutField process */
    epicsUInt8          rpro;       /* Reprocess  */
    struct asgMember    *asp;       /* Access Security Pvt */
    struct processNotify *ppn;      /* pprocessNotify */
    struct processNotifyRecord *ppnr; /* pprocessNotifyRecord */
    struct scan_element *spvt;      /* Scan Private */
    struct rset         *rset;      /* Address of RSET */
    struct dset         *dset;      /* DSET address */
    void                *dpvt;      /* Device Private */
    struct dbRecordType *rdes;      /* Address of dbRecordType */
    struct lockRecord   *lset;      /* Lock Set */
    epicsEnum16         prio;       /* Scheduling Priority */
    epicsUInt8          tpro;       /* Trace Processing */
    char                bkpt;       /* Break Point */
    epicsUInt8          udf;        /* Undefined */
    epicsEnum16         udfs;       /* Undefined Alarm Sevrty */
    epicsTimeStamp      time;       /* Time */
    DBLINK              flnk;       /* Forward Process Link */
    epicsInt32          val;        /* Subr. return value */
    epicsInt32          oval;       /* Old return value */
    char                inam[41];   /* Initialize Subr. Name */
    epicsEnum16         lflg;       /* Subr. Input Enable */
    DBLINK              subl;       /* Subroutine Name Link */
    char                snam[41];   /* Process Subr. Name */
    char                onam[41];   /* Old Subr. Name */
    long (*sadr)(struct aSubRecord *); /* Subroutine Address */
    void (*cadr)(struct aSubRecord *); /* Subroutine Cleanup Address */
    epicsEnum16         brsv;       /* Bad Return Severity */
    epicsInt16          prec;       /* Display Precision */
    epicsEnum16         eflg;       /* Output Event Flag */
    DBLINK              inpa;       /* Input Link A */
    DBLINK              inpb;       /* Input Link B */
    DBLINK              inpc;       /* Input Link C */
    DBLINK              inpd;       /* Input Link D */
    DBLINK              inpe;       /* Input Link E */
    DBLINK              inpf;       /* Input Link F */
    DBLINK              inpg;       /* Input Link G */
    DBLINK              inph;       /* Input Link H */
    DBLINK              inpi;       /* Input Link I */
    DBLINK              inpj;       /* Input Link J */
    DBLINK              inpk;       /* Input Link K */
    DBLINK              inpl;       /* Input Link L */
    DBLINK              inpm;       /* Input Link M */
    DBLINK              inpn;       /* Input Link N */
    DBLINK              inpo;       /* Input Link O */
    DBLINK              inpp;       /* Input Link P */
    DBLINK              inpq;       /* Input Link Q */
    DBLINK              inpr;       /* Input Link R */
    DBLINK              inps;       /* Input Link S */
    DBLINK              inpt;       /* Input Link T */
    DBLINK              inpu;       /* Input Link U */
    void *a;                        /* Input value A */
    void *b;                        /* Input value B */
    void *c;                        /* Input value C */
    void *d;                        /* Input value D */
    void *e;                        /* Input value E */
    void *f;                        /* Input value F */
    void *g;                        /* Input value G */
    void *h;                        /* Input value H */
    void *i;                        /* Input value I */
    void *j;                        /* Input value J */
    void *k;                        /* Input value K */
    void *l;                        /* Input value L */
    void *m;                        /* Input value M */
    void *n;                        /* Input value N */
    void *o;                        /* Input value O */
    void *p;                        /* Input value P */
    void *q;                        /* Input value Q */
    void *r;                        /* Input value R */
    void *s;                        /* Input value S */
    void *t;                        /* Input value T */
    void *u;                        /* Input value U */
    epicsEnum16         fta;        /* Type of A */
    epicsEnum16         ftb;        /* Type of B */
    epicsEnum16         ftc;        /* Type of C */
    epicsEnum16         ftd;        /* Type of D */
    epicsEnum16         fte;        /* Type of E */
    epicsEnum16         ftf;        /* Type of F */
    epicsEnum16         ftg;        /* Type of G */
    epicsEnum16         fth;        /* Type of H */
    epicsEnum16         fti;        /* Type of I */
    epicsEnum16         ftj;        /* Type of J */
    epicsEnum16         ftk;        /* Type of K */
    epicsEnum16         ftl;        /* Type of L */
    epicsEnum16         ftm;        /* Type of M */
    epicsEnum16         ftn;        /* Type of N */
    epicsEnum16         fto;        /* Type of O */
    epicsEnum16         ftp;        /* Type of P */
    epicsEnum16         ftq;        /* Type of Q */
    epicsEnum16         ftr;        /* Type of R */
    epicsEnum16         fts;        /* Type of S */
    epicsEnum16         ftt;        /* Type of T */
    epicsEnum16         ftu;        /* Type of U */
    epicsUInt32         noa;        /* Max. elements in A */
    epicsUInt32         nob;        /* Max. elements in B */
    epicsUInt32         noc;        /* Max. elements in C */
    epicsUInt32         nod;        /* Max. elements in D */
    epicsUInt32         noe;        /* Max. elements in E */
    epicsUInt32         nof;        /* Max. elements in F */
    epicsUInt32         nog;        /* Max. elements in G */
    epicsUInt32         noh;        /* Max. elements in H */
    epicsUInt32         noi;        /* Max. elements in I */
    epicsUInt32         noj;        /* Max. elements in J */
    epicsUInt32         nok;        /* Max. elements in K */
    epicsUInt32         nol;        /* Max. elements in L */
    epicsUInt32         nom;        /* Max. elements in M */
    epicsUInt32         non;        /* Max. elements in N */
    epicsUInt32         noo;        /* Max. elements in O */
    epicsUInt32         nop;        /* Max. elements in P */
    epicsUInt32         noq;        /* Max. elements in Q */
    epicsUInt32         nor;        /* Max. elements in R */
    epicsUInt32         nos;        /* Max. elements in S */
    epicsUInt32         NOT;        /* Max. elements in T */
    epicsUInt32         nou;        /* Max. elements in U */
    epicsUInt32         nea;        /* Num. elements in A */
    epicsUInt32         neb;        /* Num. elements in B */
    epicsUInt32         nec;        /* Num. elements in C */
    epicsUInt32         ned;        /* Num. elements in D */
    epicsUInt32         nee;        /* Num. elements in E */
    epicsUInt32         nef;        /* Num. elements in F */
    epicsUInt32         neg;        /* Num. elements in G */
    epicsUInt32         neh;        /* Num. elements in H */
    epicsUInt32         nei;        /* Num. elements in I */
    epicsUInt32         nej;        /* Num. elements in J */
    epicsUInt32         nek;        /* Num. elements in K */
    epicsUInt32         nel;        /* Num. elements in L */
    epicsUInt32         nem;        /* Num. elements in M */
    epicsUInt32         nen;        /* Num. elements in N */
    epicsUInt32         neo;        /* Num. elements in O */
    epicsUInt32         nep;        /* Num. elements in P */
    epicsUInt32         neq;        /* Num. elements in Q */
    epicsUInt32         ner;        /* Num. elements in R */
    epicsUInt32         nes;        /* Num. elements in S */
    epicsUInt32         net;        /* Num. elements in T */
    epicsUInt32         neu;        /* Num. elements in U */
    DBLINK              outa;       /* Output Link A */
    DBLINK              outb;       /* Output Link B */
    DBLINK              outc;       /* Output Link C */
    DBLINK              outd;       /* Output Link D */
    DBLINK              oute;       /* Output Link E */
    DBLINK              outf;       /* Output Link F */
    DBLINK              outg;       /* Output Link G */
    DBLINK              outh;       /* Output Link H */
    DBLINK              outi;       /* Output Link I */
    DBLINK              outj;       /* Output Link J */
    DBLINK              outk;       /* Output Link K */
    DBLINK              outl;       /* Output Link L */
    DBLINK              outm;       /* Output Link M */
    DBLINK              outn;       /* Output Link N */
    DBLINK              outo;       /* Output Link O */
    DBLINK              outp;       /* Output Link P */
    DBLINK              outq;       /* Output Link Q */
    DBLINK              outr;       /* Output Link R */
    DBLINK              outs;       /* Output Link S */
    DBLINK              outt;       /* Output Link T */
    DBLINK              outu;       /* Output Link U */
    void *vala;                     /* Output value A */
    void *valb;                     /* Output value B */
    void *valc;                     /* Output value C */
    void *vald;                     /* Output value D */
    void *vale;                     /* Output value E */
    void *valf;                     /* Output value F */
    void *valg;                     /* Output value G */
    void *valh;                     /* Output value H */
    void *vali;                     /* Output value I */
    void *valj;                     /* Output value J */
    void *valk;                     /* Output value K */
    void *vall;                     /* Output value L */
    void *valm;                     /* Output value M */
    void *valn;                     /* Output value N */
    void *valo;                     /* Output value O */
    void *valp;                     /* Output value P */
    void *valq;                     /* Output value Q */
    void *valr;                     /* Output value R */
    void *vals;                     /* Output value S */
    void *valt;                     /* Output value T */
    void *valu;                     /* Output value U */
    void *ovla;                     /* Old Output A */
    void *ovlb;                     /* Old Output B */
    void *ovlc;                     /* Old Output C */
    void *ovld;                     /* Old Output D */
    void *ovle;                     /* Old Output E */
    void *ovlf;                     /* Old Output F */
    void *ovlg;                     /* Old Output G */
    void *ovlh;                     /* Old Output H */
    void *ovli;                     /* Old Output I */
    void *ovlj;                     /* Old Output J */
    void *ovlk;                     /* Old Output K */
    void *ovll;                     /* Old Output L */
    void *ovlm;                     /* Old Output M */
    void *ovln;                     /* Old Output N */
    void *ovlo;                     /* Old Output O */
    void *ovlp;                     /* Old Output P */
    void *ovlq;                     /* Old Output Q */
    void *ovlr;                     /* Old Output R */
    void *ovls;                     /* Old Output S */
    void *ovlt;                     /* Old Output T */
    void *ovlu;                     /* Old Output U */
    epicsEnum16         ftva;       /* Type of VALA */
    epicsEnum16         ftvb;       /* Type of VALB */
    epicsEnum16         ftvc;       /* Type of VALC */
    epicsEnum16         ftvd;       /* Type of VALD */
    epicsEnum16         ftve;       /* Type of VALE */
    epicsEnum16         ftvf;       /* Type of VALF */
    epicsEnum16         ftvg;       /* Type of VALG */
    epicsEnum16         ftvh;       /* Type of VALH */
    epicsEnum16         ftvi;       /* Type of VALI */
    epicsEnum16         ftvj;       /* Type of VALJ */
    epicsEnum16         ftvk;       /* Type of VALK */
    epicsEnum16         ftvl;       /* Type of VALL */
    epicsEnum16         ftvm;       /* Type of VALM */
    epicsEnum16         ftvn;       /* Type of VALN */
    epicsEnum16         ftvo;       /* Type of VALO */
    epicsEnum16         ftvp;       /* Type of VALP */
    epicsEnum16         ftvq;       /* Type of VALQ */
    epicsEnum16         ftvr;       /* Type of VALR */
    epicsEnum16         ftvs;       /* Type of VALS */
    epicsEnum16         ftvt;       /* Type of VALT */
    epicsEnum16         ftvu;       /* Type of VALU */
    epicsUInt32         nova;       /* Max. elements in VALA */
    epicsUInt32         novb;       /* Max. elements in VALB */
    epicsUInt32         novc;       /* Max. elements in VALC */
    epicsUInt32         novd;       /* Max. elements in VALD */
    epicsUInt32         nove;       /* Max. elements in VALE */
    epicsUInt32         novf;       /* Max. elements in VALF */
    epicsUInt32         novg;       /* Max. elements in VALG */
    epicsUInt32         novh;       /* Max. elements in VAlH */
    epicsUInt32         novi;       /* Max. elements in VALI */
    epicsUInt32         novj;       /* Max. elements in VALJ */
    epicsUInt32         novk;       /* Max. elements in VALK */
    epicsUInt32         novl;       /* Max. elements in VALL */
    epicsUInt32         novm;       /* Max. elements in VALM */
    epicsUInt32         novn;       /* Max. elements in VALN */
    epicsUInt32         novo;       /* Max. elements in VALO */
    epicsUInt32         novp;       /* Max. elements in VALP */
    epicsUInt32         novq;       /* Max. elements in VALQ */
    epicsUInt32         novr;       /* Max. elements in VALR */
    epicsUInt32         novs;       /* Max. elements in VALS */
    epicsUInt32         novt;       /* Max. elements in VALT */
    epicsUInt32         novu;       /* Max. elements in VALU */
    epicsUInt32         neva;       /* Num. elements in VALA */
    epicsUInt32         nevb;       /* Num. elements in VALB */
    epicsUInt32         nevc;       /* Num. elements in VALC */
    epicsUInt32         nevd;       /* Num. elements in VALD */
    epicsUInt32         neve;       /* Num. elements in VALE */
    epicsUInt32         nevf;       /* Num. elements in VALF */
    epicsUInt32         nevg;       /* Num. elements in VALG */
    epicsUInt32         nevh;       /* Num. elements in VAlH */
    epicsUInt32         nevi;       /* Num. elements in VALI */
    epicsUInt32         nevj;       /* Num. elements in VALJ */
    epicsUInt32         nevk;       /* Num. elements in VALK */
    epicsUInt32         nevl;       /* Num. elements in VALL */
    epicsUInt32         nevm;       /* Num. elements in VALM */
    epicsUInt32         nevn;       /* Num. elements in VALN */
    epicsUInt32         nevo;       /* Num. elements in VALO */
    epicsUInt32         nevp;       /* Num. elements in VALP */
    epicsUInt32         nevq;       /* Num. elements in VALQ */
    epicsUInt32         nevr;       /* Num. elements in VALR */
    epicsUInt32         nevs;       /* Num. elements in VALS */
    epicsUInt32         nevt;       /* Num. elements in VALT */
    epicsUInt32         nevu;       /* Num. elements in VALU */
    epicsUInt32         onva;       /* Num. elements in OVLA */
    epicsUInt32         onvb;       /* Num. elements in OVLB */
    epicsUInt32         onvc;       /* Num. elements in OVLC */
    epicsUInt32         onvd;       /* Num. elements in OVLD */
    epicsUInt32         onve;       /* Num. elements in OVLE */
    epicsUInt32         onvf;       /* Num. elements in OVLF */
    epicsUInt32         onvg;       /* Num. elements in OVLG */
    epicsUInt32         onvh;       /* Num. elements in VAlH */
    epicsUInt32         onvi;       /* Num. elements in OVLI */
    epicsUInt32         onvj;       /* Num. elements in OVLJ */
    epicsUInt32         onvk;       /* Num. elements in OVLK */
    epicsUInt32         onvl;       /* Num. elements in OVLL */
    epicsUInt32         onvm;       /* Num. elements in OVLM */
    epicsUInt32         onvn;       /* Num. elements in OVLN */
    epicsUInt32         onvo;       /* Num. elements in OVLO */
    epicsUInt32         onvp;       /* Num. elements in OVLP */
    epicsUInt32         onvq;       /* Num. elements in OVLQ */
    epicsUInt32         onvr;       /* Num. elements in OVLR */
    epicsUInt32         onvs;       /* Num. elements in OVLS */
    epicsUInt32         onvt;       /* Num. elements in OVLT */
    epicsUInt32         onvu;       /* Num. elements in OVLU */
} aSubRecord;

typedef enum {
	aSubRecordNAME = 0,
	aSubRecordDESC = 1,
	aSubRecordASG = 2,
	aSubRecordSCAN = 3,
	aSubRecordPINI = 4,
	aSubRecordPHAS = 5,
	aSubRecordEVNT = 6,
	aSubRecordTSE = 7,
	aSubRecordTSEL = 8,
	aSubRecordDTYP = 9,
	aSubRecordDISV = 10,
	aSubRecordDISA = 11,
	aSubRecordSDIS = 12,
	aSubRecordMLOK = 13,
	aSubRecordMLIS = 14,
	aSubRecordDISP = 15,
	aSubRecordPROC = 16,
	aSubRecordSTAT = 17,
	aSubRecordSEVR = 18,
	aSubRecordNSTA = 19,
	aSubRecordNSEV = 20,
	aSubRecordACKS = 21,
	aSubRecordACKT = 22,
	aSubRecordDISS = 23,
	aSubRecordLCNT = 24,
	aSubRecordPACT = 25,
	aSubRecordPUTF = 26,
	aSubRecordRPRO = 27,
	aSubRecordASP = 28,
	aSubRecordPPN = 29,
	aSubRecordPPNR = 30,
	aSubRecordSPVT = 31,
	aSubRecordRSET = 32,
	aSubRecordDSET = 33,
	aSubRecordDPVT = 34,
	aSubRecordRDES = 35,
	aSubRecordLSET = 36,
	aSubRecordPRIO = 37,
	aSubRecordTPRO = 38,
	aSubRecordBKPT = 39,
	aSubRecordUDF = 40,
	aSubRecordUDFS = 41,
	aSubRecordTIME = 42,
	aSubRecordFLNK = 43,
	aSubRecordVAL = 44,
	aSubRecordOVAL = 45,
	aSubRecordINAM = 46,
	aSubRecordLFLG = 47,
	aSubRecordSUBL = 48,
	aSubRecordSNAM = 49,
	aSubRecordONAM = 50,
	aSubRecordSADR = 51,
	aSubRecordCADR = 52,
	aSubRecordBRSV = 53,
	aSubRecordPREC = 54,
	aSubRecordEFLG = 55,
	aSubRecordINPA = 56,
	aSubRecordINPB = 57,
	aSubRecordINPC = 58,
	aSubRecordINPD = 59,
	aSubRecordINPE = 60,
	aSubRecordINPF = 61,
	aSubRecordINPG = 62,
	aSubRecordINPH = 63,
	aSubRecordINPI = 64,
	aSubRecordINPJ = 65,
	aSubRecordINPK = 66,
	aSubRecordINPL = 67,
	aSubRecordINPM = 68,
	aSubRecordINPN = 69,
	aSubRecordINPO = 70,
	aSubRecordINPP = 71,
	aSubRecordINPQ = 72,
	aSubRecordINPR = 73,
	aSubRecordINPS = 74,
	aSubRecordINPT = 75,
	aSubRecordINPU = 76,
	aSubRecordA = 77,
	aSubRecordB = 78,
	aSubRecordC = 79,
	aSubRecordD = 80,
	aSubRecordE = 81,
	aSubRecordF = 82,
	aSubRecordG = 83,
	aSubRecordH = 84,
	aSubRecordI = 85,
	aSubRecordJ = 86,
	aSubRecordK = 87,
	aSubRecordL = 88,
	aSubRecordM = 89,
	aSubRecordN = 90,
	aSubRecordO = 91,
	aSubRecordP = 92,
	aSubRecordQ = 93,
	aSubRecordR = 94,
	aSubRecordS = 95,
	aSubRecordT = 96,
	aSubRecordU = 97,
	aSubRecordFTA = 98,
	aSubRecordFTB = 99,
	aSubRecordFTC = 100,
	aSubRecordFTD = 101,
	aSubRecordFTE = 102,
	aSubRecordFTF = 103,
	aSubRecordFTG = 104,
	aSubRecordFTH = 105,
	aSubRecordFTI = 106,
	aSubRecordFTJ = 107,
	aSubRecordFTK = 108,
	aSubRecordFTL = 109,
	aSubRecordFTM = 110,
	aSubRecordFTN = 111,
	aSubRecordFTO = 112,
	aSubRecordFTP = 113,
	aSubRecordFTQ = 114,
	aSubRecordFTR = 115,
	aSubRecordFTS = 116,
	aSubRecordFTT = 117,
	aSubRecordFTU = 118,
	aSubRecordNOA = 119,
	aSubRecordNOB = 120,
	aSubRecordNOC = 121,
	aSubRecordNOD = 122,
	aSubRecordNOE = 123,
	aSubRecordNOF = 124,
	aSubRecordNOG = 125,
	aSubRecordNOH = 126,
	aSubRecordNOI = 127,
	aSubRecordNOJ = 128,
	aSubRecordNOK = 129,
	aSubRecordNOL = 130,
	aSubRecordNOM = 131,
	aSubRecordNON = 132,
	aSubRecordNOO = 133,
	aSubRecordNOP = 134,
	aSubRecordNOQ = 135,
	aSubRecordNOR = 136,
	aSubRecordNOS = 137,
	aSubRecordNOT = 138,
	aSubRecordNOU = 139,
	aSubRecordNEA = 140,
	aSubRecordNEB = 141,
	aSubRecordNEC = 142,
	aSubRecordNED = 143,
	aSubRecordNEE = 144,
	aSubRecordNEF = 145,
	aSubRecordNEG = 146,
	aSubRecordNEH = 147,
	aSubRecordNEI = 148,
	aSubRecordNEJ = 149,
	aSubRecordNEK = 150,
	aSubRecordNEL = 151,
	aSubRecordNEM = 152,
	aSubRecordNEN = 153,
	aSubRecordNEO = 154,
	aSubRecordNEP = 155,
	aSubRecordNEQ = 156,
	aSubRecordNER = 157,
	aSubRecordNES = 158,
	aSubRecordNET = 159,
	aSubRecordNEU = 160,
	aSubRecordOUTA = 161,
	aSubRecordOUTB = 162,
	aSubRecordOUTC = 163,
	aSubRecordOUTD = 164,
	aSubRecordOUTE = 165,
	aSubRecordOUTF = 166,
	aSubRecordOUTG = 167,
	aSubRecordOUTH = 168,
	aSubRecordOUTI = 169,
	aSubRecordOUTJ = 170,
	aSubRecordOUTK = 171,
	aSubRecordOUTL = 172,
	aSubRecordOUTM = 173,
	aSubRecordOUTN = 174,
	aSubRecordOUTO = 175,
	aSubRecordOUTP = 176,
	aSubRecordOUTQ = 177,
	aSubRecordOUTR = 178,
	aSubRecordOUTS = 179,
	aSubRecordOUTT = 180,
	aSubRecordOUTU = 181,
	aSubRecordVALA = 182,
	aSubRecordVALB = 183,
	aSubRecordVALC = 184,
	aSubRecordVALD = 185,
	aSubRecordVALE = 186,
	aSubRecordVALF = 187,
	aSubRecordVALG = 188,
	aSubRecordVALH = 189,
	aSubRecordVALI = 190,
	aSubRecordVALJ = 191,
	aSubRecordVALK = 192,
	aSubRecordVALL = 193,
	aSubRecordVALM = 194,
	aSubRecordVALN = 195,
	aSubRecordVALO = 196,
	aSubRecordVALP = 197,
	aSubRecordVALQ = 198,
	aSubRecordVALR = 199,
	aSubRecordVALS = 200,
	aSubRecordVALT = 201,
	aSubRecordVALU = 202,
	aSubRecordOVLA = 203,
	aSubRecordOVLB = 204,
	aSubRecordOVLC = 205,
	aSubRecordOVLD = 206,
	aSubRecordOVLE = 207,
	aSubRecordOVLF = 208,
	aSubRecordOVLG = 209,
	aSubRecordOVLH = 210,
	aSubRecordOVLI = 211,
	aSubRecordOVLJ = 212,
	aSubRecordOVLK = 213,
	aSubRecordOVLL = 214,
	aSubRecordOVLM = 215,
	aSubRecordOVLN = 216,
	aSubRecordOVLO = 217,
	aSubRecordOVLP = 218,
	aSubRecordOVLQ = 219,
	aSubRecordOVLR = 220,
	aSubRecordOVLS = 221,
	aSubRecordOVLT = 222,
	aSubRecordOVLU = 223,
	aSubRecordFTVA = 224,
	aSubRecordFTVB = 225,
	aSubRecordFTVC = 226,
	aSubRecordFTVD = 227,
	aSubRecordFTVE = 228,
	aSubRecordFTVF = 229,
	aSubRecordFTVG = 230,
	aSubRecordFTVH = 231,
	aSubRecordFTVI = 232,
	aSubRecordFTVJ = 233,
	aSubRecordFTVK = 234,
	aSubRecordFTVL = 235,
	aSubRecordFTVM = 236,
	aSubRecordFTVN = 237,
	aSubRecordFTVO = 238,
	aSubRecordFTVP = 239,
	aSubRecordFTVQ = 240,
	aSubRecordFTVR = 241,
	aSubRecordFTVS = 242,
	aSubRecordFTVT = 243,
	aSubRecordFTVU = 244,
	aSubRecordNOVA = 245,
	aSubRecordNOVB = 246,
	aSubRecordNOVC = 247,
	aSubRecordNOVD = 248,
	aSubRecordNOVE = 249,
	aSubRecordNOVF = 250,
	aSubRecordNOVG = 251,
	aSubRecordNOVH = 252,
	aSubRecordNOVI = 253,
	aSubRecordNOVJ = 254,
	aSubRecordNOVK = 255,
	aSubRecordNOVL = 256,
	aSubRecordNOVM = 257,
	aSubRecordNOVN = 258,
	aSubRecordNOVO = 259,
	aSubRecordNOVP = 260,
	aSubRecordNOVQ = 261,
	aSubRecordNOVR = 262,
	aSubRecordNOVS = 263,
	aSubRecordNOVT = 264,
	aSubRecordNOVU = 265,
	aSubRecordNEVA = 266,
	aSubRecordNEVB = 267,
	aSubRecordNEVC = 268,
	aSubRecordNEVD = 269,
	aSubRecordNEVE = 270,
	aSubRecordNEVF = 271,
	aSubRecordNEVG = 272,
	aSubRecordNEVH = 273,
	aSubRecordNEVI = 274,
	aSubRecordNEVJ = 275,
	aSubRecordNEVK = 276,
	aSubRecordNEVL = 277,
	aSubRecordNEVM = 278,
	aSubRecordNEVN = 279,
	aSubRecordNEVO = 280,
	aSubRecordNEVP = 281,
	aSubRecordNEVQ = 282,
	aSubRecordNEVR = 283,
	aSubRecordNEVS = 284,
	aSubRecordNEVT = 285,
	aSubRecordNEVU = 286,
	aSubRecordONVA = 287,
	aSubRecordONVB = 288,
	aSubRecordONVC = 289,
	aSubRecordONVD = 290,
	aSubRecordONVE = 291,
	aSubRecordONVF = 292,
	aSubRecordONVG = 293,
	aSubRecordONVH = 294,
	aSubRecordONVI = 295,
	aSubRecordONVJ = 296,
	aSubRecordONVK = 297,
	aSubRecordONVL = 298,
	aSubRecordONVM = 299,
	aSubRecordONVN = 300,
	aSubRecordONVO = 301,
	aSubRecordONVP = 302,
	aSubRecordONVQ = 303,
	aSubRecordONVR = 304,
	aSubRecordONVS = 305,
	aSubRecordONVT = 306,
	aSubRecordONVU = 307
} aSubFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int aSubRecordSizeOffset(dbRecordType *prt)
{
    aSubRecord *prec = 0;

    assert(prt->no_fields == 308);
    prt->papFldDes[aSubRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[aSubRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[aSubRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[aSubRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[aSubRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[aSubRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[aSubRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[aSubRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[aSubRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[aSubRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[aSubRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[aSubRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[aSubRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[aSubRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[aSubRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[aSubRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[aSubRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[aSubRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[aSubRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[aSubRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[aSubRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[aSubRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[aSubRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[aSubRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[aSubRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[aSubRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[aSubRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[aSubRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[aSubRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[aSubRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[aSubRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[aSubRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[aSubRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[aSubRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[aSubRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[aSubRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[aSubRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[aSubRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[aSubRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[aSubRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[aSubRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[aSubRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[aSubRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[aSubRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[aSubRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[aSubRecordOVAL]->size = sizeof(prec->oval);
    prt->papFldDes[aSubRecordINAM]->size = sizeof(prec->inam);
    prt->papFldDes[aSubRecordLFLG]->size = sizeof(prec->lflg);
    prt->papFldDes[aSubRecordSUBL]->size = sizeof(prec->subl);
    prt->papFldDes[aSubRecordSNAM]->size = sizeof(prec->snam);
    prt->papFldDes[aSubRecordONAM]->size = sizeof(prec->onam);
    prt->papFldDes[aSubRecordSADR]->size = sizeof(prec->sadr);
    prt->papFldDes[aSubRecordCADR]->size = sizeof(prec->cadr);
    prt->papFldDes[aSubRecordBRSV]->size = sizeof(prec->brsv);
    prt->papFldDes[aSubRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[aSubRecordEFLG]->size = sizeof(prec->eflg);
    prt->papFldDes[aSubRecordINPA]->size = sizeof(prec->inpa);
    prt->papFldDes[aSubRecordINPB]->size = sizeof(prec->inpb);
    prt->papFldDes[aSubRecordINPC]->size = sizeof(prec->inpc);
    prt->papFldDes[aSubRecordINPD]->size = sizeof(prec->inpd);
    prt->papFldDes[aSubRecordINPE]->size = sizeof(prec->inpe);
    prt->papFldDes[aSubRecordINPF]->size = sizeof(prec->inpf);
    prt->papFldDes[aSubRecordINPG]->size = sizeof(prec->inpg);
    prt->papFldDes[aSubRecordINPH]->size = sizeof(prec->inph);
    prt->papFldDes[aSubRecordINPI]->size = sizeof(prec->inpi);
    prt->papFldDes[aSubRecordINPJ]->size = sizeof(prec->inpj);
    prt->papFldDes[aSubRecordINPK]->size = sizeof(prec->inpk);
    prt->papFldDes[aSubRecordINPL]->size = sizeof(prec->inpl);
    prt->papFldDes[aSubRecordINPM]->size = sizeof(prec->inpm);
    prt->papFldDes[aSubRecordINPN]->size = sizeof(prec->inpn);
    prt->papFldDes[aSubRecordINPO]->size = sizeof(prec->inpo);
    prt->papFldDes[aSubRecordINPP]->size = sizeof(prec->inpp);
    prt->papFldDes[aSubRecordINPQ]->size = sizeof(prec->inpq);
    prt->papFldDes[aSubRecordINPR]->size = sizeof(prec->inpr);
    prt->papFldDes[aSubRecordINPS]->size = sizeof(prec->inps);
    prt->papFldDes[aSubRecordINPT]->size = sizeof(prec->inpt);
    prt->papFldDes[aSubRecordINPU]->size = sizeof(prec->inpu);
    prt->papFldDes[aSubRecordA]->size = sizeof(prec->a);
    prt->papFldDes[aSubRecordB]->size = sizeof(prec->b);
    prt->papFldDes[aSubRecordC]->size = sizeof(prec->c);
    prt->papFldDes[aSubRecordD]->size = sizeof(prec->d);
    prt->papFldDes[aSubRecordE]->size = sizeof(prec->e);
    prt->papFldDes[aSubRecordF]->size = sizeof(prec->f);
    prt->papFldDes[aSubRecordG]->size = sizeof(prec->g);
    prt->papFldDes[aSubRecordH]->size = sizeof(prec->h);
    prt->papFldDes[aSubRecordI]->size = sizeof(prec->i);
    prt->papFldDes[aSubRecordJ]->size = sizeof(prec->j);
    prt->papFldDes[aSubRecordK]->size = sizeof(prec->k);
    prt->papFldDes[aSubRecordL]->size = sizeof(prec->l);
    prt->papFldDes[aSubRecordM]->size = sizeof(prec->m);
    prt->papFldDes[aSubRecordN]->size = sizeof(prec->n);
    prt->papFldDes[aSubRecordO]->size = sizeof(prec->o);
    prt->papFldDes[aSubRecordP]->size = sizeof(prec->p);
    prt->papFldDes[aSubRecordQ]->size = sizeof(prec->q);
    prt->papFldDes[aSubRecordR]->size = sizeof(prec->r);
    prt->papFldDes[aSubRecordS]->size = sizeof(prec->s);
    prt->papFldDes[aSubRecordT]->size = sizeof(prec->t);
    prt->papFldDes[aSubRecordU]->size = sizeof(prec->u);
    prt->papFldDes[aSubRecordFTA]->size = sizeof(prec->fta);
    prt->papFldDes[aSubRecordFTB]->size = sizeof(prec->ftb);
    prt->papFldDes[aSubRecordFTC]->size = sizeof(prec->ftc);
    prt->papFldDes[aSubRecordFTD]->size = sizeof(prec->ftd);
    prt->papFldDes[aSubRecordFTE]->size = sizeof(prec->fte);
    prt->papFldDes[aSubRecordFTF]->size = sizeof(prec->ftf);
    prt->papFldDes[aSubRecordFTG]->size = sizeof(prec->ftg);
    prt->papFldDes[aSubRecordFTH]->size = sizeof(prec->fth);
    prt->papFldDes[aSubRecordFTI]->size = sizeof(prec->fti);
    prt->papFldDes[aSubRecordFTJ]->size = sizeof(prec->ftj);
    prt->papFldDes[aSubRecordFTK]->size = sizeof(prec->ftk);
    prt->papFldDes[aSubRecordFTL]->size = sizeof(prec->ftl);
    prt->papFldDes[aSubRecordFTM]->size = sizeof(prec->ftm);
    prt->papFldDes[aSubRecordFTN]->size = sizeof(prec->ftn);
    prt->papFldDes[aSubRecordFTO]->size = sizeof(prec->fto);
    prt->papFldDes[aSubRecordFTP]->size = sizeof(prec->ftp);
    prt->papFldDes[aSubRecordFTQ]->size = sizeof(prec->ftq);
    prt->papFldDes[aSubRecordFTR]->size = sizeof(prec->ftr);
    prt->papFldDes[aSubRecordFTS]->size = sizeof(prec->fts);
    prt->papFldDes[aSubRecordFTT]->size = sizeof(prec->ftt);
    prt->papFldDes[aSubRecordFTU]->size = sizeof(prec->ftu);
    prt->papFldDes[aSubRecordNOA]->size = sizeof(prec->noa);
    prt->papFldDes[aSubRecordNOB]->size = sizeof(prec->nob);
    prt->papFldDes[aSubRecordNOC]->size = sizeof(prec->noc);
    prt->papFldDes[aSubRecordNOD]->size = sizeof(prec->nod);
    prt->papFldDes[aSubRecordNOE]->size = sizeof(prec->noe);
    prt->papFldDes[aSubRecordNOF]->size = sizeof(prec->nof);
    prt->papFldDes[aSubRecordNOG]->size = sizeof(prec->nog);
    prt->papFldDes[aSubRecordNOH]->size = sizeof(prec->noh);
    prt->papFldDes[aSubRecordNOI]->size = sizeof(prec->noi);
    prt->papFldDes[aSubRecordNOJ]->size = sizeof(prec->noj);
    prt->papFldDes[aSubRecordNOK]->size = sizeof(prec->nok);
    prt->papFldDes[aSubRecordNOL]->size = sizeof(prec->nol);
    prt->papFldDes[aSubRecordNOM]->size = sizeof(prec->nom);
    prt->papFldDes[aSubRecordNON]->size = sizeof(prec->non);
    prt->papFldDes[aSubRecordNOO]->size = sizeof(prec->noo);
    prt->papFldDes[aSubRecordNOP]->size = sizeof(prec->nop);
    prt->papFldDes[aSubRecordNOQ]->size = sizeof(prec->noq);
    prt->papFldDes[aSubRecordNOR]->size = sizeof(prec->nor);
    prt->papFldDes[aSubRecordNOS]->size = sizeof(prec->nos);
    prt->papFldDes[aSubRecordNOT]->size = sizeof(prec->NOT);
    prt->papFldDes[aSubRecordNOU]->size = sizeof(prec->nou);
    prt->papFldDes[aSubRecordNEA]->size = sizeof(prec->nea);
    prt->papFldDes[aSubRecordNEB]->size = sizeof(prec->neb);
    prt->papFldDes[aSubRecordNEC]->size = sizeof(prec->nec);
    prt->papFldDes[aSubRecordNED]->size = sizeof(prec->ned);
    prt->papFldDes[aSubRecordNEE]->size = sizeof(prec->nee);
    prt->papFldDes[aSubRecordNEF]->size = sizeof(prec->nef);
    prt->papFldDes[aSubRecordNEG]->size = sizeof(prec->neg);
    prt->papFldDes[aSubRecordNEH]->size = sizeof(prec->neh);
    prt->papFldDes[aSubRecordNEI]->size = sizeof(prec->nei);
    prt->papFldDes[aSubRecordNEJ]->size = sizeof(prec->nej);
    prt->papFldDes[aSubRecordNEK]->size = sizeof(prec->nek);
    prt->papFldDes[aSubRecordNEL]->size = sizeof(prec->nel);
    prt->papFldDes[aSubRecordNEM]->size = sizeof(prec->nem);
    prt->papFldDes[aSubRecordNEN]->size = sizeof(prec->nen);
    prt->papFldDes[aSubRecordNEO]->size = sizeof(prec->neo);
    prt->papFldDes[aSubRecordNEP]->size = sizeof(prec->nep);
    prt->papFldDes[aSubRecordNEQ]->size = sizeof(prec->neq);
    prt->papFldDes[aSubRecordNER]->size = sizeof(prec->ner);
    prt->papFldDes[aSubRecordNES]->size = sizeof(prec->nes);
    prt->papFldDes[aSubRecordNET]->size = sizeof(prec->net);
    prt->papFldDes[aSubRecordNEU]->size = sizeof(prec->neu);
    prt->papFldDes[aSubRecordOUTA]->size = sizeof(prec->outa);
    prt->papFldDes[aSubRecordOUTB]->size = sizeof(prec->outb);
    prt->papFldDes[aSubRecordOUTC]->size = sizeof(prec->outc);
    prt->papFldDes[aSubRecordOUTD]->size = sizeof(prec->outd);
    prt->papFldDes[aSubRecordOUTE]->size = sizeof(prec->oute);
    prt->papFldDes[aSubRecordOUTF]->size = sizeof(prec->outf);
    prt->papFldDes[aSubRecordOUTG]->size = sizeof(prec->outg);
    prt->papFldDes[aSubRecordOUTH]->size = sizeof(prec->outh);
    prt->papFldDes[aSubRecordOUTI]->size = sizeof(prec->outi);
    prt->papFldDes[aSubRecordOUTJ]->size = sizeof(prec->outj);
    prt->papFldDes[aSubRecordOUTK]->size = sizeof(prec->outk);
    prt->papFldDes[aSubRecordOUTL]->size = sizeof(prec->outl);
    prt->papFldDes[aSubRecordOUTM]->size = sizeof(prec->outm);
    prt->papFldDes[aSubRecordOUTN]->size = sizeof(prec->outn);
    prt->papFldDes[aSubRecordOUTO]->size = sizeof(prec->outo);
    prt->papFldDes[aSubRecordOUTP]->size = sizeof(prec->outp);
    prt->papFldDes[aSubRecordOUTQ]->size = sizeof(prec->outq);
    prt->papFldDes[aSubRecordOUTR]->size = sizeof(prec->outr);
    prt->papFldDes[aSubRecordOUTS]->size = sizeof(prec->outs);
    prt->papFldDes[aSubRecordOUTT]->size = sizeof(prec->outt);
    prt->papFldDes[aSubRecordOUTU]->size = sizeof(prec->outu);
    prt->papFldDes[aSubRecordVALA]->size = sizeof(prec->vala);
    prt->papFldDes[aSubRecordVALB]->size = sizeof(prec->valb);
    prt->papFldDes[aSubRecordVALC]->size = sizeof(prec->valc);
    prt->papFldDes[aSubRecordVALD]->size = sizeof(prec->vald);
    prt->papFldDes[aSubRecordVALE]->size = sizeof(prec->vale);
    prt->papFldDes[aSubRecordVALF]->size = sizeof(prec->valf);
    prt->papFldDes[aSubRecordVALG]->size = sizeof(prec->valg);
    prt->papFldDes[aSubRecordVALH]->size = sizeof(prec->valh);
    prt->papFldDes[aSubRecordVALI]->size = sizeof(prec->vali);
    prt->papFldDes[aSubRecordVALJ]->size = sizeof(prec->valj);
    prt->papFldDes[aSubRecordVALK]->size = sizeof(prec->valk);
    prt->papFldDes[aSubRecordVALL]->size = sizeof(prec->vall);
    prt->papFldDes[aSubRecordVALM]->size = sizeof(prec->valm);
    prt->papFldDes[aSubRecordVALN]->size = sizeof(prec->valn);
    prt->papFldDes[aSubRecordVALO]->size = sizeof(prec->valo);
    prt->papFldDes[aSubRecordVALP]->size = sizeof(prec->valp);
    prt->papFldDes[aSubRecordVALQ]->size = sizeof(prec->valq);
    prt->papFldDes[aSubRecordVALR]->size = sizeof(prec->valr);
    prt->papFldDes[aSubRecordVALS]->size = sizeof(prec->vals);
    prt->papFldDes[aSubRecordVALT]->size = sizeof(prec->valt);
    prt->papFldDes[aSubRecordVALU]->size = sizeof(prec->valu);
    prt->papFldDes[aSubRecordOVLA]->size = sizeof(prec->ovla);
    prt->papFldDes[aSubRecordOVLB]->size = sizeof(prec->ovlb);
    prt->papFldDes[aSubRecordOVLC]->size = sizeof(prec->ovlc);
    prt->papFldDes[aSubRecordOVLD]->size = sizeof(prec->ovld);
    prt->papFldDes[aSubRecordOVLE]->size = sizeof(prec->ovle);
    prt->papFldDes[aSubRecordOVLF]->size = sizeof(prec->ovlf);
    prt->papFldDes[aSubRecordOVLG]->size = sizeof(prec->ovlg);
    prt->papFldDes[aSubRecordOVLH]->size = sizeof(prec->ovlh);
    prt->papFldDes[aSubRecordOVLI]->size = sizeof(prec->ovli);
    prt->papFldDes[aSubRecordOVLJ]->size = sizeof(prec->ovlj);
    prt->papFldDes[aSubRecordOVLK]->size = sizeof(prec->ovlk);
    prt->papFldDes[aSubRecordOVLL]->size = sizeof(prec->ovll);
    prt->papFldDes[aSubRecordOVLM]->size = sizeof(prec->ovlm);
    prt->papFldDes[aSubRecordOVLN]->size = sizeof(prec->ovln);
    prt->papFldDes[aSubRecordOVLO]->size = sizeof(prec->ovlo);
    prt->papFldDes[aSubRecordOVLP]->size = sizeof(prec->ovlp);
    prt->papFldDes[aSubRecordOVLQ]->size = sizeof(prec->ovlq);
    prt->papFldDes[aSubRecordOVLR]->size = sizeof(prec->ovlr);
    prt->papFldDes[aSubRecordOVLS]->size = sizeof(prec->ovls);
    prt->papFldDes[aSubRecordOVLT]->size = sizeof(prec->ovlt);
    prt->papFldDes[aSubRecordOVLU]->size = sizeof(prec->ovlu);
    prt->papFldDes[aSubRecordFTVA]->size = sizeof(prec->ftva);
    prt->papFldDes[aSubRecordFTVB]->size = sizeof(prec->ftvb);
    prt->papFldDes[aSubRecordFTVC]->size = sizeof(prec->ftvc);
    prt->papFldDes[aSubRecordFTVD]->size = sizeof(prec->ftvd);
    prt->papFldDes[aSubRecordFTVE]->size = sizeof(prec->ftve);
    prt->papFldDes[aSubRecordFTVF]->size = sizeof(prec->ftvf);
    prt->papFldDes[aSubRecordFTVG]->size = sizeof(prec->ftvg);
    prt->papFldDes[aSubRecordFTVH]->size = sizeof(prec->ftvh);
    prt->papFldDes[aSubRecordFTVI]->size = sizeof(prec->ftvi);
    prt->papFldDes[aSubRecordFTVJ]->size = sizeof(prec->ftvj);
    prt->papFldDes[aSubRecordFTVK]->size = sizeof(prec->ftvk);
    prt->papFldDes[aSubRecordFTVL]->size = sizeof(prec->ftvl);
    prt->papFldDes[aSubRecordFTVM]->size = sizeof(prec->ftvm);
    prt->papFldDes[aSubRecordFTVN]->size = sizeof(prec->ftvn);
    prt->papFldDes[aSubRecordFTVO]->size = sizeof(prec->ftvo);
    prt->papFldDes[aSubRecordFTVP]->size = sizeof(prec->ftvp);
    prt->papFldDes[aSubRecordFTVQ]->size = sizeof(prec->ftvq);
    prt->papFldDes[aSubRecordFTVR]->size = sizeof(prec->ftvr);
    prt->papFldDes[aSubRecordFTVS]->size = sizeof(prec->ftvs);
    prt->papFldDes[aSubRecordFTVT]->size = sizeof(prec->ftvt);
    prt->papFldDes[aSubRecordFTVU]->size = sizeof(prec->ftvu);
    prt->papFldDes[aSubRecordNOVA]->size = sizeof(prec->nova);
    prt->papFldDes[aSubRecordNOVB]->size = sizeof(prec->novb);
    prt->papFldDes[aSubRecordNOVC]->size = sizeof(prec->novc);
    prt->papFldDes[aSubRecordNOVD]->size = sizeof(prec->novd);
    prt->papFldDes[aSubRecordNOVE]->size = sizeof(prec->nove);
    prt->papFldDes[aSubRecordNOVF]->size = sizeof(prec->novf);
    prt->papFldDes[aSubRecordNOVG]->size = sizeof(prec->novg);
    prt->papFldDes[aSubRecordNOVH]->size = sizeof(prec->novh);
    prt->papFldDes[aSubRecordNOVI]->size = sizeof(prec->novi);
    prt->papFldDes[aSubRecordNOVJ]->size = sizeof(prec->novj);
    prt->papFldDes[aSubRecordNOVK]->size = sizeof(prec->novk);
    prt->papFldDes[aSubRecordNOVL]->size = sizeof(prec->novl);
    prt->papFldDes[aSubRecordNOVM]->size = sizeof(prec->novm);
    prt->papFldDes[aSubRecordNOVN]->size = sizeof(prec->novn);
    prt->papFldDes[aSubRecordNOVO]->size = sizeof(prec->novo);
    prt->papFldDes[aSubRecordNOVP]->size = sizeof(prec->novp);
    prt->papFldDes[aSubRecordNOVQ]->size = sizeof(prec->novq);
    prt->papFldDes[aSubRecordNOVR]->size = sizeof(prec->novr);
    prt->papFldDes[aSubRecordNOVS]->size = sizeof(prec->novs);
    prt->papFldDes[aSubRecordNOVT]->size = sizeof(prec->novt);
    prt->papFldDes[aSubRecordNOVU]->size = sizeof(prec->novu);
    prt->papFldDes[aSubRecordNEVA]->size = sizeof(prec->neva);
    prt->papFldDes[aSubRecordNEVB]->size = sizeof(prec->nevb);
    prt->papFldDes[aSubRecordNEVC]->size = sizeof(prec->nevc);
    prt->papFldDes[aSubRecordNEVD]->size = sizeof(prec->nevd);
    prt->papFldDes[aSubRecordNEVE]->size = sizeof(prec->neve);
    prt->papFldDes[aSubRecordNEVF]->size = sizeof(prec->nevf);
    prt->papFldDes[aSubRecordNEVG]->size = sizeof(prec->nevg);
    prt->papFldDes[aSubRecordNEVH]->size = sizeof(prec->nevh);
    prt->papFldDes[aSubRecordNEVI]->size = sizeof(prec->nevi);
    prt->papFldDes[aSubRecordNEVJ]->size = sizeof(prec->nevj);
    prt->papFldDes[aSubRecordNEVK]->size = sizeof(prec->nevk);
    prt->papFldDes[aSubRecordNEVL]->size = sizeof(prec->nevl);
    prt->papFldDes[aSubRecordNEVM]->size = sizeof(prec->nevm);
    prt->papFldDes[aSubRecordNEVN]->size = sizeof(prec->nevn);
    prt->papFldDes[aSubRecordNEVO]->size = sizeof(prec->nevo);
    prt->papFldDes[aSubRecordNEVP]->size = sizeof(prec->nevp);
    prt->papFldDes[aSubRecordNEVQ]->size = sizeof(prec->nevq);
    prt->papFldDes[aSubRecordNEVR]->size = sizeof(prec->nevr);
    prt->papFldDes[aSubRecordNEVS]->size = sizeof(prec->nevs);
    prt->papFldDes[aSubRecordNEVT]->size = sizeof(prec->nevt);
    prt->papFldDes[aSubRecordNEVU]->size = sizeof(prec->nevu);
    prt->papFldDes[aSubRecordONVA]->size = sizeof(prec->onva);
    prt->papFldDes[aSubRecordONVB]->size = sizeof(prec->onvb);
    prt->papFldDes[aSubRecordONVC]->size = sizeof(prec->onvc);
    prt->papFldDes[aSubRecordONVD]->size = sizeof(prec->onvd);
    prt->papFldDes[aSubRecordONVE]->size = sizeof(prec->onve);
    prt->papFldDes[aSubRecordONVF]->size = sizeof(prec->onvf);
    prt->papFldDes[aSubRecordONVG]->size = sizeof(prec->onvg);
    prt->papFldDes[aSubRecordONVH]->size = sizeof(prec->onvh);
    prt->papFldDes[aSubRecordONVI]->size = sizeof(prec->onvi);
    prt->papFldDes[aSubRecordONVJ]->size = sizeof(prec->onvj);
    prt->papFldDes[aSubRecordONVK]->size = sizeof(prec->onvk);
    prt->papFldDes[aSubRecordONVL]->size = sizeof(prec->onvl);
    prt->papFldDes[aSubRecordONVM]->size = sizeof(prec->onvm);
    prt->papFldDes[aSubRecordONVN]->size = sizeof(prec->onvn);
    prt->papFldDes[aSubRecordONVO]->size = sizeof(prec->onvo);
    prt->papFldDes[aSubRecordONVP]->size = sizeof(prec->onvp);
    prt->papFldDes[aSubRecordONVQ]->size = sizeof(prec->onvq);
    prt->papFldDes[aSubRecordONVR]->size = sizeof(prec->onvr);
    prt->papFldDes[aSubRecordONVS]->size = sizeof(prec->onvs);
    prt->papFldDes[aSubRecordONVT]->size = sizeof(prec->onvt);
    prt->papFldDes[aSubRecordONVU]->size = sizeof(prec->onvu);
    prt->papFldDes[aSubRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[aSubRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[aSubRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[aSubRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[aSubRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[aSubRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[aSubRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[aSubRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[aSubRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[aSubRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[aSubRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[aSubRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[aSubRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[aSubRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[aSubRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[aSubRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[aSubRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[aSubRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[aSubRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[aSubRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[aSubRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[aSubRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[aSubRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[aSubRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[aSubRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[aSubRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[aSubRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[aSubRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[aSubRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[aSubRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[aSubRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[aSubRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[aSubRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[aSubRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[aSubRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[aSubRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[aSubRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[aSubRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[aSubRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[aSubRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[aSubRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[aSubRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[aSubRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[aSubRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[aSubRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[aSubRecordOVAL]->offset = (unsigned short)((char *)&prec->oval - (char *)prec);
    prt->papFldDes[aSubRecordINAM]->offset = (unsigned short)((char *)&prec->inam - (char *)prec);
    prt->papFldDes[aSubRecordLFLG]->offset = (unsigned short)((char *)&prec->lflg - (char *)prec);
    prt->papFldDes[aSubRecordSUBL]->offset = (unsigned short)((char *)&prec->subl - (char *)prec);
    prt->papFldDes[aSubRecordSNAM]->offset = (unsigned short)((char *)&prec->snam - (char *)prec);
    prt->papFldDes[aSubRecordONAM]->offset = (unsigned short)((char *)&prec->onam - (char *)prec);
    prt->papFldDes[aSubRecordSADR]->offset = (unsigned short)((char *)&prec->sadr - (char *)prec);
    prt->papFldDes[aSubRecordCADR]->offset = (unsigned short)((char *)&prec->cadr - (char *)prec);
    prt->papFldDes[aSubRecordBRSV]->offset = (unsigned short)((char *)&prec->brsv - (char *)prec);
    prt->papFldDes[aSubRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[aSubRecordEFLG]->offset = (unsigned short)((char *)&prec->eflg - (char *)prec);
    prt->papFldDes[aSubRecordINPA]->offset = (unsigned short)((char *)&prec->inpa - (char *)prec);
    prt->papFldDes[aSubRecordINPB]->offset = (unsigned short)((char *)&prec->inpb - (char *)prec);
    prt->papFldDes[aSubRecordINPC]->offset = (unsigned short)((char *)&prec->inpc - (char *)prec);
    prt->papFldDes[aSubRecordINPD]->offset = (unsigned short)((char *)&prec->inpd - (char *)prec);
    prt->papFldDes[aSubRecordINPE]->offset = (unsigned short)((char *)&prec->inpe - (char *)prec);
    prt->papFldDes[aSubRecordINPF]->offset = (unsigned short)((char *)&prec->inpf - (char *)prec);
    prt->papFldDes[aSubRecordINPG]->offset = (unsigned short)((char *)&prec->inpg - (char *)prec);
    prt->papFldDes[aSubRecordINPH]->offset = (unsigned short)((char *)&prec->inph - (char *)prec);
    prt->papFldDes[aSubRecordINPI]->offset = (unsigned short)((char *)&prec->inpi - (char *)prec);
    prt->papFldDes[aSubRecordINPJ]->offset = (unsigned short)((char *)&prec->inpj - (char *)prec);
    prt->papFldDes[aSubRecordINPK]->offset = (unsigned short)((char *)&prec->inpk - (char *)prec);
    prt->papFldDes[aSubRecordINPL]->offset = (unsigned short)((char *)&prec->inpl - (char *)prec);
    prt->papFldDes[aSubRecordINPM]->offset = (unsigned short)((char *)&prec->inpm - (char *)prec);
    prt->papFldDes[aSubRecordINPN]->offset = (unsigned short)((char *)&prec->inpn - (char *)prec);
    prt->papFldDes[aSubRecordINPO]->offset = (unsigned short)((char *)&prec->inpo - (char *)prec);
    prt->papFldDes[aSubRecordINPP]->offset = (unsigned short)((char *)&prec->inpp - (char *)prec);
    prt->papFldDes[aSubRecordINPQ]->offset = (unsigned short)((char *)&prec->inpq - (char *)prec);
    prt->papFldDes[aSubRecordINPR]->offset = (unsigned short)((char *)&prec->inpr - (char *)prec);
    prt->papFldDes[aSubRecordINPS]->offset = (unsigned short)((char *)&prec->inps - (char *)prec);
    prt->papFldDes[aSubRecordINPT]->offset = (unsigned short)((char *)&prec->inpt - (char *)prec);
    prt->papFldDes[aSubRecordINPU]->offset = (unsigned short)((char *)&prec->inpu - (char *)prec);
    prt->papFldDes[aSubRecordA]->offset = (unsigned short)((char *)&prec->a - (char *)prec);
    prt->papFldDes[aSubRecordB]->offset = (unsigned short)((char *)&prec->b - (char *)prec);
    prt->papFldDes[aSubRecordC]->offset = (unsigned short)((char *)&prec->c - (char *)prec);
    prt->papFldDes[aSubRecordD]->offset = (unsigned short)((char *)&prec->d - (char *)prec);
    prt->papFldDes[aSubRecordE]->offset = (unsigned short)((char *)&prec->e - (char *)prec);
    prt->papFldDes[aSubRecordF]->offset = (unsigned short)((char *)&prec->f - (char *)prec);
    prt->papFldDes[aSubRecordG]->offset = (unsigned short)((char *)&prec->g - (char *)prec);
    prt->papFldDes[aSubRecordH]->offset = (unsigned short)((char *)&prec->h - (char *)prec);
    prt->papFldDes[aSubRecordI]->offset = (unsigned short)((char *)&prec->i - (char *)prec);
    prt->papFldDes[aSubRecordJ]->offset = (unsigned short)((char *)&prec->j - (char *)prec);
    prt->papFldDes[aSubRecordK]->offset = (unsigned short)((char *)&prec->k - (char *)prec);
    prt->papFldDes[aSubRecordL]->offset = (unsigned short)((char *)&prec->l - (char *)prec);
    prt->papFldDes[aSubRecordM]->offset = (unsigned short)((char *)&prec->m - (char *)prec);
    prt->papFldDes[aSubRecordN]->offset = (unsigned short)((char *)&prec->n - (char *)prec);
    prt->papFldDes[aSubRecordO]->offset = (unsigned short)((char *)&prec->o - (char *)prec);
    prt->papFldDes[aSubRecordP]->offset = (unsigned short)((char *)&prec->p - (char *)prec);
    prt->papFldDes[aSubRecordQ]->offset = (unsigned short)((char *)&prec->q - (char *)prec);
    prt->papFldDes[aSubRecordR]->offset = (unsigned short)((char *)&prec->r - (char *)prec);
    prt->papFldDes[aSubRecordS]->offset = (unsigned short)((char *)&prec->s - (char *)prec);
    prt->papFldDes[aSubRecordT]->offset = (unsigned short)((char *)&prec->t - (char *)prec);
    prt->papFldDes[aSubRecordU]->offset = (unsigned short)((char *)&prec->u - (char *)prec);
    prt->papFldDes[aSubRecordFTA]->offset = (unsigned short)((char *)&prec->fta - (char *)prec);
    prt->papFldDes[aSubRecordFTB]->offset = (unsigned short)((char *)&prec->ftb - (char *)prec);
    prt->papFldDes[aSubRecordFTC]->offset = (unsigned short)((char *)&prec->ftc - (char *)prec);
    prt->papFldDes[aSubRecordFTD]->offset = (unsigned short)((char *)&prec->ftd - (char *)prec);
    prt->papFldDes[aSubRecordFTE]->offset = (unsigned short)((char *)&prec->fte - (char *)prec);
    prt->papFldDes[aSubRecordFTF]->offset = (unsigned short)((char *)&prec->ftf - (char *)prec);
    prt->papFldDes[aSubRecordFTG]->offset = (unsigned short)((char *)&prec->ftg - (char *)prec);
    prt->papFldDes[aSubRecordFTH]->offset = (unsigned short)((char *)&prec->fth - (char *)prec);
    prt->papFldDes[aSubRecordFTI]->offset = (unsigned short)((char *)&prec->fti - (char *)prec);
    prt->papFldDes[aSubRecordFTJ]->offset = (unsigned short)((char *)&prec->ftj - (char *)prec);
    prt->papFldDes[aSubRecordFTK]->offset = (unsigned short)((char *)&prec->ftk - (char *)prec);
    prt->papFldDes[aSubRecordFTL]->offset = (unsigned short)((char *)&prec->ftl - (char *)prec);
    prt->papFldDes[aSubRecordFTM]->offset = (unsigned short)((char *)&prec->ftm - (char *)prec);
    prt->papFldDes[aSubRecordFTN]->offset = (unsigned short)((char *)&prec->ftn - (char *)prec);
    prt->papFldDes[aSubRecordFTO]->offset = (unsigned short)((char *)&prec->fto - (char *)prec);
    prt->papFldDes[aSubRecordFTP]->offset = (unsigned short)((char *)&prec->ftp - (char *)prec);
    prt->papFldDes[aSubRecordFTQ]->offset = (unsigned short)((char *)&prec->ftq - (char *)prec);
    prt->papFldDes[aSubRecordFTR]->offset = (unsigned short)((char *)&prec->ftr - (char *)prec);
    prt->papFldDes[aSubRecordFTS]->offset = (unsigned short)((char *)&prec->fts - (char *)prec);
    prt->papFldDes[aSubRecordFTT]->offset = (unsigned short)((char *)&prec->ftt - (char *)prec);
    prt->papFldDes[aSubRecordFTU]->offset = (unsigned short)((char *)&prec->ftu - (char *)prec);
    prt->papFldDes[aSubRecordNOA]->offset = (unsigned short)((char *)&prec->noa - (char *)prec);
    prt->papFldDes[aSubRecordNOB]->offset = (unsigned short)((char *)&prec->nob - (char *)prec);
    prt->papFldDes[aSubRecordNOC]->offset = (unsigned short)((char *)&prec->noc - (char *)prec);
    prt->papFldDes[aSubRecordNOD]->offset = (unsigned short)((char *)&prec->nod - (char *)prec);
    prt->papFldDes[aSubRecordNOE]->offset = (unsigned short)((char *)&prec->noe - (char *)prec);
    prt->papFldDes[aSubRecordNOF]->offset = (unsigned short)((char *)&prec->nof - (char *)prec);
    prt->papFldDes[aSubRecordNOG]->offset = (unsigned short)((char *)&prec->nog - (char *)prec);
    prt->papFldDes[aSubRecordNOH]->offset = (unsigned short)((char *)&prec->noh - (char *)prec);
    prt->papFldDes[aSubRecordNOI]->offset = (unsigned short)((char *)&prec->noi - (char *)prec);
    prt->papFldDes[aSubRecordNOJ]->offset = (unsigned short)((char *)&prec->noj - (char *)prec);
    prt->papFldDes[aSubRecordNOK]->offset = (unsigned short)((char *)&prec->nok - (char *)prec);
    prt->papFldDes[aSubRecordNOL]->offset = (unsigned short)((char *)&prec->nol - (char *)prec);
    prt->papFldDes[aSubRecordNOM]->offset = (unsigned short)((char *)&prec->nom - (char *)prec);
    prt->papFldDes[aSubRecordNON]->offset = (unsigned short)((char *)&prec->non - (char *)prec);
    prt->papFldDes[aSubRecordNOO]->offset = (unsigned short)((char *)&prec->noo - (char *)prec);
    prt->papFldDes[aSubRecordNOP]->offset = (unsigned short)((char *)&prec->nop - (char *)prec);
    prt->papFldDes[aSubRecordNOQ]->offset = (unsigned short)((char *)&prec->noq - (char *)prec);
    prt->papFldDes[aSubRecordNOR]->offset = (unsigned short)((char *)&prec->nor - (char *)prec);
    prt->papFldDes[aSubRecordNOS]->offset = (unsigned short)((char *)&prec->nos - (char *)prec);
    prt->papFldDes[aSubRecordNOT]->offset = (unsigned short)((char *)&prec->NOT - (char *)prec);
    prt->papFldDes[aSubRecordNOU]->offset = (unsigned short)((char *)&prec->nou - (char *)prec);
    prt->papFldDes[aSubRecordNEA]->offset = (unsigned short)((char *)&prec->nea - (char *)prec);
    prt->papFldDes[aSubRecordNEB]->offset = (unsigned short)((char *)&prec->neb - (char *)prec);
    prt->papFldDes[aSubRecordNEC]->offset = (unsigned short)((char *)&prec->nec - (char *)prec);
    prt->papFldDes[aSubRecordNED]->offset = (unsigned short)((char *)&prec->ned - (char *)prec);
    prt->papFldDes[aSubRecordNEE]->offset = (unsigned short)((char *)&prec->nee - (char *)prec);
    prt->papFldDes[aSubRecordNEF]->offset = (unsigned short)((char *)&prec->nef - (char *)prec);
    prt->papFldDes[aSubRecordNEG]->offset = (unsigned short)((char *)&prec->neg - (char *)prec);
    prt->papFldDes[aSubRecordNEH]->offset = (unsigned short)((char *)&prec->neh - (char *)prec);
    prt->papFldDes[aSubRecordNEI]->offset = (unsigned short)((char *)&prec->nei - (char *)prec);
    prt->papFldDes[aSubRecordNEJ]->offset = (unsigned short)((char *)&prec->nej - (char *)prec);
    prt->papFldDes[aSubRecordNEK]->offset = (unsigned short)((char *)&prec->nek - (char *)prec);
    prt->papFldDes[aSubRecordNEL]->offset = (unsigned short)((char *)&prec->nel - (char *)prec);
    prt->papFldDes[aSubRecordNEM]->offset = (unsigned short)((char *)&prec->nem - (char *)prec);
    prt->papFldDes[aSubRecordNEN]->offset = (unsigned short)((char *)&prec->nen - (char *)prec);
    prt->papFldDes[aSubRecordNEO]->offset = (unsigned short)((char *)&prec->neo - (char *)prec);
    prt->papFldDes[aSubRecordNEP]->offset = (unsigned short)((char *)&prec->nep - (char *)prec);
    prt->papFldDes[aSubRecordNEQ]->offset = (unsigned short)((char *)&prec->neq - (char *)prec);
    prt->papFldDes[aSubRecordNER]->offset = (unsigned short)((char *)&prec->ner - (char *)prec);
    prt->papFldDes[aSubRecordNES]->offset = (unsigned short)((char *)&prec->nes - (char *)prec);
    prt->papFldDes[aSubRecordNET]->offset = (unsigned short)((char *)&prec->net - (char *)prec);
    prt->papFldDes[aSubRecordNEU]->offset = (unsigned short)((char *)&prec->neu - (char *)prec);
    prt->papFldDes[aSubRecordOUTA]->offset = (unsigned short)((char *)&prec->outa - (char *)prec);
    prt->papFldDes[aSubRecordOUTB]->offset = (unsigned short)((char *)&prec->outb - (char *)prec);
    prt->papFldDes[aSubRecordOUTC]->offset = (unsigned short)((char *)&prec->outc - (char *)prec);
    prt->papFldDes[aSubRecordOUTD]->offset = (unsigned short)((char *)&prec->outd - (char *)prec);
    prt->papFldDes[aSubRecordOUTE]->offset = (unsigned short)((char *)&prec->oute - (char *)prec);
    prt->papFldDes[aSubRecordOUTF]->offset = (unsigned short)((char *)&prec->outf - (char *)prec);
    prt->papFldDes[aSubRecordOUTG]->offset = (unsigned short)((char *)&prec->outg - (char *)prec);
    prt->papFldDes[aSubRecordOUTH]->offset = (unsigned short)((char *)&prec->outh - (char *)prec);
    prt->papFldDes[aSubRecordOUTI]->offset = (unsigned short)((char *)&prec->outi - (char *)prec);
    prt->papFldDes[aSubRecordOUTJ]->offset = (unsigned short)((char *)&prec->outj - (char *)prec);
    prt->papFldDes[aSubRecordOUTK]->offset = (unsigned short)((char *)&prec->outk - (char *)prec);
    prt->papFldDes[aSubRecordOUTL]->offset = (unsigned short)((char *)&prec->outl - (char *)prec);
    prt->papFldDes[aSubRecordOUTM]->offset = (unsigned short)((char *)&prec->outm - (char *)prec);
    prt->papFldDes[aSubRecordOUTN]->offset = (unsigned short)((char *)&prec->outn - (char *)prec);
    prt->papFldDes[aSubRecordOUTO]->offset = (unsigned short)((char *)&prec->outo - (char *)prec);
    prt->papFldDes[aSubRecordOUTP]->offset = (unsigned short)((char *)&prec->outp - (char *)prec);
    prt->papFldDes[aSubRecordOUTQ]->offset = (unsigned short)((char *)&prec->outq - (char *)prec);
    prt->papFldDes[aSubRecordOUTR]->offset = (unsigned short)((char *)&prec->outr - (char *)prec);
    prt->papFldDes[aSubRecordOUTS]->offset = (unsigned short)((char *)&prec->outs - (char *)prec);
    prt->papFldDes[aSubRecordOUTT]->offset = (unsigned short)((char *)&prec->outt - (char *)prec);
    prt->papFldDes[aSubRecordOUTU]->offset = (unsigned short)((char *)&prec->outu - (char *)prec);
    prt->papFldDes[aSubRecordVALA]->offset = (unsigned short)((char *)&prec->vala - (char *)prec);
    prt->papFldDes[aSubRecordVALB]->offset = (unsigned short)((char *)&prec->valb - (char *)prec);
    prt->papFldDes[aSubRecordVALC]->offset = (unsigned short)((char *)&prec->valc - (char *)prec);
    prt->papFldDes[aSubRecordVALD]->offset = (unsigned short)((char *)&prec->vald - (char *)prec);
    prt->papFldDes[aSubRecordVALE]->offset = (unsigned short)((char *)&prec->vale - (char *)prec);
    prt->papFldDes[aSubRecordVALF]->offset = (unsigned short)((char *)&prec->valf - (char *)prec);
    prt->papFldDes[aSubRecordVALG]->offset = (unsigned short)((char *)&prec->valg - (char *)prec);
    prt->papFldDes[aSubRecordVALH]->offset = (unsigned short)((char *)&prec->valh - (char *)prec);
    prt->papFldDes[aSubRecordVALI]->offset = (unsigned short)((char *)&prec->vali - (char *)prec);
    prt->papFldDes[aSubRecordVALJ]->offset = (unsigned short)((char *)&prec->valj - (char *)prec);
    prt->papFldDes[aSubRecordVALK]->offset = (unsigned short)((char *)&prec->valk - (char *)prec);
    prt->papFldDes[aSubRecordVALL]->offset = (unsigned short)((char *)&prec->vall - (char *)prec);
    prt->papFldDes[aSubRecordVALM]->offset = (unsigned short)((char *)&prec->valm - (char *)prec);
    prt->papFldDes[aSubRecordVALN]->offset = (unsigned short)((char *)&prec->valn - (char *)prec);
    prt->papFldDes[aSubRecordVALO]->offset = (unsigned short)((char *)&prec->valo - (char *)prec);
    prt->papFldDes[aSubRecordVALP]->offset = (unsigned short)((char *)&prec->valp - (char *)prec);
    prt->papFldDes[aSubRecordVALQ]->offset = (unsigned short)((char *)&prec->valq - (char *)prec);
    prt->papFldDes[aSubRecordVALR]->offset = (unsigned short)((char *)&prec->valr - (char *)prec);
    prt->papFldDes[aSubRecordVALS]->offset = (unsigned short)((char *)&prec->vals - (char *)prec);
    prt->papFldDes[aSubRecordVALT]->offset = (unsigned short)((char *)&prec->valt - (char *)prec);
    prt->papFldDes[aSubRecordVALU]->offset = (unsigned short)((char *)&prec->valu - (char *)prec);
    prt->papFldDes[aSubRecordOVLA]->offset = (unsigned short)((char *)&prec->ovla - (char *)prec);
    prt->papFldDes[aSubRecordOVLB]->offset = (unsigned short)((char *)&prec->ovlb - (char *)prec);
    prt->papFldDes[aSubRecordOVLC]->offset = (unsigned short)((char *)&prec->ovlc - (char *)prec);
    prt->papFldDes[aSubRecordOVLD]->offset = (unsigned short)((char *)&prec->ovld - (char *)prec);
    prt->papFldDes[aSubRecordOVLE]->offset = (unsigned short)((char *)&prec->ovle - (char *)prec);
    prt->papFldDes[aSubRecordOVLF]->offset = (unsigned short)((char *)&prec->ovlf - (char *)prec);
    prt->papFldDes[aSubRecordOVLG]->offset = (unsigned short)((char *)&prec->ovlg - (char *)prec);
    prt->papFldDes[aSubRecordOVLH]->offset = (unsigned short)((char *)&prec->ovlh - (char *)prec);
    prt->papFldDes[aSubRecordOVLI]->offset = (unsigned short)((char *)&prec->ovli - (char *)prec);
    prt->papFldDes[aSubRecordOVLJ]->offset = (unsigned short)((char *)&prec->ovlj - (char *)prec);
    prt->papFldDes[aSubRecordOVLK]->offset = (unsigned short)((char *)&prec->ovlk - (char *)prec);
    prt->papFldDes[aSubRecordOVLL]->offset = (unsigned short)((char *)&prec->ovll - (char *)prec);
    prt->papFldDes[aSubRecordOVLM]->offset = (unsigned short)((char *)&prec->ovlm - (char *)prec);
    prt->papFldDes[aSubRecordOVLN]->offset = (unsigned short)((char *)&prec->ovln - (char *)prec);
    prt->papFldDes[aSubRecordOVLO]->offset = (unsigned short)((char *)&prec->ovlo - (char *)prec);
    prt->papFldDes[aSubRecordOVLP]->offset = (unsigned short)((char *)&prec->ovlp - (char *)prec);
    prt->papFldDes[aSubRecordOVLQ]->offset = (unsigned short)((char *)&prec->ovlq - (char *)prec);
    prt->papFldDes[aSubRecordOVLR]->offset = (unsigned short)((char *)&prec->ovlr - (char *)prec);
    prt->papFldDes[aSubRecordOVLS]->offset = (unsigned short)((char *)&prec->ovls - (char *)prec);
    prt->papFldDes[aSubRecordOVLT]->offset = (unsigned short)((char *)&prec->ovlt - (char *)prec);
    prt->papFldDes[aSubRecordOVLU]->offset = (unsigned short)((char *)&prec->ovlu - (char *)prec);
    prt->papFldDes[aSubRecordFTVA]->offset = (unsigned short)((char *)&prec->ftva - (char *)prec);
    prt->papFldDes[aSubRecordFTVB]->offset = (unsigned short)((char *)&prec->ftvb - (char *)prec);
    prt->papFldDes[aSubRecordFTVC]->offset = (unsigned short)((char *)&prec->ftvc - (char *)prec);
    prt->papFldDes[aSubRecordFTVD]->offset = (unsigned short)((char *)&prec->ftvd - (char *)prec);
    prt->papFldDes[aSubRecordFTVE]->offset = (unsigned short)((char *)&prec->ftve - (char *)prec);
    prt->papFldDes[aSubRecordFTVF]->offset = (unsigned short)((char *)&prec->ftvf - (char *)prec);
    prt->papFldDes[aSubRecordFTVG]->offset = (unsigned short)((char *)&prec->ftvg - (char *)prec);
    prt->papFldDes[aSubRecordFTVH]->offset = (unsigned short)((char *)&prec->ftvh - (char *)prec);
    prt->papFldDes[aSubRecordFTVI]->offset = (unsigned short)((char *)&prec->ftvi - (char *)prec);
    prt->papFldDes[aSubRecordFTVJ]->offset = (unsigned short)((char *)&prec->ftvj - (char *)prec);
    prt->papFldDes[aSubRecordFTVK]->offset = (unsigned short)((char *)&prec->ftvk - (char *)prec);
    prt->papFldDes[aSubRecordFTVL]->offset = (unsigned short)((char *)&prec->ftvl - (char *)prec);
    prt->papFldDes[aSubRecordFTVM]->offset = (unsigned short)((char *)&prec->ftvm - (char *)prec);
    prt->papFldDes[aSubRecordFTVN]->offset = (unsigned short)((char *)&prec->ftvn - (char *)prec);
    prt->papFldDes[aSubRecordFTVO]->offset = (unsigned short)((char *)&prec->ftvo - (char *)prec);
    prt->papFldDes[aSubRecordFTVP]->offset = (unsigned short)((char *)&prec->ftvp - (char *)prec);
    prt->papFldDes[aSubRecordFTVQ]->offset = (unsigned short)((char *)&prec->ftvq - (char *)prec);
    prt->papFldDes[aSubRecordFTVR]->offset = (unsigned short)((char *)&prec->ftvr - (char *)prec);
    prt->papFldDes[aSubRecordFTVS]->offset = (unsigned short)((char *)&prec->ftvs - (char *)prec);
    prt->papFldDes[aSubRecordFTVT]->offset = (unsigned short)((char *)&prec->ftvt - (char *)prec);
    prt->papFldDes[aSubRecordFTVU]->offset = (unsigned short)((char *)&prec->ftvu - (char *)prec);
    prt->papFldDes[aSubRecordNOVA]->offset = (unsigned short)((char *)&prec->nova - (char *)prec);
    prt->papFldDes[aSubRecordNOVB]->offset = (unsigned short)((char *)&prec->novb - (char *)prec);
    prt->papFldDes[aSubRecordNOVC]->offset = (unsigned short)((char *)&prec->novc - (char *)prec);
    prt->papFldDes[aSubRecordNOVD]->offset = (unsigned short)((char *)&prec->novd - (char *)prec);
    prt->papFldDes[aSubRecordNOVE]->offset = (unsigned short)((char *)&prec->nove - (char *)prec);
    prt->papFldDes[aSubRecordNOVF]->offset = (unsigned short)((char *)&prec->novf - (char *)prec);
    prt->papFldDes[aSubRecordNOVG]->offset = (unsigned short)((char *)&prec->novg - (char *)prec);
    prt->papFldDes[aSubRecordNOVH]->offset = (unsigned short)((char *)&prec->novh - (char *)prec);
    prt->papFldDes[aSubRecordNOVI]->offset = (unsigned short)((char *)&prec->novi - (char *)prec);
    prt->papFldDes[aSubRecordNOVJ]->offset = (unsigned short)((char *)&prec->novj - (char *)prec);
    prt->papFldDes[aSubRecordNOVK]->offset = (unsigned short)((char *)&prec->novk - (char *)prec);
    prt->papFldDes[aSubRecordNOVL]->offset = (unsigned short)((char *)&prec->novl - (char *)prec);
    prt->papFldDes[aSubRecordNOVM]->offset = (unsigned short)((char *)&prec->novm - (char *)prec);
    prt->papFldDes[aSubRecordNOVN]->offset = (unsigned short)((char *)&prec->novn - (char *)prec);
    prt->papFldDes[aSubRecordNOVO]->offset = (unsigned short)((char *)&prec->novo - (char *)prec);
    prt->papFldDes[aSubRecordNOVP]->offset = (unsigned short)((char *)&prec->novp - (char *)prec);
    prt->papFldDes[aSubRecordNOVQ]->offset = (unsigned short)((char *)&prec->novq - (char *)prec);
    prt->papFldDes[aSubRecordNOVR]->offset = (unsigned short)((char *)&prec->novr - (char *)prec);
    prt->papFldDes[aSubRecordNOVS]->offset = (unsigned short)((char *)&prec->novs - (char *)prec);
    prt->papFldDes[aSubRecordNOVT]->offset = (unsigned short)((char *)&prec->novt - (char *)prec);
    prt->papFldDes[aSubRecordNOVU]->offset = (unsigned short)((char *)&prec->novu - (char *)prec);
    prt->papFldDes[aSubRecordNEVA]->offset = (unsigned short)((char *)&prec->neva - (char *)prec);
    prt->papFldDes[aSubRecordNEVB]->offset = (unsigned short)((char *)&prec->nevb - (char *)prec);
    prt->papFldDes[aSubRecordNEVC]->offset = (unsigned short)((char *)&prec->nevc - (char *)prec);
    prt->papFldDes[aSubRecordNEVD]->offset = (unsigned short)((char *)&prec->nevd - (char *)prec);
    prt->papFldDes[aSubRecordNEVE]->offset = (unsigned short)((char *)&prec->neve - (char *)prec);
    prt->papFldDes[aSubRecordNEVF]->offset = (unsigned short)((char *)&prec->nevf - (char *)prec);
    prt->papFldDes[aSubRecordNEVG]->offset = (unsigned short)((char *)&prec->nevg - (char *)prec);
    prt->papFldDes[aSubRecordNEVH]->offset = (unsigned short)((char *)&prec->nevh - (char *)prec);
    prt->papFldDes[aSubRecordNEVI]->offset = (unsigned short)((char *)&prec->nevi - (char *)prec);
    prt->papFldDes[aSubRecordNEVJ]->offset = (unsigned short)((char *)&prec->nevj - (char *)prec);
    prt->papFldDes[aSubRecordNEVK]->offset = (unsigned short)((char *)&prec->nevk - (char *)prec);
    prt->papFldDes[aSubRecordNEVL]->offset = (unsigned short)((char *)&prec->nevl - (char *)prec);
    prt->papFldDes[aSubRecordNEVM]->offset = (unsigned short)((char *)&prec->nevm - (char *)prec);
    prt->papFldDes[aSubRecordNEVN]->offset = (unsigned short)((char *)&prec->nevn - (char *)prec);
    prt->papFldDes[aSubRecordNEVO]->offset = (unsigned short)((char *)&prec->nevo - (char *)prec);
    prt->papFldDes[aSubRecordNEVP]->offset = (unsigned short)((char *)&prec->nevp - (char *)prec);
    prt->papFldDes[aSubRecordNEVQ]->offset = (unsigned short)((char *)&prec->nevq - (char *)prec);
    prt->papFldDes[aSubRecordNEVR]->offset = (unsigned short)((char *)&prec->nevr - (char *)prec);
    prt->papFldDes[aSubRecordNEVS]->offset = (unsigned short)((char *)&prec->nevs - (char *)prec);
    prt->papFldDes[aSubRecordNEVT]->offset = (unsigned short)((char *)&prec->nevt - (char *)prec);
    prt->papFldDes[aSubRecordNEVU]->offset = (unsigned short)((char *)&prec->nevu - (char *)prec);
    prt->papFldDes[aSubRecordONVA]->offset = (unsigned short)((char *)&prec->onva - (char *)prec);
    prt->papFldDes[aSubRecordONVB]->offset = (unsigned short)((char *)&prec->onvb - (char *)prec);
    prt->papFldDes[aSubRecordONVC]->offset = (unsigned short)((char *)&prec->onvc - (char *)prec);
    prt->papFldDes[aSubRecordONVD]->offset = (unsigned short)((char *)&prec->onvd - (char *)prec);
    prt->papFldDes[aSubRecordONVE]->offset = (unsigned short)((char *)&prec->onve - (char *)prec);
    prt->papFldDes[aSubRecordONVF]->offset = (unsigned short)((char *)&prec->onvf - (char *)prec);
    prt->papFldDes[aSubRecordONVG]->offset = (unsigned short)((char *)&prec->onvg - (char *)prec);
    prt->papFldDes[aSubRecordONVH]->offset = (unsigned short)((char *)&prec->onvh - (char *)prec);
    prt->papFldDes[aSubRecordONVI]->offset = (unsigned short)((char *)&prec->onvi - (char *)prec);
    prt->papFldDes[aSubRecordONVJ]->offset = (unsigned short)((char *)&prec->onvj - (char *)prec);
    prt->papFldDes[aSubRecordONVK]->offset = (unsigned short)((char *)&prec->onvk - (char *)prec);
    prt->papFldDes[aSubRecordONVL]->offset = (unsigned short)((char *)&prec->onvl - (char *)prec);
    prt->papFldDes[aSubRecordONVM]->offset = (unsigned short)((char *)&prec->onvm - (char *)prec);
    prt->papFldDes[aSubRecordONVN]->offset = (unsigned short)((char *)&prec->onvn - (char *)prec);
    prt->papFldDes[aSubRecordONVO]->offset = (unsigned short)((char *)&prec->onvo - (char *)prec);
    prt->papFldDes[aSubRecordONVP]->offset = (unsigned short)((char *)&prec->onvp - (char *)prec);
    prt->papFldDes[aSubRecordONVQ]->offset = (unsigned short)((char *)&prec->onvq - (char *)prec);
    prt->papFldDes[aSubRecordONVR]->offset = (unsigned short)((char *)&prec->onvr - (char *)prec);
    prt->papFldDes[aSubRecordONVS]->offset = (unsigned short)((char *)&prec->onvs - (char *)prec);
    prt->papFldDes[aSubRecordONVT]->offset = (unsigned short)((char *)&prec->onvt - (char *)prec);
    prt->papFldDes[aSubRecordONVU]->offset = (unsigned short)((char *)&prec->onvu - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(aSubRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_aSubRecord_H */
