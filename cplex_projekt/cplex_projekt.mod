/*********************************************
 * OPL 12.7.1.0 Model
 * Author: root
 * Creation Date: 20 gru 2019 at 08:17:46
 *********************************************/

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
