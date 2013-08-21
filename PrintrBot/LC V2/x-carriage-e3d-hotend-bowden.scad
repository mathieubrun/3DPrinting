//**************************************************
// Quick-Fit carriage for Printrbot
//
// Copyright (c) 2012, Andrew Dalgleish <andrew+github@ajd.net.au>
// Copyright (c) 2013, Mathieu Brun 
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
// 
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
// 
//
// This is modelled as fitted, with the top-front edge of the Carriage() module on the X-axis.
//
// Each of the OpenSCAD axes is parallel with the Printrbot axes with the same name, 
// except the sign is the opposite for X and Y.
//
// OpenSCAD X +ve is towards the left of the Printrbot.
// OpenSCAD Y +ve is towards the front of the Printrbot.
// OpenSCAD Z +ve is towards the top of the Printrbot.

// printable - set to 1 from the command-line
printable	= 0;

// mo = manifold overlap
// this is a small overlap used to force the model to be manifold
mo	= 0.01;

// constant used to calculate radius for hex holes
da6		= 1/cos(180/6)/2;

// size of horizontal plate
base_plate	= [60, 40, 3];

// carriage parameters
carriage_hole_spacing	= 15;
carriage_holes_top = [-carriage_hole_spacing, 0];
carriage_holes_bottom = [-carriage_hole_spacing, 0];
carriage_holes_z	= [-25.600, -44];
carriage_hole_d		= 4.2;
carriage_nut_d		= 7.95;
carriage_nut_h1		= 3;
pneufit_d		= 10;
mounting_plate_hole_spacing = 17;

// locating lug, dimensions from PB files
groove_zo	= 30;
groove_z	= 7.8;
groove_y1	= 1.5;		// groove is deeper than the lug
groove_y2	= 1;

// bracket parameters
extruder_offset	= [0, 25, 0];

// integrated fan parameters
fan_width = 40;
fan_holder = [fan_width + 15, 20, fan_width + 15];
inner_hole = [35,15,20];
bolt_distance = 5;
bolt_depth = 5;
top_angle = -55;
bottom_angle = -45;
beak_angle = [-50,0,0];

module	LocatingGroove(X, Y) {
	Z	= groove_z;
	ZO	= groove_zo;

	translate([-X/2 -mo, -Y, -Z -ZO])
		rotate([0, 90, 0])
		linear_extrude(height=X +mo*2, convexity=2)
		polygon([[0, 0], [0, Y +mo], [-Z, Y+mo], [-Z +Y, 0]]);
}

module Carriage() {

	block_size		= [60, 25, 32];	// ajd - make wider to seperate the groove from the bearing

	rod_offset	= 15.5;
	rod_spacing	= 39; // or 38 ?

	gap1_y		= 2;

	// LM8UU 8x15x24
	// You may need to adjust bearing_od
	// Initial print 15.2 (0.4mm layer, 0.5mm nozzle) measured 14.2
	bearing_clr	= 10.2;
	bearing_id	= 8;
	bearing_od	= 15.2;
	bearing_w	= 24;
	bearing_od	= 15.7;

	belt_distance_from_rod = 40;
	x_stop_distance_from_rod = 30;

	x_stop		= [10, 28, 10];
	x_stop_offset	= [-block_size[0]/2, -x_stop[1] -block_size[1] +mo + 10, -rod_offset +1 - rod_spacing -x_stop[2]];

	flange		= [block_size[0] - 10, 40, 5];
	flange_offset	= [-block_size[0]/2, -flange[1] -block_size[1] +mo, -rod_offset +1 -flange[2]];	// from PB files, top of flange is 1mm above rod center

	// FIXME - check bottom of flange!
	belt		= [8, 8, flange[2] +mo*2];

	belt_offset1	= [-block_size[0]/2 +flange[0] -belt[0] -10, -block_size[1]/2 - belt_distance_from_rod -belt[1]/2, flange_offset[2] -mo];
	belt_offset2	= [-block_size[0]/2 + 10, -block_size[1]/2 - belt_distance_from_rod -belt[1]/2, flange_offset[2] -mo];

	gusset1_x	= 5;
	gusset1_yz	= 12;

	gusset2_x	= flange[0];
	gusset2_yz	= 5;

	gusset3_x	= 5;
	gusset3_yz	= 15;

	gusset4_x	= flange[0];
	gusset4_yz	= 2;

	gusset5_z	= flange[2];
	gusset5_xy	= block_size[0] - flange[0];

