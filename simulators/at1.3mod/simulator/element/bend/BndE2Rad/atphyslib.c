/*   File: atphyslib.c
     Common physics functions for Accelerator Toolbox
     A.Terebilo   10/28/04

	 functions edge_fringe2A and edge_fringe2B were added by Xiaobiao Huang, August 2009
*/
	
#include "mex.h"
#include <math.h>

void edge(double* r, double inv_rho, double edge_angle)
{	/* Edge focusing in dipoles with hard-edge field */
    double psi = inv_rho*tan(edge_angle);

    r[1]+=r[0]*psi;
	r[3]-=r[2]*psi;
}


void edge_fringe(double* r, double inv_rho, double edge_angle, double fint, double gap)
{   /* Edge focusing in dipoles with fringe field */
    double fx = inv_rho*tan(edge_angle);
    double psi_bar = edge_angle-inv_rho*gap*fint*(1+sin(edge_angle)*sin(edge_angle))/cos(edge_angle)/(1+r[4]);
    double fy = inv_rho*tan(psi_bar);
    r[1]+=r[0]*fx;
    r[3]-=r[2]*fy;    
}

void edge_fringe2A(double* r, double inv_rho, double edge_angle, double fint, double gap,double h1,double K1)
{   /* Entrance Fringe field transport map to second order in dipoles with fringe field */
    double fx = inv_rho*tan(edge_angle);
	double dpsi = inv_rho*gap*fint*(1+sin(edge_angle)*sin(edge_angle))/cos(edge_angle); /* /(1+r[4]); */
    double psi_bar = edge_angle-dpsi;
    double fy = inv_rho*tan(psi_bar);
    double h = inv_rho;
    double tpsi=tan(edge_angle), tpsib=tan(psi_bar);
    double spsi=1.0/cos(edge_angle), spsib=1.0/cos(psi_bar);
    double T111,T234,T414,   T212,T313,  T133,T423,T211,T233,T413;
	double T216, T436;

	double r0=r[0],r2=r[2],r1=r[1];
    T111 = -0.5*h*tpsi*tpsi; 
    /* T234=  -0.5*h*tpsi*tpsib;    */
	T234=  -0.5*h*tpsi*tpsi;    
	T414=T234;
    T212 = -T111; 
    T313 = -T234;
    T133 = 0.5*h*spsi*spsi;  T423=-T133;
    T211 = 0.5*h*h1*spsi*spsi*spsi + K1*tpsi;
    T233 = -0.5*h*h1*spsi*spsi*spsi -K1*tpsi+0.5*h*h*tpsi*(tpsib*tpsib+spsi*spsi);
    T413 = -0.5*h*h1*spsi*spsi*spsi -K1*tpsi;/*-0.5*h*h*tpsi*(spsi*spsi+tpsib*tpsib); */

	T216 = 0; /*  -0.5*h*tpsi; */
	T436 = 0; /*  0.5*h*(tpsi - dpsi*spsib*spsib); */

    r[0] += T111*r[0]*r[0]+T133*r[2]*r[2];
	r[1] += r0*fx + 2*T212*r0*r[1]+2*T234*r[2]*r[3]+T211*r0*r0+T233*r[2]*r[2] + 2*T216*r[0]*r[4];
    r[2] += 2*T313*r0*r[2];
    r[3] += -r2*fy + 2*T414*r0*r[3]+2*T413*r0*r2+2*T423*r1*r2  + 2*T436*r[2]*r[4];    
    
}

void edge_fringe2B(double* r, double inv_rho, double edge_angle, double fint, double gap,double h2,double K1)
{   /* Exit Fringe field transport map to second order in dipoles with fringe field */
    double fx = inv_rho*tan(edge_angle);
	double dpsi = inv_rho*gap*fint*(1+sin(edge_angle)*sin(edge_angle))/cos(edge_angle); /* /(1+r[4]);  */
    double psi_bar = edge_angle-dpsi;
    double fy = inv_rho*tan(psi_bar);
    double h = inv_rho;
    double tpsi=tan(edge_angle), tpsib=tan(psi_bar);
    double spsi=1.0/cos(edge_angle), spsib=1.0/cos(psi_bar);
    double T111,T234,T414,   T212,T313,  T133,T423,T211,T233,T413;
	double T216, T436;

	double r0=r[0],r2=r[2],r1=r[1];
    T111 = 0.5*h*tpsi*tpsi; 
    /* T234=  0.5*h*tpsi*tpsib;    */
	T234=  0.5*h*tpsi*tpsi;    
	T414=T234;
    T212 = -T111; 
    T313 = -T234;
    T133 = -0.5*h*spsi*spsi;  T423=-T133;
    T211 = 0.5*h*h2*spsi*spsi*spsi +K1*tpsi-0.5*h*h*tpsi*tpsi*tpsi;
    T233 = -0.5*h*h2*spsi*spsi*spsi -K1*tpsi-0.5*h*h*tpsi*tpsib*tpsib;
    T413 = -0.5*h*h2*spsi*spsi*spsi -K1*tpsi+0.5*h*h*tpsi*(spsi*spsi);

	T216 = 0; /*  -0.5*h*tpsi; */
	T436 = 0; /*  0.5*h*(tpsi - dpsi*spsib*spsib); */

    r[0] += T111*r[0]*r[0]+T133*r[2]*r[2];
    r[1] += r0*fx + 2*T212*r0*r[1]+2*T234*r[2]*r[3]+T211*r0*r0+T233*r[2]*r[2] + 2*T216*r[0]*r[4];;
    r[2] += 2*T313*r0*r[2];
    r[3] += -r2*fy + 2*T414*r0*r[3]+2*T413*r0*r2+2*T423*r1*r2 + 2*T436*r[2]*r[4];      
    
}
