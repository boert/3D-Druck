
module Oberteil()
{

module Schraubenbippus()
{
	difference()
	{
		// Huelle
		cylinder( h = 14, d1 = 7, d2 = 5);

		// Schraubenloch
		translate([ 0, 0, -0.01])
			//linear_extrude( height = 5.4)
			//circle( d=5.3, $fn = 25);
			cylinder( h = 5.4, d1 = 5.3, d2 = 4.5, $fn = 25);

		// Durchgangsloch fuer Schraube
		translate([ 0, 0, -0.1]) cylinder( h = 15, d = 2.6, $fn = 25);
	}
}


// Erzeugt Viertelkreis in Z-Richtung
module Kante_rund( length = 1, radius = 1.5)
{
	linear_extrude(height = length)
	difference()
	{
		circle( r = radius, $fs=1);
		translate([ -radius, 0, 0]) square( 2 * radius, center=true);
		translate([ 0, -radius, 0]) square( 2 * radius, center=true);
	}
}


// Parallelogrammartig
module Seitenwand( length = 1)
{
	// nach hinten schieben
	translate( [ 0, length, 0])
	// hochkant drehen
	rotate( [ 90, 0, 0])
	// gross machen
	linear_extrude( height = length)
	polygon( points=[[ -.01, -.1], [ 1.5, -.1], [ 1.75, 8.6], [ 0.25, 8.6]], paths=[[ 0, 1, 2, 3]]);
}




module Front()
{
	module front_ohne_rundung()
	{
	rotate( [ 90, 0, 0])
		linear_extrude( height = 1.5)
		polygon( points=[[ -1, -0.5], [ 123.5/2-1.5, -0.5], [ 124/2-1.5, 10], [ -1, 10]], paths=[[ 0, 1, 2, 3]]);
	}


    // Rundung anbringen
	minkowski()
	{
		front_ohne_rundung();
		// kleiner liegender Halb-Zylinder
		difference()
		{
			rotate([ 90, 0, 0]) cylinder( r=1.5, h=0.01, $fn=10);
			translate([ 0, 0, 2]) cube(4, center=true);
		}
	}
}


module haelfte()
{
	// rechte Haelfte

	// Position Lagerbock
	lager_x = 107.6/2;
	lager_y = -105;


	// Grundflaeche
	difference() {
		translate([ -1, -118, -1.5]) cube([ (119-1.5)/2+1, 118, 1.5]);

		// Aussparung Mutternlochmodul hinten
		translate([ 85/2, -17.5, -1.6]) cylinder( h = 3.6, d = 6);

		// Aussparung Mutternlochmodul vorn
		translate([ 85/2, -107.5, -1.6]) cylinder( h = 3.6, d = 6);

		// der Laengsschlitz im Lagerbock
		translate([ lager_x, lager_y, 0])
		translate([ 1.5, -4.3, 0.01]) cube([ 1.5, 10, 10]);

	}


	// Abrundung
	translate([ (119-1.5)/2 - 0.01, -118, 0.01]) rotate([ -90, 0, 0]) Kante_rund( 118);

	// Seitenwand
	difference() {
		translate([ (119-1.5)/2, -118, 0]) Seitenwand( 118);

		// Aussparung fuer Nippel
		translate([ lager_x, lager_y, 0])
		translate([ 4.5, -3, 7.5]) cube([ 1.1, 6, 2]);
	}

	// Rueckwand aussen
	translate([ -1, -1.5, -0.1]) cube([ 117/2+1.5, 1.5, 8.6]);

	// Rueckwand, nach innen gehend
	translate([ 92.5/2, -8, -0.1]) cube([ 1.5, 8, 8.6]);
	
	// Rueckwand, nach innen gehend, zusaetzlich
	translate([ 92.5/6, -8, -0.1]) cube([ 1.5, 8, 8.6]);
	
	union() {
		// Rueckwand, innen
		// breiter und hoeher
		translate([ -1, -8, -0.1]) cube([ 49.75+10, 1.5, 8.6]);

		// Lippe fuer Leiterplatte
		translate([ 0, -6.5, 7.5])
		rotate([ 90, 0, 0]) 
		linear_extrude( height = 1.5) 
		polygon( points=[[ -1, 0], [ 75.5/2, 0], [ 75.2/2, 5], [ -1, 5]], paths=[[ 0, 1, 2, 3]]);

	}


    // Loecher
	// hinten
	translate([ 85/2, -17.5, -1.5]) Schraubenbippus();

	// vorn
	translate([ 85/2, -107.5, -1.5]) Schraubenbippus();


