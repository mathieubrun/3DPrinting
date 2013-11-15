//pdiam based on Nophead's : http://hydraraptor.blogspot.com/2011/02/polyholes.html 
debug=0;

assemble= 0;
show_axles=0;

function pdiam(diam, tolerance=0.1)=debug?diam:(diam) / cos (180 / max(round(2 * diam),3))+tolerance;

//function pdiam(diam)=diam;

extruder_gear_D = 9;//12.6;
extruder_gear_length = 11;
filament_D = 1.75;

m3_D=3;
m8_D=8;

nema_size = 42;
nema_holes_distance = 31;
nema_axle_length = 24;
nema_axle_cutout_D = 24;

shaft_D = 5;

bearing625_D = 16.25;
bearing625_height=5;

bearing608_D	= 22;
bearing608_D_clr	= 24;
bearing608_width	= 7;
bearing608_clr	= bearing608_width+1;
bearing608_m8	= 14;

bearingLM8UU_height	= 23.75;
bearingLM8UU_D	= 15;
holder_LM8UU_D = 1;

thickness = 4;
depth = 16;
idler_depth = depth - 1;

echo( "Required M3 len : ");
echo( 2*thickness + depth + 4);

holder_offset_x = bearingLM8UU_D / 2 + thickness / 2;
holder_offset_y = -bearingLM8UU_D/2+ thickness / 2;

pneufit_D = 9.8;
pneufit_depth = 7;
filament_path_width = pneufit_D + 4;
filament_path_height = nema_size/4 + 2;
mo = 0.01;
da6 = 1/cos(180/6)/2;

idler_angle = 0;
idler_rotation_tolerance = 1;

hole_distance = (nema_size - nema_holes_distance) / 2; 
holes = 
[
	[hole_distance, hole_distance, -mo],
	[nema_size - hole_distance, hole_distance, -mo],
	[hole_distance, nema_size - hole_distance, -mo],
	//[nema_size - hole_distance, nema_size - hole_distance, -mo],
];

pillar_width = hole_distance*2;
pillar_offset = hole_distance - pillar_width / 2;
pillars = 
[
	[pillar_offset,pillar_offset,thickness-mo],
	[pillar_offset,nema_size - pillar_offset - pillar_width,thickness-mo],
];

holder_holes_distance = depth / 2 - m3_D - 1;
holder_holes = [-holder_holes_distance,holder_holes_distance];