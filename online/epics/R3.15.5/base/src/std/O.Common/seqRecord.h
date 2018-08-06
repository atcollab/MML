/* seqRecord.h generated from seqRecord.dbd */

#ifndef INC_seqRecord_H
#define INC_seqRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    seqSELM_All                     /* All */,
    seqSELM_Specified               /* Specified */,
    seqSELM_Mask                    /* Mask */
} seqSELM;
#define seqSELM_NUM_CHOICES 3

typedef struct seqRecord {
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
    epicsInt32          val;        /* Used to trigger */
    epicsEnum16         selm;       /* Select Mechanism */
    epicsUInt16         seln;       /* Link Selection */
    DBLINK              sell;       /* Link Selection Loc */
    epicsInt16          offs;       /* Offset for Specified */
    epicsInt16          shft;       /* Shift for Mask mode */
    epicsUInt16         oldn;       /* Old Selection */
    epicsInt16          prec;       /* Display Precision */
    epicsFloat64        dly0;       /* Delay 0 */
    DBLINK              dol0;       /* Input link 0 */
    epicsFloat64        do0;        /* Value 0 */
    DBLINK              lnk0;       /* Output Link 0 */
    epicsFloat64        dly1;       /* Delay 1 */
    DBLINK              dol1;       /* Input link1 */
    epicsFloat64        do1;        /* Value 1 */
    DBLINK              lnk1;       /* Output Link 1 */
    epicsFloat64        dly2;       /* Delay 2 */
    DBLINK              dol2;       /* Input link 2 */
    epicsFloat64        do2;        /* Value 2 */
    DBLINK              lnk2;       /* Output Link 2 */
    epicsFloat64        dly3;       /* Delay 3 */
    DBLINK              dol3;       /* Input link 3 */
    epicsFloat64        do3;        /* Value 3 */
    DBLINK              lnk3;       /* Output Link 3 */
    epicsFloat64        dly4;       /* Delay 4 */
    DBLINK              dol4;       /* Input link 4 */
    epicsFloat64        do4;        /* Value 4 */
    DBLINK              lnk4;       /* Output Link 4 */
    epicsFloat64        dly5;       /* Delay 5 */
    DBLINK              dol5;       /* Input link 5 */
    epicsFloat64        do5;        /* Value 5 */
    DBLINK              lnk5;       /* Output Link 5 */
    epicsFloat64        dly6;       /* Delay 6 */
    DBLINK              dol6;       /* Input link 6 */
    epicsFloat64        do6;        /* Value 6 */
    DBLINK              lnk6;       /* Output Link 6 */
    epicsFloat64        dly7;       /* Delay 7 */
    DBLINK              dol7;       /* Input link 7 */
    epicsFloat64        do7;        /* Value 7 */
    DBLINK              lnk7;       /* Output Link 7 */
    epicsFloat64        dly8;       /* Delay 8 */
    DBLINK              dol8;       /* Input link 8 */
    epicsFloat64        do8;        /* Value 8 */
    DBLINK              lnk8;       /* Output Link 8 */
    epicsFloat64        dly9;       /* Delay 9 */
    DBLINK              dol9;       /* Input link 9 */
    epicsFloat64        do9;        /* Value 9 */
    DBLINK              lnk9;       /* Output Link 9 */
    epicsFloat64        dlya;       /* Delay 10 */
    DBLINK              dola;       /* Input link 10 */
    epicsFloat64        doa;        /* Value 10 */
    DBLINK              lnka;       /* Output Link 10 */
    epicsFloat64        dlyb;       /* Delay 11 */
    DBLINK              dolb;       /* Input link 11 */
    epicsFloat64        dob;        /* Value 11 */
    DBLINK              lnkb;       /* Output Link 11 */
    epicsFloat64        dlyc;       /* Delay 12 */
    DBLINK              dolc;       /* Input link 12 */
    epicsFloat64        doc;        /* Value 12 */
    DBLINK              lnkc;       /* Output Link 12 */
    epicsFloat64        dlyd;       /* Delay 13 */
    DBLINK              dold;       /* Input link 13 */
    epicsFloat64        dod;        /* Value 13 */
    DBLINK              lnkd;       /* Output Link 13 */
    epicsFloat64        dlye;       /* Delay 14 */
    DBLINK              dole;       /* Input link 14 */
    epicsFloat64        doe;        /* Value 14 */
    DBLINK              lnke;       /* Output Link 14 */
    epicsFloat64        dlyf;       /* Delay 15 */
    DBLINK              dolf;       /* Input link 15 */
    epicsFloat64        dof;        /* Value 15 */
    DBLINK              lnkf;       /* Output Link 15 */
} seqRecord;

