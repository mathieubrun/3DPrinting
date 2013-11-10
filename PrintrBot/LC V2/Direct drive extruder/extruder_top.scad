include<extruder_configuration.scad>

rotate([0,180,0])
top();

module top()
{
	difference()
	{
		// main body
		union()
		{
			translate([0,0, 0])
			cube([nema_size, nema_size, thickness]);
			
			// lm8uu holder
			translate([holder_offset_x, holder_offset_y,0])
			cylinder(r=pdiam(bearingLM8UU_D)/2 + thickness/2, h=thickness);
		}

		// lm8uu holder
		translate([holder_offset_x, holder_offset_y,-mo])
		cylinder(r=pdiam(bearingLM8UU_D)/2 + thickness/2 + mo, h=bearingLM8UU_height-thickness-depth+holder_LM8UU_D);

		// lm8uu holder
		translate([holder_offset_x, holder_offset_y,-mo])
		cylinder(r=pdiam(m8_D)/2, h=thickness+2*mo);

		// motor holes
		for (h = holes) 
		{
			translate(h)
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);
		}

		// shaft hole
		translate([nema_size/2, nema_size/2, -mo])
		cylinder(r=pdiam(shaft_D)/2, h=thickness+mo*2);

		// bearing holder
		translate([nema_size/2, nema_size/2, -mo])
		cylinder(r=pdiam(bearing625_D)/2, h=thickness-1+mo*2);

		// material cutout
		translate([0,0,-mo])
		linear_extrude(height=thickness+2*mo, convexity=1)
		polygon([[nema_size+mo, nema_size+mo], [nema_size+mo, pillar_width], [pillar_width,nema_size + mo]], center=false);

	}		
}