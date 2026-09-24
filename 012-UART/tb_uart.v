`timescale 1ns / 1ps

module uart_tb();

    // --- Cmod A7 (12 MHz) ve 9600 Baud Rate Parametreleri ---
    parameter CLKS_PER_BIT = 1250; 
    parameter real CLK_PERIOD_NS = 83.333; // 1 / 12MHz = ~83.333 ns

    // --- Testbench Sinyalleri ---
    reg clk;
    reg reset;

    // TX Sinyalleri
    reg tx_start;
    reg [7:0] tx_data_in;
    wire tx_wire; 
    wire tx_active;
    wire tx_done;

    // RX Sinyalleri
    wire [7:0] rx_data_out;
    wire rx_dv;

    // --- Modüllerin Çağrılması (Instantiation) ---

    // UART Verici Modülü
    uart_tx #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_tx (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data_in(tx_data_in),
        .tx(tx_wire),
        .tx_active(tx_active),
        .tx_done(tx_done)
    );

    // UART Alıcı Modülü
    uart_rx #(.CLKS_PER_BIT(CLKS_PER_BIT)) u_rx (
        .clk(clk),
        .reset(reset),
        .rx(tx_wire), 
        .rx_data_out(rx_data_out),
        .rx_dv(rx_dv)
    );

    // --- Saat (Clock) Sinyali Üretimi (12 MHz) ---
    initial begin
        clk = 0;
        // 83.333 ns'nin yarısında bir (yaklaşık 41.666 ns) sinyali tersine çevir
        forever #(CLK_PERIOD_NS / 2) clk = ~clk; 
    end

    // --- Test Senaryosu ---
    initial begin
        // 1. Başlangıç Değerlerinin Atanması
        reset = 1'b1;
        tx_start = 1'b0;
        tx_data_in = 8'h00;

        // Sistemin oturması için bekle ve reset'i kaldır
        #(CLK_PERIOD_NS * 10);
        reset = 1'b0;
        #(CLK_PERIOD_NS * 10);

        // ---------------------------------------------------------
        // TEST 1: 8'hAB (10101011) Verisinin Gönderilmesi
        // ---------------------------------------------------------
        $display("--- Test 1 Basliyor: 8'hAB gonderiliyor (9600 Baud) ---");
        tx_data_in = 8'hAB; 
        tx_start = 1'b1;    
        #(CLK_PERIOD_NS);   
        tx_start = 1'b0;    

        // RX modülü veriyi alana kadar bekle
        @(posedge rx_dv); 
        
        // Alınan veri ile gönderilen veriyi karşılaştır
        if (rx_data_out == 8'hAB) begin
            $display("-> BASARILI: Gonderilen: %h, Alinan: %h", 8'hAB, rx_data_out);
        end else begin
            $display("-> HATA: Gonderilen: %h, Alinan: %h", 8'hAB, rx_data_out);
        end

        #(CLK_PERIOD_NS * CLKS_PER_BIT * 2); 

        // ---------------------------------------------------------
        // TEST 2: 8'h3F (00111111) Verisinin Gönderilmesi
        // ---------------------------------------------------------
        $display("--- Test 2 Basliyor: 8'h3F gonderiliyor (9600 Baud) ---");
        tx_data_in = 8'h3F;
        tx_start = 1'b1;
        #(CLK_PERIOD_NS);
        tx_start = 1'b0;

        @(posedge rx_dv);

        if (rx_data_out == 8'h3F) begin
            $display("-> BASARILI: Gonderilen: %h, Alinan: %h", 8'h3F, rx_data_out);
        end else begin
            $display("-> HATA: Gonderilen: %h, Alinan: %h", 8'h3F, rx_data_out);
        end

        #(CLK_PERIOD_NS * CLKS_PER_BIT * 2);
        
        // Simülasyonu bitir
        $display("--- Simulasyon Tamamlandi ---");
        $finish; 
    end

endmodule