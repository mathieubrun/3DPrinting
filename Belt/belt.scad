include <belt_configuration.scad>

use <buckle.scad>
use <end.scad>
use <cross.scad>

use <cross_hole.scad>

use <cross_male.scad>
use <h.scad>
use <h_hole.scad>
use <peak.scad>

module print()
{
	rotate([0,0,180])
	end();

   cross();

   translate([(cross_width - belt_thickness),0,0])
   h();

   translate([(cross_width + h_width - 2*belt_thickness),0,0])
   cross_hole();

   translate([(2*cross_width + h_width - 3*belt_thickness),0,0])
   h_hole();

   translate([(2*cross_width + 2*h_width - 4*belt_thickness),0,0])
   cross_male();

   translate([(3*cross_width + 2*h_width - 5*belt_thickness),0,0])
   peak();

	translate([0, 2*belt_thickness,0])
   buckle();
}

print();