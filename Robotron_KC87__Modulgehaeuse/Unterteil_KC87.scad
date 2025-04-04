/*
 25.11.2017 erste Version, erster Druck
    Größe muß noch geprüft werden
    die Schraubenlöcher und die Aussparung solten getapert werden
*/
$fs = 0.2; // minimum size 0.2
eps = 0.01;


breite = 100;
laenge = 112;
dicke = 1.8;
wandhoehe = 8.5;

include <scad-utils/morphology.scad>

module wandform( klein = false)
{
    // unten innen
    fillet( r = 1) polygon([[1,0], [3,0], [3,dicke], [dicke,dicke], [dicke,3], [1,3]]);
    difference()
    {
        // Hauptteil
        rounding( r = 0.9) polygon([[0,0], [3,0] ,[3,dicke], [dicke,dicke], [dicke,wandhoehe+1],[-0.5,wandhoehe+1]]);
        
        if( klein)
        {
            // fehlendes  Stueck
            polygon([[dicke+eps,4], [dicke+eps,wandhoehe+1], [-2,wandhoehe+1],[-2,4]]);
        }
        else
        {
            // fehlende Ecke
            polygon([[1,wandhoehe-1.5], [1,wandhoehe+1],[-2,wandhoehe+1],[-2,wandhoehe-1.5]]);
        }
    }
    
}


module wandecke( vorn = false)
{
    rotate([0,0,-1])
    rotate_extrude( angle = 92)  
    translate([-dicke,0])
    difference()
    {
        if( vorn)
        {
            difference()
            {
                wandform( klein=false);
                polygon([[dicke,0], [3,0], [3+eps,wandhoehe+1], [dicke,wandhoehe+1]]);
                polygon([[dicke,4], [dicke,wandhoehe+2], [-2,wandhoehe+2], [-2,4]]);
            }
        }
        else
        {
            difference()
            {
                wandform();
                polygon([[dicke,0], [3+eps,0], [3+eps,wandhoehe+1+eps], [dicke,wandhoehe+1+eps]]);
            }
        }
        // alles rechts von dicke, wegschneiden
        polygon([[dicke,0],[dicke,5],[10,5],[10,0]]);
    }
}

//!wandecke(vorn=true);

module pcb_auflage()
{    
     cylinder( h = 4.1, d = 7.5);
     cylinder( h = 4.8, d = 4.5);
}

module pcb_auflage_loecher()
{    
    translate([0,0,-eps]) cylinder( h = 1.5 + eps, d = 6);
    translate([0,0,-eps]) cylinder( h = 5, d = 3.3);
    // Abschraegung fuer 3D-Druck
    translate([0,0,1.5 - eps]) cylinder( h = 1.2 + eps + eps, d1 = 6, d2 = 3.3);
}


module grundkoerper()
{
    // unten
    translate([ 1, 1, 0]) cube([ breite - 2, laenge - 2, dicke]);
 
       
    // kleine Ecke
    translate([ dicke, dicke, 0]) wandecke( vorn = true);
    
    // links
    translate([0, laenge - dicke, 0]) rotate([90,0,0]) linear_extrude( laenge - dicke) wandform();
   
    // Ecke 
    translate([dicke, laenge - dicke, 0]) rotate([ 0, 0, -90]) wandecke();

    // hinten
    translate([breite - dicke, laenge, 0]) rotate([ 90, 0, -90]) linear_extrude( breite - dicke - dicke) wandform();

    // Ecke
    translate([breite - dicke, laenge - dicke, 0]) rotate( [0, 0, 180]) wandecke();

    // rechts
    translate([breite, 0, 0]) rotate([90,0,180]) linear_extrude( laenge - dicke) wandform();
    
    // kleine Ecke
    translate([breite - dicke, dicke, 0]) rotate([0,0,90]) wandecke( vorn = true);
    
    // vorn
    translate([dicke, 0, 0]) rotate([ 90, 0, 90]) linear_extrude( breite - dicke - dicke) wandform( klein = true);
    
}

module ecke_voll()
{
    translate([0,-0.2+eps+1,4.1]) rotate([-90,0,0]) linear_extrude( 24.4) rounding( r= 0.9) polygon([[0,0], [4.5,0], [4.5,4.1], [0,4.1]]);
}

module ecke_weg()
{
    translate([0,-0.2,-eps]) rotate([90,-90,180]) linear_extrude( 24.4) rounding( r = 0.9) polygon([[-1,-1], [3.2,-1], [3.2,3.5], [-1,3.5]]);
}


module unterteil()
{
    difference()
    {
        abstand_rechts = 85;
        abstand_hinten = 90;
     
        union()
        {
            grundkoerper();
            // PCB Auflagen
            translate([7.5, 15, 0]) pcb_auflage();
            translate([7.5, 15 + abstand_hinten, 0]) pcb_auflage();
            translate([7.5 + abstand_rechts, 15, 0]) pcb_auflage();
            translate([7.5 + abstand_rechts, 15 + abstand_hinten, 0]) pcb_auflage();
            // Ecke
            ecke_voll();   
        }
            
        // oben glatt schneiden
        translate([ -5, -5, wandhoehe ]) cube([ breite + 10, laenge  + 10, 10]);
        
        // Loecher reinmachen
        translate([7.5, 15, 0]) pcb_auflage_loecher();
        translate([7.5, 15 + abstand_hinten, 0]) pcb_auflage_loecher();
        translate([7.5 + abstand_rechts, 15, 0]) pcb_auflage_loecher();
        translate([7.5 + abstand_rechts, 15 + abstand_hinten, 0]) pcb_auflage_loecher();
        
        // Ecke
        ecke_weg();
    }
}

unterteil();