/* mbboRecord.h generated from mbboRecord.dbd */

#ifndef INC_mbboRecord_H
#define INC_mbboRecord_H

#include "epicsTypes.h"
#include "link.h"
#include "epicsMutex.h"
#include "ellLib.h"
#include "epicsTime.h"

typedef struct mbboRecord {
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
    epicsEnum16         val;        /* Desired Value */
    DBLINK              dol;        /* Desired Output Loc */
    epicsEnum16         omsl;       /* Output Mode Select */
    epicsUInt16         nobt;       /* Number of Bits */
    DBLINK              out;        /* Output Specification */
    epicsUInt32         zrvl;       /* Zero Value */
    epicsUInt32         onvl;       /* One Value */
    epicsUInt32         twvl;       /* Two Value */
    epicsUInt32         thvl;       /* Three Value */
    epicsUInt32         frvl;       /* Four Value */
    epicsUInt32         fvvl;       /* Five Value */
    epicsUInt32         sxvl;       /* Six Value */
    epicsUInt32         svvl;       /* Seven Value */
    epicsUInt32         eivl;       /* Eight Value */
    epicsUInt32         nivl;       /* Nine Value */
    epicsUInt32         tevl;       /* Ten Value */
    epicsUInt32         elvl;       /* Eleven Value */
    epicsUInt32         tvvl;       /* Twelve Value */
    epicsUInt32         ttvl;       /* Thirteen Value */
    epicsUInt32         ftvl;       /* Fourteen Value */
    epicsUInt32         ffvl;       /* Fifteen Value */
    char                zrst[26];   /* Zero String */
    char                onst[26];   /* One String */
    char                twst[26];   /* Two String */
    char                thst[26];   /* Three String */
    char                frst[26];   /* Four String */
    char                fvst[26];   /* Five String */
    char                sxst[26];   /* Six String */
    char                svst[26];   /* Seven String */
    char                eist[26];   /* Eight String */
    char                nist[26];   /* Nine String */
    char                test[26];   /* Ten String */
    char                elst[26];   /* Eleven String */
    char                tvst[26];   /* Twelve String */
    char                ttst[26];   /* Thirteen String */
    char                ftst[26];   /* Fourteen String */
    char                ffst[26];   /* Fifteen String */
    epicsEnum16         zrsv;       /* State Zero Severity */
    epicsEnum16         onsv;       /* State One Severity */
    epicsEnum16         twsv;       /* State Two Severity */
    epicsEnum16         thsv;       /* State Three Severity */
    epicsEnum16         frsv;       /* State Four Severity */
    epicsEnum16         fvsv;       /* State Five Severity */
    epicsEnum16         sxsv;       /* State Six Severity */
    epicsEnum16         svsv;       /* State Seven Severity */
    epicsEnum16         eisv;       /* State Eight Severity */
    epicsEnum16         nisv;       /* State Nine Severity */
    epicsEnum16         tesv;       /* State Ten Severity */
    epicsEnum16         elsv;       /* State Eleven Severity */
    epicsEnum16         tvsv;       /* State Twelve Severity */
    epicsEnum16         ttsv;       /* State Thirteen Sevr */
    epicsEnum16         ftsv;       /* State Fourteen Sevr */
    epicsEnum16         ffsv;       /* State Fifteen Sevr */
    epicsEnum16         unsv;       /* Unknown State Sevr */
    epicsEnum16         cosv;       /* Change of State Sevr */
    epicsUInt32         rval;       /* Raw Value */
    epicsUInt32         oraw;       /* Prev Raw Value */
    epicsUInt32         rbv;        /* Readback Value */
    epicsUInt32         orbv;       /* Prev Readback Value */
    epicsUInt32         mask;       /* Hardware Mask */
    epicsUInt16         mlst;       /* Last Value Monitored */
    epicsUInt16         lalm;       /* Last Value Alarmed */
    epicsInt16          sdef;       /* States Defined */
    epicsUInt16         shft;       /* Shift */
    DBLINK              siol;       /* Sim Output Specifctn */
    DBLINK              siml;       /* Sim Mode Location */
    epicsEnum16         simm;       /* Simulation Mode */
    epicsEnum16         sims;       /* Sim mode Alarm Svrty */
    epicsEnum16         ivoa;       /* INVALID outpt action */
    epicsUInt16         ivov;       /* INVALID output value */
} mbboRecord;

