
`timescale 1ns / 1ps

module tb_edge_detect_moore();

    // Girişler için reg, çıkışlar için wire tanımlanması
    reg clk;
    reg reset;
    reg level;
    wire tick;

    // Test edilecek modülün (DUT - Device Under Test) bağlanması
    edge_detect_moore uut (
        .clk(clk),
        .reset(reset),
        .level(level),
        .tick(tick)
    );

    // Saat (Clock) sinyali üretimi - 10ns periyot (5ns düşük, 5ns yüksek)
    always #5 clk = ~clk;

    // Test senaryolarının (Stimulus) uygulanması
    initial begin
        // 1. Başlangıç durumu
        clk = 0;
        reset = 1;
        level = 0;

        // 2. Sistemi resetten çıkar
        #15 reset = 0; 

        // 3. Senaryo: Normal bir 0 -> 1 geçişi ve uzun süre 1'de kalma durumu
        #10 level = 1; 
        #40 level = 0; // Sinyal 0'a düşüyor

        // 4. Senaryo: Kısa süreli bir 1 sinyali gelmesi durumu
        #20 level = 1;
        #15 level = 0;

        // 5. Senaryo: Tekrar bir yükselen kenar oluşturma
        #25 level = 1;
        #30 level = 0;

        // Simülasyonu sonlandır
        #20 $finish;
    end

    // Konsol ekranına (Terminal) sonuçları yazdırma
    initial begin
        $monitor("Zaman: %0t | reset=%b | level=%b | tick=%b", $time, reset, level, tick);
    end

endmodule