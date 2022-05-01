// file parts/misc.scad

module din_rail(l=1000, center=false) {
    if (center==true) {
        translate([-l/2,-7.5/2,-35/2]) din_rail(l=l, center=false);
    }
    else {
        renderc=0.1;
        cutw=4;
        h=7.5;
        th=1;
        rotate([90,0,0])
        translate([0,0,-h])
        difference() {
            cube([l,35,7.5]);
            translate([-renderc,th+cutw,th]) cube([l+2*renderc,35-2*th-2*cutw,h-th+renderc]);
            translate([-renderc,-renderc,-renderc]) cube([l+2*renderc,cutw+renderc,7.5-th+renderc]);
            translate([-renderc,35-cutw,-renderc]) cube([l+2*renderc,cutw+renderc,7.5-th+renderc]);
            c=l/25-1;
            for (i=[1:c]) {

                translate([i*25,35/2,0]) sportplatz(d=5.2, l=18, center=true, h=h);
            }
        }

    }
}


module sportplatz(d=5, l=10, h=25, center=true) {
    union() {
        cube([l-d, d, h], center=true);
        translate([-l/2+d/2,0,0]) cylinder(d=d, h=h, $fn=50, center=true);
        translate([+l/2-d/2,0,0]) cylinder(d=d, h=h, $fn=50, center=true);
    }    
}
