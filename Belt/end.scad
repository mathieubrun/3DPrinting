include <belt_configuration.scad>

module end()
{
  difference()
  {
    // main part
    union()
    {
      cylinder(r=belt_thickness / 2, h=belt_height);

      translate([h_width - belt_thickness,0,0])
        cylinder(r=belt_thickness / 2, h=belt_height);

      translate([0, -belt_thickness / 2, 0])
        cube([h_width-belt_thickness, belt_thickness, belt_height]);
    }

    // left pin hole
    translate([0,0,-mo])
      cylinder(r=pin_diameter / 2, h=belt_height + 2 * mo);
  
    // left cut
    translate([0,0, (belt_height - link_depth_height)/2])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=link_depth_height);
  }
}

end();