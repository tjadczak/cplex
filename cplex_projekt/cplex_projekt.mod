/*********************************************
 * OPL 12.7.1.0 Model
 * Author: root
 * Creation Date: 20 gru 2019 at 08:17:46
 *********************************************/
/* INDEKSY I STALE */
 {string} Nodes = ...;
 
 tuple arc
 {
   string source;
   string destination;
 }   
 
 {arc} Arcs with source in Nodes, destination in Nodes = ...;

 int LinkCapacity[Arcs] = ...;
 
 tuple demand
 {
   string source;
   string destination;
 }   
 
{demand} Demands with source in Nodes, destination in Nodes = ...;

float Volume[Demands] = ...;

/* ZMIENNE */

dvar float+ x[Arcs][Demands];
dvar float+ u[Arcs][Demands];
dvar float+ alfa[Arcs];
dvar float+ alfaTotal;

/* FUNKCJA CELU */

minimize alfaTotal;

/* OGRANICZENIA */
subject to{
  forall(e in Arcs)
    minimalizacja_wektora_alf:
    {
    	alfaTotal >= alfa[e];
    }
  forall(e in Arcs){
    forall(k in Demands)
    x_u_mniejsze:
    {
    	x[e][k] <= 1;
    	u[e][k] <= 1;
    	u[e][k] - x[e][k] >= 0;
    }  
  }       
  forall(e in Arcs)
    ruch:
    {
    	alfaTotal >= alfa[e];
    	/* to do (12); ograniczenie zeby w ogole ruch poszedl; ktores z (3)(4) */
    }	
}
