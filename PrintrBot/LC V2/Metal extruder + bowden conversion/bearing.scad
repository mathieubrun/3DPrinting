

608_height=8;

608_diameter=22;

difference()
{
translate([0,0,-1])
cylinder(r=608_diameter/2+1,h=3);

#cylinder(r=608_diameter/2,h=608_height);
translate([0,0,-2])
#cylinder(r=8/2,h=608_height+4);

}
