/* This rountine establishes a link between channel access full names and matlab family-type name        */
/* Also, SP-AM tolerance, present ramp rate, and time constants are set for each magnet type             */
/* Authored by Greg Portmann                                                                             */
/*                                                                                                       */
/* September, 2001 Christoph Steier, Tom Scarvie                                                         */
/* Added Bergoz BPMs(BBPM), Superbends(BSC), Superbend trim magnets (VCBSC) and Hall probes (BSChall)    */
/*                                                                                                       */
/* 2001-11-27, T.Scarvie, found typo that was probably causing SQSD tolreance warning errors             */
/* 2002-04-09, T.Scarvie, added QF and QD -- DAC, timeconstant, and ramprate channels                    */
/* 2002-04-09, T.Scarvie, added HCMxxT and VCMxxT -- DAC AC and AM channels                              */
/* 2002-04-16, T.Scarvie, added ExtraDelayPerAmp for BSC, QDA magnets (are these appropriate values??    */
/* 2002-04-16, T.Scarvie, modified SR04U HCM2,VCM2 boolean channels due to channel name changes          */
/* 2002-04-18, T.Scarvie, modified SR04U HCM2,VCM2 analog channels due to channel name changes           */
/* 2002-05-01, C. Steier, added SR11 IDBPM3+4                                                            */
/* 2002-06-14, T.Scarvie, added SR11U chicane channels and checks for legitimate sector for chicane calls*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "gpfunc.h"
#include "gplink.h"
#include "scalib.h"


/* Static variables */
static int  StatusArray1[MaxNumberOfChannels];
static double DataArray1[MaxNumberOfChannels];

static int  StatusArray2[MaxNumberOfChannels];
static double DataArray2[MaxNumberOfChannels];




