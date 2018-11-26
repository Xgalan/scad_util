use <MCAD/units.scad>;

module tray(width, depth, height, radius) {
    points = [ [abs(0+radius),abs(0+radius),0],
               [abs(width-radius),(0+radius),0],
               [abs(width-radius),abs(depth-radius),0],
               [abs(0+radius),abs(depth-radius),0] 
             ];
    hull() {
        for (p = points) {
            translate(p) sphere(r = abs(radius));
            translate(p) cylinder(r = abs(radius),
                                  h = abs(height - radius));
        };
    };
};

//example
tray(100,121,22,5);
