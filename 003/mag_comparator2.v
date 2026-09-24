

module mag_comp22(
    input wire [3:0] a, b,
    output wire E, G, L
);

    wire [1:0] e, g, l; 

    
    mag_comp2 mag_com_bit_10 (
        .i0(a[1:0]), 
        .i1(b[1:0]),
        .aeqb(e[0]), 
        .agreb(g[0]), 
        .alessb(l[0])
    );                     

    
    mag_comp2 mag_com_bit_32 (
        .i0(a[3:2]), 
        .i1(b[3:2]),
        .aeqb(e[1]), 
        .agreb(g[1]), 
        .alessb(l[1])
    );

    
    assign E = e[1] & e[0];
       
    assign G = g[1] | (e[1] & g[0]);
    
    assign L = l[1] | (e[1] & l[0]); 

endmodule
