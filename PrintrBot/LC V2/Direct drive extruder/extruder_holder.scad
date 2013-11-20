include<extruder_configuration.scad>

holder();

module holder()
{
	difference()
	{
		union()
		{
			cube([nema_size/2 + extruder_gear_D / 2 + thickness, m3_D + 4, idler_depth]);
			translate([-m3_D - 4,-15+ m3_D + 4,0])
			cube([m3_D + 4, 15, idler_depth]);
		}
		
		translate([nema_size/2 + extruder_gear_D / 2,10,idler_depth/2])
		rotate([90,0,0])
		cylinder(r=pdiam(filament_D)/2, h = 20);

		for (h = holder_holes) 
		{
			translate([-m4_D - 4-mo,(m4_D + 3)/2,idler_depth/2 - h])
			rotate([0,90,0])
			#cylinder(r=pdiam(m4_D)/2, h=nema_size/2 + extruder_gear_D / 2 + thickness+ m4_D + 4 + mo*2);
		}	
	}		
}