	rotate(printable ? [0, -90, 0] : [0, 0, 0])
	translate(printable ? [block_size[0]/2, block_size[1]/2, block_size[2]/2] : [0, 0, 0])
	difference() {
		union() {
			// main body, top rod
			translate([-block_size[0]/2, -block_size[1], -block_size[2]])
				cube(block_size);

			// main body, bottom rod
			hull() {
				translate([-block_size[0]/2, -block_size[1], -block_size[2]])
					cube([block_size[0]/2+bearing_w/2, block_size[1], mo]);
				translate([-block_size[0]/2, -block_size[1]/2, -block_size[2]/2 -rod_spacing])
					rotate([0, 90, 0]) cylinder(r=block_size[1]/2, h=block_size[0]/2 +bearing_w/2);
			}

			// x endstop
			translate(x_stop_offset) cube(x_stop);
			translate([-block_size[0]/2 -mo, -block_size[1]/2 - x_stop_distance_from_rod, -rod_offset-rod_spacing - bearing_id/2])
				rotate([0, 90, 0]) cylinder(r=x_stop[2]/2,h=x_stop[0] + +mo*2);

			// belt flange
			translate(flange_offset) cube(flange);

			// top right gusset
			translate([-block_size[0]/2, -block_size[1] -gusset1_yz, flange_offset[2] +flange[2] -mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset1_x, convexity=1)
					polygon([[0, 0], [0, gusset1_yz+mo], [-gusset1_yz -mo, gusset1_yz +mo]]);

			// top wide gusset
			translate([-block_size[0]/2, -block_size[1] -gusset2_yz, flange_offset[2] +flange[2] -mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset2_x, convexity=1)
					polygon([[0, 0], [0, gusset2_yz +mo], [-gusset2_yz -mo, gusset2_yz -mo]]);

			// bottom right gusset
			translate([-block_size[0]/2, -block_size[1] -gusset3_yz, flange_offset[2] +mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset3_x, convexity=1)
					polygon([[0, 0], [0, gusset3_yz+mo], [gusset3_yz +mo, gusset3_yz +mo]]);

			// bottom wide gusset
			translate([-block_size[0]/2, -block_size[1] -gusset4_yz, flange_offset[2] +mo])
			rotate([0, 90, 0]) linear_extrude(height=gusset4_x, convexity=1)
					polygon([[0, 0], [0, gusset4_yz+mo], [gusset4_yz +mo, gusset4_yz +mo]]);

			// flange edge gusset
			translate([block_size[0]/2 - gusset5_xy -mo, -block_size[1] -gusset5_xy, flange_offset[2]])
			linear_extrude(height=gusset5_z, convexity=1)
					polygon([[0, 0], [gusset5_xy +mo, gusset5_xy +mo], [0, gusset5_xy +mo]]);

		}

		// show top rod for assembly
		#translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset])
			rotate([0, 90, 0]) cylinder(r=bearing_id/2, h=block_size[0] +mo*2);
		#translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset -rod_spacing])
			rotate([0, 90, 0]) cylinder(r=bearing_id/2, h=block_size[0] +mo*2);

		// clamp gap
		translate([-block_size[0]/2 -mo, -block_size[1]/2 -gap1_y/2, -rod_offset -rod_spacing])
			cube([block_size[0] +mo*2, gap1_y, rod_spacing]);

		// top rod bearings
		translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset])
			rotate([0, 90, 0]) cylinder(r=bearing_od/2, h=block_size[0] +mo*2);

		// bottom rod clearance
		translate([-block_size[0]/2 -mo, -block_size[1]/2, -rod_offset -rod_spacing])
			rotate([0, 90, 0]) cylinder(r=bearing_clr/2, h=block_size[0] +mo*2);

		// bottom rod bearing
		translate([-bearing_w/2, -block_size[1]/2, -rod_offset -rod_spacing])
			rotate([0, 90, 0]) cylinder(r=bearing_od/2, h=bearing_w +mo);

		// x end stop screw hole
		translate([-block_size[0]/2 - 2* mo, -block_size[1]/2 - x_stop_distance_from_rod, -rod_offset-rod_spacing - bearing_id/2])
			rotate([0, 90, 0]) cylinder(r=2,h=x_stop[0] + mo*4);

		// bolt holes, top row
		#for (hx = carriage_holes_top) translate([hx, -block_size[1] -mo, carriage_holes_z[0]]) rotate([-90, 0, 0]) {
			cylinder(r=carriage_hole_d *da6, h=block_size[1]+mo*2, $fn=6);
		}

		// bolt holes, bottom row
		#for (hx = carriage_holes_bottom) translate([hx, -block_size[1] -mo, carriage_holes_z[1]]) rotate([-90, 0, 0]) {
			cylinder(r=carriage_hole_d *da6, h=block_size[1]+mo*2, $fn=6);
		}

