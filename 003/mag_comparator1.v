
module mag_comp2(
    
    input wire[1:0] i0, i1,
    output agreb, aeqb, alessb
    
);
    wire p0, p1, p2, p3, p4, p5, p6, p7;
    
    assign agreb = (p0 | p1 | p2);
    assign aeqb = p3 & p4;
    assign alessb = p5 | p6 | p7;

    assign p0 = i0[0] & ~i1[1] & ~i1[0];
    assign p1 = i0[1] & ~i1[1];
    assign p2 = i0[1] & i0[0] & ~i1[0];

    assign p3 = ~(i0[0] ^ i1[0]);
    assign p4 = ~(i0[1] ^ i1[1]);

    assign p5 = ~i0[1] & ~i0[0] & i1[0];
    assign p6 = ~i0[0] & i1[1] & i1[0];
    assign p7 = ~i0[1] & i1[1]; 

endmodule

