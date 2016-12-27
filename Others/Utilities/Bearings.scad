
use <../../Values/Libs.scad>
include <../../Values/Values.scad>


module LMU88() tag("negative") {
	cylinder(d = linearRailDiameter + 2*playLooseFit, h = 100, center=true);
	cylinder(d = _bearingDiameter, h = _bearingLength, center=true);
}
