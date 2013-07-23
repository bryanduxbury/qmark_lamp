// TODOs

// t = 3; // acrylic
t = 0.177 * 25.4; // 3/16" acrylic (adam's recommendation)

d = 1/8 * 25.4; // #4-40 screws

pcb_t = 1.6;

m2x5_connector = [20.25 / 25.4 * 1000, 9 / 25.4 * 1000, 12 / 25.4 * 1000];

pogo_pin_d = 1.01;
pogo_pin_static_len = 25;
pogo_pin_dyn_len = 6.3;
pogo_pin_head_len = 2;
pogo_pin_exposed_shaft_len=t - 1;

overall_width = 7 * 25.4;
overall_height = 5*25.4;

closing_screw_len = 25.4 * 1.75;
inside_height = closing_screw_len - 3*t;

washer_t = 1;

tab_width=10;

function mm(mil) = mil / 1000 * 25.4;

module mil_to_mm() {
  scale(25.4/1000) {
    child(0);
  }
}

module _blk() {
  color([0/255, 0/255, 0/255]) {
    child(0);
  }
}

module _pcb() {
  color([0/255, 255/255, 0/255]) {
    child(0);
  }
}

module _screw(head_t, head_d, d, l) {
  color([32/255, 32/255, 32/255])
  union() {
    translate([0, 0, head_t/2]) cylinder(r=head_d/2, h=head_t, center=true);
    translate([0, 0, -l/2]) cylinder(r=d/2, h=l, center=true);
  }
}

module _rounded_rect(w, l, t, r) {
  linear_extrude(height=t, center=true)
  hull() {
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (w / 2 - r), y * (l / 2 - r), 0]) 
        circle(r=r, center=true, $fn=36);
    }
  }
}

module toggle_button() {
  color([192/255, 32/255, 32/255])
  render()
  mil_to_mm()
  union() {
    translate([0, 0, 308 + 200/2]) cube(size=[403, 403, 200], center=true);
    translate([0, 0, 308/2]) cube(size=[587, 587, 308], center=true);
    translate([386/2, 0, -20]) cube(size=[(429-386)*2, 58, 40], center=true);
    translate([0, 0, (877-508)/-2]) cylinder(r=386/2, h=877-508, center=true); 
    translate([0, 0, -(1088 - 508) + (1088-877)/2]) cylinder(r=335/2, h=1088-877, center=true); 
  }
}

module small_momentary() {
  color([192/255, 32/255, 32/255])
  render()
  mil_to_mm()
  union() {
    translate([0, 0, 306/2]) cylinder(r=267/2, h=306, center=true);
    translate([0, 0, -610/2]) cylinder(r=397/2, h=610, center=true);
  }
}

module pcba() {
  linear_extrude(height=pcb_t, center=true)
  mil_to_mm() translate([-1500, -1500, 0]) difference() {
    polygon(points=[[0,0],[0,3000],[2900,3000],[3000,2800],[3000,0]],path=[1,2,3,4,5]);
    translate([1200, 1200, 0]) circle(r=50/2,$fn=36);
    translate([1500, 1200, 0]) circle(r=50/2,$fn=36);
    translate([1800, 1200, 0]) circle(r=50/2,$fn=36);
    translate([1800, 1400, 0]) circle(r=50/2,$fn=36);
    translate([1800, 1600, 0]) circle(r=50/2,$fn=36);
    translate([1800, 1800, 0]) circle(r=50/2,$fn=36);
    translate([1600, 1800, 0]) circle(r=50/2,$fn=36);
    translate([1400, 1800, 0]) circle(r=50/2,$fn=36);
    translate([1200, 1800, 0]) circle(r=50/2,$fn=36);
    translate([1200, 1500, 0]) circle(r=50/2,$fn=36);
  }
}

module arduino_pcb() {
  _pcb()
  linear_extrude(height=pcb_t, center=true)
  mil_to_mm() 
  difference() {
    polygon(points=[[0,0], [0,2100], [2540,2100], [2600,2040],[2600,1590],[2700,1490], [2700,200], [2600,100], [2600,0]]);
    translate([550, 100, 0]) circle(r=125/2);
    translate([600, 2000, 0]) circle(r=125/2);
    translate([2600, 1400, 0]) circle(r=125/2);
    translate([2600, 300, 0]) circle(r=125/2);
  }
}

