
include <Values.scad>

module cableHole(cd = 3, ow = -1) {
	openingWidth = (ow > 0) ? ow : cd;

	//wCirclePos = cd/2 - sqrt(pow(cd/2, 2) - pow(openingWidth/2, 2));
	//backShift = - cd/2 - ( (wCirclePos < wallSize) ? wallSize - wCirclePos : 0);

	backShift = -cd/2 - wallSize;

	translate([backShift, 0]) {
		#circle(r = cd/2);
		translate([0, -openingWidth/2]) square([1000, openingWidth]);
	}
}

module cableHoles(r, cables) {
	for(x = [0:len(cables) - 1]) rotate(360/len(cables) * x) translate([r, 0])
		cableHole(cables[x][0], cables[x][1]);
}

module cableRings(r, cables) {
	for(x = [0:len(cables) - 1]) rotate(360/len(cables) * x) translate([r - cables[x][0]/2 - wallSize, 0])
		circle(r = cables[x][0]/2 + wallSize);
}

module multiCableClip(r, cables) linear_extrude(height = clipHeight) {
	difference() {
		union() {
			difference() {
				circle(r = r);
				circle(r = r - wallSize);
			}
			intersection() {
				cableRings(r, cables);
				circle(r = r);
			}
		}

		cableHoles(r, cables);
	}
}

module multiOuterClip(r, angle = 15) linear_extrude(height = clipHeight) {
	slice(360 - angle) difference() {
		circle(r = r + wallSize);
		circle(r = r);
	}
}

cR = 9;
cbles = [ [6.2, 2], [6.2, 2], [6.2, 2]];


multiCableClip(cR, cbles);
