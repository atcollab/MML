/* aiRecord.h generated from aiRecord.dbd */

#ifndef INC_aiRecord_H
#define INC_aiRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct aiRecord {
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
    epicsFloat64        val;        /* Current EGU Value */
    DBLINK              inp;        /* Input Specification */
    epicsInt16          prec;       /* Display Precision */
    epicsEnum16         linr;       /* Linearization */
    epicsFloat64        eguf;       /* Engineer Units Full */
    epicsFloat64        egul;       /* Engineer Units Low */
    char                egu[16];    /* Engineering Units */
    epicsFloat64        hopr;       /* High Operating Range */
    epicsFloat64        lopr;       /* Low Operating Range */
    epicsFloat64        aoff;       /* Adjustment Offset */
    epicsFloat64        aslo;       /* Adjustment Slope */
    epicsFloat64        smoo;       /* Smoothing */
    epicsFloat64        hihi;       /* Hihi Alarm Limit */
    epicsFloat64        lolo;       /* Lolo Alarm Limit */
    epicsFloat64        high;       /* High Alarm Limit */
    epicsFloat64        low;        /* Low Alarm Limit */
    epicsEnum16         hhsv;       /* Hihi Severity */
    epicsEnum16         llsv;       /* Lolo Severity */
    epicsEnum16         hsv;        /* High Severity */
    epicsEnum16         lsv;        /* Low Severity */
    epicsFloat64        hyst;       /* Alarm Deadband */
    epicsFloat64        aftc;       /* Alarm Filter Time Constant */
    epicsFloat64        adel;       /* Archive Deadband */
    epicsFloat64        mdel;       /* Monitor Deadband */
    epicsFloat64        lalm;       /* Last Value Alarmed */
    epicsFloat64        afvl;       /* Alarm Filter Value */
    epicsFloat64        alst;       /* Last Value Archived */
    epicsFloat64        mlst;       /* Last Val Monitored */
    epicsFloat64        eslo;       /* Raw to EGU Slope */
    epicsFloat64        eoff;       /* Raw to EGU Offset */
    epicsUInt32         roff;       /* Raw Offset */
    void *   pbrk;                  /* Ptrto brkTable */
    epicsInt16          init;       /* Initialized? */
    epicsInt16          lbrk;       /* LastBreak Point */
    epicsInt32          rval;       /* Current Raw Value */
    epicsInt32          oraw;       /* Previous Raw Value */
    DBLINK              siol;       /* Sim. Input Specification */
    epicsFloat64        sval;       /* Simulation Value */
    DBLINK              siml;       /* Sim. Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Simulation Mode Severity */
} aiRecord;

