
$fs = 0.33;
$fn = 120;
dicke = 12;
hoehe = 45;
rand = 5;
phase = 2;
eps = 0.01;

module ferritstab()
{
    cylinder( h = 200, d = dicke, center = true);
}

module abschraegung_innen()
{
    translate([ 0, 0, hoehe/2+.8]) cylinder( h = phase, d1 = dicke, d2 = dicke + phase, center = false);
    translate([ 0, 0, -hoehe/2-.8-phase]) cylinder( h = phase, d2 = dicke, d1 = dicke + phase, center = false);
}


module wickelkoerper()
{
    translate([ 0, 0, hoehe/2-eps]) cylinder( h = rand, d1 = dicke, d2 = dicke + 8, center = true);
    translate([ 0, 0, -hoehe/2+eps]) cylinder( h = rand, d2 = dicke, d1 = dicke + 8, center = true);
    cylinder( h = hoehe, d = dicke + 2, center = true);
}

module notch()
{
    translate([ dicke/2+1, -1.5/2, -(hoehe/2)-rand]) cube([rand+eps, 1.5, hoehe+2*rand+eps]);
}

difference()
{
    wickelkoerper();
    ferritstab();
    abschraegung_innen();
    notch();
}

