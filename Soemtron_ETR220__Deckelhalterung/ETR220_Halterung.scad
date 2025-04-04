
dicke = 3.5; // original: 3.5
versatz = 3.5;

$fn = 60;   // fragments
eps = 0.05;



module halterung()
{
    difference()
    {
        union()
        {
            difference()
            {
                // Grundkoerper
                cube([ 35, 14, dicke], false);
            
                // Bohrung 1
                translate([ 5, 7, -eps]) cylinder( dicke + 2*eps, d = 3.8, center = false);
                
                // Bohrung 2
                translate([ 30, 7, -eps]) cylinder( dicke + 2*eps, d = 3.8, center = false);
                
                // Vertiefung 1
                translate([ 5, 7, dicke - 1.5 + 2.5]) cylinder( 5, d = 6.3, center = true);
                    
                // Vertiefung 2
                translate([ 30, 7, dicke - 1.5 + 2.5]) cylinder( 5, d = 6.3, center = true);
            }
            
            // Kurve zum Anbau
            translate([ 20+eps, 14-eps, 0])
            difference()
            {
                cube([ 5+eps, 5+eps, dicke], false);
                translate([ 0, 5, -eps])
                cylinder( dicke+2*eps, r = 5); 
            }
            
            // kleiner Anbau
            translate([ 25, 14 - eps, 0]) cube([ 14, 5 + 2*eps, dicke], false);
            
            // schraege Verbindung
            translate([ 25, 19, 0]) rotate( a = 30, v=[ 1, 0, 0]) cube([ 20, 5+dicke, dicke]);
            
            // oberere Ecke
            translate([ 21.5, 24, versatz]) cube([ 25, 10, dicke]);
            
            // oberer Kreis
            translate([ 21.5, 30, versatz]) cylinder( dicke, d = 12, center = false);
        }
        
        // schraege Seite
        translate([ 36, 0, -1]) minkowski()
        {
               linear_extrude( height = 10) polygon([ [0,0], [12,0], [12,32], [0,14]]);
            cylinder( 1, d = 2);
        }
        
        // oben flach machen
        translate([ 0, 14, dicke+versatz-eps]) cube([ 50, 40, 10]);
    }
    
    // Verstaerkung
    hull()
    {
        translate([ 38, 29, 4])
        sphere( 2.9);
        translate([ 22, 29, 4])
        sphere( 2.9);
    }
    
    // Verstaerkung 2
    hull()
    {
        translate([ 32, 29, 4])
        sphere( 2.9);
        translate([ 32, 20, 0])
        sphere( 2.9);
    }
    
    // Verstaerkung 3
    // innen, die Schraege
    hull()
    {
        translate([ 32, 20, 0])
        sphere( 2.9);
        translate([ 22, 7, 0])
        sphere( 2.9);
    }
    // Verstaerkung 4
    // ganz innen
    hull()
    {
        translate([ 22, 7, 0])
        sphere( 2.9);
        translate([ 12, 7, 0])
        sphere( 2.9);
    }
}

translate([ 0, 1, 0])   halterung();
translate([ 0, -1, 0]) mirror([ 0, 1, 0]) halterung();

