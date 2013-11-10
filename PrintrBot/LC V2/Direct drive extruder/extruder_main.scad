include<extruder_configuration.scad>

main();

module main()
{
	difference()
	{
		// main body
		union()
		{
			cube([nema_size, nema_size, thickness]);

			// filament guide
			translate([nema_size/2-filament_path_width/2+extruder_gear_D/2, 0, thickness-mo])
			cube([filament_path_width, filament_path_height, depth+mo]);
	
			for (p = pillars) 
			{
				translate(p)
				cube([pillar_width, pillar_width, depth]);		
			}

			// lm8uu holder
			translate([holder_offset_x, holder_offset_y,0])
			cylinder(r=pdiam(bearingLM8UU_D)/2 + thickness/2, h=bearingLM8UU_height);
		}

		// material cutout
		translate([0,0,-mo])
		linear_extrude(height=thickness+2*mo, convexity=1)
		polygon([[nema_size+mo, nema_size+mo], [nema_size+mo, pillar_width], [pillar_width,nema_size + mo]], center=false);

		// lm8uu holder
		translate([holder_offset_x, holder_offset_y,holder_LM8UU_D])
		cylinder(r=pdiam(bearingLM8UU_D)/2, h=bearingLM8UU_height+thickness+2*mo);
		translate([holder_offset_x, holder_offset_y,-mo])
		cylinder(r=pdiam(m8_D)/2, h=holder_LM8UU_D+2*mo);

		// axle cutout
		translate([nema_size/2, nema_size/2, -mo])
		cylinder(r=nema_axle_cutout_D / 2, h=thickness+ depth + 2 * mo);

		// idler rotation tolerance
		translate([nema_size - hole_distance * 2 - idler_rotation_tolerance, hole_distance, thickness])
		cube([2 * hole_distance, hole_distance * 2, depth+mo]);

		translate([nema_size - hole_distance, hole_distance, thickness])
		cylinder(r=hole_distance + idler_rotation_tolerance, h=depth + mo);

		// filament path
		translate([nema_size/2+extruder_gear_D/2, -mo, thickness + depth / 2])
		rotate([-90, 0, 0])
		cylinder(r=filament_D / 2, h=100);

		// pneufit hole
		translate([nema_size/2+extruder_gear_D/2, -pneufit_depth - mo, thickness + depth / 2])
		rotate([-90, 0, 0])
		cylinder(r=pdiam(pneufit_D)/ 2, h=pneufit_depth);

		// motor holes
		for (h = holes) 
		{
			translate(h)
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);
		}
	}		

	if(show_axles > 0)
	{
		translate([nema_size/2,nema_size/2,0])
		color("Grey")cylinder(r=shaft_D/2,h=nema_axle_length);

		translate([nema_size/2,nema_size/2,6])
		color("Grey")cylinder(r=extruder_gear_D/2,h=extruder_gear_length);
	}	
}