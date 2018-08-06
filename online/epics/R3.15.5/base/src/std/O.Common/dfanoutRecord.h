/* dfanoutRecord.h generated from dfanoutRecord.dbd */

#ifndef INC_dfanoutRecord_H
#define INC_dfanoutRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef enum {
    dfanoutSELM_All                 /* All */,
    dfanoutSELM_Specified           /* Specified */,
    dfanoutSELM_Mask                /* Mask */
} dfanoutSELM;
#define dfanoutSELM_NUM_CHOICES 3

typedef struct dfanoutRecord {
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
    epicsFloat64        val;        /* Desired Output */
    epicsEnum16         selm;       /* Select Mechanism */
    epicsUInt16         seln;       /* Link Selection */
    DBLINK              sell;       /* Link Selection Loc */
    DBLINK              outa;       /* Output Spec A */
    DBLINK              outb;       /* Output Spec B */
    DBLINK              outc;       /* Output Spec C */
    DBLINK              outd;       /* Output Spec D */
    DBLINK              oute;       /* Output Spec E */
    DBLINK              outf;       /* Output Spec F */
    DBLINK              outg;       /* Output Spec G */
    DBLINK              outh;       /* Output Spec H */
    DBLINK              dol;        /* Desired Output Loc */
    epicsEnum16         omsl;       /* Output Mode Select */
    char                egu[16];    /* Engineering Units */
    epicsInt16          prec;       /* Display Precision */
    epicsFloat64        hopr;       /* High Operating Range */
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
    epicsFloat64        lalm;       /* Last Value Alarmed */
    epicsFloat64        alst;       /* Last Value Archived */
    epicsFloat64        mlst;       /* Last Val Monitored */
} dfanoutRecord;