typedef enum {
	mbboRecordNAME = 0,
	mbboRecordDESC = 1,
	mbboRecordASG = 2,
	mbboRecordSCAN = 3,
	mbboRecordPINI = 4,
	mbboRecordPHAS = 5,
	mbboRecordEVNT = 6,
	mbboRecordTSE = 7,
	mbboRecordTSEL = 8,
	mbboRecordDTYP = 9,
	mbboRecordDISV = 10,
	mbboRecordDISA = 11,
	mbboRecordSDIS = 12,
	mbboRecordMLOK = 13,
	mbboRecordMLIS = 14,
	mbboRecordDISP = 15,
	mbboRecordPROC = 16,
	mbboRecordSTAT = 17,
	mbboRecordSEVR = 18,
	mbboRecordNSTA = 19,
	mbboRecordNSEV = 20,
	mbboRecordACKS = 21,
	mbboRecordACKT = 22,
	mbboRecordDISS = 23,
	mbboRecordLCNT = 24,
	mbboRecordPACT = 25,
	mbboRecordPUTF = 26,
	mbboRecordRPRO = 27,
	mbboRecordASP = 28,
	mbboRecordPPN = 29,
	mbboRecordPPNR = 30,
	mbboRecordSPVT = 31,
	mbboRecordRSET = 32,
	mbboRecordDSET = 33,
	mbboRecordDPVT = 34,
	mbboRecordRDES = 35,
	mbboRecordLSET = 36,
	mbboRecordPRIO = 37,
	mbboRecordTPRO = 38,
	mbboRecordBKPT = 39,
	mbboRecordUDF = 40,
	mbboRecordUDFS = 41,
	mbboRecordTIME = 42,
	mbboRecordFLNK = 43,
	mbboRecordVAL = 44,
	mbboRecordDOL = 45,
	mbboRecordOMSL = 46,
	mbboRecordNOBT = 47,
	mbboRecordOUT = 48,
	mbboRecordZRVL = 49,
	mbboRecordONVL = 50,
	mbboRecordTWVL = 51,
	mbboRecordTHVL = 52,
	mbboRecordFRVL = 53,
	mbboRecordFVVL = 54,
	mbboRecordSXVL = 55,
	mbboRecordSVVL = 56,
	mbboRecordEIVL = 57,
	mbboRecordNIVL = 58,
	mbboRecordTEVL = 59,
	mbboRecordELVL = 60,
	mbboRecordTVVL = 61,
	mbboRecordTTVL = 62,
	mbboRecordFTVL = 63,
	mbboRecordFFVL = 64,
	mbboRecordZRST = 65,
	mbboRecordONST = 66,
	mbboRecordTWST = 67,
	mbboRecordTHST = 68,
	mbboRecordFRST = 69,
	mbboRecordFVST = 70,
	mbboRecordSXST = 71,
	mbboRecordSVST = 72,
	mbboRecordEIST = 73,
	mbboRecordNIST = 74,
	mbboRecordTEST = 75,
	mbboRecordELST = 76,
	mbboRecordTVST = 77,
	mbboRecordTTST = 78,
	mbboRecordFTST = 79,
	mbboRecordFFST = 80,
	mbboRecordZRSV = 81,
	mbboRecordONSV = 82,
	mbboRecordTWSV = 83,
	mbboRecordTHSV = 84,
	mbboRecordFRSV = 85,
	mbboRecordFVSV = 86,
	mbboRecordSXSV = 87,
	mbboRecordSVSV = 88,
	mbboRecordEISV = 89,
	mbboRecordNISV = 90,
	mbboRecordTESV = 91,
	mbboRecordELSV = 92,
	mbboRecordTVSV = 93,
	mbboRecordTTSV = 94,
	mbboRecordFTSV = 95,
	mbboRecordFFSV = 96,
	mbboRecordUNSV = 97,
	mbboRecordCOSV = 98,
	mbboRecordRVAL = 99,
	mbboRecordORAW = 100,
	mbboRecordRBV = 101,
	mbboRecordORBV = 102,
	mbboRecordMASK = 103,
	mbboRecordMLST = 104,
	mbboRecordLALM = 105,
	mbboRecordSDEF = 106,
	mbboRecordSHFT = 107,
	mbboRecordSIOL = 108,
	mbboRecordSIML = 109,
	mbboRecordSIMM = 110,
	mbboRecordSIMS = 111,
	mbboRecordIVOA = 112,
	mbboRecordIVOV = 113
} mbboFieldIndex;

