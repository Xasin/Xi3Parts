use <../../Values/Libs.scad>
include <../../Values/Values.scad>
use <../../Others/Utilities/Bearings.scad>

railHeight = 55;

rodCasingWall = 2;

rodCasingDiameter = 15;
rodCasingLength = 20;

rodHeigts = [[10, 90, 0], [20, 0, 0], [30, 90, 0]];

blockHeight = railHeight;


railMountScrewDist = rodCasingDiameter + 5.5;

module rod() tag("negative") {
	cylinder(d = _linearRailDiameter, h = 1000, center=true);
}

module rawRods() {
	for(i = rodHeigts) translate([0, 0, i[0]]) rotate([90, 0, i[1]]) rod();
}

fancyDelta = 2;
module blockOutline() {
	tag("positive")
	offset(delta = fancyDelta, chamfer=true) offset(delta = -fancyDelta)
		translate([-rodCasingDiameter/2, -rodCasingLength/2])
		square([rodCasingDiameter, rodCasingLength]);
}

_screwDiameter = 3 + 2*playLooseFit;
screwWall = rodCasingWall;
module screwOutline() {
	for(x = [-0.5, 0.5]) translate([x*railMountScrewDist, 0]) {
		tag("positive") circle(d = _screwDiameter + 2*screwWall);
		tag("negative") circle(d = _screwDiameter);
	}
}

module blockScrewOutline() {
	tag("positive") hull() showOnly("positive") {
		blockOutline();
		screwOutline();
	}

	blockOutline();
	screwOutline();
}

mountHeight = 2;
rodBackShift = -rodCasingLength/2 + rodCasingWall;
module railMount() {
	translate([0, 0, -mountHeight]) linear_extrude(height = mountHeight) blockScrewOutline();

	tag("negative") translate([0, rodBackShift]) rotate([-90, 0, 0]) cylinder(d = _linearRailDiameter, h= 100);
}

module railMountCap() taggedDifference("positive","negative","neutral") {
	linear_extrude(height = mountHeight) blockScrewOutline();
	tag("positive") difference() {
		rotate([-90, 0, 0]) cylinder(d = _linearRailDiameter + 2*mountHeight, h = rodCasingLength, center=true);
		translate([0, 0, -50]) cube([100, 100, 100], true);
	}

	tag("negative") translate([0, rodBackShift]) rotate([-90, 0, 0]) cylinder(d = _linearRailDiameter, h= 100);
}

module rodBlock() taggedDifference("positive","negative","neutral") {
	linear_extrude(height = blockHeight)
		blockOutline();

	translate([0, 0, blockHeight]) railMount();

	rawRods();
}

translate([0, 0, blockHeight + 0.5]) railMountCap();
rodBlock();
