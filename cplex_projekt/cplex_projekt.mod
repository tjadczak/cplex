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
 
/* ZMIENNE */

dvar float+ x[Arcs][Demands];
dvar float+ u[Arcs][Demands];
//dvar boolean x[Arcs][Demands];
//dvar boolean u[Arcs][Demands];
dvar float+ alfa[Arcs];
//dvar float+ alfaTotal;

/* FUNKCJA CELU */

/* Jak zmienilem funkcje celu na taka jak nizej,
	i usunalem w ogole alfaTotal ktora chce zelek,
	to zaczelo poprawnie liczyc wszystko dla przypadku single-path.
	Niestety, liczy tak samo (to znaczy oblicza przypadek single-path)
	bez wzgledu na to, czy zmienne x,u sa typu boolean czy float+ - Tomek */
	
//minimize alfaTotal;
minimize sum(a in Arcs) alfa[a];

/* OGRANICZENIA */
subject to{
  /*forall(e in Arcs)
    minimalizacja_wektora_alf:
    {
    	alfa[e] <= alfaTotal;
    }*/
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
		sum(k in Demands) Lambda[k]*u[e][k] <= alfa[e]*Fi[e];
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
