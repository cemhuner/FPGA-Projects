
`timescale 1ns / 1ps

module tb_fp_adder;

    // Girişler (Test vektörleri için reg tipi kullanılır)
    reg sign1, sign2;
    reg [3:0] exp1, exp2;
    reg [7:0] frac1, frac2;

    // Çıkışlar (Bağlantı noktaları için wire tipi kullanılır)
    wire sign_out;
    wire [3:0] exp_out;
    wire [7:0] frac_out;

    // Test edilecek modülün (Device Under Test - DUT) çağrılması
    fp_adder dut (
        .sign1(sign1),
        .sign2(sign2),
        .exp1(exp1),
        .exp2(exp2),
        .frac1(frac1),
        .frac2(frac2),
        .sign_out(sign_out),
        .exp_out(exp_out),
        .frac_out(frac_out)
    );

    initial begin
        // Her giriş veya çıkış değiştiğinde konsola değerleri yazdırır
        $monitor("Zaman=%0t | S1=%b E1=%b F1=%b | S2=%b E2=%b F2=%b || S_OUT=%b E_OUT=%b F_OUT=%b", 
                 $time, sign1, exp1, frac1, sign2, exp2, frac2, sign_out, exp_out, frac_out);

        // 1. Senaryo: Basit Toplama (Üsleri aynı olan iki sayının toplanması)
        // Beklenen: Kesirler toplanır, taşma veya kaydırma olmaz.
        sign1 = 0; exp1 = 4'd4; frac1 = 8'b10000000;
        sign2 = 0; exp2 = 4'd4; frac2 = 8'b01000000;
        #10;

        // 2. Senaryo: Elde Taşması (Carry Out) Durumu
        // Beklenen: Toplam 8 bite sığmaz (sum[8] = 1). Kesir 1 bit sağa kayar, üs 1 artar.
        sign1 = 0; exp1 = 4'd5; frac1 = 8'b11000000;
        sign2 = 0; exp2 = 4'd5; frac2 = 8'b11000000;
        #10;

        // 3. Senaryo: Çıkarma ve Normalizasyon (Farklı işaretler, farklı üsler)
        // Beklenen: Küçük sayının kesri hizalanır, çıkarma yapılır ve baştaki sıfırlar için sola kaydırılıp üs azaltılır.
        sign1 = 0; exp1 = 4'd5; frac1 = 8'b10000000;
        sign2 = 1; exp2 = 4'd4; frac2 = 8'b10000000;
        #10;

        // 4. Senaryo: Underflow (Sayının sıfırlanması durumu)
        // Beklenen: İki aynı sayı birbirinden çıkarılır, sonuç tamamen 0 olur.
        sign1 = 0; exp1 = 4'd3; frac1 = 8'b10101010;
        sign2 = 1; exp2 = 4'd3; frac2 = 8'b10101010;
        #10;

        // Simülasyonu sonlandır
        $finish;
    end

endmodule