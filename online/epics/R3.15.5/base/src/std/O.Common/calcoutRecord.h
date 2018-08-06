/* calcoutRecord.h generated from calcoutRecord.dbd */

#ifndef INC_calcoutRecord_H
#define INC_calcoutRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"
#include "dbScan.h"
#include "postfix.h"

typedef enum {
    calcoutINAV_EXT_NC              /* Ext PV NC */,
    calcoutINAV_EXT                 /* Ext PV OK */,
    calcoutINAV_LOC                 /* Local PV */,
    calcoutINAV_CON                 /* Constant */
} calcoutINAV;
#define calcoutINAV_NUM_CHOICES 4

typedef enum {
    calcoutDOPT_Use_VAL             /* Use CALC */,
    calcoutDOPT_Use_OVAL            /* Use OCAL */
} calcoutDOPT;
#define calcoutDOPT_NUM_CHOICES 2

typedef enum {
    calcoutOOPT_Every_Time          /* Every Time */,
    calcoutOOPT_On_Change           /* On Change */,
    calcoutOOPT_When_Zero           /* When Zero */,
    calcoutOOPT_When_Non_zero       /* When Non-zero */,
    calcoutOOPT_Transition_To_Zero  /* Transition To Zero */,
    calcoutOOPT_Transition_To_Non_zero /* Transition To Non-zero */
} calcoutOOPT;
#define calcoutOOPT_NUM_CHOICES 6

