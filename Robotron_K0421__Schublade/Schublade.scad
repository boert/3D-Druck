// changed 04/2025  dickere Wand am Grundkörper


module grundkoerper( laenge)
{

    points = [
    [0,-20], [0,20],
    [16,28], [16,-28]
    ];


    linear_extrude( height = laenge, center = true)
    {
        polygon( points=points);
    }
}


module koerper()
{
    rotate([0,-90,0])
    difference()
    {
        grundkoerper( 125);
        translate([2.0, 0.0, 0.0]) scale([ 1.0, 0.95, 1.0]) grundkoerper( 122);
    }
}

module griff()
{
    shift = 10.5;
    translate([125/2,0,0])
    translate([17/2-0.3,0,6])
    intersection()
    {
        difference()
        {
            translate([0,0,shift/2]) cube([17, 70, 33-shift], center = true);
            cube([15, 69, 31], center = true);
            translate([0,0,-2]) cube([15, 71, 31], center = true);
            translate([2,0,-10]) cube([15, 71, 31], center = true);
            
        }
        // Abrundung unten
            
            rotate([0,90,0]) translate([-10,0,-150]) cylinder( h =200, r = 40);
    }
}

module griff2()
{
    shift = 10.5;
    translate([125/2,0,0])
    translate([17/2-0.3,0,6])
    difference()
    {
        translate([0,0,shift/2]) cube([17, 70, 33-shift], center = true);
        translate([0,0,shift/2]) rotate([0,45,0]) cube([11, 72, 11], center = true);
        translate([1,0,-2]) cube([17, 72, 15], center = true);        
    }
}


module griff3()
{
    shift = 10.5;
    translate([125/2,0,0])
    translate([17/2-0.3,0,6])
    union()
    {
        // frontplatte
        translate([-7.5,0,shift/2]) cube([2, 70, 33-shift], center = true);

    x = 2.5;
    y = 11;
    z = 11;

    translate([-7,0,5])
    rotate([90,0,0])
        linear_extrude( height = 70, center = true)
        {
            polygon( points=[[0,-x],[z,-y],[z,y],[0,x]]);
        }
    }
}


koerper();
griff3();
