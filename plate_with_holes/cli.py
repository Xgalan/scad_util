import json
from pathlib import Path

from solid import scad_render_to_file
import click
import model as Model


SEGMENTS = 150



@click.command()
@click.argument('filename', required=True, type=click.STRING)
def cli(filename):
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
                scad_render_to_file(
                    Model.plate_with_holes(
                        data["form"] if "form" in data else "square",
                        {
                        "width": data["width"] if "width" in data else 0,
                        "height": data["height"] if "height" in data else 0,
                        "diameter": data["diameter"] if "diameter" in data else 0,
                        "thickness": data["thickness"],
                        "fillet": data["fillet"] if "fillet" in data else 0
                        },
                        data["holes"],
                        data["bosses"] if "bosses" in data else None
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
    cli()
