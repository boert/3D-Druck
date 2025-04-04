eps     = 0.01;
enhance = 0.3;  // fuer Innenloecher
segment = 0.2;  // für $fs

difference()
{
    union()
    {
        // unten dick
        cylinder( d = 5, h = 5, $fs = segment);
        // Mittelteil
        cylinder( d = 2.8 - enhance, h = 8, $fs = segment);
        // oben etwas dicker
        translate([ 0, 0, 6.5]) cylinder( d = 0.2 + 2.8 - enhance, h = 8 - 5 - 1.5, $fs = segment);
    }
    translate([ 0, 0, 5 / 2 + 5 +eps ]) cube( [ 0.5, 2.8 + 0.5, 5], center = true);
}
