lamp_side_dim = 5.75 * 25.4;

t = 0.250 * 25.4;

corner_r = 3 * 25.4;
pipe_d = 2.75 * 25.4;
flange_depth = 1/2 * 25.4;

clearance_above = 2 * 25.4;
clearance_below = 5 * 25.4;
clearance_side = 3 * 25.4;

slot_depth = pipe_d/2;

side_feet_width = 4*25.4;

translate([0, 0, lamp_side_dim/2 + clearance_below + pipe_d]) rotate([90, 0, 0]) {
  // lamp blank
  cube(size=[lamp_side_dim, lamp_side_dim, lamp_side_dim], center=true);

  // main piece
  render()
  difference() {
    union() {
      translate([0, lamp_side_dim/2 + clearance_above - flange_depth - flange_depth/2, 0]) 
        cube(size=[corner_r, flange_depth, t], center=true);

      translate([0, lamp_side_dim/2 + clearance_above - flange_depth/2, 0]) 
        cube(size=[pipe_d, flange_depth, t], center=true);

      translate([(pipe_d/2 + lamp_side_dim/2 + clearance_side)/2 - pipe_d/2, lamp_side_dim/2 + clearance_above + pipe_d/2, 0]) 
        cube(size=[pipe_d/2 + lamp_side_dim/2 + clearance_side, pipe_d, t], center=true);

      translate([lamp_side_dim/2 + clearance_side + pipe_d/2, -lamp_side_dim/2 - clearance_below - pipe_d + (clearance_above + clearance_below + lamp_side_dim + pipe_d*2)/2, 0]) 
        cube(size=[pipe_d, clearance_above + clearance_below + lamp_side_dim + pipe_d*2, t], center=true);

      translate([0, -lamp_side_dim/2 - clearance_below - pipe_d/2, 0]) cube(size=[clearance_side * 2 + lamp_side_dim, pipe_d, t], center=true);

      translate([(clearance_side * 2 + lamp_side_dim)/-2, -lamp_side_dim/2 - clearance_below - pipe_d/2 + (corner_r - pipe_d)/4, 0]) 
        cube(size=[flange_depth, corner_r - (corner_r - pipe_d)/2, t], center=true);
    }
    translate([lamp_side_dim/2 + clearance_side + pipe_d/2, -lamp_side_dim/2 - clearance_below - pipe_d, 0]) 
      cube(size=[t, slot_depth*2, t*2], center=true);
  }
  
  
  // cross piece
  translate([lamp_side_dim/2 + clearance_side + pipe_d/2, -lamp_side_dim/2 - clearance_below - pipe_d, 0]) rotate([0, 90, 0]) {
    translate([0, pipe_d/2, 0]) 
    render()
    difference() {
      union() {
        cube(size=[side_feet_width * 2 + t, pipe_d, t], center=true);
        for (x=[-1,1]) {
          translate([x * (side_feet_width + flange_depth/2), 0, 0]) cube(size=[flange_depth, corner_r, t], center=true);
        }
      }
      translate([0, -pipe_d/2 - 10, 0]) cube(size=[side_feet_width*3, 20, t*2], center=true);
      translate([0, pipe_d/2, 0]) cube(size=[t, slot_depth*2, t*2], center=true);
    }
  }
}

