nema_size = 30;
thickness = 5;
depth = 20;

extruder_drive = 11/2;

m3 = 2;
mo = 0.01;
hole_distance =5;
holes = 
[
	[hole_distance, hole_distance, -mo],
	[nema_size - hole_distance, hole_distance, -mo],
	[hole_distance, nema_size - hole_distance, -mo],
	[nema_size - hole_distance, nema_size - hole_distance, -mo],
];

pillars = 
[
	[0,0,thickness-mo],
	[nema_size - hole_distance * 2,0,thickness-mo],
	[0,nema_size - hole_distance * 2,thickness-mo],
	[nema_size - hole_distance * 2,nema_size - hole_distance * 2,thickness-mo],
];



main();

module main()
{
	difference()
	{
		union()
		{
			cube([nema_size, nema_size, thickness]);
	
			#for (p = pillars) 
			{
				translate(p)
				cube([hole_distance * 2, hole_distance * 2, depth]);		
			}
		}

		translate([nema_size/2, nema_size/2, -mo])
		cylinder(r=extruder_drive, h=thickness+mo*2);

		#for (h = holes) 
		{
			translate(h)
			cylinder(r=m3, h=depth + thickness+mo*2, $fn=6);
		}
	}		
}