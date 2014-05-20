include<belt_configuration.scad>

use <end.scad>

module peak()
{
  union()
  {
    end();

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
}

peak();