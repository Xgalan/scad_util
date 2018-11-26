module try_square(base_thickness,
                  base_height,
                  wing_thickness,
                  wing_height,
                  width,
                  length) {
    union() {
        translate([0,0,0]) 
            cube([base_height, width,
                  base_thickness]);
        translate([0, 0,
                   (base_thickness - wing_thickness)/2]) 
            cube([length, wing_height,
                  wing_thickness]);
    }
};
    
try_square(10.2, 14.1, 2, 16, 50, 75);