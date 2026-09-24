
// 'or' operation of two input signals, 1-bit comparator

module eq1 (
    input wire i0, i1,
    output wire eq
);

    wire p0, p1;

    assign eq = p0 | p1;
    assign p0 = ~i0 & ~i1;
    assign p1 = i0 & i1; 

endmodule

// 2-bit comparator

module eq2_sop
(
    input wire [1:0] a, b,
    output wire aeqb
);

    wire p0, p1, p2, p3;

    assign = aeqb = p0 | p1 | p2 | p3;
    
    assign p0 = (~a[1] & ~b[1]) & (~a[0] & ~b[0]);
    assign p1 = (~a[1] & ~b[1]) & (a[0] & b[0]);
    assign p2 = (a[1] & b[1]) & (~a[0] & ~b[0]);
    assign p3 = (a[1] & b[1]) & (a[0] & b[0]);

endmodule

// 2-bit comparator using 1-bit comparators

module eq2(
    input wire [1:0] a, b,
    output wire aeqb
);
    wire e0, e1;
    eq1 eq_bit0_unit (.i0(a[0]), .i1(b[0]), .eq(e0));
    eq1 eq_bit1_unit (.eq(e1), .i0(a[1]), .i1(b1));
    assign aeqb = e0 & e1; 

endmodule