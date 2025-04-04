/*
 28.11.2017 erste Version, erster Druck
    - Riffelung nicht sehr stark ausgeprägt
    - Druck mit Oberseite nach oben (damit diese schön wird)
    - Nachteile:
        * Lüftungslöcherstege teilweise eingebrochen
        * Unterkante nicht richtig fest, trotz Stützmaterial
        * Stützmaterial läßt sich an Nupsis nicht entfernen
        * Nupsi abgebrochen
        
  Änderungen für zweiten Versuch
    - Druck mit Oberseite nach unten
    - Logo entfernen
    - Druckbett dauerhaft auf 70 °C halten
    
 */
$fs = 0.2; // minimum size 0.2
eps = 0.01;


breite = 100;
laenge = 112;
dicke = 1.8;
wandhoehe = 11.8;

include <scad-utils/morphology.scad>



module riffle()
{
    module n_riff()
    {
        module riff( n)
        {
            translate([ n * 2, 0, 0]) linear_extrude( 9) polygon([[0,0], [2,0], [2,0.5]]);
        }
        for( r = [ 0:4])
        {
            riff( r);
        }
    }
    translate([ 100.0, 107, 2.85]) rotate([ 0, 2.4, 0]) rotate([ 0, 0, -90]) n_riff();
    translate([   -0.0, 107, 2.85]) rotate([ 0, -2.4, 0]) mirror([ 1, 0, 0]) rotate([ 0, 0, -90]) n_riff();
}


module schlitze()
{
    for( schlitz = [ 15: 3: 100 - 15])
    {
        translate([ schlitz, 108, -eps]) cube([1, 5, 7.5]);
    }
}


module logo()
{
    translate([ 50, 75+1, 0.5]) resize([ 68, 0, 0.5], auto = true) rotate([0,0,180]) mirror([0,1,0]) mirror([0,0,1]) surface( file = "megalogo.png", invert = false, center = true);
}

module logo_weg()
{
    translate([ 50, 76, 0.25]) cube([ 70, 40, 0.5 + eps], center = true);
}


module wandform( voll = false)
{
    module hauptteil()
    {
        //vunten rund
        rounding( r = 0.9) polygon([[0,0], [3,0] ,[3,dicke], [dicke,dicke], [dicke,wandhoehe],[-0.5,wandhoehe]]);
        // oben eckig
        polygon([[0,dicke], [dicke,dicke], [dicke,wandhoehe], [-0.5,wandhoehe]]);
    }


    // unten innen
    fillet( r = 1) polygon([[1,0], [3,0], [3,dicke], [dicke,dicke], [dicke,3], [1,3]]);
    if( voll)
    {
        hauptteil();
    }
    else
    {
        difference()
        {
            hauptteil();
            // fehlende Ecke (oben)
            polygon([[0.8,wandhoehe-1.5], [0.8,wandhoehe+eps],[2,wandhoehe+eps],[2,wandhoehe-1.5]]);
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
                wandform( voll=true);
                polygon([[dicke,0], [3,0], [3+eps,wandhoehe+1], [dicke,wandhoehe+1]]);
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
     cylinder( h = 13.5, d1 = 9, d2 = 7);
}
 

module pcb_auflage_loecher()
{    
    translate([0,0,dicke+2]) cylinder( h = 10, d = 2.2);
}


module grundkoerper()
{
    // unten
    translate([ 1, 1, 0]) cube([ breite - 2, laenge - 2, dicke]);
 
       
    // kleine Ecke
    translate([ dicke, dicke, 0]) wandecke( vorn = true);
    
    // links
    translate([0, laenge - dicke, 0]) rotate([90,0,0]) linear_extrude( laenge - 2 *dicke) wandform();
   
    // Ecke 
    translate([dicke, laenge - dicke, 0]) rotate([ 0, 0, -90]) wandecke();

    // hinten
    translate([breite - dicke, laenge, 0]) rotate([ 90, 0, -90]) linear_extrude( breite - dicke - dicke) wandform();

    // Ecke
    translate([breite - dicke, laenge - dicke, 0]) rotate( [0, 0, 180]) wandecke();

    // rechts
    translate([breite, dicke, 0]) rotate([90,0,180]) linear_extrude( laenge - 2 * dicke) wandform();
    
    // kleine Ecke
    translate([breite - dicke, dicke, 0]) rotate([0,0,90]) wandecke( vorn = true);
    
    // vorn
    difference()
    {
        translate([dicke, 0, 0]) rotate([ 90, 0, 90]) linear_extrude( breite - dicke - dicke) wandform( voll = true);
        // großer Ausschnitt
        translate([ 10/2, -dicke+eps, 4]) cube([ 90,  2 * dicke, 8 + eps]);
    }
    
}


module oberteil()
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
        
            riffle();
        }
        
        // Loecher reinmachen
        translate([7.5, 15, 0]) pcb_auflage_loecher();
        translate([7.5, 15 + abstand_hinten, 0]) pcb_auflage_loecher();
        translate([7.5 + abstand_rechts, 15, 0]) pcb_auflage_loecher();
        translate([7.5 + abstand_rechts, 15 + abstand_hinten, 0]) pcb_auflage_loecher();
 
        //logo_weg();
        
        schlitze();
    }
    //logo();
}

oberteil();