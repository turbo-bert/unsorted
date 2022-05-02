include <parts/all.scad>;

// modul 3 teeth 10 height 10
gear(m=3, t=10, h=10);

// standard servo (not micro)
translate([50,0,0]) servo();
