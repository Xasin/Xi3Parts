
include <Values.scad>

module simpleCableClip(iRad, type) linear_extrude(height = clipHeight) {
	iRadius = (type == 0) ? iRad : iRad + wallSize;
	cRadius = (type == 0) ? iRad + wallSize - 0.1 : iRad + 0.1;

	difference() {
		hCircle(iRadius + wallSize, iRadius);
		rotate(-openingAngle/2) slice(openingAngle);
	}

	rotate(180 -openingAngle/2) slice(openingAngle) hCircle(cRadius + wallSize, cRadius);
}

simpleCableClip(innerSize, 1);

translate([(innerSize + wallSize) * 2.5, 0, 0]) simpleCableClip(innerSize, 0);
