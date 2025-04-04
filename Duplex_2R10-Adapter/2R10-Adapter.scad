// kleinste Größe
$fs = 0.25;

// epsilon
eps = 0.05;

zugabe = 0.5;

module cell_2R10 ()
{
    // Gesamtkörper
    cylinder( h = 71.9, d = 21.0 );
    // Pluspol
    //cylinder( h = 73.0, d = 6.1);
}

module cell_18650 ()
{
    translate([ 0, 0, -eps])
    cylinder( h = 65 + eps, d = 18 + zugabe);
}


module diode_DO15 ()
{
    h = 6.5;
    //translate([ 0, 0, -$h/2])
    {
        // Körper
        cylinder( h = h + zugabe, d = 3 + zugabe);
        // Beinchen
        translate([ 0, 0, -(30-h)/2]) cylinder( h = 30, d = 1 + zugabe);
    }
} 

difference()
{
    cell_2R10();
    translate([ 0, 0, 0]) cell_18650();
    translate([ 0, 2.5, 65 + 1.2]) diode_DO15();
    translate([ 0, -2.5, 65 + 13]) diode_DO15();

    // Material sparen
    a=9;
    rotate([ 0, 0, 90]) translate([ 0, 15, (0*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
    rotate([ 0, 0,  0]) translate([ 0, 15, (1*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
    rotate([ 0, 0, 90]) translate([ 0, 15, (2*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
    rotate([ 0, 0,  0]) translate([ 0, 15, (3*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
    rotate([ 0, 0, 90]) translate([ 0, 15, (4*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
    rotate([ 0, 0,  0]) translate([ 0, 15, (5*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
    rotate([ 0, 0, 90]) translate([ 0, 15, (6*a)]) rotate([ 90, 0, 0]) cylinder( d = 12, h = 30);
}

