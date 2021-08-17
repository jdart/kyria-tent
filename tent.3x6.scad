
extrude_height=5;
tent_angle=[0,25,0];
negative_tent_angle=[-tent_angle[0], -tent_angle[1], -tent_angle[2]];
tent_cutout_z=30;
post_height=0;
cutout_offset=-20;

// radius, rotate,    scale,       translate
cutouts = [
    [50, [0, 0, 0],   [1, 1, 1],   [-125+cutout_offset, 66, 0]],
    [40, [0, 0, 0],   [1, 1, 1],   [-60+cutout_offset, -56, 0]],
    [20, [0, 0, -10], [1.8, 1, 1], [-12+cutout_offset, 20, 0]],
    [20, [0, 0, 25],  [0.5, 1, 1], [55+cutout_offset, 10, 0]]
];

main();

module tentBody() {
    translate([-31, 0, 0])
        linear_extrude(height=1, center=true, convexity=10)
        import(file = "kyria-postless.dxf", $fn=100, convexity=10);
}

module tentPosts() {
    translate([-31, 0, extrude_height/2]) difference() {
        linear_extrude(height=extrude_height, center=true, convexity=10)
            import(file="kyria-postless.dxf", $fn=100);
        linear_extrude(height=extrude_height, center=true, convexity=10)
            import(file="kyria-posted.dxf", $fn=100);
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
            translate([0,0,-(post_height+1)])
                rotate(a=tent_angle)
                union() {
                    tentPosts();
                    tentBody();
                }

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
        
        for (params=cutouts) {
            cutout(params);
        }
    }
}
