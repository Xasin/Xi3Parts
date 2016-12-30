
use <../../Values/Libs.scad>
include <../../Values/Values.scad>

fanWidth = 40;
fanScrewWidth = 35.2;
fanScrewPositions = [	[fanScrewWidth/2, fanScrewWidth/2],
								[-fanScrewWidth/2, fanScrewWidth/2],
								[-fanScrewWidth/2, -fanScrewWidth/2]];

centralOpeningDiameter = 28;

mountThickness = 2;

_mountScrewDiameter = 3 + 2*playLooseFit;
outerScrewMountDiameter = _mountScrewDiameter + 2*mountThickness;
module screwOutlines() {
	for(p = fanScrewPositions) translate(p) {
		tag("negative") circle(d = _mountScrewDiameter);
		tag("positive") circle(d = outerScrewMountDiameter);
	}
}

module centralOutline() {
	tag("negative") circle(d = centralOpeningDiameter);
}

blowerOpeningWidth = 19;
blowerOpeningHeight = 29.7;
blowerOpeningDownshift = fanWidth/2;
module blowerOpeningOutline() {
	tag("positive") translate([-blowerOpeningWidth/2, -blowerOpeningDownshift]) square([blowerOpeningWidth, blowerOpeningHeight]);
}

_CNCDiameter = 15.8 + 2*playTightFit;
CNCScrewLength = 13;
module blowerCNCConnectorOutline() {
	translate([0, blowerOpeningWidth/2 - blowerOpeningDownshift]) {
		tag("negative") circle(d = _CNCDiameter);
		tag("positive") circle(d = blowerOpeningWidth);
	}

}

blowerOpeningCoverHeight = 2;
module blowerCNCConnector() translate([fanWidth/2, 0, blowerOpeningWidth/2]) rotate([0, 90, 0]) {
	linear_extrude(height = blowerOpeningCoverHeight) {
		blowerOpeningOutline();
		blowerCNCConnectorOutline();
	}

	linear_extrude(height = CNCScrewLength) blowerCNCConnectorOutline();
}

module blowerCNCConnectorProjection() {
	tag("positive") projection(cut=true) translate([0, 0, -0.1]) showOnly("positive") blowerCNCConnector();
}

module completeLowerOutline() {
	tag("positive") hull() showOnly("positive") {
		blowerCNCConnectorProjection();
		screwOutlines();
	}

	screwOutlines();
}

module blowerMount() taggedDifference("positive","negative","neutral") {
	translate([0, 0, -mountThickness + 0.1]) linear_extrude(height = mountThickness) completeLowerOutline();
	blowerCNCConnector();
}

blowerMount();
