use <MCAD/units.scad>;

module plate_with_holes(width,
                        depth,
                        thickness,
                        holes) {
    difference() {
        cube([width, depth, thickness]);
        for(p = holes) {
            translate([p.x, p.y, 0])
                cylinder(d=p.z, h=thickness);
        };
    };
};

// example
holes = [ [20,20,1],
          [40,20,2],
          [120,20,3],
          [140,20,4],
          [20,160,5],
          [40,160,6] ];
plate_with_holes(300, 400, 10, holes);