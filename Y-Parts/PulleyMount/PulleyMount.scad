use <../../Values/Libs.scad>
include <../../Values/Values.scad>

upperPulleyHeight = 38;
bedHeight = YrailHeight + _bearingDiameter/2;
pulleyDist = bedHeight - upperPulleyHeight;

screwSpacing = 41;

pulleyWidth = 7;
toothSpacing = 2;
_toothRadius = 0.75 + playTightFit;
_beltThickness = 0.75 + playTightFit;

mountThickness = 2;
totalBeltMountHeight = mountThickness + pulleyWidth;

totalBeltThickness = _toothRadius + _beltThickness;
module pulleyBelt(length = 100) {
	translate([-length/2, _toothRadius]) square([length, _beltThickness]);

	for(x = [-length/2:toothSpacing:length/2]) translate([x, _toothRadius]) circle(r = _toothRadius, $fn = 13);
}

beltMountWallThickness = 3;
beltMountWidth = 25;
beltSpacing = 4;
module beltMountOutlines() translate([0, -pulleyDist]){
	tag("positive") {
		translate([-beltMountWidth/2, beltSpacing + 0.1]) square([beltMountWidth, totalBeltThickness + beltMountWallThickness]);

		offset(r= 1.4, chamfer= true) offset(delta= -1.4) {
			translate([-beltMountWidth/2, 0]) square([beltMountWidth/2 - totalBeltThickness, beltSpacing]);
			translate([totalBeltThickness, 0]) square([beltMountWidth/2 - totalBeltThickness, beltSpacing]);
		}
	}
	tag("negative") {
		translate([0, beltSpacing + totalBeltThickness]) rotate(180) pulleyBelt();
	}
}


module beltMount() {
	translate([0, 0, mountThickness]) linear_extrude(height = pulleyWidth) beltMountOutlines();

	linear_extrude(height = mountThickness) tag("positive") hull() {
		translate([0, -0.1]) square([beltMountWidth, 0.1], true);
		showOnly("positive") beltMountOutlines();
	}
}


screwMountExtrudeHeight = 3;
screwMountWallThickness = 2;
screwMountOuterThickness = screwMountWallThickness*2 + 3 + 2*playLooseFit;
screwMountExtraHeight = totalBeltMountHeight - screwMountOuterThickness;
module screwOutlines() {
	for(x=[-0.5, 0.5]) translate([x*screwSpacing, 0]) {
		tag("negative") translate([0, screwMountOuterThickness/2 + screwMountExtraHeight]) circle(d = 3 + 2*playLooseFit);
		tag("positive") {
			translate([0, screwMountOuterThickness/2 + screwMountExtraHeight]) circle(d = screwMountOuterThickness);

			translate([-screwMountOuterThickness/2, 0])
				square([screwMountOuterThickness, screwMountExtraHeight]);
		}
	}
}


module screwMount() rotate([90, 0, 0]) {
	linear_extrude(height = screwMountExtrudeHeight)
		tag("positive") hull() showOnly("positive") screwOutlines();

	linear_extrude(height = screwMountExtrudeHeight + 1)
		tag("negative") showOnly("negative") screwOutlines();
}

taggedDifference("positive", "negative") {
	beltMount();
	screwMount();
}
