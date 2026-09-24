module uart_rx #(parameter CLKS_PER_BIT = 1250) (
    input        clk,
    input        reset,
    input        rx,
    output reg [7:0] rx_data_out,
    output reg   rx_dv // Data Valid (Veri Geçerli) bayrağı
);

    // Durum Makinesi (State Machine) Tanımlamaları
    localparam s_IDLE       = 3'b000;
    localparam s_START_BIT  = 3'b001;
    localparam s_DATA_BITS  = 3'b010;
    localparam s_STOP_BIT   = 3'b011;
    localparam s_CLEANUP    = 3'b100;

    reg [2:0] state;
    reg [15:0] clk_count;
    reg [2:0]  bit_index;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state       <= s_IDLE;
            rx_dv       <= 1'b0;
            clk_count   <= 0;
            bit_index   <= 0;
            rx_data_out <= 8'b0;
        end else begin
            case (state)
                s_IDLE: begin
                    rx_dv     <= 1'b0;
                    clk_count <= 0;
                    bit_index <= 0;

                    if (rx == 1'b0) begin // Start biti algılandı (Hat 0'a çekildi)
                        state <= s_START_BIT;
                    end
                end

                s_START_BIT: begin
                    if (clk_count == (CLKS_PER_BIT / 2)) begin
                        if (rx == 1'b0) begin // Hatanın hala 0 olduğundan emin ol (Gürültü kontrolü)
                            clk_count <= 0;
                            state     <= s_DATA_BITS;
                        end else begin
                            state <= s_IDLE;
                        end
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                s_DATA_BITS: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        rx_data_out[bit_index] <= rx; // Veriyi örnekle

                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state     <= s_STOP_BIT;
                        end
                    end
                end

                s_STOP_BIT: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        rx_dv     <= 1'b1; // Veri alımı tamamlandı
                        clk_count <= 0;
                        state     <= s_CLEANUP;
                    end
                end

                s_CLEANUP: begin
                    state <= s_IDLE;
                    rx_dv <= 1'b0;
                end

                default: state <= s_IDLE;
            endcase
        end
    end
endmodule