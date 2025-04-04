eps = 0.1;
eps2 = eps + eps;


breite = 64;
tiefe = 109;
hoehe = 8;
innen = hoehe - 1;

wand = 1;
wand2 = wand + wand;


// Auflage für Schaltkreise
module dip_schiene(n)
{
    midspace = 0;//5;
    start = 3.2;
    
    ms = ( n > 4) ? midspace : 0;
     
    translate([0, start + ms + 9.5*n, wand-eps]) cube([ breite, 7.62, 4]);
}

// Anfasser
module grab2()
{
    $fn = 4;
    
    translate([ breite/2, tiefe/2, eps])
    
    rotate([ 0, 0, 45])
    cylinder( h = hoehe, r1 = 0, r2 = 5);
}

    
// alles zusammenbauen
difference()
{
    union()
    {
        difference()
        {
        // Hauptkörper
        cube([ breite, tiefe, hoehe]);
            
        // Innenkörper
        translate([ wand, wand, hoehe-innen]) cube([ breite-wand2, tiefe-wand2, innen+eps]);
        }
    
        for(i = [0:10])
        {
            dip_schiene(i);
        }
    }
}

grab2();
