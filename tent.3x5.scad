
extrude_height=5;
tent_angle=[0,25,0];
negative_tent_angle=[-tent_angle[0], -tent_angle[1], -tent_angle[2]];
tent_cutout_z=30;
post_height=0;

// radius, rotate,    scale,       translate
cutouts = [
    [50, [0, 0, 0],   [1, 1, 1],   [-123, 66, 0]],
    [40, [0, 0, 0],   [1, 1, 1],   [-60, -56, 0]],
    [20, [0, 0, -10], [1.8, 1, 1], [-25, 20, 0]],
    [20, [0, 0, 25],  [0.5, 1, 1], [55, 10, 0]]
];

main();

module tentBody() {
    difference() {
        translate([-8.8,0,0])
            linear_extrude(height=extrude_height, center=true, convexity=10)
            import(file = "kyria-postless.dxf", $fn=100, convexity=10);

        translate([0, -20, -3])
            cube([128, 200, 5]);
    }
    
}

module tentPosts() {
    translate([-11, 0, extrude_height/2]) difference() {
        linear_extrude(height=extrude_height, center=true, convexity=10)
            import(file="kyria-postless.dxf", $fn=100);
        linear_extrude(height=extrude_height, center=true, convexity=10)
            import(file="kyria-posted.dxf", $fn=100);
        translate([0, -20, -3])
            cube([128, 200, extrude_height+5]);
       
    }
}

module cutout(inputs) {
    rotate(inputs[1]) 
        scale(inputs[2]) 
        translate(inputs[3])
        cylinder(h=150, r=inputs[0], center=true, $fn=100);
}

module main() {
    difference() {
        union() {
            translate([0,0,-(post_height+0.1)])
                rotate(a=tent_angle)
                tentPosts();

            difference() {
                linear_extrude(100)
                    projection(cut = false)
                    rotate(a=tent_angle)
                    tentBody();
                rotate(a=tent_angle)
                    translate([-250,-80,0])
                    cube([250, 350, 100]);    
            }
        }

        translate([0, -25, -1])
            cube([200, 150, 50]);
        
        for (params=cutouts) {
            cutout(params);
        }
    }
}
