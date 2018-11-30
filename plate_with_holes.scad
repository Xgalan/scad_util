use <MCAD/units.scad>;
use <libraries/dimlines.scad>;

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

// example with dimensioning
DOC_SCALING_FACTOR = 50;
DOC_HEIGHT = 297;
DOC_WIDTH = 420;
DIM_LINE_WIDTH = .025 * DOC_SCALING_FACTOR;
DIM_SPACE = .1 * DOC_SCALING_FACTOR;

PLATE_THICKNESS = 15;
PLATE_WIDTH = 400;
PLATE_LENGTH = 300;

HOLES = [ [20,20,2],
          [40,20,3],
          [120,20,4],
          [140,20,5],
          [20,160,6],
          [40,160,7] ];

translate([-PLATE_WIDTH, -PLATE_LENGTH, 0])
plate_with_holes(PLATE_WIDTH, PLATE_LENGTH,
                 PLATE_THICKNESS, HOLES);

translate([PLATE_WIDTH/5, 0, 0])
rotate([-45, -60, -30])
plate_with_holes(PLATE_WIDTH, PLATE_LENGTH,
                 PLATE_THICKNESS, HOLES);

translate([-PLATE_WIDTH,PLATE_LENGTH/3,0])
rotate([90, 0, 0])
plate_with_holes(PLATE_WIDTH, PLATE_LENGTH,
                 PLATE_THICKNESS, HOLES);


module draw_frame(length, height, line_width=DIM_LINE_WIDTH) {
    line(length=length, width=line_width);

    translate([0, height, 0])
    line(length=length, width=line_width);

    translate([line_width / 2, line_width / 2, 0])
    rotate([0, 0, 90])
    line(length=height - line_width, width=line_width);

    translate([length - line_width / 2, line_width / 2, 0])
    rotate([0, 0, 90])
    line(length=height - line_width, width=line_width);
};

color("Black")
translate([-PLATE_WIDTH*1.1, -PLATE_LENGTH*1.1, DOC_HEIGHT])
union() {
    draw_frame(length=DOC_WIDTH*2.3,
               height=DOC_HEIGHT*2.3,
               line_width=DIM_LINE_WIDTH * 2);

    //color("Black")
    //translate([975, 153, 0])
    //sample_titleblock1();
};