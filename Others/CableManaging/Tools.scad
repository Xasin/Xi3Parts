

module hCircle(r1, r2) {
	difference() {
		circle(r1);
		circle(r2);
	}
}

module slice(angle, r = 10000) {
	if($children > 0) {
		intersection() {
			polygon(concat([[0,0]],
				[ for (x=[0:0.1:angle]) [cos(x)*r, sin(x)*r] ]));

			children();
		}
	}
	else {
			polygon(concat([[0,0]],
				[ for (x=[0:0.1:angle]) [cos(x)*r, sin(x)*r] ]));
	}
}
