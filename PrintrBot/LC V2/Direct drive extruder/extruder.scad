//pdiam based on Nophead's : http://hydraraptor.blogspot.com/2011/02/polyholes.html 

debug = 0;
show_axles=0;
assemble= 1;

function pdiam(diam, tolerance=0.2)=debug?diam:(diam) / cos (180 / max(round(2 * diam),3))+tolerance;

extruder_gear_D = 11;
extruder_gear_length = 11;
filament_D = 1.75;

m3_D=3;
m8_D=8;

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

bearingLM8UU_height	= 20;
bearingLM8UU_D	= 15.25;

thickness = 3;
depth = bearingLM8UU_height - thickness;

holder_offset_x = bearingLM8UU_D / 2 + thickness / 2;
holder_offset_y = -bearingLM8UU_D/2+ thickness / 2;

pneufit_D = 9.8;
pneufit_depth = 7;
filament_path_width = pneufit_D + 2;
filament_path_height = nema_size/4 + 2;
mo = 0.01;
da6 = 1/cos(180/6)/2;

idler_angle = 13;
idler_rotation_tolerance = 1;

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
	[pillar_offset,nema_size - pillar_offset - pillar_width,thickness-mo],
];


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

if(assemble == 0)
{
	main();

	translate([-5, 0, thickness])
	rotate([0,180,0])
	top();

	translate([nema_size + 5, 0, hole_distance*2])
	rotate([0, 90, 0])
	translate([hole_distance, hole_distance, 0])
	rotate([0, 0, idler_angle])
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

		// lm8uu holder
		translate([holder_offset_x, holder_offset_y,-mo])
		cylinder(r=pdiam(bearingLM8UU_D)/2, h=bearingLM8UU_height+thickness+2*mo);

		// axle cutout
		translate([nema_size/2, nema_size/2, -mo])
		cylinder(r=nema_axle_cutout_D / 2, h=thickness+ depth + 2 * mo);

		// idler rotation tolerance
		translate([nema_size - hole_distance * 2 - idler_rotation_tolerance, hole_distance, thickness])
		cube([2 * hole_distance, hole_distance * 2, depth+mo]);

		translate([nema_size - hole_distance, hole_distance, thickness])
		cylinder(r=hole_distance + idler_rotation_tolerance, h=depth + mo);

		// filament path
		translate([nema_size/2+extruder_gear_D/2, filament_path_height - 2+mo, thickness + depth / 2])
		rotate([-90, 0, 0])
		cylinder(r1=filament_D / 2, r2= filament_D, h=2);

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
		cylinder(r=pdiam(m8_D,1)/2 + thickness/2, h=thickness+2*mo);

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
			rotate([0, 0, -idler_angle])
			translate([-hole_distance, -hole_distance, 0])
			{
				translate([0, hole_distance, 0])
				cube([hole_distance*2, nema_size + 5, depth]);

				translate([-hole_distance*2-mo-4, nema_size-5, 0])
				rotate([0,0,5])
				cube([hole_distance*2+5, 5, depth]);
				
				translate([hole_distance, 0, 0])
				cube([hole_distance, hole_distance, depth]);

				translate([hole_distance, hole_distance, 0])
				cylinder(r=hole_distance, h=depth);
			}
		}

		
		translate([hole_distance, hole_distance, 0])
		rotate([0, 0, -idler_angle])
		translate([-hole_distance, -hole_distance, 0])
		{
			translate(holes[0])
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);

			translate([-8,nema_size+2,depth/2])
			rotate([90,0,idler_angle/2])
			cylinder(r=pdiam(filament_D)/2, h=depth + thickness+mo*2);

			translate([-mo,nema_size+hole_distance,depth - 4])
			rotate([0,90,0])
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);

			translate([-mo,nema_size+hole_distance-2,depth - 4])
			rotate([0,90,0])
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);
		
			translate([-mo,nema_size+hole_distance,depth - 13])
			rotate([0,90,0])
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);

			translate([-mo,nema_size+hole_distance-2,depth - 13])
			rotate([0,90,0])
			cylinder(r=pdiam(m3_D)/2, h=depth + thickness+mo*2);
		} 
		
		translate([hole_distance, h+hole_distance/2, thickness/2])
		cylinder(r=pdiam(m8_D) / 2, h=depth-thickness);

		translate([hole_distance, h+hole_distance/2, depth/2-bearing608_clr/2])
		cylinder(r=pdiam(bearing608_D) / 2, h=bearing608_clr);
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