from typing import NamedTuple
import json
from pathlib import Path

import click
from solid import *
from solid.utils import *  # Not required, but the utils module is useful

import_scad('MCAD/units.scad')

SEGMENTS = 150



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


def plate_with_holes(form, dimensions, holes):
    """
    Create a plate with holes
    """
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
    return difference()(
        plate[form],
        [h.create() for h in holes]
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
                        "width": data["width"] if "width" in data else 0,
                        "height": data["height"] if "height" in data else 0,
                        "diameter": data["diameter"] if "diameter" in data else 0,
                        "thickness": data["thickness"],
                        "fillet": data["fillet"] if "fillet" in data else 0
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