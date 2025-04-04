eps = 0.1;
eps2 = eps + eps;


breite = 62;
tiefe = 109;
hoehe = 8;
innen = hoehe - 1;

wand = 1;
wand2 = wand + wand;

// trapezförmig
module auslassung()
{
translate([0,0,-eps]) linear_extrude( hoehe + eps2) polygon(points=[[0,3.5],[2,2],[2,-2],[0,-3.5]]);
}


// Wand für Auslassung
module auslassung_wand()
{
    linear_extrude( hoehe) polygon(points=[[0,3.5+wand],[2+wand,2+wand],[2+wand,-2-wand],[0,-3.5-wand]]);
}


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
        
        translate([0, 36, 0]) auslassung_wand();
        translate([0, 36+41, 0]) auslassung_wand();
        translate([breite, 36, 0]) mirror([1,0,0]) auslassung_wand();
        translate([breite, 36+41, 0]) mirror([1,0,0]) auslassung_wand();
    }
    
    // Auslassungen bei +35 und +41 mm
    // am Rand
    translate([-eps, 36, 0]) auslassung();
    translate([-eps, 36+41, 0]) auslassung();
    translate([breite+eps, 36, 0]) mirror([1,0,0]) auslassung();
    translate([breite+eps, 36+41, 0]) mirror([1,0,0]) auslassung();
}

grab2();