/* Convert Family/DevList to a NameList */
int GetName(char *ChanName, char *Family, double SectorList, double DevList, int ChanTypeFlag)
{
	char ChanTypeStr[10];
	int ErrorFlag=0;

	if (ChanTypeFlag==0)
		 strcpy(ChanTypeStr, "AM");	/* Analog Monitor (AM)  */
	else if (ChanTypeFlag==1)
		 strcpy(ChanTypeStr, "AC");	/* Analog Control (AC)  */
	else if (ChanTypeFlag==2)
		 strcpy(ChanTypeStr, "BM");	/* Boolean monitor (BM) */
	else if (ChanTypeFlag==3)
		 strcpy(ChanTypeStr, "BC");	/* Boolean Control (BC) */
	else
		mexErrMsgTxt("Channel type unknown.");


	if (strcmp(Family,"BPMx")==0)
		sprintf(ChanName, "SR%02dC___BPM%1d_X_%s00", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"BPMy")==0)
		sprintf(ChanName, "SR%02dC___BPM%1d_Y_%s01", (int) SectorList, (int) DevList, ChanTypeStr);

	else if (strcmp(Family,"IDBPMx")==0 && DevList==1)
		sprintf(ChanName, "SR%02dS___IBPM%1dX_%s00", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"IDBPMy")==0 && DevList==1)
		sprintf(ChanName, "SR%02dS___IBPM%1dY_%s01", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"IDBPMx")==0 && DevList==2)
		sprintf(ChanName, "SR%02dS___IBPM%1dX_%s02", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"IDBPMy")==0 && DevList==2)
		sprintf(ChanName, "SR%02dS___IBPM%1dY_%s03", (int) SectorList, (int) DevList, ChanTypeStr);

	else if (strcmp(Family,"IDBPMx")==0 && DevList==3 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dS___IBPM%1dX_%s00", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"IDBPMy")==0 && DevList==3 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dS___IBPM%1dY_%s01", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"IDBPMx")==0 && DevList==4 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dS___IBPM%1dX_%s02", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"IDBPMy")==0 && DevList==4 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dS___IBPM%1dY_%s03", (int) SectorList, (int) DevList, ChanTypeStr);

	else if (strcmp(Family,"BBPMx")==0 && DevList==4 && (SectorList==4 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BPM%1dXT_%s00", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"BBPMy")==0 && DevList==4 && (SectorList==4 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BPM%1dYT_%s01", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"BBPMx")==0 && DevList==5 && (SectorList==4 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BPM%1dXT_%s02", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"BBPMy")==0 && DevList==5 && (SectorList==4 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BPM%1dYT_%s03", (int) SectorList, (int) DevList, ChanTypeStr);

	else if (strcmp(Family,"HCM")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___HCM1___%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM1___BM01", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM1___BM02", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM1___BC16", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM1_R_BC17", (int) SectorList);
	else if (strcmp(Family,"HCMdac")==0 && DevList==1   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___HCM1___AC10", (int) SectorList);
	else if (strcmp(Family,"HCMtimeconstant")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___HCM1___AC20", (int) SectorList);
	else if (strcmp(Family,"HCMramprate")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___HCM1___AC30", (int) SectorList);
	else if (strcmp(Family,"HCMtrim")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___HCM1T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"HCM")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___HCM2___%s01", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM2___BM04", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM2___BM05", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM2___BC18", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM2_R_BC19", (int) SectorList);
	else if (strcmp(Family,"HCMdac")==0 && DevList==2   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___HCM2___AC10", (int) SectorList);
	else if (strcmp(Family,"HCMtimeconstant")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___HCM2___AC20", (int) SectorList);
	else if (strcmp(Family,"HCMramprate")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___HCM2___AC30", (int) SectorList);
	else if (strcmp(Family,"HCMtrim")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___HCM2T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"HCM")==0 && DevList==3)
		sprintf(ChanName, "SR%02dC___HCSD1__%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==3 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSD1__BM01", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==3    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSD1__BM02", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==3    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSD1__BC16", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==3 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSD1R_BC17", (int) SectorList);

	else if (strcmp(Family,"HCM")==0 && DevList==4)
		sprintf(ChanName, "SR%02dC___HCSF1__%s02", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==4 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSF1__BM07", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==4    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSF1__BM08", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==4    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSF1__BC20", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==4 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSF1R_BC21", (int) SectorList);

	else if (strcmp(Family,"HCM")==0 && DevList==5)
		sprintf(ChanName, "SR%02dC___HCSF2__%s03", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==5 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSF2__BM10", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==5    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSF2__BM11", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==5    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSF2__BC22", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==5 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSF2R_BC23", (int) SectorList);

	else if (strcmp(Family,"HCM")==0 && DevList==6)
		sprintf(ChanName, "SR%02dC___HCSD2__%s01", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==6 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSD2__BM04", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==6    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCSD2__BM05", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==6    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSD2__BC18", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==6 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCSD2R_BC19", (int) SectorList);

	else if (strcmp(Family,"HCM")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___HCM3___%s02", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==7 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM3___BM07", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==7    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM3___BM08", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==7    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM3___BC20", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==7 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM3_R_BC21", (int) SectorList);
	else if (strcmp(Family,"HCMdac")==0 && DevList==7   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___HCM3___AC10", (int) SectorList);
	else if (strcmp(Family,"HCMtimeconstant")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___HCM3___AC20", (int) SectorList);
	else if (strcmp(Family,"HCMramprate")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___HCM3___AC30", (int) SectorList);
	else if (strcmp(Family,"HCMtrim")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___HCM3T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"HCM")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___HCM4___%s03", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"HCMready")==0 && DevList==8 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM4___BM10", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==8    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___HCM4___BM11", (int) SectorList);
	else if (strcmp(Family,"HCMon")==0 && DevList==8    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM4___BC22", (int) SectorList);
	else if (strcmp(Family,"HCMreset")==0 && DevList==8 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___HCM4_R_BC23", (int) SectorList);
	else if (strcmp(Family,"HCMdac")==0 && DevList==8   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___HCM4___AC10", (int) SectorList);
	else if (strcmp(Family,"HCMtimeconstant")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___HCM4___AC20", (int) SectorList);
	else if (strcmp(Family,"HCMramprate")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___HCM4___AC30", (int) SectorList);
	else if (strcmp(Family,"HCMtrim")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___HCM4T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"VCM")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___VCM1___%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCMready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM1___BM01", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM1___BM02", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM1___BC16", (int) SectorList);
	else if (strcmp(Family,"VCMreset")==0 && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM1_R_BC17", (int) SectorList);
	else if (strcmp(Family,"VCMdac")==0 && DevList==1   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___VCM1___AC10", (int) SectorList);
	else if (strcmp(Family,"VCMtimeconstant")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___VCM1___AC20", (int) SectorList);
	else if (strcmp(Family,"VCMramprate")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___VCM1___AC30", (int) SectorList);
	else if (strcmp(Family,"VCMtrim")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___VCM1T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"VCM")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___VCM2___%s01", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCMready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM2___BM04", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM2___BM05", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM2___BC18", (int) SectorList);
	else if (strcmp(Family,"VCMreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM2_R_BC19", (int) SectorList);
	else if (strcmp(Family,"VCMdac")==0 && DevList==2   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___VCM2___AC10", (int) SectorList);
	else if (strcmp(Family,"VCMtimeconstant")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___VCM2___AC20", (int) SectorList);
	else if (strcmp(Family,"VCMramprate")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___VCM2___AC30", (int) SectorList);
	else if (strcmp(Family,"VCMtrim")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___VCM2T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"VCM")==0 && DevList==3)
		mexErrMsgTxt("No VCSD1 corrector magnet.");

	else if (strcmp(Family,"VCM")==0 && DevList==4)
		sprintf(ChanName, "SR%02dC___VCSF1__%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCMready")==0 && DevList==4 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCSF1__BM01", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==4    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCSF1__BM02", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==4    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCSF1__BC16", (int) SectorList);
	else if (strcmp(Family,"VCMreset")==0 && DevList==4 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCSF1R_BC17", (int) SectorList);

	else if (strcmp(Family,"VCM")==0 && DevList==5)
		sprintf(ChanName, "SR%02dC___VCSF2__%s01", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCMready")==0 && DevList==5 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCSF2__BM04", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==5    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCSF2__BM05", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==5    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCSF2__BC18", (int) SectorList);
	else if (strcmp(Family,"VCMreset")==0 && DevList==5 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCSF2R_BC19", (int) SectorList);

	else if (strcmp(Family,"VCM")==0 && DevList==6)
		mexErrMsgTxt("No VCSD2 corrector magnet.");

	else if (strcmp(Family,"VCM")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___VCM3___%s02", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCMready")==0 && DevList==7 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM3___BM07", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==7    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM3___BM08", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==7    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM3___BC20", (int) SectorList);
	else if (strcmp(Family,"VCMreset")==0 && DevList==7 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM3_R_BC21", (int) SectorList);
	else if (strcmp(Family,"VCMdac")==0 && DevList==7   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___VCM3___AC10", (int) SectorList);
	else if (strcmp(Family,"VCMtimeconstant")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___VCM3___AC20", (int) SectorList);
	else if (strcmp(Family,"VCMramprate")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___VCM3___AC30", (int) SectorList);
	else if (strcmp(Family,"VCMtrim")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___VCM3T__%s10", (int) SectorList, ChanTypeStr);

	else if (strcmp(Family,"VCM")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___VCM4___%s03", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCMready")==0 && DevList==8 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM4___BM10", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==8    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___VCM4___BM11", (int) SectorList);
	else if (strcmp(Family,"VCMon")==0 && DevList==8    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM4___BC22", (int) SectorList);
	else if (strcmp(Family,"VCMreset")==0 && DevList==8 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___VCM4_R_BC23", (int) SectorList);
	else if (strcmp(Family,"VCMdac")==0 && DevList==8   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___VCM4___AC10", (int) SectorList);
	else if (strcmp(Family,"VCMtimeconstant")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___VCM4___AC20", (int) SectorList);
	else if (strcmp(Family,"VCMramprate")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___VCM4___AC30", (int) SectorList);
	else if (strcmp(Family,"VCMtrim")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___VCM4T__%s10", (int) SectorList, ChanTypeStr);

	/* Insertion device FF channels (note: no ChanTypeFlag because it is summed to the main SP, this is not a great way to do it) */
	else if (strcmp(Family,"HCMFF")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___HCM1FF_AC00", (int) SectorList);
	else if (strcmp(Family,"HCMFF")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___HCM2FF_AC01", (int) SectorList);
	else if (strcmp(Family,"HCMFF")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___HCM3FF_AC02", (int) SectorList);
	else if (strcmp(Family,"HCMFF")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___HCM4FF_AC03", (int) SectorList);

	else if (strcmp(Family,"VCMFF")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___VCM1FF_AC00", (int) SectorList);
	else if (strcmp(Family,"VCMFF")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___VCM2FF_AC01", (int) SectorList);
	else if (strcmp(Family,"VCMFF")==0 && DevList==7)
		sprintf(ChanName, "SR%02dC___VCM3FF_AC02", (int) SectorList);
	else if (strcmp(Family,"VCMFF")==0 && DevList==8)
		sprintf(ChanName, "SR%02dC___VCM4FF_AC03", (int) SectorList);

	else if (strcmp(Family,"QF")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___QF1____%s02", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QFready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QF1____BM07", (int) SectorList);
	else if (strcmp(Family,"QFon")==0 && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QF1____BM08", (int) SectorList);
	else if (strcmp(Family,"QFon")==0 && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QF1____BC20", (int) SectorList);
	else if (strcmp(Family,"QFreset")==0 && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QF1__R_BC21", (int) SectorList);
	else if (strcmp(Family,"QFdac")==0 && DevList==1   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___QF1____AC10", (int) SectorList);
	else if (strcmp(Family,"QFtimeconstant")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___QF1____AC20", (int) SectorList);
	else if (strcmp(Family,"QFramprate")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___QF1____AC30", (int) SectorList);

	else if (strcmp(Family,"QF")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___QF2____%s03", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QFready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QF2____BM10", (int) SectorList);
	else if (strcmp(Family,"QFon")==0 && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QF2____BM11", (int) SectorList);
	else if (strcmp(Family,"QFon")==0 && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QF2____BC22", (int) SectorList);
	else if (strcmp(Family,"QFreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QF2__R_BC23", (int) SectorList);
	else if (strcmp(Family,"QFdac")==0 && DevList==2   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___QF2____AC10", (int) SectorList);
	else if (strcmp(Family,"QFtimeconstant")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___QF2____AC20", (int) SectorList);
	else if (strcmp(Family,"QFramprate")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___QF2____AC30", (int) SectorList);

	else if (strcmp(Family,"QD")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___QD1____%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QDready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QD1____BM01", (int) SectorList);
	else if (strcmp(Family,"QDon")==0 && DevList==1    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QD1____BM02", (int) SectorList);
	else if (strcmp(Family,"QDon")==0 && DevList==1    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QD1____BC16", (int) SectorList);
	else if (strcmp(Family,"QDreset")==0 && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QD1__R_BC17", (int) SectorList);
	else if (strcmp(Family,"QDdac")==0 && DevList==1   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___QD1____AC10", (int) SectorList);
	else if (strcmp(Family,"QDtimeconstant")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___QD1____AC20", (int) SectorList);
	else if (strcmp(Family,"QDramprate")==0 && DevList==1)
		sprintf(ChanName, "SR%02dC___QD1____AC30", (int) SectorList);

	else if (strcmp(Family,"QD")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___QD2____%s01", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QDready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QD2____BM04", (int) SectorList);
	else if (strcmp(Family,"QDon")==0 && DevList==2    && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___QD2____BM05", (int) SectorList);
	else if (strcmp(Family,"QDon")==0 && DevList==2    && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QD2____BC18", (int) SectorList);
	else if (strcmp(Family,"QDreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___QD2__R_BC19", (int) SectorList);
	else if (strcmp(Family,"QDdac")==0 && DevList==2   && (ChanTypeFlag==1))
		sprintf(ChanName, "SR%02dC___QD2____AC10", (int) SectorList);
	else if (strcmp(Family,"QDtimeconstant")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___QD2____AC20", (int) SectorList);
	else if (strcmp(Family,"QDramprate")==0 && DevList==2)
		sprintf(ChanName, "SR%02dC___QD2____AC30", (int) SectorList);

	else if (strcmp(Family,"QDA")==0 && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1___%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QDAready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1___BM10", (int) SectorList);
	else if (strcmp(Family,"QDAon")==0    && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1___BM09", (int) SectorList);
	else if (strcmp(Family,"QDAon")==0    && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1___BC15", (int) SectorList);
	else if (strcmp(Family,"QDAreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1R__BC14", (int) SectorList);
	else if (strcmp(Family,"QDAtimeconstant")==0 && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1___AC02", (int) SectorList);
	else if (strcmp(Family,"QDAramprate")==0 && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA1___AC03", (int) SectorList);

	else if (strcmp(Family,"QDA")==0 && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2___%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QDAready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2___BM07", (int) SectorList);
	else if (strcmp(Family,"QDAon")==0    && (ChanTypeFlag==0 || ChanTypeFlag==2) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2___BM06", (int) SectorList);
	else if (strcmp(Family,"QDAon")==0    && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2___BC13", (int) SectorList);
	else if (strcmp(Family,"QDAreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2R__BC12", (int) SectorList);
	else if (strcmp(Family,"QDAtimeconstant")==0 && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2___AC02", (int) SectorList);
	else if (strcmp(Family,"QDAramprate")==0 && DevList==2 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QDA2___AC03", (int) SectorList);

	else if (strcmp(Family,"QDA")==0 && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
		mexErrMsgTxt("No QDA magnet in that sector.");

	else if (strcmp(Family,"SQSF")==0 && DevList==1 && ChanTypeFlag==0)
		sprintf(ChanName, "SR%02dC___SQSF1__AM00", (int) SectorList);
	else if (strcmp(Family,"SQSF")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF1__AC00", (int) SectorList);
	else if (strcmp(Family,"SQSFready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___SQSF1__BM19", (int) SectorList);
	else if (strcmp(Family,"SQSFon")==0    && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___SQSF1__BM18", (int) SectorList);
	else if (strcmp(Family,"SQSFon")==0    && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___SQSF1__BC23", (int) SectorList);
	else if (strcmp(Family,"SQSFdac")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF1__AC10", (int) SectorList);
	else if (strcmp(Family,"SQSFtimeconstant")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF1__AC20", (int) SectorList);
	else if (strcmp(Family,"SQSFramprate")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF1__AC30", (int) SectorList);

	else if (strcmp(Family,"SQSF")==0 && DevList==2 && ChanTypeFlag==0)
		sprintf(ChanName, "SR%02dC___SQSF2__AM01", (int) SectorList);
	else if (strcmp(Family,"SQSF")==0 && DevList==2 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF2__AC00", (int) SectorList);
	else if (strcmp(Family,"SQSFready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___SQSF2__BM08", (int) SectorList);
	else if (strcmp(Family,"SQSFon")==0    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___SQSF2__BM09", (int) SectorList);
	else if (strcmp(Family,"SQSFon")==0    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___SQSF2__BC21", (int) SectorList);
	else if (strcmp(Family,"SQSFdac")==0 && DevList==2 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF2__AC10", (int) SectorList);
	else if (strcmp(Family,"SQSFtimeconstant")==0 && DevList==2 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF2__AC20", (int) SectorList);
	else if (strcmp(Family,"SQSFramprate")==0 && DevList==2 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSF2__AC30", (int) SectorList);

	else if (strcmp(Family,"SQSD")==0 && DevList==1 && ChanTypeFlag==0)
		sprintf(ChanName, "SR%02dC___SQSD1__AM00", (int) SectorList);
	else if (strcmp(Family,"SQSD")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSD1__AC00", (int) SectorList);
	else if (strcmp(Family,"SQSDready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___SQSD1__BM17", (int) SectorList);
	else if (strcmp(Family,"SQSDon")==0    && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2))
		sprintf(ChanName, "SR%02dC___SQSD1__BM16", (int) SectorList);
	else if (strcmp(Family,"SQSDon")==0    && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3))
		sprintf(ChanName, "SR%02dC___SQSD1__BC22", (int) SectorList);
	else if (strcmp(Family,"SQSDdac")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSD1__AC10", (int) SectorList);
	else if (strcmp(Family,"SQSDtimeconstant")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSD1__AC20", (int) SectorList);
	else if (strcmp(Family,"SQSDramprate")==0 && DevList==1 && ChanTypeFlag==1)
		sprintf(ChanName, "SR%02dC___SQSD1__AC30", (int) SectorList);

/* SQSD2 for all sectors except SR01C */
	else if (strcmp(Family,"SQSD")==0 && DevList==2 && ChanTypeFlag==0 && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__AM01", (int) SectorList);
	else if (strcmp(Family,"SQSD")==0 && DevList==2 && ChanTypeFlag==1 && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__AC00", (int) SectorList);
	else if (strcmp(Family,"SQSDready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__BM10", (int) SectorList);
	else if (strcmp(Family,"SQSDon")==0    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__BM11", (int) SectorList);
	else if (strcmp(Family,"SQSDon")==0    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__BC20", (int) SectorList);
	else if (strcmp(Family,"SQSDdac")==0 && DevList==2 && ChanTypeFlag==1 && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__AC10", (int) SectorList);
	else if (strcmp(Family,"SQSDtimeconstant")==0 && DevList==2 && ChanTypeFlag==1 && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__AC20", (int) SectorList);
	else if (strcmp(Family,"SQSDramprate")==0 && DevList==2 && ChanTypeFlag==1 && SectorList!=1)
		sprintf(ChanName, "SR%02dC___SQSD2__AC30", (int) SectorList);

/* ganged SR01C SQSD2 */
	else if (strcmp(Family,"SQSD")==0 && DevList==2  && SectorList==1)
		sprintf(ChanName, "SR%02dC___SQSD2__%s02", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"SQSDready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SQSD2__BM07", (int) SectorList);
	else if (strcmp(Family,"SQSDon")==0    && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SQSD2__BM08", (int) SectorList);
	else if (strcmp(Family,"SQSDon")==0    && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SQSD2__BC20", (int) SectorList);
	else if (strcmp(Family,"SQSDreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SQSD2R_BC21", (int) SectorList);

	else if (strcmp(Family,"SF")==0 && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==1)
		sprintf(ChanName, "SR01C___SF_____%s00", ChanTypeStr);
	else if (strcmp(Family,"SFready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF_____BM17", (int) SectorList);
	else if (strcmp(Family,"SFon")==0    && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF_____BM18", (int) SectorList);
	else if (strcmp(Family,"SFon")==0    && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF_____BC22", (int) SectorList);
	else if (strcmp(Family,"SFdac")==0 && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF_____AC10", (int) SectorList);
	else if (strcmp(Family,"SFtimeconstant")==0 && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF_____AC20", (int) SectorList);
	else if (strcmp(Family,"SFramprate")==0 && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF_____AC30", (int) SectorList);
	else if (strcmp(Family,"SFreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SF___R_BC23", (int) SectorList);

	else if (strcmp(Family,"SD")==0 && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==1)
		sprintf(ChanName, "SR01C___SD_____%s00", ChanTypeStr);
	else if (strcmp(Family,"SDready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD_____BM17", (int) SectorList);
	else if (strcmp(Family,"SDon")==0    && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD_____BM18", (int) SectorList);
	else if (strcmp(Family,"SDon")==0    && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD_____BC22", (int) SectorList);
	else if (strcmp(Family,"SDdac")==0 && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD_____AC10", (int) SectorList);
	else if (strcmp(Family,"SDtimeconstant")==0 && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD_____AC20", (int) SectorList);
	else if (strcmp(Family,"SDramprate")==0 && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD_____AC30", (int) SectorList);
	else if (strcmp(Family,"SDreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___SD___R_BC23", (int) SectorList);

	else if (strcmp(Family,"QFA")==0 && ChanTypeFlag==0 && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QFA")==0 && ChanTypeFlag==1 && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"QFAtimeconstant")==0 && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____AC02", (int) SectorList);
	else if (strcmp(Family,"QFAramprate")==0 && (SectorList==1 || SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____AC03", (int) SectorList);
	else if (strcmp(Family,"QFAready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____BM18", (int) SectorList);
	else if (strcmp(Family,"QFAon")==0    && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____BM17", (int) SectorList);
	else if (strcmp(Family,"QFAon")==0    && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA____BC07", (int) SectorList);
	else if (strcmp(Family,"QFAreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___QFA_R__BC06", (int) SectorList);

	else if (strcmp(Family,"QFAready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___QFA____BM02", (int) SectorList);
	else if (strcmp(Family,"QFAon")==0    && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR%02dC___QFA____BM04", (int) SectorList);
	else if (strcmp(Family,"QFAon")==0    && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___QFA____BC22", (int) SectorList);
	else if (strcmp(Family,"QFAreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR%02dC___QFA__R_BC23", (int) SectorList);

	else if (strcmp(Family,"QFA")==0 && (SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
		mexErrMsgTxt("No QFA magnet in that sector.");

	else if (strcmp(Family,"BEND")==0 && ChanTypeFlag==0 && SectorList==1)
		sprintf(ChanName, "SR01C___B______%s00", ChanTypeStr);
	else if (strcmp(Family,"BEND")==0 && ChanTypeFlag==1 && SectorList==1)
		sprintf(ChanName, "SR01C___B______%s00", ChanTypeStr);
	else if (strcmp(Family,"BENDtimeconstant")==0 && SectorList==1)
		sprintf(ChanName, "SR01C___B______AC02");
	else if (strcmp(Family,"BENDramprate")==0 && SectorList==1)
		sprintf(ChanName, "SR01C___B______AC03");
	else if (strcmp(Family,"BENDready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR01C___B______BM18");
	else if (strcmp(Family,"BENDon")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==1)
		sprintf(ChanName, "SR01C___B______BM19");
	else if (strcmp(Family,"BENDon")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR01C___B______BC23");
	else if (strcmp(Family,"BENDreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==1)
		sprintf(ChanName, "SR01C___B____R_BC22");

	else if (strcmp(Family,"BSC")==0 && ChanTypeFlag==0 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"BSC")==0 && ChanTypeFlag==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"BSCramprate")==0 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__AC01", (int) SectorList);
	else if (strcmp(Family,"BSCdac")==0 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__AM01", (int) SectorList);
	else if (strcmp(Family,"BSClimit")==0 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__AC02", (int) SectorList);
	else if (strcmp(Family,"BSCready")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__BM14", (int) SectorList);
	else if (strcmp(Family,"BSCon")==0 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__BM15", (int) SectorList);
	else if (strcmp(Family,"BSCon")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_P__BC00", (int) SectorList);
	else if (strcmp(Family,"BSCreset")==0 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSC_PR_BC01", (int) SectorList);

	else if (strcmp(Family,"BSC")==0 && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
		mexErrMsgTxt("No BSC magnet in that sector.");

/* BSC Hall Probes */
	else if (strcmp(Family,"BSChall")==0 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___BSCHALLAM00", (int) SectorList);

/* BSC Vertical Trim Correctors */
	else if (strcmp(Family,"VCBSC")==0 && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1_%s00", (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"VCBSCready")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1_BM10", (int) SectorList);
	else if (strcmp(Family,"VCBSCon")==0 && DevList==1 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1_BM09", (int) SectorList);
	else if (strcmp(Family,"VCBSCon")==0 && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1_BC15", (int) SectorList);
	else if (strcmp(Family,"VCBSCreset")==0 && DevList==1 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1RBC14", (int) SectorList);
	else if (strcmp(Family,"VCBSCtimeconstant")==0 && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1_AC02", (int) SectorList);
	else if (strcmp(Family,"VCBSCramprate")==0 && DevList==1 && (SectorList==4 || SectorList==8 || SectorList==12))
		sprintf(ChanName, "SR%02dC___VCBSC1_AC03", (int) SectorList);

	else if (strcmp(Family,"VCBSC")==0 && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==9 || SectorList==10 || SectorList==11))
		mexErrMsgTxt("No VCBSC magnet in that sector.");


	else if (strcmp(Family,"HCMCHICANE")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==4)
		sprintf(ChanName, "SR%02dU___HCM%1d___%s01", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"HCMCHICANE")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==1) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___%s00", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"HCMCHICANEready")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
		sprintf(ChanName, "SR%02dU___HCM%1d___BM04", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___BM19", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEon")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
		sprintf(ChanName, "SR%02dU___HCM%1d___BM05", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEon")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___BM18", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEon")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==4)
		sprintf(ChanName, "SR%02dU___HCM%1d___BC18", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEon")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___BC23", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEdac")==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___AC10", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEtimeconstant")==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___AC20", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEramprate")==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d___AC30", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"HCMCHICANEreset")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d_R_BC19", (int) SectorList, (int) DevList);
	/* No reset channels for chicane magnets */
	/*else if (strcmp(Family,"HCMCHICANEreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM%1d_R_BC23", (int) SectorList, (int) DevList); */

	else if (strcmp(Family,"HCMCHICANEM")==0 && DevList==1 && ChanTypeFlag==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM2M1_AC00.EPOS", (int) SectorList);
	else if (strcmp(Family,"HCMCHICANEM")==0 && DevList==2 && ChanTypeFlag==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM2M2_AC01.EPOS", (int) SectorList);
	else if (strcmp(Family,"HCMCHICANEM")==0 && DevList==3 && ChanTypeFlag==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM2M3_AC02.EPOS", (int) SectorList);
	else if (strcmp(Family,"HCMCHICANEM")==0 && DevList==1 && ChanTypeFlag==1 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM2M1_AC00", (int) SectorList);
	else if (strcmp(Family,"HCMCHICANEM")==0 && DevList==2 && ChanTypeFlag==1 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM2M2_AC01", (int) SectorList);
	else if (strcmp(Family,"HCMCHICANEM")==0 && DevList==3 && ChanTypeFlag==1 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___HCM2M3_AC02", (int) SectorList);

 	else if (strncmp(Family,"HCMCHICANE",10)==0 && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
		mexErrMsgTxt("No CHICANE magnets in that sector.");

	else if (strcmp(Family,"VCMCHICANE")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==1) && SectorList==4)
		sprintf(ChanName, "SR%02dU___VCM%1d___%s00", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"VCMCHICANE")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==1) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___%s01", (int) SectorList, (int) DevList, ChanTypeStr);
	else if (strcmp(Family,"VCMCHICANEready")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
		sprintf(ChanName, "SR%02dU___VCM%1d___BM01", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEready")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___BM17", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEon")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==0 || ChanTypeFlag==2) && SectorList==4)
		sprintf(ChanName, "SR%02dU___VCM%1d___BM02", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEon")==0 && DevList==2 && (ChanTypeFlag==0 || ChanTypeFlag==2) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___BM16", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEon")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==4)
		sprintf(ChanName, "SR%02dU___VCM%1d___BC16", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEon")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___BC22", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEdac")==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___AC10", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEtimeconstant")==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___AC20", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEramprate")==0 && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d___AC30", (int) SectorList, (int) DevList);
	else if (strcmp(Family,"VCMCHICANEreset")==0 && (DevList==1 || DevList==3) && (ChanTypeFlag==1 || ChanTypeFlag==3) && SectorList==4)
		sprintf(ChanName, "SR%02dU___VCM%1d_R_BC17", (int) SectorList, (int) DevList);
	/*else if (strcmp(Family,"VCMCHICANEreset")==0 && DevList==2 && (ChanTypeFlag==1 || ChanTypeFlag==3) && (SectorList==4 || SectorList==11))
		sprintf(ChanName, "SR%02dU___VCM%1d_R_BC21", (int) SectorList, (int) DevList); */

 	else if (strncmp(Family,"VCMCHICANE",10)==0 && (SectorList==1 || SectorList==2 || SectorList==3 || SectorList==5 || SectorList==6 || SectorList==7 || SectorList==8 || SectorList==9 || SectorList==10 || SectorList==12))
		mexErrMsgTxt("No CHICANE magnets in that sector.");

	else if (strcmp(Family,"IDpos")==0)
		if (SectorList==5)
			sprintf(ChanName, "SR%02dW___GDS1PS_%s00",   (int) SectorList, ChanTypeStr);
		else
			sprintf(ChanName, "SR%02dU___GDS1PS_%s00",   (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"IDvel")==0)
		if (SectorList==5)
			sprintf(ChanName, "SR%02dW___GDS1V__%s01",   (int) SectorList, ChanTypeStr);
		else
			sprintf(ChanName, "SR%02dU___GDS1V__%s01",   (int) SectorList, ChanTypeStr);
	else if (strcmp(Family,"IDrunflag")==0)
		if (SectorList==5)
			sprintf(ChanName, "SR%02dW___GDS1E__%s02",   (int) SectorList, ChanTypeStr);
		else
			sprintf(ChanName, "SR%02dU___GDS1E__%s02",   (int) SectorList, ChanTypeStr);

	else {
		strcpy(ChanName, Family);
		ErrorFlag = -1;
	}


	/* Check for missing magnets */
	if ((strcmp(Family,"HCM")==0 || strcmp(Family,"VCM")==0) && SectorList==1 && DevList==1)
		mexErrMsgTxt("HCM1 & VCM1 are missing from sector 1.");
	else if ((strcmp(Family,"HCM")==0 || strcmp(Family,"VCM")==0) && SectorList==12 && DevList==8)
		mexErrMsgTxt("HCM4 & VCM4 are missing from sector 12.");
	else
		;


/*	printf("Channel Name: %s\n", ChanName); */
	return (int) ErrorFlag;
}




/*  GetChannels - gets data by family name or channel name  */
/*  ChanTypeFlag = 0  ->  Analog Monitor (AM)               */
/*               = 1  ->  Analog Control (AC)               */
/*               = 2  ->  Boolean monitor (BM)              */
/*               = 3  ->  Boolean Control (BC)              */
/*                                                          */
/*  Note: all SCA errors cause mexErrMsgTxt                 */
/*                                                          */
int GetChannels(char *Family, double *SectorList, double *DevList, double *AM, int NumberOfDevices, int NumberOfAverages, int ChanTypeFlag)
{
	char ChannelName[50];
	int  i, Device, AverageLoop, ErrorFlag=0, Status, NumberOfErrors, SleepTimeInt;
	double max_wait=5.0, Time0, SleepTime;


	set_min_time_between_do_gets(0.0);


	/* Initialize output array */
	for (Device=0; Device<NumberOfDevices; Device++)
		AM[Device] = (double) 0.0;


	/* Build channel list */
	for (Device=0; Device<NumberOfDevices; Device++) {
		GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeFlag);
		Status = que_get(ChannelName, SCA_DOUBLE, 1, &DataArray1[Device], &StatusArray1[Device]);
		if (sca_error(Status)) {
			print_sca_status(Status);
			ErrorFlag = -1;
			mexErrMsgTxt("    QUE_GET error in GetChannels (alsfunc.c).\n");
		}
	}


	/* Get data */
	for (AverageLoop=1; AverageLoop<=NumberOfAverages; AverageLoop++) {
		Time0 = GetTime();
		NumberOfErrors = do_get(max_wait);
		if (NumberOfErrors > 0) {
			printf(" NumberOfErrors=%d\n", NumberOfErrors);
			for (Device=0; Device<NumberOfDevices; Device++) {
				if (sca_error(StatusArray1[Device])) {
					GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeFlag);
					printf(" Channel Name: %s, status=%x\n", ChannelName, StatusArray1[Device]);
					print_sca_status(StatusArray1[Device]);
					ErrorFlag = -1;
				}
			}
			if (ErrorFlag)
				mexErrMsgTxt("    DO_GET error in GetChannels (alsfunc.c).\n");

		} else {
			for (Device=0; Device<NumberOfDevices; Device++)
				AM[Device] = AM[Device] + DataArray1[Device]/(double) NumberOfAverages;

			/* Approximately a 10 Hz data rate */
			if (AverageLoop < NumberOfAverages) {
				SleepTime = .1 - (GetTime()-Time0) - .002;
				if (SleepTime > 0) {
					SleepTimeInt = (int)  (1000 * SleepTime);
					/* printf(" SleepTime = %f %d\n", SleepTime, SleepTimeInt); */
					sca_sleep(SleepTimeInt, 100000);
				}
			}
		}
	}

	return ErrorFlag;
}



/*  SetChannels - gets data by family name or channel name  */
/*  WaitOnSPFlag = 0  ->  return immediately                */
/*               = 1  ->  wait until SP=AM + BPM delay      */
/*               else ->  wait until SP=AM                  */
/*               (only for magnet families)                 */
/*  ErrorFlag = 0  ->  No errors                            */
/*             -2  ->  SP-AM out of tolerance (printed)     */
/*             all other errors cause a mexErrMsgTxt        */
/*                                                          */
int SetChannels(char *Family, double *SectorList, double *DevList, double *NewSP, int NumberOfDevices, int ChanTypeSetPoint, int WaitOnSPFlag)
{
	char ChannelName[50], Family2[50], ChannelName2[50], Family3[50];
	int  Device, ErrorFlag=0, Status, ChanTypeMonitor, NumberOfErrors, TryAgain, SleepTimeInt;
	double ChangeAmps, MaxChangeAmps=0, ExtraDelay, ExtraDelayPerAmp, tol, Time0, Tmax, max_wait=5.0;
	double RampRate, RampRateTmp, TimeConstant, TimeConstantTmp;


	set_min_time_between_do_gets(0.0);
	set_min_time_between_do_puts(0.0);


	/*  ChanTypeFlag = 0  ->  Analog Monitor (AM)   */
	/*               = 1  ->  Analog Control (AC)   */
	/*               = 2  ->  Boolean monitor (BM)  */
	/*               = 3  ->  Boolean Control (BC)  */
	if (ChanTypeSetPoint == 1)
		ChanTypeMonitor = 0;
	else if (ChanTypeSetPoint == 3)
		ChanTypeMonitor = 2;
	else
		ChanTypeMonitor = 0;


 	if (WaitOnSPFlag) {
		/* SP-AM tolerance, present ramp rate, and time constant                                 */
		/* Note:  only wait on a SP-AM comparison for magnets or devices with known AM/SP pairs  */
		/*        (the channel names must compliment the getam/getsp naming convention)          */
		if (strcmp(Family,"HCM")==0) {
			sprintf(Family2, "HCMtrim");
			RampRate = 1000.0;
			TimeConstant = 0.0;
			tol = .1;
			for (Device=0; Device<NumberOfDevices; Device++) {
				if (DevList[Device] == 1 || DevList[Device] == 2 || DevList[Device] == 7 || DevList[Device] == 8) {

					GetChannels("HCMramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);   /* was 0.5 amps/sec */
					if (RampRateTmp < RampRate)
						RampRate = RampRateTmp;

					if (RampRate < .01)
						RampRate = .01;
					/* printf(" Ramprate=%f\n", RampRate); */

					GetChannels("HCMtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
					if (TimeConstantTmp > TimeConstant)
						TimeConstant = TimeConstantTmp;

				} else {
					if (RampRate > .5)
						RampRate = .5;
				}
			}
		} else if (strcmp(Family,"HCMtrim")==0) {
			RampRate = 1000.0;
			TimeConstant = 0.0;
			tol = 0.1;
		} else if (strcmp(Family,"VCM")==0) {
			sprintf(Family2, "VCMtrim");
			RampRate = 1000.0;
			TimeConstant = 0.0;
			tol = .3;
			for (Device=0; Device<NumberOfDevices; Device++) {
				if (DevList[Device] == 1 || DevList[Device] == 2 || DevList[Device] == 7 || DevList[Device] == 8) {

					GetChannels("VCMramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);   /* was 0.57 amps/sec */
					if (RampRateTmp < RampRate)
						RampRate = RampRateTmp;

					if (RampRate < .01)
						RampRate = .01;
					/* printf(" Ramprate=%f\n", RampRate); */

					GetChannels("VCMtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
					if (TimeConstantTmp > TimeConstant)
						TimeConstant = TimeConstantTmp;
				} else {
					if (RampRate > .57)
						RampRate = .57;
				}
			}
		} else if (strcmp(Family,"VCMtrim")==0) {
			RampRate = 1000.0;
			TimeConstant = 0.0;
			tol = 0.3;
		} else if (strcmp(Family,"VCBSC")==0) {
				tol = .075;

				RampRate = 1000.0;
				for (Device=0; Device<NumberOfDevices; Device++) {
					GetChannels("VCBSCramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);   /* was 0.57 amps/sec */
					if (RampRateTmp < RampRate)
						RampRate = RampRateTmp;
				}
				if (RampRate < .01)
					RampRate = .01;
				/* printf(" Ramprate=%f\n", RampRate); */

				TimeConstant = 0.0;
				for (Device=0; Device<NumberOfDevices; Device++) {
					GetChannels("VCBSCtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
					if (TimeConstantTmp > TimeConstant)
						TimeConstant = TimeConstantTmp;
				}
		} else if (strcmp(Family,"HCMCHICANE")==0) {
			tol = .1;
			RampRate = 2;
			TimeConstant = 0;
		} else if (strcmp(Family,"HCMCHICANEM")==0) {
			tol = .1;
			RampRate = 2;
			TimeConstant = 0;
		} else if (strcmp(Family,"VCMCHICANE")==0) {
			tol = .1;
			RampRate = 2;
			TimeConstant = 0;
		} else if (strcmp(Family,"QF")==0) {
			tol = .25;

			/*RampRate = 1.1; should this still be 1.1?, or higher than 5.4?*/
			RampRate = 5.4;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QFramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);
				if (RampRateTmp < RampRate)
					RampRate = RampRateTmp;
			}
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate=%f\n", RampRate); */

			TimeConstant = 0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QDtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
				if (TimeConstantTmp > TimeConstant)
					TimeConstant = TimeConstantTmp;
			}
		} else if (strcmp(Family,"QD")==0) {
			tol = .25;

			/*RampRate = 1.1; should this still be 1.1?, or higher than 5.4?*/
			RampRate = 5.4;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QDramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);
				if (RampRateTmp < RampRate)
					RampRate = RampRateTmp;
			}
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate=%f\n", RampRate); */

			TimeConstant = 0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QDtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
				if (TimeConstantTmp > TimeConstant)
					TimeConstant = TimeConstantTmp;
			}
		} else if (strcmp(Family,"SQSF")==0) {
			tol = .25;
			RampRate = .6;
			TimeConstant = 0;
		} else if (strcmp(Family,"SQSD")==0) {
			tol = .25;
			RampRate = .6;
			TimeConstant = 0;
		} else if (strcmp(Family,"SF")==0) {
			tol = .25;
			RampRate = 3.6;
			TimeConstant = 0;
		} else if (strcmp(Family,"SD")==0) {
			tol = .25;
			RampRate = 3.6;
			TimeConstant = 0;
		} else if (strcmp(Family,"QFA")==0) {
			tol = 1.0;

			RampRate = 1000.0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QFAramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);   /* was 6 amps/sec */
				if (RampRateTmp < RampRate)
					RampRate = RampRateTmp;
			}
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate=%f\n", RampRate); */

			TimeConstant = 0.0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QFAtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
				if (TimeConstantTmp > TimeConstant)
					TimeConstant = TimeConstantTmp;
			}
		} else if (strcmp(Family,"QDA")==0) {
			tol = 0.25;

			RampRate = 1000.0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QDAramprate", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);
				if (RampRateTmp < RampRate)
					RampRate = RampRateTmp;
			}
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate=%f\n", RampRate); */

			TimeConstant = 0.0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("QDAtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
				if (TimeConstantTmp > TimeConstant)
					TimeConstant = TimeConstantTmp;
			}
		} else if (strcmp(Family,"BEND")==0) {
			tol = 1.5;

			GetChannels("BENDramprate", SectorList, DevList, &RampRate, 1, 1, 1);   /* was 10.5 amps/sec */
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate=%f\n", RampRate); */

			TimeConstant = 0.0;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("BENDtimeconstant", &SectorList[Device], &DevList[Device], &TimeConstantTmp, 1, 1, 1);
				if (TimeConstantTmp > TimeConstant)
					TimeConstant = TimeConstantTmp;
			}
		} else if (strcmp(Family,"BSC")==0) {
			tol = 0.25;

			GetChannels("BSCramprate", SectorList, DevList, &RampRate, 1, 1, 1);
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate=%f\n", RampRate); */

			TimeConstant = 0.0;
		} else if (strcmp(Family,"IDpos")==0) {
			tol = 0.030;
			RampRate = 10;
			for (Device=0; Device<NumberOfDevices; Device++) {
				GetChannels("IDvel", &SectorList[Device], &DevList[Device], &RampRateTmp, 1, 1, 1);   /* was .25 mm/sec */
				if (RampRateTmp < RampRate)
					RampRate = RampRateTmp;
			}
			if (RampRate < .01)
				RampRate = .01;
			/* printf(" Ramprate = %f mm \n", RampRate); */
			TimeConstant = 0;
		} else {
			WaitOnSPFlag = 0;
		}
	}


 	if (WaitOnSPFlag) {
		/* Build monitor channel list */
		for (Device=0; Device<NumberOfDevices; Device++) {
			if (strcmp(Family,"HCMtrim")==0) {
				sprintf(Family3,"HCM");
				GetName(ChannelName, Family3, SectorList[Device], DevList[Device], ChanTypeMonitor);
			}
			else if (strcmp(Family,"VCMtrim")==0) {
				sprintf(Family3,"VCM");
				GetName(ChannelName, Family3, SectorList[Device], DevList[Device], ChanTypeMonitor);
			} else {
				GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
			}
			Status = que_get(ChannelName, SCA_DOUBLE, 1, &DataArray1[Device], &StatusArray1[Device]);
			if (sca_error(Status)) {
				print_sca_status(Status);
				ErrorFlag = -1;
				mexErrMsgTxt("    QUE_GET error in SetChannels (gplink.c).\n");
			}
		}


		/* Get monitors */
		NumberOfErrors = do_get(max_wait);
		if (NumberOfErrors > 0) {
			printf(" NumberOfErrors=%d\n", NumberOfErrors);
			for (Device=0; Device<NumberOfDevices; Device++) {
				if (sca_error(StatusArray1[Device])) {
					GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
					printf(" Channel Name: %s, status=%x\n", ChannelName, StatusArray1[Device]);
					print_sca_status(StatusArray1[Device]);
					ErrorFlag = -1;
				}
			}
		}
		if (ErrorFlag)
			mexErrMsgTxt("    DO_GET error in SetChannels (gplink.c).\n");


		/* Find the largest change in set point */
		for (Device=0; Device<NumberOfDevices; Device++) {
			ChangeAmps = fabs(NewSP[Device] - DataArray1[Device]);
			if (ChangeAmps > MaxChangeAmps)
				MaxChangeAmps = ChangeAmps;
		}
	}


	/* Change setpoint */
	/* Build setpoint channel list */
	for (Device=0; Device<NumberOfDevices; Device++) {
		GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeSetPoint);
		Status = que_put(ChannelName, SCA_DOUBLE, 1, &NewSP[Device], &StatusArray2[Device]);
		if (sca_error(Status)) {
			print_sca_status(Status);
			ErrorFlag = -1;
			mexErrMsgTxt("    QUE_PUT error in SetChannels (gplink.c).\n");
		}
	}

	NumberOfErrors = do_put(-1.0);  /* Do puts without callbacks */
	if (NumberOfErrors > 0) {
		printf(" NumberOfErrors=%d\n", NumberOfErrors);
		for (Device=0; Device<NumberOfDevices; Device++) {
			if (sca_error(StatusArray2[Device])) {
				GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeSetPoint);
				printf(" Channel Name: %s, status=%x\n", ChannelName, StatusArray2[Device]);
				print_sca_status(StatusArray2[Device]);
				ErrorFlag = -1;
			}
		}
	}
	if (ErrorFlag)
		mexErrMsgTxt("    DO_PUT error in SetChannels (gplink.c).\n");


 	if (WaitOnSPFlag) {
		/* Timeout period for SP-AM comparision [seconds] */
		Tmax = 1.2*(MaxChangeAmps/RampRate)+10;

		/* Modify SP channel list to use trim AMs as corrector SP for corrector SP-AM comparison */
		/*                          and to use corrector AM as trim SP for trim SP-AM comparison */
		for (Device=0; Device<NumberOfDevices; Device++) {
			if (strcmp(Family,"HCM")==0 && (DevList[Device] == 1 || DevList[Device] == 2 || DevList[Device] == 7 || DevList[Device] == 8)) {
				GetName(ChannelName, Family2, SectorList[Device], DevList[Device], ChanTypeMonitor);
			} else if (strcmp(Family,"VCM")==0 && (DevList[Device] == 1 || DevList[Device] == 2 || DevList[Device] == 7 || DevList[Device] == 8)) {
				GetName(ChannelName, Family2, SectorList[Device], DevList[Device], ChanTypeMonitor);
			} else if (strcmp(Family,"HCMtrim")==0 || strcmp(Family,"VCMtrim")==0) {
				GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
			} else {
				GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeSetPoint);
			}
			Status = que_get(ChannelName, SCA_DOUBLE, 1, &NewSP[Device], &StatusArray2[Device]);
			if (sca_error(Status)) {
				print_sca_status(Status);
				ErrorFlag = -1;
				mexErrMsgTxt("    QUE_GET error in SetChannels (gplink.c).\n");
			}
		}

		/* Compare SP-AM */
		/* Build monitor channel list */
		for (Device=0; Device<NumberOfDevices; Device++) {
			if (strcmp(Family,"HCMtrim")==0) {
				sprintf(Family3,"HCM");
				GetName(ChannelName, Family3, SectorList[Device], DevList[Device], ChanTypeMonitor);
			}
			else if (strcmp(Family,"VCMtrim")==0) {
				sprintf(Family3,"VCM");
				GetName(ChannelName, Family3, SectorList[Device], DevList[Device], ChanTypeMonitor);
			}
          else {
				GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
			}
			Status = que_get(ChannelName, SCA_DOUBLE, 1, &DataArray1[Device], &StatusArray1[Device]);
			if (sca_error(Status)) {
				print_sca_status(Status);
				ErrorFlag = -1;
				mexErrMsgTxt("    QUE_GET error in SetChannels (gplink.c).\n");
			}
		}

		Time0 = GetTime();

		do {
			TryAgain = 0;

			/* Get current monitors */
			NumberOfErrors = do_get(max_wait);
			if (NumberOfErrors > 0) {
				printf(" NumberOfErrors=%d\n", NumberOfErrors);
				for (Device=0; Device<NumberOfDevices; Device++) {
					if (sca_error(StatusArray1[Device])) {
						GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
						printf(" Channel Name: %s, status=%x\n", ChannelName, StatusArray1[Device]);
						print_sca_status(StatusArray1[Device]);
						ErrorFlag = -1;
					}
				}
			}
			if (ErrorFlag)
				mexErrMsgTxt("    DO_GET error in SetChannels (gplink.c).\n");


			for (Device=0; Device<NumberOfDevices; Device++) {
				if ((fabs(NewSP[Device]-DataArray1[Device]) > 2*tol))
					TryAgain = 1;
			}

			if (TryAgain == 1)
				sca_sleep(150, 100000);

		} while ((TryAgain==1) && ((GetTime()-Time0)<Tmax));



 		/* Extra delay to account for transients */
		if (strcmp(Family,"HCM")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(100, 100000);
		} else if (strcmp(Family,"VCM")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(100, 100000);
		} else if (strcmp(Family,"HCMCHICANE")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(100, 100000);
		} else if (strcmp(Family,"VCMCHICANE")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(100, 100000);
		} else if (strcmp(Family,"HCMCHICANEM")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(100, 100000);
		} else if (strcmp(Family,"QF")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(250, 100000);
		} else if (strcmp(Family,"QD")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(250, 100000);
		} else if (strcmp(Family,"SQSF")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(250, 100000);
		} else if (strcmp(Family,"SQSD")==0){
			ExtraDelayPerAmp = .2;
			sca_sleep(250, 100000);
		} else if (strcmp(Family,"SF")==0){
			ExtraDelayPerAmp = .75;
			sca_sleep(250, 100000);
		} else if (strcmp(Family,"SD")==0){
			ExtraDelayPerAmp = .75;
			sca_sleep(250, 100000);
		} else if (strcmp(Family,"QFA")==0){
			ExtraDelayPerAmp = 1.0;
			sca_sleep(500, 100000);
		} else if (strcmp(Family,"QDA")==0){
			ExtraDelayPerAmp = 1.0;
			sca_sleep(500, 100000);
		} else if (strcmp(Family,"BEND")==0){
			ExtraDelayPerAmp = 1.0;
			sca_sleep(500, 100000);
		} else if (strcmp(Family,"BSC")==0){
			ExtraDelayPerAmp = 1.0;
			sca_sleep(500, 100000);
		} else if (strcmp(Family,"IDpos")==0){
			ExtraDelayPerAmp = 0.0;
			sca_sleep(1000, 100000);
		} else {
			ExtraDelayPerAmp = 0;
			sca_sleep(50, 100000);
		}

		if (ExtraDelayPerAmp*MaxChangeAmps<.25 && ExtraDelayPerAmp*MaxChangeAmps>=0.0) {
			SleepTimeInt = (int)  (1000 * ExtraDelayPerAmp * MaxChangeAmps);
			sca_sleep(SleepTimeInt, 100000);
		} else
			sca_sleep(250, 100000);

		/* Extra delay for tolerance */
		SleepTimeInt = (int)  (1000 * tol / RampRate );
		sca_sleep(SleepTimeInt, 100000);

		/* Extra delay for time constant */
		SleepTimeInt = (int)  (1000 * 2 * TimeConstant );
		sca_sleep(SleepTimeInt, 100000);

		/* BPM sample rate delay */
		if (WaitOnSPFlag == 1)
			sca_sleep(1100, 100000);


		/* Final check on SP-AM tolerance */

		/* Get current monitors */
		NumberOfErrors = do_get(max_wait);
		if (NumberOfErrors > 0) {
			printf(" NumberOfErrors=%d\n", NumberOfErrors);
			for (Device=0; Device<NumberOfDevices; Device++) {
				if (sca_error(StatusArray1[Device])) {
					GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
					printf(" Channel Name: %s, status=%x\n", ChannelName, StatusArray1[Device]);
					print_sca_status(StatusArray1[Device]);
					ErrorFlag = -1;
				}
			}
		}
		if (ErrorFlag)
			mexErrMsgTxt("    DO_GET error in SetChannels (gplink.c).\n");


		/* Check tolerances (Note: this is only a warning! */
		for (Device=0; Device<NumberOfDevices; Device++) {
			if ((fabs(NewSP[Device]-DataArray1[Device]) > tol)) {
				GetName(ChannelName, Family, SectorList[Device], DevList[Device], ChanTypeMonitor);
				printf(" SP-AM WARNING: Channel Name=%s, Setpoint=%g, Monitor=%g, SP-AM=%g, tol=%g\n", ChannelName, NewSP[Device], DataArray1[Device], NewSP[Device]-DataArray1[Device], tol);
				ErrorFlag = -2;
			}
		}

	}

	return ErrorFlag;
}


