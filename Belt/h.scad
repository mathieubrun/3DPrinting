include <belt_configuration.scad>

use <end.scad>

module h()
{
  difference()
  {
    end();

    translate([h_width - belt_thickness,0,-mo])
      cylinder(r=pin_diameter / 2, h=belt_height + 2 * mo);

    translate([h_width - link_depth +pin_diameter/4- belt_thickness / 2,-belt_thickness / 2 - mo, belt_height/2 - link_depth_height/2+link_tolerance / 2])
      cube([link_depth-pin_diameter/4, belt_thickness + 2* mo, link_depth_height-link_tolerance/2]); 

    translate([h_width - belt_thickness,0, belt_height/2 - link_depth_height/2+link_tolerance / 2])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=link_depth_height-link_tolerance/2);
  }
}

h();