module arduino() {
  arduino_pcb();
  translate([0, 0, pcb_t/2]) 
    _blk()
    mil_to_mm() 
      translate([525/2 - 75, 100 + 350/2, 450/2]) 
        cube(size=[525, 350, 450], center=true);
  translate([0, 0, pcb_t/2])
    _blk()
    mil_to_mm() 
      translate([625/2 - 250, 1275 + 450/2, 450/2]) 
        cube(size=[625, 450, 450], center=true);
}

module adapter_board() {
  _pcb()
  linear_extrude(height=pcb_t, center=true)
  mil_to_mm() 
  difference() {
    polygon(points=[[0,0], [0,2100], [2140,2100], [2200,2040],[2200,1590],[2300,1490], [2300,200], [2200,100], [2200,0]]);
    translate([150, 100, 0]) circle(r=125/2);
    translate([200, 2000, 0]) circle(r=125/2);
    translate([2200, 1400, 0]) circle(r=125/2);
    translate([2200, 300, 0]) circle(r=125/2);
  }
}

module controller_package() {
  arduino();
  translate([25.4/1000*400, 0, 25.4/1000*500 + pcb_t]) adapter_board();
  translate([25, 25, 1/2 * 25.4 + pcb_t / 2 + pcb_t + mm(m2x5_connector[2])/2]) mil_to_mm() _blk() cube(size=m2x5_connector, center=true);
}

module led_board() {
  _pcb()
  linear_extrude(height=pcb_t, center=true)
  mil_to_mm()
  difference() {
    polygon(points=[
      [-1500, 150],
      [1500, 150],
      [1500, -150],
      [1300, -150],
      [1200, -250],
      [950, -650],
      [-450, -650],
      [-450, -250],
      [-1200, -250],
      [-1300, -150],
      [-1500, -150]
      ]);
    translate([-1350, 0, 0]) circle(r=125/2, $fn=36);
    translate([1350, 0, 0]) circle(r=125/2, $fn=36);
  }

}

module led(c) {
  color(c)
  render()
  union() {
    translate([0, 0, 1]) cylinder(r=11.2/2, h=2, center=true);
    translate([0, 0, 11.5 - 10/2]) sphere(r=5);
    translate([0, 0, 6.5/2]) cylinder(r=10/2, h=6.5, center=true);
  }
}

module led_board_assembly() {
  translate([0, 0, -2]) {
    rotate([0, 180, 0]) {
      translate([0, 0, pcb_t/2]) led_board();
      translate([0, mm(-450), pcb_t/2 + mm(m2x5_connector[2]/2)]) mil_to_mm() _blk() cube(size=m2x5_connector, center=true);
    }
    for (params = [[1000, [1, 0, 0]], [500, [0, 1, 0]], [0, [0, 0, 1]], [-500, [1, 1, 0]], [-1000, [1, 1, 1]]]) {
      translate([mm(params[0]), 0, 0]) led(params[1]);
    }
  }
}

module pogo_top() {
  color([0/255, 255/255, 0/255]) 
  linear_extrude(height=pcb_t, center=true)
  mil_to_mm()
  difference() {
    polygon(points=[[0,0], [0,1500], [1300,1500], [1300,0]]);
    translate([400, 350, 0]) circle(r=50/2,$fn=36);
    translate([700, 350, 0]) circle(r=50/2,$fn=36);
    translate([1000, 350, 0]) circle(r=50/2,$fn=36);
    translate([1000, 550, 0]) circle(r=50/2,$fn=36);
    translate([1000, 750, 0]) circle(r=50/2,$fn=36);
    translate([1000, 950, 0]) circle(r=50/2,$fn=36);
    translate([800, 950, 0]) circle(r=50/2,$fn=36);
    translate([600, 950, 0]) circle(r=50/2,$fn=36);
    translate([400, 950, 0]) circle(r=50/2,$fn=36);
    translate([400, 650, 0]) circle(r=50/2,$fn=36);

    translate([100, 1000, 0]) circle(r=125/2);
    translate([400, 100, 0]) circle(r=125/2);
    translate([1200, 100, 0]) circle(r=125/2);
    translate([1200, 1000, 0]) circle(r=125/2);
  }
}