#ifdef GEN_SIZE_OFFSET

#include <epicsAssert.h>
#include <epicsExport.h>
#ifdef __cplusplus
extern "C" {
#endif
static int mbboRecordSizeOffset(dbRecordType *prt)
{
    mbboRecord *prec = 0;

    assert(prt->no_fields == 114);
    prt->papFldDes[mbboRecordNAME]->size = sizeof(prec->name);
    prt->papFldDes[mbboRecordDESC]->size = sizeof(prec->desc);
    prt->papFldDes[mbboRecordASG]->size = sizeof(prec->asg);
    prt->papFldDes[mbboRecordSCAN]->size = sizeof(prec->scan);
    prt->papFldDes[mbboRecordPINI]->size = sizeof(prec->pini);
    prt->papFldDes[mbboRecordPHAS]->size = sizeof(prec->phas);
    prt->papFldDes[mbboRecordEVNT]->size = sizeof(prec->evnt);
    prt->papFldDes[mbboRecordTSE]->size = sizeof(prec->tse);
    prt->papFldDes[mbboRecordTSEL]->size = sizeof(prec->tsel);
    prt->papFldDes[mbboRecordDTYP]->size = sizeof(prec->dtyp);
    prt->papFldDes[mbboRecordDISV]->size = sizeof(prec->disv);
    prt->papFldDes[mbboRecordDISA]->size = sizeof(prec->disa);
    prt->papFldDes[mbboRecordSDIS]->size = sizeof(prec->sdis);
    prt->papFldDes[mbboRecordMLOK]->size = sizeof(prec->mlok);
    prt->papFldDes[mbboRecordMLIS]->size = sizeof(prec->mlis);
    prt->papFldDes[mbboRecordDISP]->size = sizeof(prec->disp);
    prt->papFldDes[mbboRecordPROC]->size = sizeof(prec->proc);
    prt->papFldDes[mbboRecordSTAT]->size = sizeof(prec->stat);
    prt->papFldDes[mbboRecordSEVR]->size = sizeof(prec->sevr);
    prt->papFldDes[mbboRecordNSTA]->size = sizeof(prec->nsta);
    prt->papFldDes[mbboRecordNSEV]->size = sizeof(prec->nsev);
    prt->papFldDes[mbboRecordACKS]->size = sizeof(prec->acks);
    prt->papFldDes[mbboRecordACKT]->size = sizeof(prec->ackt);
    prt->papFldDes[mbboRecordDISS]->size = sizeof(prec->diss);
    prt->papFldDes[mbboRecordLCNT]->size = sizeof(prec->lcnt);
    prt->papFldDes[mbboRecordPACT]->size = sizeof(prec->pact);
    prt->papFldDes[mbboRecordPUTF]->size = sizeof(prec->putf);
    prt->papFldDes[mbboRecordRPRO]->size = sizeof(prec->rpro);
    prt->papFldDes[mbboRecordASP]->size = sizeof(prec->asp);
    prt->papFldDes[mbboRecordPPN]->size = sizeof(prec->ppn);
    prt->papFldDes[mbboRecordPPNR]->size = sizeof(prec->ppnr);
    prt->papFldDes[mbboRecordSPVT]->size = sizeof(prec->spvt);
    prt->papFldDes[mbboRecordRSET]->size = sizeof(prec->rset);
    prt->papFldDes[mbboRecordDSET]->size = sizeof(prec->dset);
    prt->papFldDes[mbboRecordDPVT]->size = sizeof(prec->dpvt);
    prt->papFldDes[mbboRecordRDES]->size = sizeof(prec->rdes);
    prt->papFldDes[mbboRecordLSET]->size = sizeof(prec->lset);
    prt->papFldDes[mbboRecordPRIO]->size = sizeof(prec->prio);
    prt->papFldDes[mbboRecordTPRO]->size = sizeof(prec->tpro);
    prt->papFldDes[mbboRecordBKPT]->size = sizeof(prec->bkpt);
    prt->papFldDes[mbboRecordUDF]->size = sizeof(prec->udf);
    prt->papFldDes[mbboRecordUDFS]->size = sizeof(prec->udfs);
    prt->papFldDes[mbboRecordTIME]->size = sizeof(prec->time);
    prt->papFldDes[mbboRecordFLNK]->size = sizeof(prec->flnk);
    prt->papFldDes[mbboRecordVAL]->size = sizeof(prec->val);
    prt->papFldDes[mbboRecordDOL]->size = sizeof(prec->dol);
    prt->papFldDes[mbboRecordOMSL]->size = sizeof(prec->omsl);
    prt->papFldDes[mbboRecordNOBT]->size = sizeof(prec->nobt);
    prt->papFldDes[mbboRecordOUT]->size = sizeof(prec->out);
    prt->papFldDes[mbboRecordZRVL]->size = sizeof(prec->zrvl);
    prt->papFldDes[mbboRecordONVL]->size = sizeof(prec->onvl);
    prt->papFldDes[mbboRecordTWVL]->size = sizeof(prec->twvl);
    prt->papFldDes[mbboRecordTHVL]->size = sizeof(prec->thvl);
    prt->papFldDes[mbboRecordFRVL]->size = sizeof(prec->frvl);
    prt->papFldDes[mbboRecordFVVL]->size = sizeof(prec->fvvl);
    prt->papFldDes[mbboRecordSXVL]->size = sizeof(prec->sxvl);
    prt->papFldDes[mbboRecordSVVL]->size = sizeof(prec->svvl);
    prt->papFldDes[mbboRecordEIVL]->size = sizeof(prec->eivl);
    prt->papFldDes[mbboRecordNIVL]->size = sizeof(prec->nivl);
    prt->papFldDes[mbboRecordTEVL]->size = sizeof(prec->tevl);
    prt->papFldDes[mbboRecordELVL]->size = sizeof(prec->elvl);
    prt->papFldDes[mbboRecordTVVL]->size = sizeof(prec->tvvl);
    prt->papFldDes[mbboRecordTTVL]->size = sizeof(prec->ttvl);
    prt->papFldDes[mbboRecordFTVL]->size = sizeof(prec->ftvl);
    prt->papFldDes[mbboRecordFFVL]->size = sizeof(prec->ffvl);
    prt->papFldDes[mbboRecordZRST]->size = sizeof(prec->zrst);
    prt->papFldDes[mbboRecordONST]->size = sizeof(prec->onst);
    prt->papFldDes[mbboRecordTWST]->size = sizeof(prec->twst);
    prt->papFldDes[mbboRecordTHST]->size = sizeof(prec->thst);
    prt->papFldDes[mbboRecordFRST]->size = sizeof(prec->frst);
    prt->papFldDes[mbboRecordFVST]->size = sizeof(prec->fvst);
    prt->papFldDes[mbboRecordSXST]->size = sizeof(prec->sxst);
    prt->papFldDes[mbboRecordSVST]->size = sizeof(prec->svst);
    prt->papFldDes[mbboRecordEIST]->size = sizeof(prec->eist);
    prt->papFldDes[mbboRecordNIST]->size = sizeof(prec->nist);
    prt->papFldDes[mbboRecordTEST]->size = sizeof(prec->test);
    prt->papFldDes[mbboRecordELST]->size = sizeof(prec->elst);
    prt->papFldDes[mbboRecordTVST]->size = sizeof(prec->tvst);
    prt->papFldDes[mbboRecordTTST]->size = sizeof(prec->ttst);
    prt->papFldDes[mbboRecordFTST]->size = sizeof(prec->ftst);
    prt->papFldDes[mbboRecordFFST]->size = sizeof(prec->ffst);
    prt->papFldDes[mbboRecordZRSV]->size = sizeof(prec->zrsv);
    prt->papFldDes[mbboRecordONSV]->size = sizeof(prec->onsv);
    prt->papFldDes[mbboRecordTWSV]->size = sizeof(prec->twsv);
    prt->papFldDes[mbboRecordTHSV]->size = sizeof(prec->thsv);
    prt->papFldDes[mbboRecordFRSV]->size = sizeof(prec->frsv);
    prt->papFldDes[mbboRecordFVSV]->size = sizeof(prec->fvsv);
    prt->papFldDes[mbboRecordSXSV]->size = sizeof(prec->sxsv);
    prt->papFldDes[mbboRecordSVSV]->size = sizeof(prec->svsv);
    prt->papFldDes[mbboRecordEISV]->size = sizeof(prec->eisv);
    prt->papFldDes[mbboRecordNISV]->size = sizeof(prec->nisv);
    prt->papFldDes[mbboRecordTESV]->size = sizeof(prec->tesv);
    prt->papFldDes[mbboRecordELSV]->size = sizeof(prec->elsv);
    prt->papFldDes[mbboRecordTVSV]->size = sizeof(prec->tvsv);
    prt->papFldDes[mbboRecordTTSV]->size = sizeof(prec->ttsv);
    prt->papFldDes[mbboRecordFTSV]->size = sizeof(prec->ftsv);
    prt->papFldDes[mbboRecordFFSV]->size = sizeof(prec->ffsv);
    prt->papFldDes[mbboRecordUNSV]->size = sizeof(prec->unsv);
    prt->papFldDes[mbboRecordCOSV]->size = sizeof(prec->cosv);
    prt->papFldDes[mbboRecordRVAL]->size = sizeof(prec->rval);
    prt->papFldDes[mbboRecordORAW]->size = sizeof(prec->oraw);
    prt->papFldDes[mbboRecordRBV]->size = sizeof(prec->rbv);
    prt->papFldDes[mbboRecordORBV]->size = sizeof(prec->orbv);
    prt->papFldDes[mbboRecordMASK]->size = sizeof(prec->mask);
    prt->papFldDes[mbboRecordMLST]->size = sizeof(prec->mlst);
    prt->papFldDes[mbboRecordLALM]->size = sizeof(prec->lalm);
    prt->papFldDes[mbboRecordSDEF]->size = sizeof(prec->sdef);
    prt->papFldDes[mbboRecordSHFT]->size = sizeof(prec->shft);
    prt->papFldDes[mbboRecordSIOL]->size = sizeof(prec->siol);
    prt->papFldDes[mbboRecordSIML]->size = sizeof(prec->siml);
    prt->papFldDes[mbboRecordSIMM]->size = sizeof(prec->simm);
    prt->papFldDes[mbboRecordSIMS]->size = sizeof(prec->sims);
    prt->papFldDes[mbboRecordIVOA]->size = sizeof(prec->ivoa);
    prt->papFldDes[mbboRecordIVOV]->size = sizeof(prec->ivov);
    prt->papFldDes[mbboRecordNAME]->offset = (unsigned short)((char *)&prec->name - (char *)prec);
    prt->papFldDes[mbboRecordDESC]->offset = (unsigned short)((char *)&prec->desc - (char *)prec);
    prt->papFldDes[mbboRecordASG]->offset = (unsigned short)((char *)&prec->asg - (char *)prec);
    prt->papFldDes[mbboRecordSCAN]->offset = (unsigned short)((char *)&prec->scan - (char *)prec);
    prt->papFldDes[mbboRecordPINI]->offset = (unsigned short)((char *)&prec->pini - (char *)prec);
    prt->papFldDes[mbboRecordPHAS]->offset = (unsigned short)((char *)&prec->phas - (char *)prec);
    prt->papFldDes[mbboRecordEVNT]->offset = (unsigned short)((char *)&prec->evnt - (char *)prec);
    prt->papFldDes[mbboRecordTSE]->offset = (unsigned short)((char *)&prec->tse - (char *)prec);
    prt->papFldDes[mbboRecordTSEL]->offset = (unsigned short)((char *)&prec->tsel - (char *)prec);
    prt->papFldDes[mbboRecordDTYP]->offset = (unsigned short)((char *)&prec->dtyp - (char *)prec);
    prt->papFldDes[mbboRecordDISV]->offset = (unsigned short)((char *)&prec->disv - (char *)prec);
    prt->papFldDes[mbboRecordDISA]->offset = (unsigned short)((char *)&prec->disa - (char *)prec);
    prt->papFldDes[mbboRecordSDIS]->offset = (unsigned short)((char *)&prec->sdis - (char *)prec);
    prt->papFldDes[mbboRecordMLOK]->offset = (unsigned short)((char *)&prec->mlok - (char *)prec);
    prt->papFldDes[mbboRecordMLIS]->offset = (unsigned short)((char *)&prec->mlis - (char *)prec);
    prt->papFldDes[mbboRecordDISP]->offset = (unsigned short)((char *)&prec->disp - (char *)prec);
    prt->papFldDes[mbboRecordPROC]->offset = (unsigned short)((char *)&prec->proc - (char *)prec);
    prt->papFldDes[mbboRecordSTAT]->offset = (unsigned short)((char *)&prec->stat - (char *)prec);
    prt->papFldDes[mbboRecordSEVR]->offset = (unsigned short)((char *)&prec->sevr - (char *)prec);
    prt->papFldDes[mbboRecordNSTA]->offset = (unsigned short)((char *)&prec->nsta - (char *)prec);
    prt->papFldDes[mbboRecordNSEV]->offset = (unsigned short)((char *)&prec->nsev - (char *)prec);
    prt->papFldDes[mbboRecordACKS]->offset = (unsigned short)((char *)&prec->acks - (char *)prec);
    prt->papFldDes[mbboRecordACKT]->offset = (unsigned short)((char *)&prec->ackt - (char *)prec);
    prt->papFldDes[mbboRecordDISS]->offset = (unsigned short)((char *)&prec->diss - (char *)prec);
    prt->papFldDes[mbboRecordLCNT]->offset = (unsigned short)((char *)&prec->lcnt - (char *)prec);
    prt->papFldDes[mbboRecordPACT]->offset = (unsigned short)((char *)&prec->pact - (char *)prec);
    prt->papFldDes[mbboRecordPUTF]->offset = (unsigned short)((char *)&prec->putf - (char *)prec);
    prt->papFldDes[mbboRecordRPRO]->offset = (unsigned short)((char *)&prec->rpro - (char *)prec);
    prt->papFldDes[mbboRecordASP]->offset = (unsigned short)((char *)&prec->asp - (char *)prec);
    prt->papFldDes[mbboRecordPPN]->offset = (unsigned short)((char *)&prec->ppn - (char *)prec);
    prt->papFldDes[mbboRecordPPNR]->offset = (unsigned short)((char *)&prec->ppnr - (char *)prec);
    prt->papFldDes[mbboRecordSPVT]->offset = (unsigned short)((char *)&prec->spvt - (char *)prec);
    prt->papFldDes[mbboRecordRSET]->offset = (unsigned short)((char *)&prec->rset - (char *)prec);
    prt->papFldDes[mbboRecordDSET]->offset = (unsigned short)((char *)&prec->dset - (char *)prec);
    prt->papFldDes[mbboRecordDPVT]->offset = (unsigned short)((char *)&prec->dpvt - (char *)prec);
    prt->papFldDes[mbboRecordRDES]->offset = (unsigned short)((char *)&prec->rdes - (char *)prec);
    prt->papFldDes[mbboRecordLSET]->offset = (unsigned short)((char *)&prec->lset - (char *)prec);
    prt->papFldDes[mbboRecordPRIO]->offset = (unsigned short)((char *)&prec->prio - (char *)prec);
    prt->papFldDes[mbboRecordTPRO]->offset = (unsigned short)((char *)&prec->tpro - (char *)prec);
    prt->papFldDes[mbboRecordBKPT]->offset = (unsigned short)((char *)&prec->bkpt - (char *)prec);
    prt->papFldDes[mbboRecordUDF]->offset = (unsigned short)((char *)&prec->udf - (char *)prec);
    prt->papFldDes[mbboRecordUDFS]->offset = (unsigned short)((char *)&prec->udfs - (char *)prec);
    prt->papFldDes[mbboRecordTIME]->offset = (unsigned short)((char *)&prec->time - (char *)prec);
    prt->papFldDes[mbboRecordFLNK]->offset = (unsigned short)((char *)&prec->flnk - (char *)prec);
    prt->papFldDes[mbboRecordVAL]->offset = (unsigned short)((char *)&prec->val - (char *)prec);
    prt->papFldDes[mbboRecordDOL]->offset = (unsigned short)((char *)&prec->dol - (char *)prec);
    prt->papFldDes[mbboRecordOMSL]->offset = (unsigned short)((char *)&prec->omsl - (char *)prec);
    prt->papFldDes[mbboRecordNOBT]->offset = (unsigned short)((char *)&prec->nobt - (char *)prec);
    prt->papFldDes[mbboRecordOUT]->offset = (unsigned short)((char *)&prec->out - (char *)prec);
    prt->papFldDes[mbboRecordZRVL]->offset = (unsigned short)((char *)&prec->zrvl - (char *)prec);
    prt->papFldDes[mbboRecordONVL]->offset = (unsigned short)((char *)&prec->onvl - (char *)prec);
    prt->papFldDes[mbboRecordTWVL]->offset = (unsigned short)((char *)&prec->twvl - (char *)prec);
    prt->papFldDes[mbboRecordTHVL]->offset = (unsigned short)((char *)&prec->thvl - (char *)prec);
    prt->papFldDes[mbboRecordFRVL]->offset = (unsigned short)((char *)&prec->frvl - (char *)prec);
    prt->papFldDes[mbboRecordFVVL]->offset = (unsigned short)((char *)&prec->fvvl - (char *)prec);
    prt->papFldDes[mbboRecordSXVL]->offset = (unsigned short)((char *)&prec->sxvl - (char *)prec);
    prt->papFldDes[mbboRecordSVVL]->offset = (unsigned short)((char *)&prec->svvl - (char *)prec);
    prt->papFldDes[mbboRecordEIVL]->offset = (unsigned short)((char *)&prec->eivl - (char *)prec);
    prt->papFldDes[mbboRecordNIVL]->offset = (unsigned short)((char *)&prec->nivl - (char *)prec);
    prt->papFldDes[mbboRecordTEVL]->offset = (unsigned short)((char *)&prec->tevl - (char *)prec);
    prt->papFldDes[mbboRecordELVL]->offset = (unsigned short)((char *)&prec->elvl - (char *)prec);
    prt->papFldDes[mbboRecordTVVL]->offset = (unsigned short)((char *)&prec->tvvl - (char *)prec);
    prt->papFldDes[mbboRecordTTVL]->offset = (unsigned short)((char *)&prec->ttvl - (char *)prec);
    prt->papFldDes[mbboRecordFTVL]->offset = (unsigned short)((char *)&prec->ftvl - (char *)prec);
    prt->papFldDes[mbboRecordFFVL]->offset = (unsigned short)((char *)&prec->ffvl - (char *)prec);
    prt->papFldDes[mbboRecordZRST]->offset = (unsigned short)((char *)&prec->zrst - (char *)prec);
    prt->papFldDes[mbboRecordONST]->offset = (unsigned short)((char *)&prec->onst - (char *)prec);
    prt->papFldDes[mbboRecordTWST]->offset = (unsigned short)((char *)&prec->twst - (char *)prec);
    prt->papFldDes[mbboRecordTHST]->offset = (unsigned short)((char *)&prec->thst - (char *)prec);
    prt->papFldDes[mbboRecordFRST]->offset = (unsigned short)((char *)&prec->frst - (char *)prec);
    prt->papFldDes[mbboRecordFVST]->offset = (unsigned short)((char *)&prec->fvst - (char *)prec);
    prt->papFldDes[mbboRecordSXST]->offset = (unsigned short)((char *)&prec->sxst - (char *)prec);
    prt->papFldDes[mbboRecordSVST]->offset = (unsigned short)((char *)&prec->svst - (char *)prec);
    prt->papFldDes[mbboRecordEIST]->offset = (unsigned short)((char *)&prec->eist - (char *)prec);
    prt->papFldDes[mbboRecordNIST]->offset = (unsigned short)((char *)&prec->nist - (char *)prec);
    prt->papFldDes[mbboRecordTEST]->offset = (unsigned short)((char *)&prec->test - (char *)prec);
    prt->papFldDes[mbboRecordELST]->offset = (unsigned short)((char *)&prec->elst - (char *)prec);
    prt->papFldDes[mbboRecordTVST]->offset = (unsigned short)((char *)&prec->tvst - (char *)prec);
    prt->papFldDes[mbboRecordTTST]->offset = (unsigned short)((char *)&prec->ttst - (char *)prec);
    prt->papFldDes[mbboRecordFTST]->offset = (unsigned short)((char *)&prec->ftst - (char *)prec);
    prt->papFldDes[mbboRecordFFST]->offset = (unsigned short)((char *)&prec->ffst - (char *)prec);
    prt->papFldDes[mbboRecordZRSV]->offset = (unsigned short)((char *)&prec->zrsv - (char *)prec);
    prt->papFldDes[mbboRecordONSV]->offset = (unsigned short)((char *)&prec->onsv - (char *)prec);
    prt->papFldDes[mbboRecordTWSV]->offset = (unsigned short)((char *)&prec->twsv - (char *)prec);
    prt->papFldDes[mbboRecordTHSV]->offset = (unsigned short)((char *)&prec->thsv - (char *)prec);
    prt->papFldDes[mbboRecordFRSV]->offset = (unsigned short)((char *)&prec->frsv - (char *)prec);
    prt->papFldDes[mbboRecordFVSV]->offset = (unsigned short)((char *)&prec->fvsv - (char *)prec);
    prt->papFldDes[mbboRecordSXSV]->offset = (unsigned short)((char *)&prec->sxsv - (char *)prec);
    prt->papFldDes[mbboRecordSVSV]->offset = (unsigned short)((char *)&prec->svsv - (char *)prec);
    prt->papFldDes[mbboRecordEISV]->offset = (unsigned short)((char *)&prec->eisv - (char *)prec);
    prt->papFldDes[mbboRecordNISV]->offset = (unsigned short)((char *)&prec->nisv - (char *)prec);
    prt->papFldDes[mbboRecordTESV]->offset = (unsigned short)((char *)&prec->tesv - (char *)prec);
    prt->papFldDes[mbboRecordELSV]->offset = (unsigned short)((char *)&prec->elsv - (char *)prec);
    prt->papFldDes[mbboRecordTVSV]->offset = (unsigned short)((char *)&prec->tvsv - (char *)prec);
    prt->papFldDes[mbboRecordTTSV]->offset = (unsigned short)((char *)&prec->ttsv - (char *)prec);
    prt->papFldDes[mbboRecordFTSV]->offset = (unsigned short)((char *)&prec->ftsv - (char *)prec);
    prt->papFldDes[mbboRecordFFSV]->offset = (unsigned short)((char *)&prec->ffsv - (char *)prec);
    prt->papFldDes[mbboRecordUNSV]->offset = (unsigned short)((char *)&prec->unsv - (char *)prec);
    prt->papFldDes[mbboRecordCOSV]->offset = (unsigned short)((char *)&prec->cosv - (char *)prec);
    prt->papFldDes[mbboRecordRVAL]->offset = (unsigned short)((char *)&prec->rval - (char *)prec);
    prt->papFldDes[mbboRecordORAW]->offset = (unsigned short)((char *)&prec->oraw - (char *)prec);
    prt->papFldDes[mbboRecordRBV]->offset = (unsigned short)((char *)&prec->rbv - (char *)prec);
    prt->papFldDes[mbboRecordORBV]->offset = (unsigned short)((char *)&prec->orbv - (char *)prec);
    prt->papFldDes[mbboRecordMASK]->offset = (unsigned short)((char *)&prec->mask - (char *)prec);
    prt->papFldDes[mbboRecordMLST]->offset = (unsigned short)((char *)&prec->mlst - (char *)prec);
    prt->papFldDes[mbboRecordLALM]->offset = (unsigned short)((char *)&prec->lalm - (char *)prec);
    prt->papFldDes[mbboRecordSDEF]->offset = (unsigned short)((char *)&prec->sdef - (char *)prec);
    prt->papFldDes[mbboRecordSHFT]->offset = (unsigned short)((char *)&prec->shft - (char *)prec);
    prt->papFldDes[mbboRecordSIOL]->offset = (unsigned short)((char *)&prec->siol - (char *)prec);
    prt->papFldDes[mbboRecordSIML]->offset = (unsigned short)((char *)&prec->siml - (char *)prec);
    prt->papFldDes[mbboRecordSIMM]->offset = (unsigned short)((char *)&prec->simm - (char *)prec);
    prt->papFldDes[mbboRecordSIMS]->offset = (unsigned short)((char *)&prec->sims - (char *)prec);
    prt->papFldDes[mbboRecordIVOA]->offset = (unsigned short)((char *)&prec->ivoa - (char *)prec);
    prt->papFldDes[mbboRecordIVOV]->offset = (unsigned short)((char *)&prec->ivov - (char *)prec);
    prt->rec_size = sizeof(*prec);
    return 0;
}
epicsExportRegistrar(mbboRecordSizeOffset);

#ifdef __cplusplus
}
#endif
#endif /* GEN_SIZE_OFFSET */

#endif /* INC_mbboRecord_H */
