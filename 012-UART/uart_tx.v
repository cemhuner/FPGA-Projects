
module uart_tx #(parameter CLKS_PER_BIT = 1250) (
    input       clk,
    input       reset,
    input       tx_start,
    input [7:0] tx_data_in,
    output reg  tx,
    output reg  tx_active,
    output reg  tx_done
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
    reg [7:0]  tx_data;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state     <= s_IDLE;
            tx        <= 1'b1; // Boşta (Idle) durumunda hat daima High (1) seviyesindedir.
            tx_done   <= 1'b0;
            tx_active <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
        end else begin
            case (state)
                s_IDLE: begin
                    tx        <= 1'b1;
                    tx_done   <= 1'b0;
                    clk_count <= 0;
                    bit_index <= 0;

                    if (tx_start == 1'b1) begin
                        tx_active <= 1'b1;
                        tx_data   <= tx_data_in;
                        state     <= s_START_BIT;
                    end else begin
                        tx_active <= 1'b0;
                    end
                end

                s_START_BIT: begin
                    tx <= 1'b0; // Başlangıç biti daima Low (0)'dur.
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state     <= s_DATA_BITS;
                    end
                end

                s_DATA_BITS: begin
                    tx <= tx_data[bit_index]; // Veri bitleri LSB'den (en sağdaki bit) başlanarak gönderilir.
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state     <= s_STOP_BIT;
                        end
                    end
                end

                s_STOP_BIT: begin
                    tx <= 1'b1; // Durdurma biti daima High (1)'dır.
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        tx_done   <= 1'b1;
                        clk_count <= 0;
                        state     <= s_CLEANUP;
                    end
                end

                s_CLEANUP: begin
                    tx_active <= 1'b0;
                    tx_done   <= 1'b1;
                    state     <= s_IDLE;
                end

                default: state <= s_IDLE;
            endcase
        end
    end
endmodule