use <MCAD/units.scad>;

$fn=30;

module tray(width, length, height, radius) {
    points = [ [abs(0+radius),abs(0+radius),0],
               [abs(width-radius),(0+radius),0],
               [abs(width-radius),abs(length-radius),0],
               [abs(0+radius),abs(length-radius),0] 
             ];
    hull() {
        hull() {
            for (p = points) {
                translate(p) sphere(r = abs(radius));
                translate(p) cylinder(r = abs(radius),
                                      h = abs(height - radius));
            };
        };
        translate([radius/2, radius/2, -radius])
            #cube([width-radius, length-radius, radius/2]);
    };
};

//example
TRAY_W = 77;
TRAY_L = 52;
TRAY_H = 40;
TRAY_BOTTOM = 4;
TRAY_WALLS = 0.94;
TRAY_RADIUS = 4;

difference() {
    tray(TRAY_W, TRAY_L, TRAY_H, TRAY_RADIUS);
    translate([(TRAY_W-(TRAY_W*TRAY_WALLS))/2, (TRAY_L-(TRAY_L*TRAY_WALLS))/2, TRAY_BOTTOM])
        tray(TRAY_W*TRAY_WALLS, TRAY_L*TRAY_WALLS, TRAY_H, TRAY_RADIUS*TRAY_WALLS);
};