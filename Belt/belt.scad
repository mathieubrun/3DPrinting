include <belt_configuration.scad>

use <buckle.scad>
use <end.scad>
use <cross.scad>

use <cross_hole.scad>

use <cross_male.scad>
use <h.scad>
use <h_hole.scad>

module print()
{
	cross();

   translate([(cross_width + belt_thickness),0,0])
   cross_hole();

   translate([2*(cross_width + belt_thickness),0,0])
   cross_male();

   translate([(h_width + 2* belt_thickness)+ 2*(cross_width + belt_thickness),0,0])
   h();

   translate([2*(h_width + 2 * belt_thickness)+ 2*(cross_width + belt_thickness),0,0])
   h_hole();

   translate([3*(h_width + 2 * belt_thickness)+ 2*(cross_width + belt_thickness),0,0])
   end();	

   translate([4*(h_width + 2 * belt_thickness)+ 2*(cross_width + belt_thickness),0,0])
   peak();	

   translate([3*peak_width + belt_thickness + 4*(h_width + 2 * belt_thickness)+ 2*(cross_width + belt_thickness),0,0])
   buckle();	
}

print();
