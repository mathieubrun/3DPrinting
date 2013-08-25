use <obiscad/bevel.scad>
use <obiscad/attach.scad>

block = [31,71,6];
holder = [6, block[1], 11];

holder_spacing = 11;
rod_spacing = 39;
rod_offset = 3;
mo	= 0.01;

m8 = 8;
us_nut = 3.4;

da6 = 1/cos(180/6)/2;

nut_hole_d = us_nut * da6;
nut_offset = 11.35;
nut_spacing = 25.4;

rod_holes = [	[holder_spacing/2,rod_spacing/2],
					[holder_spacing/2,-rod_spacing/2]					
];

nut_holes = [	[block[0]/2 + nut_offset,block[1]/2],
					[block[0]/2 - nut_offset,block[1]/2],
					[block[0]/2 + nut_offset,block[1]/2 + nut_spacing],
					[block[0]/2 - nut_offset,block[1]/2 + nut_spacing],
					[block[0]/2 + nut_offset,block[1]/2 - nut_spacing],
					[block[0]/2 - nut_offset,block[1]/2 - nut_spacing]
];

//-- Top-right beveling (rounded)
ec1 = [ [0, 0, block[2]/2], [0,0,1], 0];
en1 = [ ec1[0],                    [-1,-1,0], 0];
bevel_radius = 2;
bevel_res = 10;

*connector(ec1);
*connector(en1);

difference()
{
	union()
	{
		cube(block);

		translate([block[0]/2-holder[0]/2 + holder_spacing/2,0,block[2]])
			cube(holder);

		translate([block[0]/2-holder[0]/2 - holder_spacing/2,0,block[2]])
			cube(holder);
	}

	union()
	{
		bevel(ec1, en1, cr = bevel_radius, cres=bevel_res, l=block[2]+mo);

		translate([block[0],0,0])
		rotate([0,0,90])	
		bevel(ec1, en1, cr = bevel_radius, cres=bevel_res, l=block[2]+mo);

		translate([block[0],block[1],0])
		rotate([0,0,180])	
		bevel(ec1, en1, cr = bevel_radius, cres=bevel_res, l=block[2]+mo);

		translate([0,block[1],0])
		rotate([0,0,270])	
		bevel(ec1, en1, cr = bevel_radius, cres=bevel_res, l=block[2]+mo);

		#for (hole = rod_holes)
		{	
			translate([-10,block[1]/2 + hole[1],block[2]+holder[2]-rod_offset])
			rotate([0,90,0])
				#cylinder(r=m8/2,h=50,$fn=40);

			translate([10,block[1]/2 + hole[1],block[2]+holder[2]-rod_offset])
				translate([3,0,m8/2])
				cube([60,8+mo,8+mo], center=true);
		}
		
		#for (hole = nut_holes)
		{
			translate([hole[0],hole[1],-mo])
			cylinder(r=nut_hole_d, h=30, $fn=6);
		}
	}
}