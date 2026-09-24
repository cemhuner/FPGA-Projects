`timescale 1ns / 1ps

module tb_univ_shift_reg;

    // Parametre tanımı (Modül ile uyumlu)
    parameter N = 8;

    // Girişler (reg tipi)
    reg clk;
    reg reset;
    reg [1:0] ctrl;
    reg [N-1:0] d;

    // Çıkış (wire tipi)
    wire [N-1:0] q;

    // Test edilecek modülün (DUT) örneklendirilmesi
    univ_shift_reg #(.N(N)) dut (
        .clk(clk),
        .reset(reset),
        .ctrl(ctrl),
        .d(d),
        .q(q)
    );

    // Saat (Clock) sinyali üretimi: 10 ns periyotlu (5 ns high, 5 ns low)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test Senaryoları
    initial begin
        // Her giriş/çıkış değişiminde terminale değerleri yazdırır
        $monitor("Zaman=%0t | Reset=%b | Ctrl=%b | D=%b || Q=%b", 
                 $time, reset, ctrl, d, q);

        // Başlangıç durumu: Sistemi resetle
        reset = 1;
        ctrl = 2'b00;
        d = 8'b00000000;
        #15; // Asenkron resetin etkisini görmek için bekle
        
        reset = 0; // Reset kaldırıldı, normal çalışma başlıyor

        // 1. Senaryo: Paralel Yükleme (Parallel Load)
        // Beklenen: ctrl = 11 olduğunda D'deki değer saat vuruşuyla Q'ya aktarılır.
        ctrl = 2'b11; 
        d = 8'b10110011;
        #10;

        // 2. Senaryo: Tutma (Hold)
        // Beklenen: ctrl = 00 olduğunda D değişse bile Q aynı kalır.
        ctrl = 2'b00;
        d = 8'b11111111; 
        #10;

        // 3. Senaryo: Sola Kaydırma (Shift Left)
        // Beklenen: D'nin 0. biti (d[0]) sağdan (LSB) giriş yapar.
        // Q: 10110011 -> 01100110 (Sağdan 0 girer)
        ctrl = 2'b01;
        d = 8'b00000000; 
        #10;
        
        // Sola kaydırmaya devam (Bu kez sağdan 1 girsin)
        // Q: 01100110 -> 11001101
        ctrl = 2'b01;
        d = 8'b00000001; 
        #10;

        // 4. Senaryo: Sağa Kaydırma (Shift Right)
        // Beklenen: D'nin 7. biti (d[7]) soldan (MSB) giriş yapar.
        // Q: 11001101 -> 11100110 (Soldan 1 girer)
        ctrl = 2'b10;
        d = 8'b10000000; 
        #10;

        // Sağa kaydırmaya devam (Bu kez soldan 0 girsin)
        // Q: 11100110 -> 01110011
        ctrl = 2'b10;
        d = 8'b00000000; 
        #10;

        // Tekrar Reset Testi
        // Beklenen: Saat vuruşu beklenmeden asenkron olarak Q anında 0 olur.
        reset = 1;
        #5;

        // Simülasyonu bitir
        $finish;
    end

endmodule