typedef enum {
	seqRecordNAME = 0,
	seqRecordDESC = 1,
	seqRecordASG = 2,
	seqRecordSCAN = 3,
	seqRecordPINI = 4,
	seqRecordPHAS = 5,
	seqRecordEVNT = 6,
	seqRecordTSE = 7,
	seqRecordTSEL = 8,
	seqRecordDTYP = 9,
	seqRecordDISV = 10,
	seqRecordDISA = 11,
	seqRecordSDIS = 12,
	seqRecordMLOK = 13,
	seqRecordMLIS = 14,
	seqRecordDISP = 15,
	seqRecordPROC = 16,
	seqRecordSTAT = 17,
	seqRecordSEVR = 18,
	seqRecordNSTA = 19,
	seqRecordNSEV = 20,
	seqRecordACKS = 21,
	seqRecordACKT = 22,
	seqRecordDISS = 23,
	seqRecordLCNT = 24,
	seqRecordPACT = 25,
	seqRecordPUTF = 26,
	seqRecordRPRO = 27,
	seqRecordASP = 28,
	seqRecordPPN = 29,
	seqRecordPPNR = 30,
	seqRecordSPVT = 31,
	seqRecordRSET = 32,
	seqRecordDSET = 33,
	seqRecordDPVT = 34,
	seqRecordRDES = 35,
	seqRecordLSET = 36,
	seqRecordPRIO = 37,
	seqRecordTPRO = 38,
	seqRecordBKPT = 39,
	seqRecordUDF = 40,
	seqRecordUDFS = 41,
	seqRecordTIME = 42,
	seqRecordFLNK = 43,
	seqRecordVAL = 44,
	seqRecordSELM = 45,
	seqRecordSELN = 46,
	seqRecordSELL = 47,
	seqRecordOFFS = 48,
	seqRecordSHFT = 49,
	seqRecordOLDN = 50,
	seqRecordPREC = 51,
	seqRecordDLY0 = 52,
	seqRecordDOL0 = 53,
	seqRecordDO0 = 54,
	seqRecordLNK0 = 55,
	seqRecordDLY1 = 56,
	seqRecordDOL1 = 57,
	seqRecordDO1 = 58,
	seqRecordLNK1 = 59,
	seqRecordDLY2 = 60,
	seqRecordDOL2 = 61,
	seqRecordDO2 = 62,
	seqRecordLNK2 = 63,
	seqRecordDLY3 = 64,
	seqRecordDOL3 = 65,
	seqRecordDO3 = 66,
	seqRecordLNK3 = 67,
	seqRecordDLY4 = 68,
	seqRecordDOL4 = 69,
	seqRecordDO4 = 70,
	seqRecordLNK4 = 71,
	seqRecordDLY5 = 72,
	seqRecordDOL5 = 73,
	seqRecordDO5 = 74,
	seqRecordLNK5 = 75,
	seqRecordDLY6 = 76,
	seqRecordDOL6 = 77,
	seqRecordDO6 = 78,
	seqRecordLNK6 = 79,
	seqRecordDLY7 = 80,
	seqRecordDOL7 = 81,
	seqRecordDO7 = 82,
	seqRecordLNK7 = 83,
	seqRecordDLY8 = 84,
	seqRecordDOL8 = 85,
	seqRecordDO8 = 86,
	seqRecordLNK8 = 87,
	seqRecordDLY9 = 88,
	seqRecordDOL9 = 89,
	seqRecordDO9 = 90,
	seqRecordLNK9 = 91,
	seqRecordDLYA = 92,
	seqRecordDOLA = 93,
	seqRecordDOA = 94,
	seqRecordLNKA = 95,
	seqRecordDLYB = 96,
	seqRecordDOLB = 97,
	seqRecordDOB = 98,
	seqRecordLNKB = 99,
	seqRecordDLYC = 100,
	seqRecordDOLC = 101,
	seqRecordDOC = 102,
	seqRecordLNKC = 103,
	seqRecordDLYD = 104,
	seqRecordDOLD = 105,
	seqRecordDOD = 106,
	seqRecordLNKD = 107,
	seqRecordDLYE = 108,
	seqRecordDOLE = 109,
	seqRecordDOE = 110,
	seqRecordLNKE = 111,
	seqRecordDLYF = 112,
	seqRecordDOLF = 113,
	seqRecordDOF = 114,
	seqRecordLNKF = 115
} seqFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int seqRecordSizeOffset(dbRecordType *prt)
{
    seqRecord *prec = 0;

    assert(prt->no_fields == 116);
    prt->papFldDes[seqRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[seqRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[seqRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[seqRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[seqRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[seqRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[seqRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[seqRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[seqRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[seqRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[seqRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[seqRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[seqRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[seqRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[seqRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[seqRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[seqRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[seqRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[seqRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[seqRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[seqRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[seqRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[seqRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[seqRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[seqRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[seqRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[seqRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[seqRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[seqRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[seqRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[seqRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[seqRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[seqRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[seqRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[seqRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[seqRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[seqRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[seqRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[seqRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[seqRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[seqRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[seqRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[seqRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[seqRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[seqRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[seqRecordSELM]->size = sizeof(prec->selm);
    prt->papFldDes[seqRecordSELN]->size = sizeof(prec->seln);
    prt->papFldDes[seqRecordSELL]->size = sizeof(prec->sell);
    prt->papFldDes[seqRecordOFFS]->size = sizeof(prec->offs);
    prt->papFldDes[seqRecordSHFT]->size = sizeof(prec->shft);
    prt->papFldDes[seqRecordOLDN]->size = sizeof(prec->oldn);
    prt->papFldDes[seqRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[seqRecordDLY0]->size = sizeof(prec->dly0);
    prt->papFldDes[seqRecordDOL0]->size = sizeof(prec->dol0);
    prt->papFldDes[seqRecordDO0]->size = sizeof(prec->do0);
    prt->papFldDes[seqRecordLNK0]->size = sizeof(prec->lnk0);
    prt->papFldDes[seqRecordDLY1]->size = sizeof(prec->dly1);
    prt->papFldDes[seqRecordDOL1]->size = sizeof(prec->dol1);
    prt->papFldDes[seqRecordDO1]->size = sizeof(prec->do1);
    prt->papFldDes[seqRecordLNK1]->size = sizeof(prec->lnk1);
    prt->papFldDes[seqRecordDLY2]->size = sizeof(prec->dly2);
    prt->papFldDes[seqRecordDOL2]->size = sizeof(prec->dol2);
    prt->papFldDes[seqRecordDO2]->size = sizeof(prec->do2);
    prt->papFldDes[seqRecordLNK2]->size = sizeof(prec->lnk2);
    prt->papFldDes[seqRecordDLY3]->size = sizeof(prec->dly3);
    prt->papFldDes[seqRecordDOL3]->size = sizeof(prec->dol3);
    prt->papFldDes[seqRecordDO3]->size = sizeof(prec->do3);
    prt->papFldDes[seqRecordLNK3]->size = sizeof(prec->lnk3);
    prt->papFldDes[seqRecordDLY4]->size = sizeof(prec->dly4);
    prt->papFldDes[seqRecordDOL4]->size = sizeof(prec->dol4);
    prt->papFldDes[seqRecordDO4]->size = sizeof(prec->do4);
    prt->papFldDes[seqRecordLNK4]->size = sizeof(prec->lnk4);
    prt->papFldDes[seqRecordDLY5]->size = sizeof(prec->dly5);
    prt->papFldDes[seqRecordDOL5]->size = sizeof(prec->dol5);
    prt->papFldDes[seqRecordDO5]->size = sizeof(prec->do5);
    prt->papFldDes[seqRecordLNK5]->size = sizeof(prec->lnk5);
    prt->papFldDes[seqRecordDLY6]->size = sizeof(prec->dly6);
    prt->papFldDes[seqRecordDOL6]->size = sizeof(prec->dol6);
    prt->papFldDes[seqRecordDO6]->size = sizeof(prec->do6);
    prt->papFldDes[seqRecordLNK6]->size = sizeof(prec->lnk6);
    prt->papFldDes[seqRecordDLY7]->size = sizeof(prec->dly7);
    prt->papFldDes[seqRecordDOL7]->size = sizeof(prec->dol7);
    prt->papFldDes[seqRecordDO7]->size = sizeof(prec->do7);
    prt->papFldDes[seqRecordLNK7]->size = sizeof(prec->lnk7);
    prt->papFldDes[seqRecordDLY8]->size = sizeof(prec->dly8);
    prt->papFldDes[seqRecordDOL8]->size = sizeof(prec->dol8);
    prt->papFldDes[seqRecordDO8]->size = sizeof(prec->do8);
    prt->papFldDes[seqRecordLNK8]->size = sizeof(prec->lnk8);
    prt->papFldDes[seqRecordDLY9]->size = sizeof(prec->dly9);
    prt->papFldDes[seqRecordDOL9]->size = sizeof(prec->dol9);
    prt->papFldDes[seqRecordDO9]->size = sizeof(prec->do9);
    prt->papFldDes[seqRecordLNK9]->size = sizeof(prec->lnk9);
    prt->papFldDes[seqRecordDLYA]->size = sizeof(prec->dlya);
    prt->papFldDes[seqRecordDOLA]->size = sizeof(prec->dola);
    prt->papFldDes[seqRecordDOA]->size = sizeof(prec->doa);
    prt->papFldDes[seqRecordLNKA]->size = sizeof(prec->lnka);
    prt->papFldDes[seqRecordDLYB]->size = sizeof(prec->dlyb);
    prt->papFldDes[seqRecordDOLB]->size = sizeof(prec->dolb);
    prt->papFldDes[seqRecordDOB]->size = sizeof(prec->dob);
    prt->papFldDes[seqRecordLNKB]->size = sizeof(prec->lnkb);
    prt->papFldDes[seqRecordDLYC]->size = sizeof(prec->dlyc);
    prt->papFldDes[seqRecordDOLC]->size = sizeof(prec->dolc);
    prt->papFldDes[seqRecordDOC]->size = sizeof(prec->doc);
    prt->papFldDes[seqRecordLNKC]->size = sizeof(prec->lnkc);
    prt->papFldDes[seqRecordDLYD]->size = sizeof(prec->dlyd);
    prt->papFldDes[seqRecordDOLD]->size = sizeof(prec->dold);
    prt->papFldDes[seqRecordDOD]->size = sizeof(prec->dod);
    prt->papFldDes[seqRecordLNKD]->size = sizeof(prec->lnkd);
    prt->papFldDes[seqRecordDLYE]->size = sizeof(prec->dlye);
    prt->papFldDes[seqRecordDOLE]->size = sizeof(prec->dole);
    prt->papFldDes[seqRecordDOE]->size = sizeof(prec->doe);
    prt->papFldDes[seqRecordLNKE]->size = sizeof(prec->lnke);
    prt->papFldDes[seqRecordDLYF]->size = sizeof(prec->dlyf);
    prt->papFldDes[seqRecordDOLF]->size = sizeof(prec->dolf);
    prt->papFldDes[seqRecordDOF]->size = sizeof(prec->dof);
    prt->papFldDes[seqRecordLNKF]->size = sizeof(prec->lnkf);
    prt->papFldDes[seqRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[seqRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[seqRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[seqRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[seqRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[seqRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[seqRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[seqRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[seqRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[seqRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[seqRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[seqRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[seqRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[seqRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[seqRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[seqRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[seqRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[seqRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[seqRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[seqRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[seqRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[seqRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[seqRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[seqRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[seqRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[seqRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[seqRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[seqRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[seqRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[seqRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[seqRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[seqRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[seqRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[seqRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[seqRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[seqRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[seqRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[seqRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[seqRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[seqRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[seqRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[seqRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[seqRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[seqRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[seqRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[seqRecordSELM]->offset = (unsigned short)((char *)&prec->selm - (char *)prec);
    prt->papFldDes[seqRecordSELN]->offset = (unsigned short)((char *)&prec->seln - (char *)prec);
    prt->papFldDes[seqRecordSELL]->offset = (unsigned short)((char *)&prec->sell - (char *)prec);
    prt->papFldDes[seqRecordOFFS]->offset = (unsigned short)((char *)&prec->offs - (char *)prec);
    prt->papFldDes[seqRecordSHFT]->offset = (unsigned short)((char *)&prec->shft - (char *)prec);
    prt->papFldDes[seqRecordOLDN]->offset = (unsigned short)((char *)&prec->oldn - (char *)prec);
    prt->papFldDes[seqRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[seqRecordDLY0]->offset = (unsigned short)((char *)&prec->dly0 - (char *)prec);
    prt->papFldDes[seqRecordDOL0]->offset = (unsigned short)((char *)&prec->dol0 - (char *)prec);
    prt->papFldDes[seqRecordDO0]->offset = (unsigned short)((char *)&prec->do0 - (char *)prec);
    prt->papFldDes[seqRecordLNK0]->offset = (unsigned short)((char *)&prec->lnk0 - (char *)prec);
    prt->papFldDes[seqRecordDLY1]->offset = (unsigned short)((char *)&prec->dly1 - (char *)prec);
    prt->papFldDes[seqRecordDOL1]->offset = (unsigned short)((char *)&prec->dol1 - (char *)prec);
    prt->papFldDes[seqRecordDO1]->offset = (unsigned short)((char *)&prec->do1 - (char *)prec);
    prt->papFldDes[seqRecordLNK1]->offset = (unsigned short)((char *)&prec->lnk1 - (char *)prec);
    prt->papFldDes[seqRecordDLY2]->offset = (unsigned short)((char *)&prec->dly2 - (char *)prec);
    prt->papFldDes[seqRecordDOL2]->offset = (unsigned short)((char *)&prec->dol2 - (char *)prec);
    prt->papFldDes[seqRecordDO2]->offset = (unsigned short)((char *)&prec->do2 - (char *)prec);
    prt->papFldDes[seqRecordLNK2]->offset = (unsigned short)((char *)&prec->lnk2 - (char *)prec);
    prt->papFldDes[seqRecordDLY3]->offset = (unsigned short)((char *)&prec->dly3 - (char *)prec);
    prt->papFldDes[seqRecordDOL3]->offset = (unsigned short)((char *)&prec->dol3 - (char *)prec);
    prt->papFldDes[seqRecordDO3]->offset = (unsigned short)((char *)&prec->do3 - (char *)prec);
    prt->papFldDes[seqRecordLNK3]->offset = (unsigned short)((char *)&prec->lnk3 - (char *)prec);
    prt->papFldDes[seqRecordDLY4]->offset = (unsigned short)((char *)&prec->dly4 - (char *)prec);
    prt->papFldDes[seqRecordDOL4]->offset = (unsigned short)((char *)&prec->dol4 - (char *)prec);
    prt->papFldDes[seqRecordDO4]->offset = (unsigned short)((char *)&prec->do4 - (char *)prec);
    prt->papFldDes[seqRecordLNK4]->offset = (unsigned short)((char *)&prec->lnk4 - (char *)prec);
    prt->papFldDes[seqRecordDLY5]->offset = (unsigned short)((char *)&prec->dly5 - (char *)prec);
    prt->papFldDes[seqRecordDOL5]->offset = (unsigned short)((char *)&prec->dol5 - (char *)prec);
    prt->papFldDes[seqRecordDO5]->offset = (unsigned short)((char *)&prec->do5 - (char *)prec);
    prt->papFldDes[seqRecordLNK5]->offset = (unsigned short)((char *)&prec->lnk5 - (char *)prec);
    prt->papFldDes[seqRecordDLY6]->offset = (unsigned short)((char *)&prec->dly6 - (char *)prec);
    prt->papFldDes[seqRecordDOL6]->offset = (unsigned short)((char *)&prec->dol6 - (char *)prec);
    prt->papFldDes[seqRecordDO6]->offset = (unsigned short)((char *)&prec->do6 - (char *)prec);
    prt->papFldDes[seqRecordLNK6]->offset = (unsigned short)((char *)&prec->lnk6 - (char *)prec);
    prt->papFldDes[seqRecordDLY7]->offset = (unsigned short)((char *)&prec->dly7 - (char *)prec);
    prt->papFldDes[seqRecordDOL7]->offset = (unsigned short)((char *)&prec->dol7 - (char *)prec);
    prt->papFldDes[seqRecordDO7]->offset = (unsigned short)((char *)&prec->do7 - (char *)prec);
    prt->papFldDes[seqRecordLNK7]->offset = (unsigned short)((char *)&prec->lnk7 - (char *)prec);
    prt->papFldDes[seqRecordDLY8]->offset = (unsigned short)((char *)&prec->dly8 - (char *)prec);
    prt->papFldDes[seqRecordDOL8]->offset = (unsigned short)((char *)&prec->dol8 - (char *)prec);
    prt->papFldDes[seqRecordDO8]->offset = (unsigned short)((char *)&prec->do8 - (char *)prec);
    prt->papFldDes[seqRecordLNK8]->offset = (unsigned short)((char *)&prec->lnk8 - (char *)prec);
    prt->papFldDes[seqRecordDLY9]->offset = (unsigned short)((char *)&prec->dly9 - (char *)prec);
    prt->papFldDes[seqRecordDOL9]->offset = (unsigned short)((char *)&prec->dol9 - (char *)prec);
    prt->papFldDes[seqRecordDO9]->offset = (unsigned short)((char *)&prec->do9 - (char *)prec);
    prt->papFldDes[seqRecordLNK9]->offset = (unsigned short)((char *)&prec->lnk9 - (char *)prec);
    prt->papFldDes[seqRecordDLYA]->offset = (unsigned short)((char *)&prec->dlya - (char *)prec);
    prt->papFldDes[seqRecordDOLA]->offset = (unsigned short)((char *)&prec->dola - (char *)prec);
    prt->papFldDes[seqRecordDOA]->offset = (unsigned short)((char *)&prec->doa - (char *)prec);
    prt->papFldDes[seqRecordLNKA]->offset = (unsigned short)((char *)&prec->lnka - (char *)prec);
    prt->papFldDes[seqRecordDLYB]->offset = (unsigned short)((char *)&prec->dlyb - (char *)prec);
    prt->papFldDes[seqRecordDOLB]->offset = (unsigned short)((char *)&prec->dolb - (char *)prec);
    prt->papFldDes[seqRecordDOB]->offset = (unsigned short)((char *)&prec->dob - (char *)prec);
    prt->papFldDes[seqRecordLNKB]->offset = (unsigned short)((char *)&prec->lnkb - (char *)prec);
    prt->papFldDes[seqRecordDLYC]->offset = (unsigned short)((char *)&prec->dlyc - (char *)prec);
    prt->papFldDes[seqRecordDOLC]->offset = (unsigned short)((char *)&prec->dolc - (char *)prec);
    prt->papFldDes[seqRecordDOC]->offset = (unsigned short)((char *)&prec->doc - (char *)prec);
    prt->papFldDes[seqRecordLNKC]->offset = (unsigned short)((char *)&prec->lnkc - (char *)prec);
    prt->papFldDes[seqRecordDLYD]->offset = (unsigned short)((char *)&prec->dlyd - (char *)prec);
    prt->papFldDes[seqRecordDOLD]->offset = (unsigned short)((char *)&prec->dold - (char *)prec);
    prt->papFldDes[seqRecordDOD]->offset = (unsigned short)((char *)&prec->dod - (char *)prec);
    prt->papFldDes[seqRecordLNKD]->offset = (unsigned short)((char *)&prec->lnkd - (char *)prec);
    prt->papFldDes[seqRecordDLYE]->offset = (unsigned short)((char *)&prec->dlye - (char *)prec);
    prt->papFldDes[seqRecordDOLE]->offset = (unsigned short)((char *)&prec->dole - (char *)prec);
    prt->papFldDes[seqRecordDOE]->offset = (unsigned short)((char *)&prec->doe - (char *)prec);
    prt->papFldDes[seqRecordLNKE]->offset = (unsigned short)((char *)&prec->lnke - (char *)prec);
    prt->papFldDes[seqRecordDLYF]->offset = (unsigned short)((char *)&prec->dlyf - (char *)prec);
    prt->papFldDes[seqRecordDOLF]->offset = (unsigned short)((char *)&prec->dolf - (char *)prec);
    prt->papFldDes[seqRecordDOF]->offset = (unsigned short)((char *)&prec->dof - (char *)prec);
    prt->papFldDes[seqRecordLNKF]->offset = (unsigned short)((char *)&prec->lnkf - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(seqRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_seqRecord_H */