typedef struct calcoutRecord {
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
    struct rpvtStruct *rpvt;        /* Record Private */
    epicsFloat64        val;        /* Result */
    epicsFloat64        pval;       /* Previous Value */
    char                calc[80];   /* Calculation */
    epicsInt32          clcv;       /* CALC Valid */
    DBLINK              inpa;       /* Input A */
    DBLINK              inpb;       /* Input B */
    DBLINK              inpc;       /* Input C */
    DBLINK              inpd;       /* Input D */
    DBLINK              inpe;       /* Input E */
    DBLINK              inpf;       /* Input F */
    DBLINK              inpg;       /* Input G */
    DBLINK              inph;       /* Input H */
    DBLINK              inpi;       /* Input I */
    DBLINK              inpj;       /* Input J */
    DBLINK              inpk;       /* Input K */
    DBLINK              inpl;       /* Input L */
    DBLINK              out;        /* Output Specification */
    epicsEnum16         inav;       /* INPA PV Status */
    epicsEnum16         inbv;       /* INPB PV Status */
    epicsEnum16         incv;       /* INPC PV Status */
    epicsEnum16         indv;       /* INPD PV Status */
    epicsEnum16         inev;       /* INPE PV Status */
    epicsEnum16         infv;       /* INPF PV Status */
    epicsEnum16         ingv;       /* INPG PV Status */
    epicsEnum16         inhv;       /* INPH PV Status */
    epicsEnum16         iniv;       /* INPI PV Status */
    epicsEnum16         injv;       /* INPJ PV Status */
    epicsEnum16         inkv;       /* INPK PV Status */
    epicsEnum16         inlv;       /* INPL PV Status */
    epicsEnum16         outv;       /* OUT PV Status */
    epicsEnum16         oopt;       /* Output Execute Opt */
    epicsFloat64        odly;       /* Output Execute Delay */
    epicsUInt16         dlya;       /* Output Delay Active */
    epicsEnum16         dopt;       /* Output Data Opt */
    char                ocal[80];   /* Output Calculation */
    epicsInt32          oclv;       /* OCAL Valid */
    char                oevt[40];   /* Event To Issue */
    EVENTPVT epvt;                  /* Event private */
    epicsEnum16         ivoa;       /* INVALID output action */
    epicsFloat64        ivov;       /* INVALID output value */
    char                egu[16];    /* Engineering Units */
    epicsInt16          prec;       /* Display Precision */
    epicsFloat64        hopr;       /* High Operating Rng */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsFloat64        hihi;       /* Hihi Alarm Limit */
    epicsFloat64        lolo;       /* Lolo Alarm Limit */
    epicsFloat64        high;       /* High Alarm Limit */
    epicsFloat64        low;        /* Low Alarm Limit */
    epicsEnum16         hhsv;       /* Hihi Severity */
    epicsEnum16         llsv;       /* Lolo Severity */
    epicsEnum16         hsv;        /* High Severity */
    epicsEnum16         lsv;        /* Low Severity */
    epicsFloat64        hyst;       /* Alarm Deadband */
    epicsFloat64        adel;       /* Archive Deadband */
    epicsFloat64        mdel;       /* Monitor Deadband */
    epicsFloat64        a;          /* Value of Input A */
    epicsFloat64        b;          /* Value of Input B */
    epicsFloat64        c;          /* Value of Input C */
    epicsFloat64        d;          /* Value of Input D */
    epicsFloat64        e;          /* Value of Input E */
    epicsFloat64        f;          /* Value of Input F */
    epicsFloat64        g;          /* Value of Input G */
    epicsFloat64        h;          /* Value of Input H */
    epicsFloat64        i;          /* Value of Input I */
    epicsFloat64        j;          /* Value of Input J */
    epicsFloat64        k;          /* Value of Input K */
    epicsFloat64        l;          /* Value of Input L */
    epicsFloat64        oval;       /* Output Value */
    epicsFloat64        la;         /* Prev Value of A */
    epicsFloat64        lb;         /* Prev Value of B */
    epicsFloat64        lc;         /* Prev Value of C */
    epicsFloat64        ld;         /* Prev Value of D */
    epicsFloat64        le;         /* Prev Value of E */
    epicsFloat64        lf;         /* Prev Value of F */
    epicsFloat64        lg;         /* Prev Value of G */
    epicsFloat64        lh;         /* Prev Value of H */
    epicsFloat64        li;         /* Prev Value of I */
    epicsFloat64        lj;         /* Prev Value of J */
    epicsFloat64        lk;         /* Prev Value of K */
    epicsFloat64        ll;         /* Prev Value of L */
    epicsFloat64        povl;       /* Prev Value of OVAL */
    epicsFloat64        lalm;       /* Last Value Alarmed */
    epicsFloat64        alst;       /* Last Value Archived */
    epicsFloat64        mlst;       /* Last Val Monitored */
    char	rpcl[INFIX_TO_POSTFIX_SIZE(80)]; /* Reverse Polish Calc */
    char	orpc[INFIX_TO_POSTFIX_SIZE(80)]; /* Reverse Polish OCalc */
} calcoutRecord;