module pogo_bottom() {
  color([0/255, 255/255, 0/255]) 
  linear_extrude(height=pcb_t, center=true)
  mil_to_mm()
  difference() {
    polygon(points=[[0,0], [0,1100], [1300,1100], [1300,0]]);
    translate([400, 350, 0]) circle(r=50/2,$fn=36);
    translate([700, 350, 0]) circle(r=50/2,$fn=36);
    translate([1000, 350, 0]) circle(r=50/2,$fn=36);
    translate([1000, 550, 0]) circle(r=50/2,$fn=36);
    translate([1000, 750, 0]) circle(r=50/2,$fn=36);
    translate([1000, 950, 0]) circle(r=50/2,$fn=36);
    translate([800, 950, 0]) circle(r=50/2,$fn=36);
    translate([600, 950, 0]) circle(r=50/2,$fn=36);
    translate([400, 950, 0]) circle(r=50/2,$fn=36);
    translate([400, 650, 0]) circle(r=50/2,$fn=36);

    translate([100, 1000, 0]) circle(r=125/2);
    translate([400, 100, 0]) circle(r=125/2);
    translate([1200, 100, 0]) circle(r=125/2);
    translate([1200, 1000, 0]) circle(r=125/2);
  }
}

module pogo_pin() {
  color([192/255, 192/255, 192/255])
  translate([0, 0, -pogo_pin_static_len/2 + pogo_pin_exposed_shaft_len]) {
    cylinder(r=pogo_pin_d/2, h=pogo_pin_static_len, center=true, $fn=36);
    translate([0, 0, pogo_pin_static_len/2 + pogo_pin_dyn_len/2]) cylinder(r=pogo_pin_d/2 - 0.1, h=pogo_pin_dyn_len, center=true, $fn=36);
    translate([0, 0, pogo_pin_static_len/2 + pogo_pin_dyn_len]) cylinder(r=pogo_pin_d/2, h=pogo_pin_head_len, center=true, $fn=36);
  }
}

module pogo_assembly() {
  translate([0, 0, -pcb_t/2]) rotate([0, 180, -90]) {
    translate([(-400 - 300) / 1000 * 25.4, (-350 - 300) / 1000 * 25.4, 0]) {
      pogo_top();
      color([0/255, 0/255, 0/255]) mil_to_mm() translate([700, 1300, m2x5_connector[2] / 2]) cube(size=m2x5_connector, center=true);

      for (xy=[[100, 1000], [400, 100], [1200, 100], [1200, 1000]]) {
        color([255/255, 255/255, 255/255])
          mil_to_mm() 
            translate([xy[0], xy[1], (pogo_pin_static_len - pogo_pin_exposed_shaft_len - 2 * pcb_t) / 2 / 25.4 * 1000 + pcb_t / 2 / 25.4 * 1000]) 
              difference() {
                cylinder(r=125/2+10, h=(pogo_pin_static_len - pogo_pin_exposed_shaft_len - 2 * pcb_t) / 25.4 * 1000, center=true);
                cylinder(r=125/2, h=(pogo_pin_static_len - pogo_pin_exposed_shaft_len - 2 * pcb_t) / 25.4 * 1000 + 10, center=true);
              }
      }

      // translate([0, 0, pcb_t + 1/4 * 25.4]) 
      translate([0, 0, pogo_pin_static_len - pogo_pin_exposed_shaft_len - pcb_t]) 
        pogo_bottom();

      for (xy=[
        [400, 350], 
        [700, 350], 
        [1000, 350],
        [1000, 550],
        [1000, 750],
        [1000, 950],
        [800, 950], 
        [600, 950], 
        [400, 950], 
        [400, 650]]) 
      {
        translate([mm(xy[0]), mm(xy[1]), 0]) rotate([180, 0, 0]) pogo_pin();
      }
    }
  }
}

