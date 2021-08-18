tent_angle=5;
tent_rotate=[0, tent_angle, 0];
cutout_offset=-20;
offset_x=-29.8;
post_height=5;

// radius, rotate,    scale,       translate
cutouts = [
    [50, [0, 0, 0],   [1, 1, 1],   [-128+cutout_offset, 66, 0]],
    [40, [0, 0, 0],   [1, 1, 1],   [-68+cutout_offset, -56, 0]],
    [20, [0, 0, -10], [1.8, 1, 1], [-12+cutout_offset, 20, 0]],
    [20, [0, 0, 25],  [0.5, 1, 1], [35+cutout_offset, 10, 0]]
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
    }
}

module cutout(inputs) {
    rotate(inputs[1]) 
        scale(inputs[2]) 
        translate(inputs[3])
        cylinder(h=150, r=inputs[0], center=false, $fn=100);
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
                    translate([-250, -80, 0])
                    cube([250, 350, 100]);    
            }
        }
        
        for (params=cutouts) {
            cutout(params);
        }
    }
}
