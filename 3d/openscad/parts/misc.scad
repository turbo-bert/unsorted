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

module servo() { 
    servo_carson_cs3(); 
}

module servo_carson_cs3(show_cross=true) {
    union() {
        // gehaeuse
        cube([40, 20, 33.3], center=false);
        
        // servo kreuz
        color("red") translate([10-21,6,42]) cube([42, 8, 2.5], center=false);
        color("red") translate([8+6,10-22.5,42]) rotate([0,0,90]) cube([45, 8, 2.5], center=false);
        
        // platte (rund) servodeckel
        translate([6+4,10,36.3-1]) cylinder(h=3, d=12, center=false, $fn=50);
        // achse
        color("black") translate([6+4,10,1]) cylinder(h=44, d=4, center=false, $fn=50);
        // platte oben
        translate([2,2,32.3]) cube([36, 16, 4], center=false);
        // kasten fuer kabel
        translate([-8,5.75,0]) cube([10, 8.5, 7], center=false);
        difference() {
            // befestigungsplatte
            translate([-55.6/2+40/2,0,25.4]) cube([55.6, 20, 3.6], center=false);
            // hauptbohrloecher
            translate([-4.5,+4.5,0]) cylinder(h=100, d=4.6, center=true, $fn=50);
            translate([-4.5,20-+4.5,0]) cylinder(h=100, d=4.6, center=true, $fn=50);
            translate([-4.5+40+4.5+4.5,+4.5,0]) cylinder(h=100, d=4.6, center=true, $fn=50);
            translate([-4.5+40+4.5+4.5,20-+4.5,0]) cylinder(h=100, d=4.6, center=true, $fn=50);
            translate([-15, 4.5-1.25,22]) cube([10,2.5,10], center=false);
            translate([-15, 20-4.5-1.25,22]) cube([10,2.5,10], center=false);
            translate([44, 4.5-1.25,22]) cube([10,2.5,10], center=false);
            translate([44, 20-4.5-1.25,22]) cube([10,2.5,10], center=false);
        }
    }
}

// fits perfect! bore is too small for M4 drill
module servo_mount(h=2, w=8, helpers=false, osd=0, osb=7.2, osc=0, d=3.3) {
    difference() {
        union() {
            translate([-10,-w,0]) cube([60,w,h]);
            translate([-10,0,0]) cube([9,20,h]);
            translate([41,0,0]) cube([9,20,h]);
            if (helpers == true) {
                color("red") translate([10,10,0]) cylinder(d=2, h=100, center=true, $fn=40);
                color("red") translate([30,10,0]) cylinder(d=2, h=100, center=true, $fn=40);
            }
            if (osd > 0) {
                translate([osc,0,0]) difference() {
                    translate([20,-w/2,h/2]) rotate([90,0,0]) sportplatz(h=w,l=osd+osb+6, d=osb+6);
                    translate([20-osd/2,0,h/2]) rotate([90,0,0]) cylinder(d=osb, h=100, center=true, $fn=40);
                    translate([20+osd/2,0,h/2]) rotate([90,0,0]) cylinder(d=osb, h=100, center=true, $fn=40);
                }
            }
        }
        translate([-5+0.5,   4.5+1,0]) cylinder(d=d, h=100, center=true, $fn=40);
        translate([-5+0.5,   4.5+11,0]) cylinder(d=d, h=100, center=true, $fn=40);
        translate([+5+40-0.5,4.5+1,0]) cylinder(d=d, h=100, center=true, $fn=40);
        translate([+5+40-0.5,4.5+11,0]) cylinder(d=d, h=100, center=true, $fn=40);
    }
}






























module fischert() {
    union() {
        translate([0,0,-1]) cube([15,30,2], center=true); // base plate

        a=2.8284; // cube diagonal 4, so 4**2 = a**2 + a**2, sqrt(8) = a
        cube([2.5,30,2.5], center=true);
        translate([0,0,-1]) translate([0,0,-0.5+2.5]) difference() {
            rotate([0, 45, 0]) cube([a, 30, a], center=true); // 3mm lower socket
            translate([0,0,(a/2)+0.5]) rotate([0, 0, 0]) cube([2*a, 31, a], center=true);
            translate([0,0,(a/2)-4]) rotate([0, 0, 0]) cube([2*a, 31, a], center=true);
        }
    }
}