typedef enum {
	calcoutRecordNAME = 0,
	calcoutRecordDESC = 1,
	calcoutRecordASG = 2,
	calcoutRecordSCAN = 3,
	calcoutRecordPINI = 4,
	calcoutRecordPHAS = 5,
	calcoutRecordEVNT = 6,
	calcoutRecordTSE = 7,
	calcoutRecordTSEL = 8,
	calcoutRecordDTYP = 9,
	calcoutRecordDISV = 10,
	calcoutRecordDISA = 11,
	calcoutRecordSDIS = 12,
	calcoutRecordMLOK = 13,
	calcoutRecordMLIS = 14,
	calcoutRecordDISP = 15,
	calcoutRecordPROC = 16,
	calcoutRecordSTAT = 17,
	calcoutRecordSEVR = 18,
	calcoutRecordNSTA = 19,
	calcoutRecordNSEV = 20,
	calcoutRecordACKS = 21,
	calcoutRecordACKT = 22,
	calcoutRecordDISS = 23,
	calcoutRecordLCNT = 24,
	calcoutRecordPACT = 25,
	calcoutRecordPUTF = 26,
	calcoutRecordRPRO = 27,
	calcoutRecordASP = 28,
	calcoutRecordPPN = 29,
	calcoutRecordPPNR = 30,
	calcoutRecordSPVT = 31,
	calcoutRecordRSET = 32,
	calcoutRecordDSET = 33,
	calcoutRecordDPVT = 34,
	calcoutRecordRDES = 35,
	calcoutRecordLSET = 36,
	calcoutRecordPRIO = 37,
	calcoutRecordTPRO = 38,
	calcoutRecordBKPT = 39,
	calcoutRecordUDF = 40,
	calcoutRecordUDFS = 41,
	calcoutRecordTIME = 42,
	calcoutRecordFLNK = 43,
	calcoutRecordRPVT = 44,
	calcoutRecordVAL = 45,
	calcoutRecordPVAL = 46,
	calcoutRecordCALC = 47,
	calcoutRecordCLCV = 48,
	calcoutRecordINPA = 49,
	calcoutRecordINPB = 50,
	calcoutRecordINPC = 51,
	calcoutRecordINPD = 52,
	calcoutRecordINPE = 53,
	calcoutRecordINPF = 54,
	calcoutRecordINPG = 55,
	calcoutRecordINPH = 56,
	calcoutRecordINPI = 57,
	calcoutRecordINPJ = 58,
	calcoutRecordINPK = 59,
	calcoutRecordINPL = 60,
	calcoutRecordOUT = 61,
	calcoutRecordINAV = 62,
	calcoutRecordINBV = 63,
	calcoutRecordINCV = 64,
	calcoutRecordINDV = 65,
	calcoutRecordINEV = 66,
	calcoutRecordINFV = 67,
	calcoutRecordINGV = 68,
	calcoutRecordINHV = 69,
	calcoutRecordINIV = 70,
	calcoutRecordINJV = 71,
	calcoutRecordINKV = 72,
	calcoutRecordINLV = 73,
	calcoutRecordOUTV = 74,
	calcoutRecordOOPT = 75,
	calcoutRecordODLY = 76,
	calcoutRecordDLYA = 77,
	calcoutRecordDOPT = 78,
	calcoutRecordOCAL = 79,
	calcoutRecordOCLV = 80,
	calcoutRecordOEVT = 81,
	calcoutRecordEPVT = 82,
	calcoutRecordIVOA = 83,
	calcoutRecordIVOV = 84,
	calcoutRecordEGU = 85,
	calcoutRecordPREC = 86,
	calcoutRecordHOPR = 87,
	calcoutRecordLOPR = 88,
	calcoutRecordHIHI = 89,
	calcoutRecordLOLO = 90,
	calcoutRecordHIGH = 91,
	calcoutRecordLOW = 92,
	calcoutRecordHHSV = 93,
	calcoutRecordLLSV = 94,
	calcoutRecordHSV = 95,
	calcoutRecordLSV = 96,
	calcoutRecordHYST = 97,
	calcoutRecordADEL = 98,
	calcoutRecordMDEL = 99,
	calcoutRecordA = 100,
	calcoutRecordB = 101,
	calcoutRecordC = 102,
	calcoutRecordD = 103,
	calcoutRecordE = 104,
	calcoutRecordF = 105,
	calcoutRecordG = 106,
	calcoutRecordH = 107,
	calcoutRecordI = 108,
	calcoutRecordJ = 109,
	calcoutRecordK = 110,
	calcoutRecordL = 111,
	calcoutRecordOVAL = 112,
	calcoutRecordLA = 113,
	calcoutRecordLB = 114,
	calcoutRecordLC = 115,
	calcoutRecordLD = 116,
	calcoutRecordLE = 117,
	calcoutRecordLF = 118,
	calcoutRecordLG = 119,
	calcoutRecordLH = 120,
	calcoutRecordLI = 121,
	calcoutRecordLJ = 122,
	calcoutRecordLK = 123,
	calcoutRecordLL = 124,
	calcoutRecordPOVL = 125,
	calcoutRecordLALM = 126,
	calcoutRecordALST = 127,
	calcoutRecordMLST = 128,
	calcoutRecordRPCL = 129,
	calcoutRecordORPC = 130
} calcoutFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int calcoutRecordSizeOffset(dbRecordType *prt)
{
    calcoutRecord *prec = 0;

    assert(prt->no_fields == 131);
    prt->papFldDes[calcoutRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[calcoutRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[calcoutRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[calcoutRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[calcoutRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[calcoutRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[calcoutRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[calcoutRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[calcoutRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[calcoutRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[calcoutRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[calcoutRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[calcoutRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[calcoutRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[calcoutRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[calcoutRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[calcoutRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[calcoutRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[calcoutRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[calcoutRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[calcoutRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[calcoutRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[calcoutRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[calcoutRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[calcoutRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[calcoutRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[calcoutRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[calcoutRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[calcoutRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[calcoutRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[calcoutRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[calcoutRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[calcoutRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[calcoutRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[calcoutRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[calcoutRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[calcoutRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[calcoutRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[calcoutRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[calcoutRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[calcoutRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[calcoutRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[calcoutRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[calcoutRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[calcoutRecordRPVT]->size = sizeof(prec->rpvt);
    prt->papFldDes[calcoutRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[calcoutRecordPVAL]->size = sizeof(prec->pval);
    prt->papFldDes[calcoutRecordCALC]->size = sizeof(prec->calc);
    prt->papFldDes[calcoutRecordCLCV]->size = sizeof(prec->clcv);
    prt->papFldDes[calcoutRecordINPA]->size = sizeof(prec->inpa);
    prt->papFldDes[calcoutRecordINPB]->size = sizeof(prec->inpb);
    prt->papFldDes[calcoutRecordINPC]->size = sizeof(prec->inpc);
    prt->papFldDes[calcoutRecordINPD]->size = sizeof(prec->inpd);
    prt->papFldDes[calcoutRecordINPE]->size = sizeof(prec->inpe);
    prt->papFldDes[calcoutRecordINPF]->size = sizeof(prec->inpf);
    prt->papFldDes[calcoutRecordINPG]->size = sizeof(prec->inpg);
    prt->papFldDes[calcoutRecordINPH]->size = sizeof(prec->inph);
    prt->papFldDes[calcoutRecordINPI]->size = sizeof(prec->inpi);
    prt->papFldDes[calcoutRecordINPJ]->size = sizeof(prec->inpj);
    prt->papFldDes[calcoutRecordINPK]->size = sizeof(prec->inpk);
    prt->papFldDes[calcoutRecordINPL]->size = sizeof(prec->inpl);
    prt->papFldDes[calcoutRecordOUT]->size = sizeof(prec->out);
    prt->papFldDes[calcoutRecordINAV]->size = sizeof(prec->inav);
    prt->papFldDes[calcoutRecordINBV]->size = sizeof(prec->inbv);
    prt->papFldDes[calcoutRecordINCV]->size = sizeof(prec->incv);
    prt->papFldDes[calcoutRecordINDV]->size = sizeof(prec->indv);
    prt->papFldDes[calcoutRecordINEV]->size = sizeof(prec->inev);
    prt->papFldDes[calcoutRecordINFV]->size = sizeof(prec->infv);
    prt->papFldDes[calcoutRecordINGV]->size = sizeof(prec->ingv);
    prt->papFldDes[calcoutRecordINHV]->size = sizeof(prec->inhv);
    prt->papFldDes[calcoutRecordINIV]->size = sizeof(prec->iniv);
    prt->papFldDes[calcoutRecordINJV]->size = sizeof(prec->injv);
    prt->papFldDes[calcoutRecordINKV]->size = sizeof(prec->inkv);
    prt->papFldDes[calcoutRecordINLV]->size = sizeof(prec->inlv);
    prt->papFldDes[calcoutRecordOUTV]->size = sizeof(prec->outv);
    prt->papFldDes[calcoutRecordOOPT]->size = sizeof(prec->oopt);
    prt->papFldDes[calcoutRecordODLY]->size = sizeof(prec->odly);
    prt->papFldDes[calcoutRecordDLYA]->size = sizeof(prec->dlya);
    prt->papFldDes[calcoutRecordDOPT]->size = sizeof(prec->dopt);
    prt->papFldDes[calcoutRecordOCAL]->size = sizeof(prec->ocal);
    prt->papFldDes[calcoutRecordOCLV]->size = sizeof(prec->oclv);
    prt->papFldDes[calcoutRecordOEVT]->size = sizeof(prec->oevt);
    prt->papFldDes[calcoutRecordEPVT]->size = sizeof(prec->epvt);
    prt->papFldDes[calcoutRecordIVOA]->size = sizeof(prec->ivoa);
    prt->papFldDes[calcoutRecordIVOV]->size = sizeof(prec->ivov);
    prt->papFldDes[calcoutRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[calcoutRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[calcoutRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[calcoutRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[calcoutRecordHIHI]->size = sizeof(prec->hihi);
    prt->papFldDes[calcoutRecordLOLO]->size = sizeof(prec->lolo);
    prt->papFldDes[calcoutRecordHIGH]->size = sizeof(prec->high);
    prt->papFldDes[calcoutRecordLOW]->size = sizeof(prec->low);
    prt->papFldDes[calcoutRecordHHSV]->size = sizeof(prec->hhsv);
    prt->papFldDes[calcoutRecordLLSV]->size = sizeof(prec->llsv);
    prt->papFldDes[calcoutRecordHSV]->size = sizeof(prec->hsv);
    prt->papFldDes[calcoutRecordLSV]->size = sizeof(prec->lsv);
    prt->papFldDes[calcoutRecordHYST]->size = sizeof(prec->hyst);
    prt->papFldDes[calcoutRecordADEL]->size = sizeof(prec->adel);
    prt->papFldDes[calcoutRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[calcoutRecordA]->size = sizeof(prec->a);
    prt->papFldDes[calcoutRecordB]->size = sizeof(prec->b);
    prt->papFldDes[calcoutRecordC]->size = sizeof(prec->c);
    prt->papFldDes[calcoutRecordD]->size = sizeof(prec->d);
    prt->papFldDes[calcoutRecordE]->size = sizeof(prec->e);
    prt->papFldDes[calcoutRecordF]->size = sizeof(prec->f);
    prt->papFldDes[calcoutRecordG]->size = sizeof(prec->g);
    prt->papFldDes[calcoutRecordH]->size = sizeof(prec->h);
    prt->papFldDes[calcoutRecordI]->size = sizeof(prec->i);
    prt->papFldDes[calcoutRecordJ]->size = sizeof(prec->j);
    prt->papFldDes[calcoutRecordK]->size = sizeof(prec->k);
    prt->papFldDes[calcoutRecordL]->size = sizeof(prec->l);
    prt->papFldDes[calcoutRecordOVAL]->size = sizeof(prec->oval);
    prt->papFldDes[calcoutRecordLA]->size = sizeof(prec->la);
    prt->papFldDes[calcoutRecordLB]->size = sizeof(prec->lb);
    prt->papFldDes[calcoutRecordLC]->size = sizeof(prec->lc);
    prt->papFldDes[calcoutRecordLD]->size = sizeof(prec->ld);
    prt->papFldDes[calcoutRecordLE]->size = sizeof(prec->le);
    prt->papFldDes[calcoutRecordLF]->size = sizeof(prec->lf);
    prt->papFldDes[calcoutRecordLG]->size = sizeof(prec->lg);
    prt->papFldDes[calcoutRecordLH]->size = sizeof(prec->lh);
    prt->papFldDes[calcoutRecordLI]->size = sizeof(prec->li);
    prt->papFldDes[calcoutRecordLJ]->size = sizeof(prec->lj);
    prt->papFldDes[calcoutRecordLK]->size = sizeof(prec->lk);
    prt->papFldDes[calcoutRecordLL]->size = sizeof(prec->ll);
    prt->papFldDes[calcoutRecordPOVL]->size = sizeof(prec->povl);
    prt->papFldDes[calcoutRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[calcoutRecordALST]->size = sizeof(prec->alst);
    prt->papFldDes[calcoutRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[calcoutRecordRPCL]->size = sizeof(prec->rpcl);
    prt->papFldDes[calcoutRecordORPC]->size = sizeof(prec->orpc);
    prt->papFldDes[calcoutRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[calcoutRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[calcoutRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[calcoutRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[calcoutRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[calcoutRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[calcoutRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[calcoutRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[calcoutRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[calcoutRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[calcoutRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[calcoutRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[calcoutRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[calcoutRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[calcoutRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[calcoutRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[calcoutRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[calcoutRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[calcoutRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[calcoutRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[calcoutRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[calcoutRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[calcoutRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[calcoutRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[calcoutRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[calcoutRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[calcoutRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[calcoutRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[calcoutRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[calcoutRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[calcoutRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[calcoutRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[calcoutRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[calcoutRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[calcoutRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[calcoutRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[calcoutRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[calcoutRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[calcoutRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[calcoutRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[calcoutRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[calcoutRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[calcoutRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[calcoutRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[calcoutRecordRPVT]->offset = (unsigned short)((char *)&prec->rpvt - (char *)prec);
    prt->papFldDes[calcoutRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[calcoutRecordPVAL]->offset = (unsigned short)((char *)&prec->pval - (char *)prec);
    prt->papFldDes[calcoutRecordCALC]->offset = (unsigned short)((char *)&prec->calc - (char *)prec);
    prt->papFldDes[calcoutRecordCLCV]->offset = (unsigned short)((char *)&prec->clcv - (char *)prec);
    prt->papFldDes[calcoutRecordINPA]->offset = (unsigned short)((char *)&prec->inpa - (char *)prec);
    prt->papFldDes[calcoutRecordINPB]->offset = (unsigned short)((char *)&prec->inpb - (char *)prec);
    prt->papFldDes[calcoutRecordINPC]->offset = (unsigned short)((char *)&prec->inpc - (char *)prec);
    prt->papFldDes[calcoutRecordINPD]->offset = (unsigned short)((char *)&prec->inpd - (char *)prec);
    prt->papFldDes[calcoutRecordINPE]->offset = (unsigned short)((char *)&prec->inpe - (char *)prec);
    prt->papFldDes[calcoutRecordINPF]->offset = (unsigned short)((char *)&prec->inpf - (char *)prec);
    prt->papFldDes[calcoutRecordINPG]->offset = (unsigned short)((char *)&prec->inpg - (char *)prec);
    prt->papFldDes[calcoutRecordINPH]->offset = (unsigned short)((char *)&prec->inph - (char *)prec);
    prt->papFldDes[calcoutRecordINPI]->offset = (unsigned short)((char *)&prec->inpi - (char *)prec);
    prt->papFldDes[calcoutRecordINPJ]->offset = (unsigned short)((char *)&prec->inpj - (char *)prec);
    prt->papFldDes[calcoutRecordINPK]->offset = (unsigned short)((char *)&prec->inpk - (char *)prec);
    prt->papFldDes[calcoutRecordINPL]->offset = (unsigned short)((char *)&prec->inpl - (char *)prec);
    prt->papFldDes[calcoutRecordOUT]->offset = (unsigned short)((char *)&prec->out - (char *)prec);
    prt->papFldDes[calcoutRecordINAV]->offset = (unsigned short)((char *)&prec->inav - (char *)prec);
    prt->papFldDes[calcoutRecordINBV]->offset = (unsigned short)((char *)&prec->inbv - (char *)prec);
    prt->papFldDes[calcoutRecordINCV]->offset = (unsigned short)((char *)&prec->incv - (char *)prec);
    prt->papFldDes[calcoutRecordINDV]->offset = (unsigned short)((char *)&prec->indv - (char *)prec);
    prt->papFldDes[calcoutRecordINEV]->offset = (unsigned short)((char *)&prec->inev - (char *)prec);
    prt->papFldDes[calcoutRecordINFV]->offset = (unsigned short)((char *)&prec->infv - (char *)prec);
    prt->papFldDes[calcoutRecordINGV]->offset = (unsigned short)((char *)&prec->ingv - (char *)prec);
    prt->papFldDes[calcoutRecordINHV]->offset = (unsigned short)((char *)&prec->inhv - (char *)prec);
    prt->papFldDes[calcoutRecordINIV]->offset = (unsigned short)((char *)&prec->iniv - (char *)prec);
    prt->papFldDes[calcoutRecordINJV]->offset = (unsigned short)((char *)&prec->injv - (char *)prec);
    prt->papFldDes[calcoutRecordINKV]->offset = (unsigned short)((char *)&prec->inkv - (char *)prec);
    prt->papFldDes[calcoutRecordINLV]->offset = (unsigned short)((char *)&prec->inlv - (char *)prec);
    prt->papFldDes[calcoutRecordOUTV]->offset = (unsigned short)((char *)&prec->outv - (char *)prec);
    prt->papFldDes[calcoutRecordOOPT]->offset = (unsigned short)((char *)&prec->oopt - (char *)prec);
    prt->papFldDes[calcoutRecordODLY]->offset = (unsigned short)((char *)&prec->odly - (char *)prec);
    prt->papFldDes[calcoutRecordDLYA]->offset = (unsigned short)((char *)&prec->dlya - (char *)prec);
    prt->papFldDes[calcoutRecordDOPT]->offset = (unsigned short)((char *)&prec->dopt - (char *)prec);
    prt->papFldDes[calcoutRecordOCAL]->offset = (unsigned short)((char *)&prec->ocal - (char *)prec);
    prt->papFldDes[calcoutRecordOCLV]->offset = (unsigned short)((char *)&prec->oclv - (char *)prec);
    prt->papFldDes[calcoutRecordOEVT]->offset = (unsigned short)((char *)&prec->oevt - (char *)prec);
    prt->papFldDes[calcoutRecordEPVT]->offset = (unsigned short)((char *)&prec->epvt - (char *)prec);
    prt->papFldDes[calcoutRecordIVOA]->offset = (unsigned short)((char *)&prec->ivoa - (char *)prec);
    prt->papFldDes[calcoutRecordIVOV]->offset = (unsigned short)((char *)&prec->ivov - (char *)prec);
    prt->papFldDes[calcoutRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[calcoutRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[calcoutRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[calcoutRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[calcoutRecordHIHI]->offset = (unsigned short)((char *)&prec->hihi - (char *)prec);
    prt->papFldDes[calcoutRecordLOLO]->offset = (unsigned short)((char *)&prec->lolo - (char *)prec);
    prt->papFldDes[calcoutRecordHIGH]->offset = (unsigned short)((char *)&prec->high - (char *)prec);
    prt->papFldDes[calcoutRecordLOW]->offset = (unsigned short)((char *)&prec->low - (char *)prec);
    prt->papFldDes[calcoutRecordHHSV]->offset = (unsigned short)((char *)&prec->hhsv - (char *)prec);
    prt->papFldDes[calcoutRecordLLSV]->offset = (unsigned short)((char *)&prec->llsv - (char *)prec);
    prt->papFldDes[calcoutRecordHSV]->offset = (unsigned short)((char *)&prec->hsv - (char *)prec);
    prt->papFldDes[calcoutRecordLSV]->offset = (unsigned short)((char *)&prec->lsv - (char *)prec);
    prt->papFldDes[calcoutRecordHYST]->offset = (unsigned short)((char *)&prec->hyst - (char *)prec);
    prt->papFldDes[calcoutRecordADEL]->offset = (unsigned short)((char *)&prec->adel - (char *)prec);
    prt->papFldDes[calcoutRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[calcoutRecordA]->offset = (unsigned short)((char *)&prec->a - (char *)prec);
    prt->papFldDes[calcoutRecordB]->offset = (unsigned short)((char *)&prec->b - (char *)prec);
    prt->papFldDes[calcoutRecordC]->offset = (unsigned short)((char *)&prec->c - (char *)prec);
    prt->papFldDes[calcoutRecordD]->offset = (unsigned short)((char *)&prec->d - (char *)prec);
    prt->papFldDes[calcoutRecordE]->offset = (unsigned short)((char *)&prec->e - (char *)prec);
    prt->papFldDes[calcoutRecordF]->offset = (unsigned short)((char *)&prec->f - (char *)prec);
    prt->papFldDes[calcoutRecordG]->offset = (unsigned short)((char *)&prec->g - (char *)prec);
    prt->papFldDes[calcoutRecordH]->offset = (unsigned short)((char *)&prec->h - (char *)prec);
    prt->papFldDes[calcoutRecordI]->offset = (unsigned short)((char *)&prec->i - (char *)prec);
    prt->papFldDes[calcoutRecordJ]->offset = (unsigned short)((char *)&prec->j - (char *)prec);
    prt->papFldDes[calcoutRecordK]->offset = (unsigned short)((char *)&prec->k - (char *)prec);
    prt->papFldDes[calcoutRecordL]->offset = (unsigned short)((char *)&prec->l - (char *)prec);
    prt->papFldDes[calcoutRecordOVAL]->offset = (unsigned short)((char *)&prec->oval - (char *)prec);
    prt->papFldDes[calcoutRecordLA]->offset = (unsigned short)((char *)&prec->la - (char *)prec);
    prt->papFldDes[calcoutRecordLB]->offset = (unsigned short)((char *)&prec->lb - (char *)prec);
    prt->papFldDes[calcoutRecordLC]->offset = (unsigned short)((char *)&prec->lc - (char *)prec);
    prt->papFldDes[calcoutRecordLD]->offset = (unsigned short)((char *)&prec->ld - (char *)prec);
    prt->papFldDes[calcoutRecordLE]->offset = (unsigned short)((char *)&prec->le - (char *)prec);
    prt->papFldDes[calcoutRecordLF]->offset = (unsigned short)((char *)&prec->lf - (char *)prec);
    prt->papFldDes[calcoutRecordLG]->offset = (unsigned short)((char *)&prec->lg - (char *)prec);
    prt->papFldDes[calcoutRecordLH]->offset = (unsigned short)((char *)&prec->lh - (char *)prec);
    prt->papFldDes[calcoutRecordLI]->offset = (unsigned short)((char *)&prec->li - (char *)prec);
    prt->papFldDes[calcoutRecordLJ]->offset = (unsigned short)((char *)&prec->lj - (char *)prec);
    prt->papFldDes[calcoutRecordLK]->offset = (unsigned short)((char *)&prec->lk - (char *)prec);
    prt->papFldDes[calcoutRecordLL]->offset = (unsigned short)((char *)&prec->ll - (char *)prec);
    prt->papFldDes[calcoutRecordPOVL]->offset = (unsigned short)((char *)&prec->povl - (char *)prec);
    prt->papFldDes[calcoutRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[calcoutRecordALST]->offset = (unsigned short)((char *)&prec->alst - (char *)prec);
    prt->papFldDes[calcoutRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->papFldDes[calcoutRecordRPCL]->offset = (unsigned short)((char *)&prec->rpcl - (char *)prec);
    prt->papFldDes[calcoutRecordORPC]->offset = (unsigned short)((char *)&prec->orpc - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(calcoutRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_calcoutRecord_H */
