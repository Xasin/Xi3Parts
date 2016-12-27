use <../../Values/Libs.scad>
include <../../Values/Values.scad>
use <../../Others/Utilities/Bearings.scad>

screwDistance = 20;

caseWallThickness = 1.83;

bearingLift = _bearingDiameter/2 + caseWallThickness;

caseLength = _bearingLength + 2*caseWallThickness;
caseWidth = _bearingDiameter + 2*caseWallThickness;
module caseOutline() {
	tag("positive") square([caseLength, caseWidth], true);
}

_mountScrewDiam = 3 + playLooseFit*2;
mountScrewOuterDiam = _mountScrewDiam + 2*caseWallThickness;
module mountScrewOutline() {
	for(y = [-0.5, 0.5]) translate([0, y*screwDistance]) {
		tag("negative") circle(d = _mountScrewDiam);
		tag("positive") circle(d = mountScrewOuterDiam);
	}
}

module mountOutline() {
	hull() tag("positive") showOnly("positive") {
		mountScrewOutline();
		caseOutline();
	}
	mountScrewOutline();
}

module lowerMount() taggedDifference("positive","negative","neutral") {
	linear_extrude(height = bearingLift - playTightFit, convexity = 3) {
		mountOutline();
	}

	translate([0, 0, bearingLift]) rotate([0, 90, 0]) LMU88();
}

screwMountHeight = 5;
module upperMount() taggedDifference("positive","negative","neutral") {
	tag("positive") rotate([0, 90, 0]) cylinder(d = caseWidth, h = mountScrewOuterDiam, center=true);

	linear_extrude(height = screwMountHeight) tag("positive") hull() showOnly("positive")
		mountScrewOutline();
	
	tag("negative") {
		showOnly("negative") linear_extrude(height = screwMountHeight) 
		mountScrewOutline();
		
		translate([0, 0, screwMountHeight]) linear_extrude(height = 100) offset(r = 1.5) showOnly("negative") mountScrewOutline();
	}
	

	rotate([0, 90, 0]) LMU88();

	tag("negative") translate([-100, -100, -100]) cube([200, 200, 100]);
}


translate([0, 0, bearingLift]) upperMount();
lowerMount();
