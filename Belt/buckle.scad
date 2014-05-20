include<belt_configuration.scad>

module buckle()
{
	difference()
	{
		cube([buckle_length, 2*belt_thickness+2*buckle_thickness, belt_height+2*buckle_thickness]);
		translate([-mo, buckle_thickness-tolerance, buckle_thickness-tolerance/2])
		cube([buckle_length+2*mo, 2*belt_thickness+2*tolerance, belt_height+tolerance]);
	}
}

rotate([0,-90,0])
buckle();