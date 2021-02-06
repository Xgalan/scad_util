from typing import NamedTuple

from solid import *
from solid.utils import *  # Not required, but the utils module is useful

import_scad('MCAD/units.scad')



class Pocket(NamedTuple):
    width: float
    length: float
    x: float
    y: float
    z: float
    depth: float

    @property
    def create(self):
        return translate([self.x, self.y, self.z])(
            cube([self.width, self.length, self.depth])
        )


class Hole(NamedTuple):
    diameter: float
    x: float
    y: float
    z: float
    depth: float

    @property
    def create(self):
        return translate([self.x, self.y, self.z])(
            cylinder(d=self.diameter, h=self.depth)
        )


class Boss(NamedTuple):
    diameter1: float
    diameter2: float
    x: float
    y: float
    z: float
    height: float
    
    @property
    def create(self):
        return translate([self.x, self.y, self.z])(
            cylinder(d1=self.diameter1, d2=self.diameter2, h=self.height)
        )


def plate_with_holes(form, dimensions, holes, bosses):
    """
    Create a plate with holes
    """
    holes = [
        Hole(
            h["diameter"], h["x_pos"], h["y_pos"], h["z_pos"], h["depth"]
        ) if "diameter" in h else Pocket(
            h["width"], h["length"], h["x_pos"], h["y_pos"], h["z_pos"], h["depth"]
        ) for h in holes
    ]
    if bosses is not None:
        bosses = [
            Boss(
                b["diameter1"], b["diameter2"], b["x_pos"], b["y_pos"], dimensions["thickness"], b["height"]
            ) for b in bosses
        ]
    fillet_plate = [
        (dimensions["fillet"], dimensions["fillet"]),
        (dimensions["fillet"], dimensions["height"] - dimensions["fillet"]),
        (dimensions["width"] - dimensions["fillet"], dimensions["height"] - dimensions["fillet"]),
        (dimensions["width"] - dimensions["fillet"], dimensions["fillet"])
    ]
    plate = {
        "circle": cylinder(d=dimensions["diameter"], h=dimensions["thickness"]),
        "square": cube([dimensions["width"], dimensions["height"], dimensions["thickness"]]),
        "fillet": hull()(
            [
                translate([p[0], p[1], 0])(
                    cylinder(r=dimensions["fillet"], h=dimensions["thickness"])
                ) for p in fillet_plate
            ]
        )
    }
    if bosses is None:
        model = difference()(
            plate[form],
            [h.create() for h in holes]
        ) 
    else: 
        model = difference()(
            union()(
                plate[form],
                [b.create() for b in bosses]
            ),
            [h.create() for h in holes]
        )
    return model
