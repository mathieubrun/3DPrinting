include <belt_configuration.scad>

use <h.scad>

module h_hole()
{
	difference()
   {
		h();
      translate([h_width/2-belt_thickness / 2,-belt_thickness/2-mo,belt_height/2])
		rotate([-90,0,0])
        cylinder(r=hole_diameter / 2, h=belt_thickness+2*mo);
   }
}

h_hole();
