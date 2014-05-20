include <belt_configuration.scad>


module cross()
{
  cut_height = belt_height - link_depth_height + link_tolerance;

  difference()
  {
    // main part
    union()
    {
      cylinder(r=belt_thickness / 2, h=belt_height);

      translate([cross_width - belt_thickness,0,0])
        cylinder(r=belt_thickness / 2, h=belt_height);

      translate([0, -belt_thickness / 2, 0])
        cube([cross_width-belt_thickness, belt_thickness, belt_height]);
    }

    // left pin
    translate([0,0,-mo])
      cylinder(r=(pin_diameter +pin_tolerance)/ 2 , h=belt_height + 2 * mo);

    // right pin
    translate([cross_width - belt_thickness,0,-mo])
      cylinder(r=(pin_diameter +pin_tolerance) / 2, h=belt_height + 2 * mo);

    // bottom left cut
    translate([0,0,-mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(cut_height) / 2);

    // top left cut
    translate([0,0,belt_height - (cut_height) / 2+mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(cut_height) / 2);

    // bottom right cut
    translate([cross_width - belt_thickness,0,-mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(cut_height) / 2);

    // top right cut
    translate([cross_width - belt_thickness,0,belt_height - (cut_height) / 2+mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(cut_height) / 2);
  }
}

cross();