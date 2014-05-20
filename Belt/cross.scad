include <belt_configuration.scad>

module cross()
{
  difference()
  {
    union()
    {
      cylinder(r=belt_thickness / 2, h=belt_height);

      translate([cross_width - belt_thickness,0,0])
        cylinder(r=belt_thickness / 2, h=belt_height);

      translate([0, -belt_thickness / 2, 0])
        cube([cross_width-belt_thickness, belt_thickness, belt_height]);
    }

    translate([0,0,-mo])
      cylinder(r=(pin_diameter +pin_tolerance)/ 2 , h=belt_height + 2 * mo);


    translate([cross_width - belt_thickness,0,-mo])
      cylinder(r=(pin_diameter +pin_tolerance) / 2, h=belt_height + 2 * mo);

    translate([-belt_thickness / 2, -belt_thickness / 2 - mo, -mo])
      cube([link_depth-pin_diameter/4, belt_thickness + 2* mo, (belt_height - link_depth_height) / 2]);
    translate([0,0,-mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(belt_height - link_depth_height) / 2);

    translate([-belt_thickness / 2, -belt_thickness / 2 - mo, belt_height - (belt_height - link_depth_height) / 2+mo])
      cube([link_depth-pin_diameter/4, belt_thickness + 2* mo, belt_height - link_depth_height * 2]);
    translate([0,0,belt_height - (belt_height - link_depth_height) / 2+mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(belt_height - link_depth_height) / 2);

    translate([cross_width - link_depth+pin_diameter/4 - belt_thickness / 2, -belt_thickness / 2 - mo, -mo])
      cube([link_depth-pin_diameter/4, belt_thickness + 2* mo, (belt_height - link_depth_height) / 2]);
    translate([cross_width - belt_thickness,0,-mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(belt_height - link_depth_height) / 2);

    translate([cross_width - link_depth+pin_diameter/4 - belt_thickness / 2, -belt_thickness / 2 - mo, belt_height - (belt_height - link_depth_height) / 2+mo])
      cube([link_depth-pin_diameter/4, belt_thickness + 2* mo, belt_height - link_depth_height * 2]);
    translate([cross_width - belt_thickness,0,belt_height - (belt_height - link_depth_height) / 2+mo])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=(belt_height - link_depth_height) / 2);
  }
}

cross();