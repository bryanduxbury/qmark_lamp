color([255/255, 0/255, 0/255]) {
  translate([0, 0, .5]) cube(size=[4, 10, 1], center=true);
}

color([0/255, 255/255, 0/255]) {
  translate([0, 3, 6]) cube(size=[2, 2, 10], center=true);
  translate([0, 0, 10]) cube(size=[2, 4, 2], center=true);
  translate([0, -1, 8.5]) cube(size=[2, 2, 1], center=true);
  translate([0, -1, 7.5]) cube(size=[3, 3, 1], center=true);
}