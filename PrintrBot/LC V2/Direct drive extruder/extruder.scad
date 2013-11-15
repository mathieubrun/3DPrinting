include <extruder_configuration.scad>
use <extruder_main.scad>
use <extruder_top.scad>
use <extruder_idler.scad>
use <extruder_holder.scad>

assemble= 1;
show_axles=1;

if(assemble > 0)
{
	main();

	translate([0, 0, depth+thickness+1])
	top();

	translate([nema_size, 0,thickness+depth])
	rotate([0, 180, 0])
	idler();

	translate([0, nema_size+1,thickness+0.5])
	holder();
}

if(assemble == 0)
{
	main();

	translate([nema_size + 5, nema_size+nema_size/2, thickness])
	rotate([0,180,90])
	top();

	translate([-depth-3, 0, hole_distance*2])
	rotate([0, 90, 0])
	translate([hole_distance, hole_distance, 0])
	rotate([0, 0, idler_angle])
	translate([-hole_distance, -hole_distance+ 5, 0])
	idler();

	translate([nema_size + 10, - nema_size/2 + 15,0])
	rotate([0,0,180])
	holder();
}