typedef enum {
	aiRecordNAME = 0,
	aiRecordDESC = 1,
	aiRecordASG = 2,
	aiRecordSCAN = 3,
	aiRecordPINI = 4,
	aiRecordPHAS = 5,
	aiRecordEVNT = 6,
	aiRecordTSE = 7,
	aiRecordTSEL = 8,
	aiRecordDTYP = 9,
	aiRecordDISV = 10,
	aiRecordDISA = 11,
	aiRecordSDIS = 12,
	aiRecordMLOK = 13,
	aiRecordMLIS = 14,
	aiRecordDISP = 15,
	aiRecordPROC = 16,
	aiRecordSTAT = 17,
	aiRecordSEVR = 18,
	aiRecordNSTA = 19,
	aiRecordNSEV = 20,
	aiRecordACKS = 21,
	aiRecordACKT = 22,
	aiRecordDISS = 23,
	aiRecordLCNT = 24,
	aiRecordPACT = 25,
	aiRecordPUTF = 26,
	aiRecordRPRO = 27,
	aiRecordASP = 28,
	aiRecordPPN = 29,
	aiRecordPPNR = 30,
	aiRecordSPVT = 31,
	aiRecordRSET = 32,
	aiRecordDSET = 33,
	aiRecordDPVT = 34,
	aiRecordRDES = 35,
	aiRecordLSET = 36,
	aiRecordPRIO = 37,
	aiRecordTPRO = 38,
	aiRecordBKPT = 39,
	aiRecordUDF = 40,
	aiRecordUDFS = 41,
	aiRecordTIME = 42,
	aiRecordFLNK = 43,
	aiRecordVAL = 44,
	aiRecordINP = 45,
	aiRecordPREC = 46,
	aiRecordLINR = 47,
	aiRecordEGUF = 48,
	aiRecordEGUL = 49,
	aiRecordEGU = 50,
	aiRecordHOPR = 51,
	aiRecordLOPR = 52,
	aiRecordAOFF = 53,
	aiRecordASLO = 54,
	aiRecordSMOO = 55,
	aiRecordHIHI = 56,
	aiRecordLOLO = 57,
	aiRecordHIGH = 58,
	aiRecordLOW = 59,
	aiRecordHHSV = 60,
	aiRecordLLSV = 61,
	aiRecordHSV = 62,
	aiRecordLSV = 63,
	aiRecordHYST = 64,
	aiRecordAFTC = 65,
	aiRecordADEL = 66,
	aiRecordMDEL = 67,
	aiRecordLALM = 68,
	aiRecordAFVL = 69,
	aiRecordALST = 70,
	aiRecordMLST = 71,
	aiRecordESLO = 72,
	aiRecordEOFF = 73,
	aiRecordROFF = 74,
	aiRecordPBRK = 75,
	aiRecordINIT = 76,
	aiRecordLBRK = 77,
	aiRecordRVAL = 78,
	aiRecordORAW = 79,
	aiRecordSIOL = 80,
	aiRecordSVAL = 81,
	aiRecordSIML = 82,
	aiRecordSIMM = 83,
	aiRecordSIMS = 84
} aiFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int aiRecordSizeOffset(dbRecordType *prt)
{
    aiRecord *prec = 0;

    assert(prt->no_fields == 85);
    prt->papFldDes[aiRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[aiRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[aiRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[aiRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[aiRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[aiRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[aiRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[aiRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[aiRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[aiRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[aiRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[aiRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[aiRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[aiRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[aiRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[aiRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[aiRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[aiRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[aiRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[aiRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[aiRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[aiRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[aiRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[aiRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[aiRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[aiRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[aiRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[aiRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[aiRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[aiRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[aiRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[aiRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[aiRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[aiRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[aiRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[aiRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[aiRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[aiRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[aiRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[aiRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[aiRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[aiRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[aiRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[aiRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[aiRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[aiRecordINP]->size = sizeof(prec->inp);
    prt->papFldDes[aiRecordPREC]->size = sizeof(prec->prec);
    prt->papFldDes[aiRecordLINR]->size = sizeof(prec->linr);
    prt->papFldDes[aiRecordEGUF]->size = sizeof(prec->eguf);
    prt->papFldDes[aiRecordEGUL]->size = sizeof(prec->egul);
    prt->papFldDes[aiRecordEGU]->size = sizeof(prec->egu);
    prt->papFldDes[aiRecordHOPR]->size = sizeof(prec->hopr);
    prt->papFldDes[aiRecordLOPR]->size = sizeof(prec->lopr);
    prt->papFldDes[aiRecordAOFF]->size = sizeof(prec->aoff);
    prt->papFldDes[aiRecordASLO]->size = sizeof(prec->aslo);
    prt->papFldDes[aiRecordSMOO]->size = sizeof(prec->smoo);
    prt->papFldDes[aiRecordHIHI]->size = sizeof(prec->hihi);
    prt->papFldDes[aiRecordLOLO]->size = sizeof(prec->lolo);
    prt->papFldDes[aiRecordHIGH]->size = sizeof(prec->high);
    prt->papFldDes[aiRecordLOW]->size = sizeof(prec->low);
    prt->papFldDes[aiRecordHHSV]->size = sizeof(prec->hhsv);
    prt->papFldDes[aiRecordLLSV]->size = sizeof(prec->llsv);
    prt->papFldDes[aiRecordHSV]->size = sizeof(prec->hsv);
    prt->papFldDes[aiRecordLSV]->size = sizeof(prec->lsv);
    prt->papFldDes[aiRecordHYST]->size = sizeof(prec->hyst);
    prt->papFldDes[aiRecordAFTC]->size = sizeof(prec->aftc);
    prt->papFldDes[aiRecordADEL]->size = sizeof(prec->adel);
    prt->papFldDes[aiRecordMDEL]->size = sizeof(prec->mdel);
    prt->papFldDes[aiRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[aiRecordAFVL]->size = sizeof(prec->afvl);
    prt->papFldDes[aiRecordALST]->size = sizeof(prec->alst);
    prt->papFldDes[aiRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[aiRecordESLO]->size = sizeof(prec->eslo);
    prt->papFldDes[aiRecordEOFF]->size = sizeof(prec->eoff);
    prt->papFldDes[aiRecordROFF]->size = sizeof(prec->roff);
    prt->papFldDes[aiRecordPBRK]->size = sizeof(prec->pbrk);
    prt->papFldDes[aiRecordINIT]->size = sizeof(prec->init);
    prt->papFldDes[aiRecordLBRK]->size = sizeof(prec->lbrk);
    prt->papFldDes[aiRecordRVAL]->size = sizeof(prec->rval);
    prt->papFldDes[aiRecordORAW]->size = sizeof(prec->oraw);
    prt->papFldDes[aiRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[aiRecordSVAL]->size = sizeof(prec->sval);
    prt->papFldDes[aiRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[aiRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[aiRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[aiRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[aiRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[aiRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[aiRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[aiRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[aiRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[aiRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[aiRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[aiRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[aiRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[aiRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[aiRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[aiRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[aiRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[aiRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[aiRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[aiRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[aiRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[aiRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[aiRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[aiRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[aiRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[aiRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[aiRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[aiRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[aiRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[aiRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[aiRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[aiRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[aiRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[aiRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[aiRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[aiRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[aiRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[aiRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[aiRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[aiRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[aiRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[aiRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[aiRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[aiRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[aiRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[aiRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[aiRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[aiRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[aiRecordINP]->offset = (unsigned short)((char *)&prec->inp - (char *)prec);
    prt->papFldDes[aiRecordPREC]->offset = (unsigned short)((char *)&prec->prec - (char *)prec);
    prt->papFldDes[aiRecordLINR]->offset = (unsigned short)((char *)&prec->linr - (char *)prec);
    prt->papFldDes[aiRecordEGUF]->offset = (unsigned short)((char *)&prec->eguf - (char *)prec);
    prt->papFldDes[aiRecordEGUL]->offset = (unsigned short)((char *)&prec->egul - (char *)prec);
    prt->papFldDes[aiRecordEGU]->offset = (unsigned short)((char *)&prec->egu - (char *)prec);
    prt->papFldDes[aiRecordHOPR]->offset = (unsigned short)((char *)&prec->hopr - (char *)prec);
    prt->papFldDes[aiRecordLOPR]->offset = (unsigned short)((char *)&prec->lopr - (char *)prec);
    prt->papFldDes[aiRecordAOFF]->offset = (unsigned short)((char *)&prec->aoff - (char *)prec);
    prt->papFldDes[aiRecordASLO]->offset = (unsigned short)((char *)&prec->aslo - (char *)prec);
    prt->papFldDes[aiRecordSMOO]->offset = (unsigned short)((char *)&prec->smoo - (char *)prec);
    prt->papFldDes[aiRecordHIHI]->offset = (unsigned short)((char *)&prec->hihi - (char *)prec);
    prt->papFldDes[aiRecordLOLO]->offset = (unsigned short)((char *)&prec->lolo - (char *)prec);
    prt->papFldDes[aiRecordHIGH]->offset = (unsigned short)((char *)&prec->high - (char *)prec);
    prt->papFldDes[aiRecordLOW]->offset = (unsigned short)((char *)&prec->low - (char *)prec);
    prt->papFldDes[aiRecordHHSV]->offset = (unsigned short)((char *)&prec->hhsv - (char *)prec);
    prt->papFldDes[aiRecordLLSV]->offset = (unsigned short)((char *)&prec->llsv - (char *)prec);
    prt->papFldDes[aiRecordHSV]->offset = (unsigned short)((char *)&prec->hsv - (char *)prec);
    prt->papFldDes[aiRecordLSV]->offset = (unsigned short)((char *)&prec->lsv - (char *)prec);
    prt->papFldDes[aiRecordHYST]->offset = (unsigned short)((char *)&prec->hyst - (char *)prec);
    prt->papFldDes[aiRecordAFTC]->offset = (unsigned short)((char *)&prec->aftc - (char *)prec);
    prt->papFldDes[aiRecordADEL]->offset = (unsigned short)((char *)&prec->adel - (char *)prec);
    prt->papFldDes[aiRecordMDEL]->offset = (unsigned short)((char *)&prec->mdel - (char *)prec);
    prt->papFldDes[aiRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[aiRecordAFVL]->offset = (unsigned short)((char *)&prec->afvl - (char *)prec);
    prt->papFldDes[aiRecordALST]->offset = (unsigned short)((char *)&prec->alst - (char *)prec);
    prt->papFldDes[aiRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->papFldDes[aiRecordESLO]->offset = (unsigned short)((char *)&prec->eslo - (char *)prec);
    prt->papFldDes[aiRecordEOFF]->offset = (unsigned short)((char *)&prec->eoff - (char *)prec);
    prt->papFldDes[aiRecordROFF]->offset = (unsigned short)((char *)&prec->roff - (char *)prec);
    prt->papFldDes[aiRecordPBRK]->offset = (unsigned short)((char *)&prec->pbrk - (char *)prec);
    prt->papFldDes[aiRecordINIT]->offset = (unsigned short)((char *)&prec->init - (char *)prec);
    prt->papFldDes[aiRecordLBRK]->offset = (unsigned short)((char *)&prec->lbrk - (char *)prec);
    prt->papFldDes[aiRecordRVAL]->offset = (unsigned short)((char *)&prec->rval - (char *)prec);
    prt->papFldDes[aiRecordORAW]->offset = (unsigned short)((char *)&prec->oraw - (char *)prec);
    prt->papFldDes[aiRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[aiRecordSVAL]->offset = (unsigned short)((char *)&prec->sval - (char *)prec);
    prt->papFldDes[aiRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[aiRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[aiRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(aiRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_aiRecord_H */
