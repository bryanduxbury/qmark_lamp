
// parameters
material_thickness = 3;
dimension = 5.75*25.4; // 2.5 inches on a side
num_squares = 16;
laser_beam_width = 0.127;

// calculated parameters
square_dim = dimension / num_squares;


module sawtooth() {
	translate([0, -laser_beam_width/2, -dimension/2 + square_dim/2]) union() {
		for (i = [0:floor(num_squares/2)]) {
			translate([0, 0, 2*i*square_dim]) cube([2*material_thickness, 2*material_thickness, square_dim-laser_beam_width], center=true);
		}
	}
}


module side_outer() {
	color([1, 0.49, 0.25, 0.80]) render() difference() {
		cube([material_thickness, dimension, dimension], center=true);
		translate([0, -dimension/2, 0]) sawtooth();
		rotate(a=[-90, 180, 0]) translate([0, -dimension/2, 0]) sawtooth();
		rotate(a=[180, 0, 0]) translate([0, -dimension/2, 0]) sawtooth();
		rotate(a=[90, 180, 0]) translate([0, -dimension/2, 0]) sawtooth();
	}
}

module side_inner_white() {
	color([1, 1, 1, 1]) render() {
		difference() {
			cube([material_thickness, (num_squares - 2) * square_dim, (num_squares - 2) * square_dim], center=true);

			for (angle = [0, 90, 180, 270]) {
				rotate(a=[angle, 0, 0]) translate([0, 5.5 * square_dim, 5.5 * square_dim]) 
					cube([material_thickness*2, square_dim, square_dim], center=true);
			}

			translate([0, -square_dim/2, square_dim]) qmark_top();
			translate([0, 0, -4 * square_dim]) qmark_bottom();
			translate([0, -3*square_dim, 0]) scale([2, 1, 1]) qmark_shadow_1();
			translate([0, 0, -3*square_dim]) scale([2, 1, 1]) qmark_shadow_2();
			translate([0, 0, -6*square_dim]) scale([2, 1, 1]) qmark_shadow_3();
		}
	}
}

module corner_nails() {
	color([0,0,0]) cube([material_thickness, square_dim, square_dim], center=true);
}

module qmark_shadow_1() {
	color([0, 0, 0, 1]) rotate(a=[90, 0, 90]) scale([square_dim, square_dim, 1]) {
		linear_extrude(height=material_thickness, center=true) {
			polygon([
				[0,0],
				[2,0],
    				[2,3],
				[4,3],
				[4,4],
				[1,4],
				[1,1],
				[0,1],
				[0,0]
			]);
		}
	}
}

module qmark_shadow_2() {
	color([0, 0, 0, 1]) rotate(a=[90, 0, 90]) scale([square_dim, square_dim, 1]) {
		linear_extrude(height=material_thickness, center=true) {
			polygon([
				[0,0],
				[2,0],
				[2,2],
				[4,2],
				[4,6],
				[3,6],
				[3,3],
				[1,3],
				[1,1],
				[0,1],
				[0,0]
			]);
		}
	}
}

module qmark_shadow_3() {
	color([0, 0, 0, 1]) {
		union() {
			translate([0, square_dim, square_dim/2]) cube([material_thickness, square_dim*2, square_dim], center=true);
			translate([0, square_dim*3/2, square_dim]) cube([material_thickness, square_dim, square_dim*2], center=true);
		}
	}
}

module qmark_top() {
	union() scale([square_dim, square_dim, square_dim]) {
		translate([0, 0, 3.5]) cube([1.01, 5.01, 1.01], center=true);
		translate([0, -2.5, 1.5]) cube([1.01, 2.01, 3.01], center=true);
		translate([0, 2.5, 1]) cube([1.01, 2.01, 4.01], center=true);
		translate([0, 0.5, -2]) cube([1.01, 2.01, 2.01], center=true);
		translate([0, 1, -0.5]) cube([1.01, 1.01, 1.01], center=true);
	}
}

module qmark_bottom() {
	cube([material_thickness*2, 2*square_dim + 0.001, 2*square_dim + 0.0001], center=true);
}

module qmark() {}

module side() {
	translate([-material_thickness - 0.0001, 0, 0]) {
		side_inner_white();
		translate([0, -3*square_dim, 0]) qmark_shadow_1();
		translate([0, 0, -3*square_dim]) qmark_shadow_2();
		translate([0, 0, -6*square_dim]) qmark_shadow_3();
	}
	side_outer();
	 
}

