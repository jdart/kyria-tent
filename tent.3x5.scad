tent_angle=6;
tent_rotate=[0,tent_angle,0];
post_height=5;
offset_x=-8.8;

// radius, rotate,    scale,       translate
cutouts = [
    [50, [0, 0, 0],   [1, 1, 1],   [-123, 66, 0]],
    [40, [0, 0, 0],   [1, 1, 1],   [-60, -56, 0]],
    [20, [0, 0, -10], [1.8, 1, 1], [-25, 20, 0]],
    [20, [0, 0, 25],  [0.5, 1, 1], [55, 10, 0]]
];

main();

module tentBody() {
    translate([offset_x, 0, 0])
        linear_extrude(height=0.1, center=false, convexity=10)
        import(file = "kyria-postless.dxf", $fn=100, convexity=10);
}

module tentPosts() {
    translate([offset_x, 0, 0]) difference() {
        linear_extrude(height=post_height, center=false, convexity=10)
            import(file="kyria-postless.dxf", $fn=100);
        linear_extrude(height=post_height, center=false, convexity=10)
            import(file="kyria-posted.dxf", $fn=100);
        translate([0, -21, -3])
            cube([128, 200, 25]);
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
            rotate(a=tent_rotate)
                tentPosts();

            difference() {
                linear_extrude(100)
                    projection(cut = false)
                    rotate(a=tent_rotate)
                    tentBody();
                rotate(a=tent_rotate)
                    translate([-250,-80,0])
                    cube([250, 350, 100]);    
            }
        }

        translate([0, -25, -1])
            cube([200, 150, 500]);
        
        for (params=cutouts) {
            cutout(params);
        }
    }
}
