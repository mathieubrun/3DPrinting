include<extruder_configuration.scad>

rotate([0,90,0])
idler();

module idler()
{
	d = nema_size / 2 - hole_distance;
	dd = extruder_gear_D/2 + bearing608_D / 2 - d;
	h = sqrt(pow(dd,2)+pow(d,2)) + hole_distance;

	bearing_holder = 8;

	difference()
	{
		union()
		{
			
			translate([0, hole_distance, 0])
			cube([hole_distance*2, nema_size + 5, idler_depth]);

			translate([hole_distance, 0, 0])
			cube([hole_distance, hole_distance, idler_depth]);

			translate([hole_distance, hole_distance, 0])
			cylinder(r=hole_distance, h=idler_depth);
			
			difference()
			{
				translate([hole_distance, h, 0])
				cylinder(r=pdiam(m8_D + bearing_holder) / 2, h=idler_depth);

				translate([hole_distance, h - pdiam(m8_D + bearing_holder)/2, -mo])
				cube([pdiam(m8_D + bearing_holder), pdiam(m8_D + bearing_holder),idler_depth+2*mo]);
			}
		}
		
		// idler fixation hole
		translate(holes[0])
		cylinder(r=pdiam(m3_D)/2, h=idler_depth + thickness+mo*2);

		// idler tightening holes
		for (h = holder_holes) 
		{
			translate([-mo,nema_size+hole_distance,idler_depth/2 + h])
			rotate([0,90,0])
			cylinder(r=pdiam(m3_D)/2, h=idler_depth + thickness+mo*2);

			translate([-mo,nema_size+hole_distance-pdiam(m3_D)/2,idler_depth/2 + h-pdiam(m3_D)/2])
			cube([idler_depth+2*mo, pdiam(m3_D)/2, pdiam(m3_D)]);

			translate([-mo,nema_size+hole_distance-2,idler_depth/2 + h])
			rotate([0,90,0])
			cylinder(r=pdiam(m3_D)/2, h=idler_depth + thickness+mo*2);
		}	

		// bearing fixation
		translate([hole_distance, h - pdiam(m8_D)/2, idler_depth/2-bearing608_m8/2])
		cube([pdiam(m8_D), pdiam(m8_D),bearing608_m8]);
		translate([hole_distance, h, idler_depth/2-bearing608_m8/2])
		cylinder(r=pdiam(m8_D) / 2, h=bearing608_m8);

		// bearing clearance
		translate([hole_distance, h - pdiam(bearing608_D_clr)/2, idler_depth/2-bearing608_clr/2])
		cube([pdiam(bearing608_D_clr), pdiam(bearing608_D_clr),bearing608_clr]);
		translate([hole_distance, h,  idler_depth/2-bearing608_clr/2])
		cylinder(r=pdiam(bearing608_D_clr) / 2, h=bearing608_clr);
	}		

	if(show_axles > 0)
	{
		translate([hole_distance, h, idler_depth/2-bearing608_width/2])
		color("Grey")cylinder(r=pdiam(bearing608_D) / 2, h=bearing608_width);		
	}	
}