module bottom_top_base() {
  difference() {
    // main outline
    _rounded_rect(overall_width, overall_height, t, t);

    // tab slots across the top and bottom
    for(x=[-2:2], y=[-1,1]) {
      translate([x * (overall_width/5), y * (overall_height / 2 - t - t/2), 0]) cube(size=[tab_width, t, t*2], center=true);
    }

    // tab slots down the sides
    for(x=[-1,1], y=[-1:1]) {
      translate([x * (overall_width - t*3)/2, y * overall_height / 3, 0]) cube(size=[t, tab_width, t*2], center=true);
    }

    // holes for the pogo assembly
    rotate([180, 0, 90]) for (xy=[[500, -550], [500,350], [-600, 350], [-300, -550]]) {
      mil_to_mm() 
        translate([xy[0], xy[1], 0]) 
          cylinder(r=125/2, h=1000, center=true);
    }

    // holes for the sandwiching screws
    for(x=[-1:1], y=[-1:1]) {
      if (!(x == 0 && y==0)) {
        translate([x * (overall_width / 2 - t*2 - 2 - d/2), y * (overall_height / 2 - t*2 - 2 - d/2), 0]) cylinder(r=d/2, h=t*2, center=true, $fn=36);
      }
    }
  }
}

module top() {
  color([128/255, 32/255, 32/255])
  assign(board_width = 3 * 25.4)
  assign(frame_thickness = 12)
  assign(frame_width = board_width + 2 * frame_thickness)
  assign(corner_radius = 4)
  render()
  difference() {
    bottom_top_base();
    cube(size=[mm(700), mm(700), t*2], center=true);

    // mounting holes for the board frame
    for (x=[-1,1], y=[-1,1]) {
      translate([x * (frame_width / 2 - frame_thickness / 2), y * (frame_width / 2 - frame_thickness / 2), 0]) 
        cylinder(r=d/2, h=t*2, center=true, $fn=36);
    }

    // led board
    translate([overall_width/2 - t*2 - d - 2 - 5 - 2, 0, 0]) {
      for (y=[-2:2]) {
        translate([0, y * mm(500), 0]) cylinder(r=5.2, h=t*2, center=true, $fn=72);
      }
      for (y=[-1,1]) {
        translate([0, y * mm(1350), 0]) cylinder(r=mm(125)/2, h=t*2, center=true, $fn=36);
      }
    }

    // "go" button
    translate([overall_width/2 - t * 2 - d - 2 - 5 - 10, -(overall_height/2 - t*2 - 5 - mm(397)/2), 0]) cylinder(r=mm(300)/2, h=t*2, center=true, $fn=72);
  }
}

module board_frame() {
  assign(board_width = 3 * 25.4)
  assign(frame_thickness = 12)
  assign(frame_width = board_width + 2 * frame_thickness)
  assign(corner_radius = 4)
  render()
  difference() {
    _rounded_rect(frame_width, frame_width, t, corner_radius);

    for (x=[-1,1], y=[-1,1]) {
      translate([x * (frame_width / 2 - frame_thickness / 2), y * (frame_width / 2 - frame_thickness / 2), 0]) 
        cylinder(r=1.6, h=t*2, center=true, $fn=36);
    }

    for (y=[-1,1]) {
      translate([0, y * (overall_height/2 - t*2 - 2 - d/2), 0]) cylinder(r=d/2+3, h=t*2, center=true, $fn=36);
    }

    linear_extrude(height=t*2, center=true) {
      mil_to_mm() polygon(points=[[-1500 - 10, -1500 - 10], [-1500 - 10, 1500 + 10], [1400 + 10, 1500 + 10], [1500 + 10, 1300 + 10], [1500 + 10, -1500 - 10]]);
    }
  }
}

module bottom() {
  color([32/255, 32/255, 96/255])
  difference() {
    bottom_top_base();
    translate([-overall_width/2 + t * 2 + d + 2 + 2, overall_height/2 - t*2, 0]) {
      rotate([0, 0, -90]) 
      linear_extrude(height=t*2, center=true)
      mil_to_mm()
      for (xy = [[550, 100], [600, 2000], [2600, 300], [2600, 1400]]) {
        translate([xy[0], xy[1], 0]) circle(r=125/2);
      }
    }
  }
}

module front_back_base() {
  difference() {
    union() {
      cube(size=[overall_width, inside_height, t], center=true);
      for(x=[-2:2], y=[-1,1]) {
        translate([x * (overall_width/5), y * inside_height / 2, 0]) cube(size=[tab_width, t*2, t], center=true);
      }
    }

    for(x=[-1,1], y=[-1,1]) {
      translate([x * (overall_width - t*3)/2, y * inside_height / 4, 0]) cube(size=[t, tab_width, t*2], center=true);
    }

    for (x=[-1,1]) {
      translate([x * (overall_width / 2 - t - t / 2), 0, 0]) cylinder(r=d/2+0.1, h=t*2, center=true, $fn=36);
    }
  }
}