module fischert15() {
    intersection() {
        rotate([90,0,0]) fischert();
        cube([15,15,15], center=true);
    }
}

module fischert_plate60120() {
    difference() {
        cube([60,120,7.5]);
        translate([31, 2, 7.5/2]) rotate([0, 90, 0]) cylinder(r=2, h=62, center=true, $fn=20);
        translate([31, 120-2, 7.5/2]) rotate([0, 90, 0]) cylinder(r=2, h=62, center=true, $fn=20);
        union () {
            for (i=[0:16]) {
                translate([0,i*(3.25+4),0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
                
                if ((i-2)%2==0 && i != 0 && i != 16) translate([-15,i*(3.25+4)-2,0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
                if ((i-2)%2==0 && i != 0 && i != 16) translate([-15,i*(3.25+4)+2,0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
                if ((i-2)%2==0 && i != 0 && i != 16) translate([-15,i*(3.25+4),0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
                
                if ((i-2)%2==0 && i != 0 && i != 16) translate([15,i*(3.25+4)-2,0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
                if ((i-2)%2==0 && i != 0 && i != 16) translate([15,i*(3.25+4)+2,0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
                if ((i-2)%2==0 && i != 0 && i != 16) translate([15,i*(3.25+4),0]) translate([30,2,-15+(7.5/2)]) cylinder(r=2, h=30, center=false, $fn=20);
            }
        }
        translate([-0.0001,0,0.0001]) union() {
            for (i=[0:7])
                translate([7.5,7.5+(i*15),7.5]) rotate([90, 0, 0]) rotate([0, 90, 0]) fiha_15();
        }
        translate([45.0001,0,0.0001]) union() {
            for (i=[0:7])
                translate([7.5,7.5+(i*15),7.5]) rotate([90, 0, 0]) rotate([0, 90, 0]) fiha_15();
        }
    }
}

// l in { 50, 60, 80, 90, 110, 125, 150, 170, 200, 235, 260, 450 }
module fischert_axleZ(l=50, center=true, drill_f=1.0) {
    cylinder(d=4*drill_f, h=l, center=center, $fn=20);
}

module fischert_axleY(l=50, center=true, drill_f=1.0) {
    rotate([-90,0,0]) fischert_axleZ(l=l, center=center, drill_f=drill_f);
}

module fischert_axleX(l=50, center=true, drill_f=1.0) {
    rotate([0,90,0]) fischert_axleZ(l=l, center=center, drill_f=drill_f);
}


module rampX(h=20, l=50, w=5, centerW=true) {
    if (centerW) {
        translate([0,w/2,0]) rotate([90,0,0]) linear_extrude(height=w) polygon(points=[[0,0], [l,0], [l,h]]);
    }
    else {
        translate([0,w/2,0]) rampX(h=h, l=l, w=w, centerW=true);
    }
}

module rampY(h=20, l=50, w=5,centerW=true) {
    rotate([0,0,90]) rampX(h=h,l=l,w=w,centerW=centerW);
}
module screw(head_d=13, head_h=9, thread_length=30, l=50, d=8, drill_f=1.0) {
    color("red") translate([0,0,-thread_length/2-(l-thread_length)]) cylinder(d=d*drill_f, h=thread_length, center=true, $fn=50); // thread
    translate([0,0,-(l-thread_length)/2]) cylinder(d=d*drill_f, h=l-thread_length, center=true, $fn=50); // nothread
    difference() {
        translate([0,0,head_h/2]) cylinder(d=head_d, h=head_h, center=true, $fn=50); // head
        translate([0,0,head_h+0.2*head_h]) cylinder(d=head_d*2/3, h=head_h, center=true, $fn=50); // head
    }
}

module nutM8() {
    h=7;
    m=8;
    mc=15;
    difference() {
        translate([0,0,-h/2]) cylinder(d=mc, h=h, $fn=6, center=true);
        translate([0,0,-h/2]) cylinder(d=m, h=h+1, $fn=50, center=true);
    }
}

module nutM3() {
    h=2.5;
    m=3;
    mc=6.1;
    difference() {
        translate([0,0,-h/2]) cylinder(d=mc, h=h, $fn=6, center=true);
        translate([0,0,-h/2]) cylinder(d=m, h=h+1, $fn=50, center=true);
    }
}

module screwM8L50(drill_f=1.0) {
    screw(drill_f=drill_f);
}

module screwM3L50(drill_f=1.0) {
    screw(head_d=6, head_h=3, thread_length=18, l=50, d=3, drill_f=drill_f);
}

module screwM3L20(drill_f=1.0) {
    screw(head_d=6, head_h=3, thread_length=20, l=20, d=3, drill_f=drill_f);
}

module screwBlock(a=8, d=4.5) {
    translate([0,0,a/4]) difference() {
        cube([a,a,a/2], center=true);
        cylinder(d=d, h=100, $fn=50, center=true);
    }
}
// Create a Frame out of cubes.
module simpleframe(oX=100, oY=50, pX=1, pZ=8, center=false) {
    if (center == false) {
        translate([oX/2,oY/2,pZ/2]) simpleframe(oX, oY, pX, pZ, center=true);
    }
    else {
        difference() {
            cube([oX, oY, pZ], center=true);
            cube([oX-2*pX, oY-2*pX, pZ+1], center=true);
        }
    }
}

module simplebox(oX=100, oY=50, oZ=20, wall=1, center=false) {
    if (center == false) {
        union() {
            simpleframe(oX, oY, wall, oZ, center=false);
            cube([oX, oY, wall], center=false);
        }
    }
    else {
        translate([-oX/2,-oY/2,-oZ/2]) simplebox(oX, oY, oZ, wall=wall, center=false);
    }
}

module pillar_helper(d=4, h=15, over_lap=1, for_cut=false) {
    union() {
        a=10;
        if (for_cut == false) translate([0,-(h+over_lap)/2,a/2]) cube([a, h+over_lap, a], center=true);
        if (for_cut == true) translate([0,0,a/2]) rotate([90,0,0]) cylinder(d=d, h=4*h, center=true);
    }
}
module reiner_one_shape(d=11, h=11, card=false, usb=false) {
    union() {
        if (card) {
            translate([(68-53.98)/2,114,2]) card_iso7816_card1();
            translate([(68-53.98)/2,114,3]) card_iso7816_card1();
        }
        if (usb) {
            translate([-5,30,h/2]) cube([10, 20, h], center=true);
        }
        difference() {
            cube([68, 114, h]);
            translate([7, 74, -1]) cube([55, 23, h+2]);
            translate([8+0*13.6, 9.5+0*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // ^
            translate([8+1*13.6, 9.5+0*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 0
            translate([8+2*13.6, 9.5+0*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // ,
            translate([8+3*13.6, 9.5+0*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // OK
            translate([8+0*13.6, 9.5+1*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 7
            translate([8+1*13.6, 9.5+1*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 8
            translate([8+2*13.6, 9.5+1*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 9
            translate([8+3*13.6, 9.5+1*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // SETTINGS
            translate([8+0*13.6, 9.5+2*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 4
            translate([8+1*13.6, 9.5+2*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 5
            translate([8+2*13.6, 9.5+2*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 6
            translate([8+3*13.6, 9.5+2*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // CLR
            translate([8+0*13.6, 9.5+3*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 1
            translate([8+1*13.6, 9.5+3*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 2
            translate([8+2*13.6, 9.5+3*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // 3
            translate([8+3*13.6, 9.5+3*13, 0]) translate([11/2, 11/2, 0]) cylinder(d=d, h=2*h+1, center=true, $fn=50); // C
        }
    }
}

module card_grabber_snapper() {
    translate([0,0,10]) difference() {
        union() {
            translate([4,0,35]) cube([25, 70, 50], center=true);
            translate([26.25,0,60]) cube([69.5, 70, 20], center=true);

            
            translate([70,0,65]) cube([30, 40, 10], center=true);
            
            translate([40,-32, 51]) rotate([180,0,180]) rampX(l=30,h=30, w=2);
            translate([40,+32, 51]) rotate([180,0,180]) rampX(l=30,h=30, w=2);

            translate([80,-19, 65]) rotate([180,0,180]) rampX(l=20,h=15, w=2);
            translate([80,+19, 65]) rotate([180,0,180]) rampX(l=20,h=15, w=2);

        }
        translate([-11, 0,40]) cube([20,40,100], center=true); // cut U in snapper
        translate([24,-15,40]) translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);
        translate([24,+15,40]) translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);

        translate([56,-25,40]) translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);
        translate([56,+25,40]) translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);

        translate([68,-10,40]) translate([0,0,-1]) cylinder(d=3.5, h=52, $fn=50);
        translate([68,+10,40]) translate([0,0,-1]) cylinder(d=3.5, h=52, $fn=50);
        translate([68+10,-10,40]) translate([0,0,-1]) cylinder(d=3.5, h=52, $fn=50);
        translate([68+10,+10,40]) translate([0,0,-1]) cylinder(d=3.5, h=52, $fn=50);

    }


}

module card_grabber() {
    union() {
        difference() {
            translate([0,0,10]) rotate([180,0,0]) translate([-85,-53.98/2,-8]) difference() {
                translate([85,-5,8]) cube([20, 53.98+10, 10]);
                card_iso7816_card1(only_bad=true);
                translate([80,-10,0]) rotate([0,0,45]) cube([20,20,100], center=true);
                translate([80,53.98+10,0]) rotate([0,0,45]) cube([20,20,100], center=true);
            }
            translate([10,0,0]) cube([15,20,100], center=true);
        }
        translate([40,0,5]) cube([40,5,10], center=true);
        translate([40,-20,5]) cube([40,5,10], center=true);
        translate([40,+20,5]) cube([40,5,10], center=true);
        
        translate([56,-25,0]) difference() {
            cylinder(d=10, h=50, $fn=50);
            translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);
        }
        translate([56,+25,0]) difference() {
            cylinder(d=10, h=50, $fn=50);
            translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);
        }

        translate([24,-15,0]) difference() { // snapper ski front
            cylinder(d=10, h=30, $fn=50);
            translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);
        }
        translate([24,+15,0]) difference() { // snapper ski back
            cylinder(d=10, h=30, $fn=50);
            translate([0,0,-1]) cylinder(d=4.5, h=52, $fn=50);
        }
        
        translate([25,-27,0]) screwBlock(a=10, d=3.5);
        translate([25,+27,0]) screwBlock(a=10, d=3.5);
        translate([47,-27,0]) screwBlock(a=10, d=3.5);
        translate([47,+27,0]) screwBlock(a=10, d=3.5);

        difference() {
            translate([60,0,25]) cube([2,50,50], center=true);
            translate([58,-12,40+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,+12,40+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,-12,28+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,+12,28+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,-12,16+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,+12,16+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,-12, 4+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
            translate([58,+12, 4+2]) rotate([0,-90,0]) screwM3L20(drill_f=1.1);
        }
        
        translate([20,0,9]) rampX(l=40,h=40, w=2);
        translate([20,-20,9]) rampX(l=40,h=40, w=2);
        translate([20,+20,9]) rampX(l=40,h=40, w=2);
    }
}

module card_iso7816_card1(h=0.8, l=85.6, w=53.98, chip=false, fix=true, only_bad=false, only_ceiling=false) {

    if (only_bad) {
        difference() {
            union() {
                translate([70,-5,-3]) cube([32,w+10, 10], center=false);
                translate([94,w/2-20,10]) cylinder(d1=15, d2=1, $fn=50, h=10, center=true);
                translate([94,w/2+20,10]) cylinder(d1=15, d2=1, $fn=50, h=10, center=true);
            }
            margin=1;
            translate([0,-margin/2,0]) card_iso7816_card1(h=10, fix=false, l=l, w=w+margin);
            d=5.5;
            translate([-d/2+l-8.1,17.4+d/2,0]) cylinder(d=d, h=20, center=true, $fn=50);
        }
    }
    else
    {
        if (only_ceiling) {

        }
        else {
            difference() {
                union() {
                    translate([0,w,0]) rotate([0,0,-90]) cube([w, l, h], center=false);
                    if (chip) {
                        color("yellow") translate([9,36-12.5,0.1]) cube([13.5,12.5,h], center=false);
                    }
                }
                if (fix) {
                    d=5.5;
                    translate([-d/2+l-8.1,17.4+d/2,0]) cylinder(d=d, h=20, center=true, $fn=50);
                }
            }
        }
    }
}

//module ski() {
//    difference() {
//        cube([75,16,40], center=false);
//        translate([8,8,0]) cylinder(h=100, d=8, center=true, $fn=50);
//        translate([24,0,8]) rotate([90,0,0]) cylinder(h=100, d=8, center=true, $fn=50);
//        translate([24,0,40-8]) rotate([90,0,0]) cylinder(h=100, d=8, center=true, $fn=50);
//        translate([75,0,20]) rotate([90,0,0]) cylinder(h=100, d=4, center=true, $fn=50);
//        translate([40,0,20]) rotate([90,0,0]) cylinder(h=100, d=4, center=true, $fn=50);
//    }
//    
//}
//ski();
//translate([150,16,0]) rotate([0,0,180]) ski();
module card_funnel_helper() {
    
    intersection() {
    // 0 0  50 0  50 30  0 2
    union() {
        translate([0,43+15/2,0]) rotate([90,0,0]) linear_extrude(h=84) polygon(points=[[0,0],[50,0],[50,30],[0,0.6]]);
        rotate([180,0,0]) translate([0,42+15/2,0]) rotate([90,0,0]) linear_extrude(h=84) polygon(points=[[0,0],[50,0],[50,30],[0,0.6]]);
    }
    
    // 0 0 50 0 50 15
    
    
    union() {
        color("red") translate([0,56/2,-50]) linear_extrude(h=100) polygon(points=[[0,0],[50,0],[50,15]]);
        color("red") rotate([180,0,0]) translate([0,56/2,-50]) linear_extrude(h=100) polygon(points=[[0,0],[50,0],[50,15]]);
        color("red") translate([25,0,0]) cube([50,56,84], center=true);
    }
}
}


module funnel() {
    union() {
        
        difference() {
            color("green") translate([20,0,0]) cube([40,100,80], center=true);
            card_funnel_helper();
            translate([28,0,0]) cube([35,200,200], center=true);
        }
        translate([-7.5,0,2.5]) cube([15, 74, 3], center=true);
    }
}
// Nema 17 Stepper Motor Assistive Elements

// https://cdn-shop.adafruit.com/product-files/324/C140-A+datasheet.jpg

// axis pointing up/z
module nema17_blockX(drill=false, mount=0) {
    rotate([0,90,0]) nema17_blockZ(drill=drill, mount=mount);
}

module nema17_blockY(drill=false, mount=0) {
    rotate([-90,0,0]) nema17_blockZ(drill=drill, mount=mount);
}

module nema17_blockZ(drill=false, mount=0) {
    if (mount == 0) {
        translate([0,0,-25]) union() {
            difference() {
                union () {
                    translate([0,0,-17]) cube([42.3, 42.3, 34], center=true);
                    translate([0,0,12.5]) cylinder(d=5, h=25, $fn=50, center=true);
                    translate([0,0,1]) cylinder(d=22, h=2, $fn=50, center=true);
                }

                translate([-31/2,-31/2,0]) cylinder(d=3, h=200, $fn=50, center=true); // front left
                translate([+31/2,-31/2,0]) cylinder(d=3, h=200, $fn=50, center=true); // front right
                translate([-31/2,+31/2,0]) cylinder(d=3, h=200, $fn=50, center=true); // back left
                translate([+31/2,+31/2,0]) cylinder(d=3, h=200, $fn=50, center=true); // back right
                a=7;
                translate([+42.3/2, -42.3/2,0]) rotate([0,0,45]) cube([a,a,100], center=true);
                translate([-42.3/2, -42.3/2,0]) rotate([0,0,45]) cube([a,a,100], center=true);
                translate([+42.3/2, +42.3/2,0]) rotate([0,0,45]) cube([a,a,100], center=true);
                translate([-42.3/2, +42.3/2,0]) rotate([0,0,45]) cube([a,a,100], center=true);
            }
            if (drill == true) {
                translate([0,0,12.5]) cylinder(d=5, h=250, $fn=50, center=true);
                translate([0,0,5]) cylinder(d=22, h=10, $fn=50, center=true);
                translate([-31/2,-31/2,0]) cylinder(d=3.5, h=200, $fn=50, center=true); // front left
                translate([+31/2,-31/2,0]) cylinder(d=3.5, h=200, $fn=50, center=true); // front right
                translate([-31/2,+31/2,0]) cylinder(d=3.5, h=200, $fn=50, center=true); // back left
                translate([+31/2,+31/2,0]) cylinder(d=3.5, h=200, $fn=50, center=true); // back right
            }
        }
    }

    if (mount > 0) {
        difference() {
            color("red") translate([0,0,mount/2-25]) cube([42.3, 42.3, mount], center=true);
            nema17_blockZ(drill=true, mount=0);
        }

    }

}

module nema17_mount() {
    
}


module gt2_belt_pulley(d1=20, h1=7, d2=40, h2=11, d3=36, h3=7, m=8, belt1=false, belt_angle1=0, belt_length1=100, belt2=false, belt_angle2=0, belt_length2=100) {
    translate([0,0,-h1-h2]) union() {

    difference() {
        union() {
            translate([0,0,(h1+h2)/2]) cylinder(d=d1, h=h1+h2, center=true, $fn=100); // achse mit schrauben
            translate([0,0,h1+h2/2]) cylinder(d=d2, h=h2, center=true, $fn=100); // laufrad ohne aussparung
            
        }
        difference() {
            translate([0,0,h3/2+h1+(h2-h3)/2]) cylinder(d=d2+1, h=h3, center=true, $fn=100); // aussparung aber größer als laufrad
            translate([0,0,h3/2+h1+(h2-h3)/2]) cylinder(d=d3, h=h3, center=true, $fn=100); // aussparung
        }
        cylinder(d=m, h=3*(h1+h2), center=true, $fn=50);
    }
    if (belt1) {
        //rotate([0,0,belt_angle1]) translate([belt_length1/2,d3/2+0.50,h3/2+h1+(h2-h3)/2]) cube([belt_length1, 1, 7], center=true);
        rotate([0,0,belt_angle1]) translate([belt_length1/2,d3/2+1+0.50,h3/2+h1+(h2-h3)/2]) cube([belt_length1, 1, 7], center=true);
        rotate([0,0,belt_angle1]) translate([0,d3/2+0.50,h3/2+h1+(h2-h3)/2]) union() {
            for (i=[1:belt_length1-1]) {
                if (i%2==0) translate([i,0,0]) cube([1, 1, 7], center=true);
            }
        }
    }
    if (belt2) {
        //rotate([0,0,belt_angle2]) translate([belt_length2/2,(-1)*(d3/2+0.50),h3/2+h1+(h2-h3)/2]) cube([belt_length2, 1, 7], center=true);
        rotate([0,0,belt_angle2]) translate([belt_length2/2,(-1)*(d3/2+1+0.50),h3/2+h1+(h2-h3)/2]) cube([belt_length2, 1, 7], center=true);
        rotate([0,0,belt_angle2]) translate([0,d3/2+0.50,h3/2+h1+(h2-h3)/2]) union() {
            for (i=[1:belt_length2-1]) {
                if (i%2==0) translate([i,-d3-1,0]) cube([1, 1, 7], center=true);
            }
        }
    }
    }
}

module pulleyGT2M5T16 () {
    gt2_belt_pulley(d1=13, h1=5, d2=13, h2=9, d3=9, h3=7, m=5, belt1=true);
}

module pulleyGT2M8T60 () {
    gt2_belt_pulley();
}

module pulleyGT2M8T20 () {
    gt2_belt_pulley(d1=16, h1=6, d2=16, h2=10, d3=12, h3=7, m=8, belt1=true);
}

module gt2rack_twin(t=15, w=7, h=10, bore=3.5) {
    difference() {
        union() {
            gt2rack(t=t, w=w, h=h, center=false);
            translate([0,-h,w]) rotate([180,0,0]) gt2rack(t=t, w=w, h=h, center=false);
        }
        if (bore>0) {
            translate([h,-h/2,0]) cylinder(d=bore, h=3*w, $fn=50, center=true);
            translate([h*2,-h/2,0]) cylinder(d=bore, h=3*w, $fn=50, center=true);
            translate([2*t-h,-h/2,0]) cylinder(d=bore, h=3*w, $fn=50, center=true);
            translate([2*t-h*2,-h/2,0]) cylinder(d=bore, h=3*w, $fn=50, center=true);
        }    
    }
}

module gt2rack_twinmount() {
    
}

module gt2rack(t=15, w=7, h=5, center=true) {
    if (center) {
        rotate([90,0,0]) translate([-t/2*2,h/2,-w/2]) gt2rack(t=t, w=w, h=h, center=false);
    }
    else {
        union() {
            l=100;
            for (i=[0:t-1]) {
                translate([i*2,0,0]) linear_extrude(height=w, center=false) polygon(points=[ [0,0], [1.5,0], [0.81, 0.81], [1.5-0.81,0.81] ]);
            }
            translate([0,-h,0]) cube([2*t, h, w]);
        }    
    }
}
