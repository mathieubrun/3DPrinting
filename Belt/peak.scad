include<belt_configuration.scad>

module peak()
{
  difference()
  {
    union()
    {
      cylinder(r=belt_thickness / 2, h=belt_height);

      translate([peak_width - belt_thickness,0,0])
        cylinder(r=belt_thickness / 2, h=belt_height);

      translate([0, -belt_thickness / 2, 0])
        cube([peak_width-belt_thickness, belt_thickness, belt_height]);

      translate([peak_width/2,0,belt_height/2])
      rotate([0,90,0])
      intersection()
      {
        intersection_for(n = [1 : 6])
        {
          rotate([0, 0, n * 60])
          {
              translate([10,0,0])
              sphere(r=belt_height);
          }
        }
        translate([-belt_height/2,-belt_thickness/2,0])
        cube([belt_height, belt_thickness, 50]);
      }
    }

    translate([0,0,-mo])
      cylinder(r=pin_diameter / 2, h=belt_height + 2 * mo);
  
    translate([-belt_thickness / 2, -belt_thickness / 2 - mo, belt_height/2 - link_depth_height/2+link_tolerance / 2])
      cube([link_depth-pin_diameter/4, belt_thickness + 2* mo, link_depth_height-link_tolerance/2]);

    translate([0,0, belt_height/2 - link_depth_height/2+link_tolerance / 2])
      cylinder(r=(belt_thickness+link_tolerance) / 2, h=link_depth_height-link_tolerance/2);
  }
}

peak();