module back() {
  difference() {
    front_back_base();
    // translate([0, inside_height/2 + washer_t + pcb_t + 450/1000 * 25.4 / 2, 0]) {
    translate([0, -inside_height/2 + washer_t + pcb_t + 450/1000 * 25.4 / 2, 0]) {
      translate([-overall_width / 2 + t*2 + d + 2 + 2 + 0.1 * 25.4 + 350/1000*25.4/2, 0, 0]) 
        cube(size=[400/1000 * 25.4, 475/1000 * 25.4 + 2, t*2], center=true);

      translate([-overall_width / 2 + t*2 + d + 2 + 2 + 1275/1000 * 25.4 + 450/1000*25.4/2, 0, 0]) 
        cube(size=[500/1000 * 25.4, 475/1000 * 25.4 + 2, t*2], center=true);
    }

    // hole for the prog-enable switch
    translate([-mm(587), inside_height/2 - 2 - mm(587)/2, 0]) {
      cylinder(r=mm(386)/2+0.1, h=t*2, center=true, $fn=72);
      translate([0, mm(386)/2, 0]) cube(size=[mm(58), mm(429-386)*2, t*2], center=true);
    }
  }
}

module front() {
  color([128/255, 128/255, 128/255])
  render()
  difference() {
    front_back_base();
  }
}

module side() {
  color([32/255, 0/255, 32/255])
  render()
  difference() {
    union() {
      cube(size=[overall_height - t*4, inside_height, t], center=true);
      for(x=[-1:1], y=[-1,1]) {
        translate([x * (overall_height/3), y * inside_height / 2, 0]) cube(size=[tab_width, t*2, t], center=true);
      }

      for(x=[-1,1], y=[-1,1]) {
        translate([x * (overall_height - t*4)/2, y * inside_height / 4, 0]) cube(size=[t*2, tab_width, t], center=true);
      }
    }
    for(x=[-1,1]) {
      translate([x * (overall_height / 2 - t*2), 0, 0]) {
        cube(size=[25.4, d, t*2], center=true);
      }
      translate([x * (overall_height / 2 - t*2 - 8), 0, 0]) cube(size=[3, d*2, t*2], center=true);
    }
  }
}

module assembled() {
  pogo_assembly();
  translate([0, 0, t/2]) %top();
  translate([0, 0, t + t/2]) board_frame();

  translate([-overall_width / 2 + t * 2 + d + 2 + 2, overall_height/2 - t * 2, -inside_height + pcb_t/2 + washer_t]) rotate([0, 0, -90]) controller_package();
  translate([0, 0, -inside_height - t/2]) bottom();

  translate([overall_width/2 - t * 2 - d - 2 - 5 - 2, 0, 0]) rotate([0, 0, -90]) led_board_assembly();
  // "go" button
  translate([overall_width/2 - t * 2 - d - 2 - 5 - 10, -(overall_height/2 - t*2 - 5 - mm(397)/2), 0]) small_momentary();

  translate([0, 0, t]) for (x=[-1:1], y=[-1:1]) {
    if (!(x == 0 && y == 0)) {
      translate([x * (overall_width / 2 - t * 2 - 2 - d/2), y * (overall_height / 2 - t * 2 - 2 - d/2), 0]) _screw(2, 4, d, closing_screw_len);
    }
  }

  translate([0, 0, -inside_height/2]) {
    translate([0, overall_height/2 - t - t/2, 0]) rotate([90, 0, 0]) back();

    for (x=[-1,1]) {
      translate([x * (overall_width/2 - t - t/2), 0, 0]) rotate([90, 0, 90]) side();
    }

    translate([0, -overall_height/2 + t + t/2, 0]) rotate([90, 0, 0]) %front();
  }

  // "prog-enable" switch
  translate([-mm(587), overall_height/2 - t, - 2 - mm(587)/2]) rotate([-90, 0, 0]) toggle_button();
}

// assembled();

! projection(cut=true) {
  // top();
  // bottom();
  // side();
  // front();
  // back();
  board_frame();
}
