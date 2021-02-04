use <MCAD/units.scad>;

height = 20;

for (a =[0:10:40])
    for (b =[0:10:40])
        linear_extrude(height=height)
        translate([a, b, 0])
            circle(1, $fn=50);
