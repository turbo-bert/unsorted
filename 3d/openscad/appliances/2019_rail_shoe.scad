module rail_x () {
    difference() {
    cube([20,32,20], center=true);
    translate([10,0,-6]) rotate([0,90,0]) cylinder(r=6, h=20, center=true, $fn=100);
    translate([0,-6,-25]) cube([10,12,20], center=false);
    translate([0,-16+2+3,0]) cylinder(r=2, h=100, $fn=40, center=true);
    translate([0,22-16+2+3,0]) cylinder(r=2, h=100, $fn=40, center=true);
    }
};

module rail_x_print4 () {
    rail_x();
    translate([0,-40,0]) rail_x();
    translate([0,-80,0])  rail_x();
    translate([0,-120,0]) rail_x();
    translate([-5,-120,-10]) cube([2,120,2], center=false);
};

module sled_x() {
    
};

module abec7 () {
    rotate([90,0,0])
    difference() {
        cylinder(r=11, h=7, center=true, $fn=50);    
        cylinder(r=4, h=8, center=true, $fn=50);    
    }
};


module abec7_cut(a=200) {
    union() {
        //abec7();
        rotate([90,0,0]) cylinder(r=4, h=a, center=true, $fn=50);
    }
};



module abec7_mount_45_30() {
rotate([0,45,0]) difference() {
    cylinder(r=6, h=30, $fn=50, center=true);
    cylinder(r=4, h=100, $fn=50, center=true);
    }
};

module sled_wheel () {
translate([0,0,5]) union() {
 abec7_mount_45_30();
 //translate([-12,0,-12]) rotate([90,45,0]) abec7_axed();
}
};


module sled_axe() {
 union() {
                                      sled_wheel();
translate([0,15,0]) rotate([0,0,180]) sled_wheel();
}
 
 }   ;
module sled() {
difference() {
    
union() {

// 2: 9mm for 12mm steel pipes $$id:05a8db5f-0ef1-428f-a486-9b33a800d4e1$$
translate([0, 30, 4.5+2])  rotate([0,90,0]) cylinder(r=4.5, h=40, center=true, $fn=50);
translate([0, 168, 4.5+2]) rotate([0,90,0]) cylinder(r=4.5, h=40, center=true, $fn=50);


// 10 mm schiene über die länge
translate([-6.5,100,20]) cube([2, 100, 11], center=true);
translate([ 6.5,100,20]) cube([2, 100, 11], center=true);

                     sled_axe();
translate([0,180,0]) sled_axe();
translate([0,100,7]) cube([18,215,18], center=true);
}

// cut out 2 items from $$ref:05a8db5f-0ef1-428f-a486-9b33a800d4e1$$
translate([0, 30, 4.5+2])  rotate([0,90,0]) cylinder(r=2, h=42, center=true, $fn=50);
translate([0, 168, 4.5+2]) rotate([0,90,0]) cylinder(r=2, h=42, center=true, $fn=50);

// 4 mm borhloch vorne für magnet
translate([0,-8+50,0]) cylinder(r=2, h=100, center=true, $fn=50);
// 4 mm borhloch hinten für magnet
translate([0,-8+215-50,0]) cylinder(r=2, h=100, center=true, $fn=50);

// 8 mm borhloch vorne für sled/y
translate([0,50+20,0]) cylinder(r=4, h=100, center=true, $fn=50);
// 8 mm borhloch hinten für sled/y
translate([0,50+100-20,0]) cylinder(r=4, h=100, center=true, $fn=50);

// al will be cut for the axes
                                      translate([0,0,5]) translate([-12,0,-12]) rotate([90,45,0]) abec7_cut();
translate([0,15,0]) rotate([0,0,180]) translate([0,0,5]) translate([-12,0,-12]) rotate([90,45,0]) abec7_cut();
translate([0,180,0])                                       translate([0,0,5]) translate([-12,0,-12]) rotate([90,45,0]) abec7_cut();
translate([0,180,0]) translate([0,15,0]) rotate([0,0,180]) translate([0,0,5]) translate([-12,0,-12]) rotate([90,45,0]) abec7_cut();
}
    
};

//projection(cut=true) translate([0,0,-6.5])
sled();
//projection(cut=true) sled();
//rotate([90,45,0]) abec7_axed();
//abec7_mount_45_30();
//translate([0,100,-19]) rotate([90,0,0]) cylinder(r=6,h=200,$fn=50,center=true);
