// Generated by SolidPython 1.0.4 on 2021-01-27 22:50:45
$fn = 150;


difference() {
	cube(size = [400, 300, 15]);
	translate(v = [20, 20, 0]) {
		cylinder(d = 5.5000000000, h = 15);
	}
	translate(v = [20, 20, 9.5000000000]) {
		cylinder(d = 10, h = 5.5000000000);
	}
	translate(v = [40, 20, 5]) {
		cube(size = [6, 250, 10]);
	}
}
/***********************************************
*********      SolidPython code:      **********
************************************************
 
from collections import namedtuple
from typing import NamedTuple
import json
from pathlib import Path

import click
from solid import *
from solid.utils import *  # Not required, but the utils module is useful

import_scad('MCAD/units.scad')



SEGMENTS = 150


def plate_with_holes(form, dimensions, holes):
    """
    Create a plate with holes
    """
    plate = {
        "circle": cylinder(d=dimensions["diameter"], h=dimensions["thickness"]),
        "square": cube([dimensions["width"], dimensions["height"], dimensions["thickness"]])
    }
    return difference()(
        plate[form],
        [
            h.create() for h in holes
        ]
    )


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


@click.command()
@click.argument('filename', required=True, type=click.STRING)
def create(filename):
    """
    Generate a scad file of a plate with optional holes in it.
    First define the overall geometry: "circle" or "square", then declare the holes.

    The json file must have a certain structure, i.e.:

    {
        "width": 400,
        "height": 300,
        "thickness": 15,
        "holes": [
            {
                "label": "H1",
                "diameter": 5.5,
                "x_pos": 20,
                "y_pos": 20,
                "z_pos": 0,
                "depth": 15
            },
            ...
        ]
    }
    """
    p = Path(filename)
    click.echo(f'Generating {p.stem}.scad')
    with open(filename) as f:
        data = json.load(f)
        if "holes" in data:
            if "thickness" in data:
                holes = [
                    Hole(
                        h["diameter"], h["x_pos"], h["y_pos"], h["z_pos"], h["depth"]
                    ) if "diameter" in h else Pocket(
                        h["width"], h["length"], h["x_pos"], h["y_pos"], h["z_pos"], h["depth"]
                    ) for h in data["holes"]
                ]
                scad_render_to_file(
                    plate_with_holes(
                        data["form"] if "form" in data else "square",
                        {
                        "width": data["width"] if "width" in data else None,
                        "height": data["height"] if "height" in data else None,
                        "diameter": data["diameter"] if "diameter" in data else None,
                        "thickness": data["thickness"]
                        },
                        holes
                    ),
                    file_header=f'$fn = {SEGMENTS};',
                    filepath=f'{p.stem}.scad'
                )
                click.echo('Processing complete.')
            else:
                click.echo('Declare the thickness of your plate.')
                click.echo('Process aborted.')
        else:
            click.echo('You must include some holes in your plate!')
            click.echo('Process aborted.')
    


if __name__ == '__main__':
    create() 
 
************************************************/
