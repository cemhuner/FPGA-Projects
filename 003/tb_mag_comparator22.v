`timescale 1ns / 1ps

module tb_mag_comp22;

    reg  [3:0] a, b;
    wire E, G, L;

    // UUT (Unit Under Test)
    mag_comp22 uut (
        .a(a),
        .b(b),
        .E(E),
        .G(G),
        .L(L)
    );

    initial begin
        // Durum 1: Eşitlik (0 == 0)
        a = 4'd0; b = 4'd0;
        #50;

        // Durum 2: MSB belirleyici (A > B) -> 8 > 2
        a = 4'd8; b = 4'd2;
        #50;

        // Durum 3: MSB belirleyici (A < B) -> 3 < 12
        a = 4'd3; b = 4'd12;
        #50;

        // Durum 4: MSB eşit, LSB belirleyici (A > B) -> 5 (0101) > 4 (0100)
        a = 4'b0101; b = 4'b0100;
        #50;

        // Durum 5: MSB eşit, LSB belirleyici (A < B) -> 9 (1001) < 11 (1011)
        a = 4'b1001; b = 4'b1011;
        #50;

        // Durum 6: Sınır değer eşitliği (15 == 15)
        a = 4'd15; b = 4'd15;
        #50;

        // Durum 7: Uç değerler (15 > 0)
        a = 4'd15; b = 4'd0;
        #50;

        $stop;
    end

endmodule