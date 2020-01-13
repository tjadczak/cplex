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

 int Fi[Arcs] = ...;
 
 tuple demand
 {
   string source;
   string destination;
 }   
 
{demand} Demands with source in Nodes, destination in Nodes = ...;

float Lambda[Demands] = ...;

{string} NbsO[i in Nodes] = {j | <i,j> in Arcs};
 //Set of outgoing neighbors
 
{string} NbsI[i in Nodes] = {j | <j,i> in Arcs};
 //Set of ingoing neighbors
 
/* ZMIENNE & FUNKCJA CELU */
dvar float+ u[Arcs][Demands];
dvar float+ alfa[Arcs];
dvar float+ alfaMax;

/* MULTIPATH */
/*dvar float+ x[Arcs][Demands];
minimize alfaMax;*/

/* SINGLEPATH */
dvar boolean x[Arcs][Demands];
minimize sum(a in Arcs) alfa[a];

/* OGRANICZENIA */
subject to{
  alfaMax <= 1;
  forall(e in Arcs)
    minimalizacja_wektora_alf:
    {
    	alfaMax >= alfa[e];
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
    wzor_12:
    {
		sum(k in Demands) Lambda[k]*u[e][k] <= alfaMax*Fi[e];
    }  
  forall(e in Arcs)
    wzor_17:
    {
		sum(k in Demands) Lambda[k]*u[e][k] == alfa[e]*Fi[e];
		alfa[e] <= 1;
    }  
  forall(n in Nodes,k in Demands)
     wzor_3:
     {
   	 	if(n == k.source)
   	 			sum(nodes_out in NbsO[n]) x[<n,nodes_out>][k] - sum(nodes_in in NbsI[n]) x[<nodes_in,n>][k] == 1;
   	 	else if(n == k.destination)
    			sum(nodes_out in NbsO[n]) x[<n,nodes_out>][k] - sum(nodes_in in NbsI[n]) x[<nodes_in,n>][k] == -1;
    	else if(n != k.source && n !=k.destination)
   				sum(nodes_out in NbsO[n]) x[<n,nodes_out>][k] - sum(nodes_in in NbsI[n]) x[<nodes_in,n>][k] == 0;
     }  
}
