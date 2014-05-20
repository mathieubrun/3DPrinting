include<belt_configuration.scad>

module buckle()
{
	difference()
	{
		cube([buckle_length, 2*belt_thickness+2*buckle_thickness, belt_height+2*buckle_thickness]);
		translate([-mo, buckle_thickness-buckle_tolerance, buckle_thickness-buckle_tolerance/2])
		cube([buckle_length+2*mo, 2*belt_thickness+2*buckle_tolerance, belt_height+buckle_tolerance]);
	}
}

rotate([0,-90,0])
buckle();