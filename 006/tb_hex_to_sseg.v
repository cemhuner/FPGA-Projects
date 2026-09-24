

`timescale 1ns / 1ps

module tb_hex_to_sseg;

    // Testbench sinyalleri
    reg  [3:0] hex;
    reg        dp;
    wire [7:0] sseg;

    // UUT (Unit Under Test) örneği
    hex_to_sseg uut (
        .hex(hex),
        .dp(dp),
        .sseg(sseg)
    );

    integer i;

    initial begin
        // Başlangıç değerleri
        hex = 4'h0;
        dp  = 1'b0;

        // Konsol çıktısı için başlık
        $display("-------------------------------------------");
        $display("Zaman | hex | dp | sseg[7:0] (İkilik)");
        $display("-------------------------------------------");
        $monitor("%5t |  %h  |  %b | %b", $time, hex, dp, sseg);

        #10;

        // 1. Senaryo: dp = 0 iken 0'dan F'ye tüm değerler
        dp = 1'b0;
        for (i = 0; i < 16; i = i + 1) begin
            hex = i;
            #10;
        end

        // 2. Senaryo: dp = 1 iken 0'dan F'ye tüm değerler
        dp = 1'b1;
        for (i = 0; i < 16; i = i + 1) begin
            hex = i;
            #10;
        end

        $display("-------------------------------------------");
        $display("Test tamamlandı.");
        $finish;
    end

endmodule