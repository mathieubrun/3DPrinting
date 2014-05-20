include <belt_configuration.scad>

use <end.scad>

module h()
{
  difference()
  {
    // main part
    end();

    // right pin
    translate([h_width - belt_thickness,0,-mo])
      cylinder(r=pin_diameter / 2, h=belt_height + 2 * mo);

    translate([h_width - belt_thickness,0, (belt_height - link_depth_height) / 2])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=link_depth_height);
  }
}

h();