	// Lagerbock oben
	difference()
	{
		union()
		{
			// Block
			translate([ lager_x, lager_y, 0])
			translate([ 0, -8.5/2, 0]) cube([5.5, 8.5, 8.5]);
	
			// Bippus gegenueber der Rundung
			translate([ lager_x, lager_y, 0])
			translate([ 0, -2.5/2, 8.5]) cube([ 4.5, 2.1, .6]);
		}

		// der Hebelschlitz
		translate([ lager_x, lager_y, 0])
		translate([ 1.5, -4.3, -3]) cube([ 1.5, 10, 13]);

		// Aussparung fuer Nippel
		translate([ lager_x, lager_y, 0])
		translate([ 4.5, -3, 7.5]) cube([ 1.1, 6, 2]);
	}



	// Front, Teil 1
	difference()
	{
		translate([ 0, -117, -1.5]) Front();
		// Hauptausschnitt
		translate([ -3, -118.7, 0]) cube([ 107/2 + 3, 2, 10]);
		
		// Hebelschlitz
		translate([ lager_x + 1.5, lager_y - 14, 0]) cube([1.5 , 3, 10]);
	}

	// vorderster Rahmen
	translate([ 0, -128.3, -1.5-2])
	difference()
	{
		// Volumen/ Rahmen
		minkowski()
		{
			translate([ 0, 11, 0])
			rotate([ 90, 0, 0]) 
			linear_extrude( height = 11) 
			polygon( points=[[ -1, 0+1], [ 109.5/2-1, 0+1], [ 110.5/2-1, 12], [ -1, 12]], paths=[[ 0, 1, 2, 3]]);

			// kleiner liegender Halb-Zylinder
			difference()
			{
				rotate([ 90, 0, 0]) cylinder( r=1, h=0.01, $fn=10);
				translate([ 0, 0, 2]) cube(4, center=true);
			}
		}
		
		// grosser Ausbruch
		translate([ 0, 11.5, 2])
		rotate([ 90, 0, 0]) 
		linear_extrude( height = 12) 
		polygon( points=[[ -2, 0], [ 106/2, 0], [ 107/2, 12], [ -2, 12]], paths=[[ 0, 1, 2, 3]]);


		// Ausbruch Frontplatte
		translate([ 0, 5, 1]) 
		rotate([ 90, 0, 0]) 
		linear_extrude( height = 1.6) 
		polygon( points=[[ -2, 0], [ 107.5/2, 0], [ 108.5/2, 11.5], [ -2, 11.5]], paths=[[ 0, 1, 2, 3]]);
	}
	
	

	//
	// zusaetzliche
	// Stuetzstrukturen
	//

	// an der Rueckwand
	translate([ 95/2, -8, 0]) cube([ 12, 1.5, 8]);

	// am Lagerbock, innen
	translate([ lager_x + 1.5, lager_y + 3.9, 0])
	rotate([ 0, -90, 0])
	linear_extrude( height = 1.5)
	polygon( points=[[ -0.01, -0.01], [ -0.01, 4], [ 7, -0.01]], paths=[[ 0, 1, 2]]);


	// am Lagerbock, aussen
	translate([ lager_x + 5.2, lager_y + 3.9, 0])
	rotate([ 0, -90, 0])
	linear_extrude( height = 2.2)
	polygon( points=[[ 0, 0], [ 0, 4], [ 7, 0]], paths=[[ 0, 1, 2]]);

	// zw. Lager und Front, innen
	translate([ lager_x , lager_y - 13, 0])
	cube([1.5, 9.5, 7]);	

	// zw. Lager und Front, aussen
	translate([ lager_x + 3.2, lager_y - 13, 0])
	cube([2.2, 9.5, 7]);	


}


// und nun beide zusammen:
                   haelfte();
mirror([ 1, 0, 0]) haelfte();
}


// hier wird eigentlich gemalt:
translate([ 0, 118/2, 0]) 
difference()
{
	Oberteil();
	/*
	// Aussparung fuer M052, Netzwerkbuchse
	translate([ -(119.5/2)+77, -104-15.1, -0.8])
	cube([ 16.5, 23, .9]);
	
	// Aussparung fuer M052, USB-Buchse
	translate([ -(119.5/2)+39.5, -104-15.1, -0.9])
	cube([ 8, 15, 1]);
	
	// Aussparung fuer M052, USB-Buchse
	translate([ -(119.5/2)+20.5, -104-15.1, -0.9])
	cube([ 8, 15, 1]);
    */
}