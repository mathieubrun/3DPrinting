//**************************************************
// Quick-Fit carriage for Printrbot
//
// Copyright (c) 2012, Andrew Dalgleish <andrew+github@ajd.net.au>
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
// This is modelled as fitted, with the top-front edge of the QFcarriage() module on the X-axis.
//
// Each of the OpenSCAD axes is parallel with the Printrbot axes with the same name, 
// except the sign is the opposite for X and Y.
//
// OpenSCAD X +ve is towards the left of the Printrbot.
// OpenSCAD Y +ve is towards the front of the Printrbot.
// OpenSCAD Z +ve is towards the top of the Printrbot.

// mo = manifold overlap
// this is a small overlap used to force the model to be manifold
mo	= 0.01;

// constant used to calculate radius for hex holes
da6		= 1/cos(180/6)/2;

//**************************************************
// These dimensions are common

// 3 holes on 15mm spacing - the center hole is compatible with the PB carriage/bracket
carriage_hole_spacing	= 15;
carriage_holes_x	= [-carriage_hole_spacing, 0, carriage_hole_spacing];
carriage_holes_z	= [-5.600, -25.457];	// from PB files
carriage_hole_d		= 4.5;
carriage_nut_d		= 8;
carriage_nut_h1		= 2;			// nut depth
carriage_nut_h2		= 4;			// nut trap in bracket base

// locating lug, dimensions from PB files
groove_zo	= 8.7;
groove_z	= 7.8;
groove_y1	= 1.5;		// groove is deeper than the lug
groove_y2	= 1;


//**************************************************
//	QFlocatingGroove
//
//	Draw the locating groove/lug in place
module	QFlocatingGroove(X, Y) {

	Z	= groove_z;
	ZO	= groove_zo;

	translate([-X/2 -mo, -Y, -Z -ZO])
		rotate([0, 90, 0])
		linear_extrude(height=X +mo*2, convexity=2)
		polygon([[0, 0], [0, Y +mo], [-Z, Y+mo], [-Z +Y, 0]]);
}

//**************************************************
// QFcarriage
//
// X-Carriage for Printrbot LC V2
//
// This is modelled as fitted, with the top-front edge on the X-axis.
//
module QFcarriage() {

	block_size		= [60, 25, 32];	// ajd - make wider to seperate the groove from the bearing

	rod_offset	= 15.5;
	rod_spacing	= 39;
	// The PB carriage file says 25.2, but the X ends are 25.4

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
	// from PB files, center of belt hole is 31.309mm from rod center
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

		// bolt holes
		#for (hx = carriage_holes_x) for (hz = carriage_holes_z) translate([hx, -block_size[1] -mo, hz]) rotate([-90, 0, 0]) {
			cylinder(r=carriage_hole_d *da6, h=block_size[1]+mo*2, $fn=6);
			cylinder(r=carriage_nut_d *da6, h=carriage_nut_h1 +mo, $fn=6);
		}

		// belt hole
		translate(belt_offset1) cube(belt);
		translate(belt_offset2) cube(belt);

		// locating groove
		QFlocatingGroove(X=block_size[0], Y=groove_y1);
	}
}

rotate([0, -90, 0])
	QFcarriage();
