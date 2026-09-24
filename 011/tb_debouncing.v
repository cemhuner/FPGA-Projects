
`timescale 1ns / 1ps

module tb_debouncing_fsm;

    // Sinyallerin tanımlanması
    reg clk;
    reg reset;
    reg sw;
    wire db;

    // Test edilecek modülün (UUT) örneklendirilmesi
    debouncing_fsm uut (
        .clk(clk),
        .reset(reset),
        .sw(sw),
        .db(db)
    );

    // 50 MHz Saat Sinyali Üretimi (Periyot: 20 ns)
    always #10 clk = ~clk;

    initial begin
        // Başlangıç koşulları
        clk = 0;
        reset = 1;
        sw = 0;

        // Sistemi resetleme
        #100;
        reset = 0;
        #100;
        #4000;
        // ----------------------------------------------------
        // 1. AŞAMA: BUTONA BASILMASI VE TİTREME (BOUNCE)
        // ----------------------------------------------------
        // Butona basıldığında oluşan fiziksel sekmeler (milisaniye cinsinden)
        sw = 1; #200_000;  // 2 ms basılı kaldı
        sw = 0; #1_000_000;  // 1 ms temassızlık
        sw = 1; #1_500_000;  // 1.5 ms basılı
        sw = 0; #500_000;    // 0.5 ms temassızlık
        sw = 1; #200_000;  // 2 ms basılı kaldı
        sw = 0; #1_000_000;  // 1 ms temassızlık
        sw = 1; #1_500_000;  // 1.5 ms basılı
        sw = 0; #500_000;    // 0.5 ms temassızlık
        
        // Titremeler bitti, buton kararlı şekilde basılı tutuluyor.
        // FSM'nin durumu değiştirmesi için ~31.5 ms gerekiyor. Biz 40 ms bekliyoruz.
        sw = 1; #60_000_000; // Bu sürenin ortalarında 'db' sinyali 1'e çıkacaktır.

        // ----------------------------------------------------
        // 2. AŞAMA: BUTONUN BIRAKILMASI VE TİTREME (BOUNCE)
        // ----------------------------------------------------
        // Buton bırakılırken oluşan ark/sekmeler
        sw = 0; #500_000;  // 1.5 ms bırakıldı
        sw = 1; #1_000_000;  // 1 ms tekrar temas etti
        sw = 0; #1_000_000;  // 2 ms bırakıldı
        sw = 1; #500_000;    // 0.5 ms tekrar temas
        sw = 0; #500_000;  // 1.5 ms bırakıldı
        sw = 1; #1_000_000;  // 1 ms tekrar temas etti
        sw = 0; #1_000_000;  // 2 ms bırakıldı
        sw = 1; #500_000;    // 0.5 ms tekrar temas
        
        // Titremeler bitti, buton tamamen bırakıldı.
        // FSM'nin sıfırlanması için yine ~31.5 ms gerekiyor. 40 ms bekliyoruz.
        sw = 0; #50_000_000; // Bu sürenin ortalarında 'db' sinyali 0'a inecektir.

        // Simülasyonu durdur
        $stop;
    end

endmodule