		// belt hole
		translate(belt_offset1) cube(belt);
		translate(belt_offset2) cube(belt);

		// locating groove
		LocatingGroove(X=block_size[0], Y=groove_y1);
	}
}

module Bracket() {
	base		= base_plate;

	// main vertical plate clamped against carriage
	// outer edge is flat
	plate1		= [60, 5, 55];
	
	rotate(printable ? [0, 180, 0] : [0, 0, 0])

	difference() {
		union() {
			// horizontal plate
			translate([-base[0]/2, 0, -base[2]]) cube(base);

translate([0,extruder_offset[1],-base[2]-2-mo])
				cylinder(r=pneufit_d/2 +5, h = base[2] + 2*mo);

			// vertical plate
			translate([-plate1[0]/2, 0, -plate1[2]])
				cube(plate1);

			// add locating lug
			LocatingGroove(X=plate1[0], Y=groove_y2);

			// flange
			translate([plate1[0]/2-5,plate1[1],-base[2]])
				rotate([0, 90, 0]) 
					linear_extrude(height=5, convexity=1)
						polygon([[0, 0], [0,,base[1]-plate1[1] +mo], [plate1[2]-base[2]+mo, 0]]);

			translate([-plate1[0]/2,plate1[1],-base[2]])
				rotate([0, 90, 0]) 
					linear_extrude(height=5, convexity=1)
						polygon([[0, 0], [0,base[1]-plate1[1] +mo], [plate1[2]-base[2]+mo, 0]]);

		}

		translate([0,extruder_offset[1],-base[2]-mo])
			cylinder(r=pneufit_d/2, h = base[2] + 2*mo);

		translate([15,-5,-57])
			cube([30,60,40]);

		// bracket-carriage mounting holes
		for (X = carriage_holes_top) {
			// mounting holes
			#translate([X, -mo, carriage_holes_z[0]]) rotate([-90, 0, 0])
				cylinder(r=carriage_hole_d *da6, h=plate1[1] +mo*2, $fn=6);
			#translate([X, -mo+3, carriage_holes_z[0]]) rotate([-90, 0, 0])
				cylinder(r=carriage_nut_d/2, h=carriage_nut_h1, $fn=6);
		}

		// bracket-carriage mounting holes
		for (X = carriage_holes_bottom) {
			// mounting holes
			#translate([X, -mo, carriage_holes_z[1]]) rotate([-90, 0, 0])
				cylinder(r=carriage_hole_d *da6, h=plate1[1] +mo*2, $fn=6);
			#translate([X, -mo+3, carriage_holes_z[1]]) rotate([-90, 0, 0])
				cylinder(r=carriage_nut_d/2, h=carriage_nut_h1, $fn=6);
		}

		// hotend mount holes
		#translate([mounting_plate_hole_spacing, extruder_offset[1], -base[2] - 1])
			cylinder(r=carriage_hole_d * da6, h=base[2] + 2, $fn=6);
		#translate([-mounting_plate_hole_spacing, extruder_offset[1], -base[2] - 1])
			cylinder(r=carriage_hole_d * da6, h=base[2] + 2, $fn=6);
	}
}

module HotEndMount() {
	base		= base_plate;

	translate(printable ? [60, 0, -5] : [0, 0, -2])
	rotate(printable ? [0, 180, 0] : [0, 0, 0])
	difference() {
		// plate		
		translate([-base[0]/2 + 6, 6, -base[2]-13]) cube([base_plate[0]-12,base_plate[1]-7,11]);			

		// extruder hole
		translate([0, extruder_offset[1], -base[2]-10+5.5+mo])
			cylinder(r=8,h=4+2*mo);
		translate([-8, extruder_offset[1], -base[2]-10+5.5+mo])
			cube([16,20,4+2*mo]);
		
		translate([0, extruder_offset[1], -base[2]-10+0.5-mo])
			cylinder(r=6,h=5.5+3*mo);
		translate([-6, extruder_offset[1], -base[2]-10+0.5-mo])
			cube([12,20,5.5+3*mo]);

		translate([0, extruder_offset[1], -base[2]-10-4+mo])
			cylinder(r=8,h=4+2*mo);
		translate([-8, extruder_offset[1], -base[2]-10-4+mo])
			cube([16,20,4+2*mo]);

		// hotend mount holes
		#translate([mounting_plate_hole_spacing, extruder_offset[1], - base[2] - 7-3.5])
			cylinder(r=carriage_hole_d * da6, h=10 + mo*2, $fn=6);
		#translate([mounting_plate_hole_spacing, extruder_offset[1], - base[2] - 10-4 - mo])
			cylinder(r=carriage_nut_d/2, h=carriage_nut_h1, $fn=6);

		#translate([-mounting_plate_hole_spacing, extruder_offset[1], -base[2] - 7 - 3.5])
			cylinder(r=carriage_hole_d * da6, h=10 + mo*2, $fn=6);
		#translate([-mounting_plate_hole_spacing, extruder_offset[1], - base[2] - 10-4 - mo])
			cylinder(r=carriage_nut_d/2, h=carriage_nut_h1, $fn=6);
	}
}