typedef enum {
	dfanoutRecordNAME = 0,
	dfanoutRecordDESC = 1,
	dfanoutRecordASG = 2,
	dfanoutRecordSCAN = 3,
	dfanoutRecordPINI = 4,
	dfanoutRecordPHAS = 5,
	dfanoutRecordEVNT = 6,
	dfanoutRecordTSE = 7,
	dfanoutRecordTSEL = 8,
	dfanoutRecordDTYP = 9,
	dfanoutRecordDISV = 10,
	dfanoutRecordDISA = 11,
	dfanoutRecordSDIS = 12,
	dfanoutRecordMLOK = 13,
	dfanoutRecordMLIS = 14,
	dfanoutRecordDISP = 15,
	dfanoutRecordPROC = 16,
	dfanoutRecordSTAT = 17,
	dfanoutRecordSEVR = 18,
	dfanoutRecordNSTA = 19,
	dfanoutRecordNSEV = 20,
	dfanoutRecordACKS = 21,
	dfanoutRecordACKT = 22,
	dfanoutRecordDISS = 23,
	dfanoutRecordLCNT = 24,
	dfanoutRecordPACT = 25,
	dfanoutRecordPUTF = 26,
	dfanoutRecordRPRO = 27,
	dfanoutRecordASP = 28,
	dfanoutRecordPPN = 29,
	dfanoutRecordPPNR = 30,
	dfanoutRecordSPVT = 31,
	dfanoutRecordRSET = 32,
	dfanoutRecordDSET = 33,
	dfanoutRecordDPVT = 34,
	dfanoutRecordRDES = 35,
	dfanoutRecordLSET = 36,
	dfanoutRecordPRIO = 37,
	dfanoutRecordTPRO = 38,
	dfanoutRecordBKPT = 39,
	dfanoutRecordUDF = 40,
	dfanoutRecordUDFS = 41,
	dfanoutRecordTIME = 42,
	dfanoutRecordFLNK = 43,
	dfanoutRecordVAL = 44,
	dfanoutRecordSELM = 45,
	dfanoutRecordSELN = 46,
	dfanoutRecordSELL = 47,
	dfanoutRecordOUTA = 48,
	dfanoutRecordOUTB = 49,
	dfanoutRecordOUTC = 50,
	dfanoutRecordOUTD = 51,
	dfanoutRecordOUTE = 52,
	dfanoutRecordOUTF = 53,
	dfanoutRecordOUTG = 54,
	dfanoutRecordOUTH = 55,
	dfanoutRecordDOL = 56,
	dfanoutRecordOMSL = 57,
	dfanoutRecordEGU = 58,
	dfanoutRecordPREC = 59,
	dfanoutRecordHOPR = 60,
	dfanoutRecordLOPR = 61,
	dfanoutRecordHIHI = 62,
	dfanoutRecordLOLO = 63,
	dfanoutRecordHIGH = 64,
	dfanoutRecordLOW = 65,
	dfanoutRecordHHSV = 66,
	dfanoutRecordLLSV = 67,
	dfanoutRecordHSV = 68,
	dfanoutRecordLSV = 69,
	dfanoutRecordHYST = 70,
	dfanoutRecordADEL = 71,
	dfanoutRecordMDEL = 72,
	dfanoutRecordLALM = 73,
	dfanoutRecordALST = 74,
	dfanoutRecordMLST = 75
} dfanoutFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int dfanoutRecordSizeOffset(dbRecordType *prt)
{
    dfanoutRecord *prec = 0;

    assert(prt->no_fields == 76);
    prt->papFldDes[dfanoutRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[dfanoutRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[dfanoutRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[dfanoutRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[dfanoutRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[dfanoutRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[dfanoutRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[dfanoutRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[dfanoutRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[dfanoutRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[dfanoutRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[dfanoutRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[dfanoutRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[dfanoutRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[dfanoutRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[dfanoutRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[dfanoutRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[dfanoutRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[dfanoutRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[dfanoutRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[dfanoutRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[dfanoutRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[dfanoutRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[dfanoutRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[dfanoutRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[dfanoutRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[dfanoutRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[dfanoutRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[dfanoutRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[dfanoutRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[dfanoutRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[dfanoutRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[dfanoutRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[dfanoutRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[dfanoutRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[dfanoutRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[dfanoutRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[dfanoutRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[dfanoutRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[dfanoutRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[dfanoutRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[dfanoutRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[dfanoutRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[dfanoutRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[dfanoutRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[dfanoutRecordSELM]->size = sizeof(prec->selm);
    prt->papFldDes[dfanoutRecordSELN]->size = sizeof(prec->seln);
    prt->papFldDes[dfanoutRecordSELL]->size = sizeof(prec->sell);
    prt->papFldDes[dfanoutRecordOUTA]->size = sizeof(prec->outa);
    prt->papFldDes[dfanoutRecordOUTB]->size = sizeof(prec->outb);
    prt->papFldDes[dfanoutRecordOUTC]->size = sizeof(prec->outc);
    prt->papFldDes[dfanoutRecordOUTD]->size = sizeof(prec->outd);
    prt->papFldDes[dfanoutRecordOUTE]->size = sizeof(prec->oute);
    prt->papFldDes[dfanoutRecordOUTF]->size = sizeof(prec->outf);
    prt->papFldDes[dfanoutRecordOUTG]->size = sizeof(prec->outg);
    prt->papFldDes[dfanoutRecordOUTH]->size = sizeof(prec->outh);
    prt->papFldDes[dfanoutRecordDOL]->size = sizeof(prec->dol);
    prt->papFldDes[dfanoutRecordOMSL]->size = sizeof(prec->omsl);
    prt->papFldDes[dfanoutRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[dfanoutRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[dfanoutRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[dfanoutRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[dfanoutRecordHIHI]->size = sizeof(prec->hihi);
    prt->papFldDes[dfanoutRecordLOLO]->size = sizeof(prec->lolo);
    prt->papFldDes[dfanoutRecordHIGH]->size = sizeof(prec->high);
    prt->papFldDes[dfanoutRecordLOW]->size = sizeof(prec->low);
    prt->papFldDes[dfanoutRecordHHSV]->size = sizeof(prec->hhsv);
    prt->papFldDes[dfanoutRecordLLSV]->size = sizeof(prec->llsv);
    prt->papFldDes[dfanoutRecordHSV]->size = sizeof(prec->hsv);
    prt->papFldDes[dfanoutRecordLSV]->size = sizeof(prec->lsv);
    prt->papFldDes[dfanoutRecordHYST]->size = sizeof(prec->hyst);
    prt->papFldDes[dfanoutRecordADEL]->size = sizeof(prec->adel);
    prt->papFldDes[dfanoutRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[dfanoutRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[dfanoutRecordALST]->size = sizeof(prec->alst);
    prt->papFldDes[dfanoutRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[dfanoutRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[dfanoutRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[dfanoutRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[dfanoutRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[dfanoutRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[dfanoutRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[dfanoutRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[dfanoutRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[dfanoutRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[dfanoutRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[dfanoutRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[dfanoutRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[dfanoutRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[dfanoutRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[dfanoutRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[dfanoutRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[dfanoutRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[dfanoutRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[dfanoutRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[dfanoutRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[dfanoutRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[dfanoutRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[dfanoutRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[dfanoutRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[dfanoutRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[dfanoutRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[dfanoutRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[dfanoutRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[dfanoutRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[dfanoutRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[dfanoutRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[dfanoutRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[dfanoutRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[dfanoutRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[dfanoutRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[dfanoutRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[dfanoutRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[dfanoutRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[dfanoutRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[dfanoutRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[dfanoutRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[dfanoutRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[dfanoutRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[dfanoutRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[dfanoutRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[dfanoutRecordSELM]->offset = (unsigned short)((char *)&prec->selm - (char *)prec);
    prt->papFldDes[dfanoutRecordSELN]->offset = (unsigned short)((char *)&prec->seln - (char *)prec);
    prt->papFldDes[dfanoutRecordSELL]->offset = (unsigned short)((char *)&prec->sell - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTA]->offset = (unsigned short)((char *)&prec->outa - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTB]->offset = (unsigned short)((char *)&prec->outb - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTC]->offset = (unsigned short)((char *)&prec->outc - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTD]->offset = (unsigned short)((char *)&prec->outd - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTE]->offset = (unsigned short)((char *)&prec->oute - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTF]->offset = (unsigned short)((char *)&prec->outf - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTG]->offset = (unsigned short)((char *)&prec->outg - (char *)prec);
    prt->papFldDes[dfanoutRecordOUTH]->offset = (unsigned short)((char *)&prec->outh - (char *)prec);
    prt->papFldDes[dfanoutRecordDOL]->offset = (unsigned short)((char *)&prec->dol - (char *)prec);
    prt->papFldDes[dfanoutRecordOMSL]->offset = (unsigned short)((char *)&prec->omsl - (char *)prec);
    prt->papFldDes[dfanoutRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[dfanoutRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[dfanoutRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[dfanoutRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[dfanoutRecordHIHI]->offset = (unsigned short)((char *)&prec->hihi - (char *)prec);
    prt->papFldDes[dfanoutRecordLOLO]->offset = (unsigned short)((char *)&prec->lolo - (char *)prec);
    prt->papFldDes[dfanoutRecordHIGH]->offset = (unsigned short)((char *)&prec->high - (char *)prec);
    prt->papFldDes[dfanoutRecordLOW]->offset = (unsigned short)((char *)&prec->low - (char *)prec);
    prt->papFldDes[dfanoutRecordHHSV]->offset = (unsigned short)((char *)&prec->hhsv - (char *)prec);
    prt->papFldDes[dfanoutRecordLLSV]->offset = (unsigned short)((char *)&prec->llsv - (char *)prec);
    prt->papFldDes[dfanoutRecordHSV]->offset = (unsigned short)((char *)&prec->hsv - (char *)prec);
    prt->papFldDes[dfanoutRecordLSV]->offset = (unsigned short)((char *)&prec->lsv - (char *)prec);
    prt->papFldDes[dfanoutRecordHYST]->offset = (unsigned short)((char *)&prec->hyst - (char *)prec);
    prt->papFldDes[dfanoutRecordADEL]->offset = (unsigned short)((char *)&prec->adel - (char *)prec);
    prt->papFldDes[dfanoutRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[dfanoutRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[dfanoutRecordALST]->offset = (unsigned short)((char *)&prec->alst - (char *)prec);
    prt->papFldDes[dfanoutRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(dfanoutRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_dfanoutRecord_H */
