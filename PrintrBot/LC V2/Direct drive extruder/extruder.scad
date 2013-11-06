//pdiam based on Nophead's : http://hydraraptor.blogspot.com/2011/02/polyholes.html 

debug = 1;

function pdiam(diam, tolerance=0.2)=debug?diam:(diam) / cos (180 / max(round(2 * diam),3))+tolerance;

thickness = 3;
depth = 20;
extruder_gear_D = 11;
extruder_gear_length = 11;
filament_D = 1.75;

m3_D=3;
m8_D=8;

filament_path_width = 10;

nema_size = 42;
nema_holes_distance = 31;
nema_axle_length = 24;
nema_axle_cutout_D = 20;

shaft_D = 5;

bearing625_D = 16.25;
bearing625_height=5;

bearing608_clr	= 10.2;
bearing608_D	= 15.25;
bearing608_width	= 8;

pneufit_D = 9.8;
pneufit_depth = 7;

mo = 0.1;
da6 = 1/cos(180/6)/2;

hole_distance = (nema_size - nema_holes_distance) / 2; 
holes = 
[
	[hole_distance, hole_distance, -mo],
	[nema_size - hole_distance, hole_distance, -mo],
	[hole_distance, nema_size - hole_distance, -mo],
	[nema_size - hole_distance, nema_size - hole_distance, -mo],
];

pillar_width = hole_distance*2;
pillar_offset = hole_distance - pillar_width / 2;
pillars = 
[
	[pillar_offset,pillar_offset,thickness-mo],
//	[nema_size - pillar_offset - pillar_width,pillar_offset,thickness-mo],
	[pillar_offset,nema_size - pillar_offset - pillar_width,thickness-mo],
//	[nema_size - pillar_offset - pillar_width,nema_size - pillar_offset - pillar_width,thickness-mo],
];
show_axles=1;
assemble= 1;

if(assemble > 0)
{
	main();

	translate([0, 0, depth+thickness])
	top();

	translate([nema_size-hole_distance*2, 0,thickness])
	translate([hole_distance, hole_distance, 0])
	rotate([0, 0, 8])
	translate([-hole_distance, -hole_distance, 0])

	idler();

	translate([0, nema_size + 10,0])
	holder();
}

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
			cube([filament_path_width, nema_size/2-extruder_gear_D/2, depth]);
	
			for (p = pillars) 
			{
				translate(p)
				cube([pillar_width, pillar_width, depth]);		
			}
		}

		// axle cutout
		translate([nema_size/2, nema_size/2, -mo])
		cylinder(r=nema_axle_cutout_D / 2, h=thickness+ depth + mo);

		// filament path
		translate([nema_size/2+extruder_gear_D/2, -mo, thickness + depth / 2])
		rotate([-90, 0, 0])
		cylinder(r=filament_D / 2, h=100);

		// pneufit hole
		translate([nema_size/2+extruder_gear_D/2, -mo, thickness + depth / 2])
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

module top()
{
	difference()
	{
		// main body
		union()
		{
			translate([0,0, 0])
			cube([nema_size, nema_size, thickness]);
		}

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

module idler()
{
	d = nema_size / 2 - hole_distance;
	dd = extruder_gear_D + bearing608_D - d;
	h = sqrt(pow(dd,2)+pow(d,2));

	difference()
	{
		union()
		{
			translate([hole_distance, hole_distance, 0])
			rotate([0, 0, -13])
			translate([-hole_distance, -hole_distance, 0])
			cube([hole_distance*2, nema_size + 10, depth]);
		}

		translate([hole_distance, h+hole_distance/2, thickness/2])
		#cylinder(r=pdiam(m8_D) / 2, h=depth-thickness+10);

		translate([hole_distance, h+hole_distance/2, depth/2-bearing608_clr/2])
		cylinder(r=pdiam(bearing608_D) / 2, h=bearing608_clr);

		translate(holes[0])
		cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);
	}		

	if(show_axles > 0)
	{
		translate([hole_distance, h+hole_distance/2, depth/2-bearing608_width/2])
		color("Grey")cylinder(r=pdiam(bearing608_D) / 2, h=bearing608_width);		
	}	
}

module holder()
{
	difference()
	{
		union()
		{
			cube([10, 10, depth + 2* thickness]);
		}
	}		
}

module noop()
{
}