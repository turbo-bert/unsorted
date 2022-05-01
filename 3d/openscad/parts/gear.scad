// file parts/gear.scad


module gear(m=8, h=10, t=5) {
    x=str("parts/gear/m8/gear-modul8-",str(t),".svg");
    linear_extrude(height=h) import(str("parts/gear/m",str(m),"/gear-modul",str(m),"-t",str(t),".svg"), center=true);

}

//module tooth_gear(m=8,h=10) {
//intersection() {
//    
//       translate([2*m,0,0]) cube([3*m,m*2,4*h], center=true);
//       gear(m=m, t=5, h=h) ;
//}
//}
//

module speiche(h=10, r_from=15, r_to=30, cut_deg=15, space_deg=5, limit=100) {
    step_rot=cut_deg+space_deg;
    steps=360/(cut_deg+space_deg);
    union() {
        for (i=[0:steps-1]) {
            if (i<limit) {
                rotate([0,0,i*step_rot]) difference() {
                    cylinder(d=2*r_to,h=h,center=true,$fn=120);
                    translate([0,-(r_to*2+2)/2,0]) cube([r_to*2+2,r_to*2+2,h+2], center=true);
                    rotate([0,0,-180+cut_deg]) translate([0,-(r_to*2+2)/2,0]) cube([r_to*2+2,r_to*2+2,h+2], center=true);
                    cylinder(d=2*r_from,h=h+2,center=true,$fn=120);
                }
            }
        }
    }
}