module IntegratedFan()
{	
	beak_difference = [40,10];

	translate(printable ? [-5, 0, -5] : [0, 0, 0])
	rotate(printable ? [0, 180, 0] : [0, 0, 0])

	union()
	{
		translate([(55-fan_holder[0])/2,0,0])
		difference()
		{
			union()
			{
				// main body
				cube(fan_holder);

				// beak
				hull()
				{
					translate([beak_difference[0]/2,beak_difference[1]/2+15,fan_holder[2]-mo+20])
					rotate(beak_angle)
						cube([fan_holder[0]-beak_difference[0],fan_holder[1]-beak_difference[1],mo]);
		
					translate([0,0,fan_holder[2]-mo])
						cube([fan_holder[0],fan_holder[1],mo]);
				}
			}

			// beak
			hull()
			{
				translate([(beak_difference[0]+4)/2,22,fan_holder[2]-mo+20])
				rotate(beak_angle)
					cube([fan_holder[0]-beak_difference[0]-4,fan_holder[1]-13,mo]);
		
				translate([fan_holder[0]/2 - inner_hole[0]/2,fan_holder[1]/2 - inner_hole[1]/2,fan_holder[2]-mo])
					cube([inner_hole[0],inner_hole[1],mo]);
			}

			// fan hole
			translate([fan_holder[0]/2,0-mo,fan_holder[2]/2])
				rotate([-90,0,0])
					cylinder(r= fan_width/2, h=inner_hole[1] + (fan_holder[1]-inner_hole[1])/2);

			// flow exit hole
			translate([fan_holder[0]/2 - inner_hole[0]/2,fan_holder[1]/2 - inner_hole[1]/2,fan_holder[2]-inner_hole[2]+mo])
					cube(inner_hole);

			// fan mounting holes
			for (X = [[bolt_distance,bolt_depth,bolt_distance],[fan_holder[0] - bolt_distance,bolt_depth,bolt_distance],[fan_holder[0] - bolt_distance, bolt_depth,fan_holder[2] - bolt_distance],[bolt_distance,bolt_depth,fan_holder[2] - bolt_distance]]) {
				#translate(X)
					rotate([90,0,0])
						cylinder(r=carriage_hole_d * da6, h=bolt_depth + mo*2, $fn=6);
			}
		}
		difference()
		{
			// mounting plate
			translate([0,0,-5+mo])
				cube([55,50,5]);
			
			// mounting holes
			#translate([mounting_plate_hole_spacing + 55/2, 40, -5])
				cylinder(r=carriage_hole_d * da6, h=5+2*mo, $fn=6);
			#translate([-mounting_plate_hole_spacing + 55/2, 40, -5])
				cylinder(r=carriage_hole_d * da6, h=5+2*mo, $fn=6);

			// hole for pneufit
			translate([(55-55/3)/2,fan_holder[1]+mo,-5])
				cube([55/3,50-fan_holder[1],5+2*mo]);
		}
	}
}

module HotEnd(forDifference=0)
{
	hotend_height = 70;
	union() {
		difference() {
			cylinder(r= 8, h=hotend_height);
			translate([0,0,hotend_height-10])
				cylinder(r= 9, h=5.5);
		}
		cylinder(r= 6, h=hotend_height);
	
		translate([0,0,hotend_height - 18 - 32])
			cylinder(r= 12.5, h=32);			

		rotate([0,0,-90])
			translate([-16,-10,20])
				cube([31,35,31]);
	}
}

module	show_assembly(exploded=0) {
	gap	= 20;

	translate(exploded ? [0, -gap, 0] : [0, 0, 0])
		Carriage();

	Bracket();

	HotEndMount();

	translate([extruder_offset[0],extruder_offset[1], -70- base_plate[2]-2])
		#HotEnd();

	
	translate([-27.5,65,0])
		rotate([180,0,0])
			IntegratedFan();
}

show_assembly(exploded=1);

//IntegratedFan();
//FanHolder();
//Bracket();
//HotEndMount();
//Carriage();