module top() {
	color([1, 0.49, 0.25, 0.8]) difference() {
		cube([dimension, dimension, material_thickness], center=true);
		for (angle=[0, 90, 180, 270]) {
			rotate(a=[0, 0, angle]) translate([dimension/2, 0, 0]) rotate(a=[270, 0, 0]) sawtooth();
		}

		for (angle=[0, 90, 180, 270]) {
	    rotate(a=[0, 0, angle]) translate([dimension/2, dimension/2, 0]) cube([square_dim, material_thickness*2-laser_beam_width, material_thickness*2], center=true);
	  }

		cylinder(r=4, h=material_thickness*2, center=true);
	}
}

module bottom() {
	color([1, 0.49, 0.25, 0.8]) difference() {
		cube([dimension, dimension, material_thickness], center=true);
		for (angle=[0, 90, 180, 270]) {
			rotate(a=[0, 0, angle]) translate([dimension/2, 0, 0]) rotate(a=[90, 0, 0]) sawtooth();
		}
		
		for (angle=[0, 90, 180, 270]) {
	    rotate(a=[0, 0, angle]) translate([dimension/2, dimension/2, 0]) cube([material_thickness*2-laser_beam_width, square_dim, material_thickness*2], center=true);
	  }
	}
}

module assembled() {
	cube([10, 10, 10], center=true);
	
	for (i = [0:3]) {
		rotate([0, 0, 90*i]) translate([dimension / 2 - material_thickness / 2, 0, 0]) side();
	}
	
	translate([0, 0, dimension / 2 - material_thickness / 2]) top();
	translate([0, 0, -dimension / 2 + material_thickness / 2]) bottom();
}

module orange_panel() {
	projection(cut=true) {
		for (i = [0:2]) {
			translate([i * (dimension + 1), 0, 0]) rotate(a=[0, 90, 0]) side_outer();
		}
		translate([0, -dimension - 1, 0]) {
			rotate(a=[0, 90, 0]) side_outer();
			translate([dimension + 1, 0, 0]) top();
			translate([2*(dimension + 1), 0, 0]) bottom();
		}
	}

}

module white_panel() {
	projection(cut=true) {
		for (i = [0:3]) {
			translate([floor(i/2) * (dimension * (num_squares - 2) / num_squares + 1), i % 2 * (dimension * (num_squares - 2) / num_squares+ 1)]) 
				rotate(a=[0, 90, 0]) side_inner_white();
		}
	}
}

module black_panel() {
  translate([0, 7 * square_dim, 0]) rotate([180, 0, 0]) %cube(size=[25.4*12, 25.4*12, 1]);
  
	projection(cut=true) rotate(a=[0, 90, 0]) {
		translate([0, 3 * square_dim, 6.1*square_dim]) for (i = [0:19]) {
			translate([0, -i * (square_dim+1), i * (square_dim+1)]) qmark_shadow_1();
		}

		translate([0, 0 * square_dim, 0 * square_dim]) for (i = [0:19]) {
			translate([0, -i * (square_dim+1), i * (square_dim+1)]) qmark_shadow_2();
		}

    translate([0, -25 * square_dim, 1 * square_dim]) for (i = [0:20*4-1]) {
      translate([0, floor(i/10) * (square_dim + 1), i%10 * (square_dim+1)]) corner_nails();
    }
    
    translate([0, -3 * square_dim, 22* square_dim]) for (i = [0:20*4-1]) {
      translate([0, floor(i/10) * (square_dim + 1), i%10 * (square_dim+1)]) corner_nails();
    }
    
    translate([0, -24.5 * square_dim + 0.1, 21.2 * square_dim]) for (i = [0:19]) {
      translate([0, i * (square_dim + 1), -i * (square_dim+1)]) qmark_shadow_3();
    }
	}
}

module single_silk_panel() {
  projection(cut=true) {
    rotate([0, 90, 0]) {
      translate([0, -dimension/2 - 2 * 25.4, 0]) side_inner_white();
  
      translate([0, dimension/2 + 2 * 25.4, 0]) {
        translate([0, -3*square_dim, 0]) qmark_shadow_1();
    	  translate([0, 0, -3*square_dim]) qmark_shadow_2();
    	  translate([0, 0, -6*square_dim]) qmark_shadow_3();
      }
    }
  }
}

// assembled();

// orange_panel();

// white_panel();

// black_panel();

single_silk_panel();