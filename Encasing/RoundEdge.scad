// Resolution
height = 30;
radius = 20;
thick = 4;
screw_d = 4;
hex_d = 8;
hex_h = 3;
nut_sup_d = 10;

module roof(radius, height) {
	rotate(-45)
	    intersection() {
	        cube([radius, radius, height]);
	        rotate(45) 
				cube([radius * 2, radius * 2, height]);
	    }
}

module round_edge(radius, height) {
	difference() {
        union() {
            roof(radius, height);
            mirror([1,0,0]) 
                roof(radius, height);
            cylinder(h = height, r = radius, $fn = 200);
        }
        translate([0, -radius / 2, height / 2])
            cube([3 * radius, radius, height + 1], center=true);
   }
}

module cut_plane(radius, height, direction) {
	mirror_x = max(direction, 0);
	translate([direction * 2 * radius * sin(45), 0, -1])
		rotate(direction * 45)
       		mirror([mirror_x, 0, 0])
				translate([-1, 0, 0]) 
					cube([thick + 1, radius,  height + 2]);
}

module omega(radius, height) {
	difference() {
		round_edge(radius, height);
		cut_plane(radius, height, 1);
		cut_plane(radius, height, -1);
	}
}

module empty_omega(radius, height) {
	translate([0,  -thick / 2 - 1, 0]) 
		difference() {
			omega(radius, height);
			// inner omega
			translate([0, thick / 2, thick / 2]) 
				scale([(radius - thick) / radius, 
	                  (radius - thick) / radius, 
	                  (height - thick) / height])
					omega(radius, height);
			// cut bottom
			translate([-1.5 * radius, -radius + thick / 2 + 1, -1]) 
				cube([3 * radius, radius, height + 2]);
		}
	}

module edge(radius, height) {
	difference() {
		empty_omega(radius, height);
		// holes z
	    translate([0,  (radius - thick / 2 - 1) / 3, -1])
			cylinder(h = height + 2, r = screw_d / 2, $fn = 50);
		// hole x1
		translate([-(radius - thick / 2 - 2) * sin(45),  0, height / 2])
			rotate([0, 90, 135])
				cylinder(h = radius, r = screw_d / 2, $fn = 50);
		// hole x2
		translate([(radius - thick / 2 - 2) * sin(45),  0, height / 2])
			rotate([0, 90, 45])
				cylinder(h = radius, r = screw_d / 2, $fn = 50);
	}
}


edge(radius, height);

module nut_support(nut_sup_d, hex_d, hex_h) {
	translate([0, hex_h, 0]) 
	    cube([nut_sup_d, nut_sup_d, hex_h]);
	translate([0, 2 * hex_h + nut_sup_d, 0])
	    rotate([0, 90, 0]) rotate([0, 0, -135])
	            roof(hex_h, nut_sup_d);
	mirror([0, 1, 0])
	    rotate([0, 90, 0]) rotate([0, 0, -135])
	            roof(hex_h, nut_sup_d);
}

translate([20, 0, 0])
difference() {
	nut_support(nut_sup_d, hex_d, hex_h);
	translate([nut_sup_d / 2, nut_sup_d / 2 + hex_h, -1]) cylinder(h = hex_h + 2, r = hex_d / sqrt(3), $fn = 6);
}
	

//%omega(radius, height);
//%scale([(radius - thick) / radius, 
//	(radius - thick) / radius, 
//	(height - thick) / height])
//		omega(radius, height);
//
//#translate([height / 2,  0, 0])
//rotate([0, 270, 0])
//    roof(radius, height);