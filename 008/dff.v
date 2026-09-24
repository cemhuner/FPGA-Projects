
module d_ff(
    input wire clk,
    input wire d,
    output reg q
);
    always @(posedge clk)
        q <= d;
endmodule

module d_ff_reset(
    input wire clk, reset,
    input wire d,
    output reg q
);
    always @(posedge clk, posedge reset)
        if (reset)
            q <= 1'b0;
        else 
            q <= d;
endmodule

module d_ff_1seg(
    input wire clk, reset,
    input wire en,
    input wire d,
    output reg q
);
    always @(posedge clk, posedge reset)
        if (reset)
            q <= 1'b0;
        else if (en)
            q <= d;
endmodule

module reg_reset(
    input wire clk, reset,
    input wire [7:0] d,
    output reg [7:0] q
);
    always @(posedge clk, posedge reset) begin
        if (reset)
            q <= 0;
        else   
            q <= d;
    end
endmodule

module reg_file #(
    parameter B = 8;
              W = 2
)
(
    input wire clk,
    input wire wr_en,
    input wire [W-1:0] w_addr, r_addr,
    input wire [B-1:0] w_data,
    output wire [B-1:0] r_data
);
    reg [B-1:0] array_reg [2**W-1:0];

    always @(posedge clk ) 
        if (wr_en)
            array_reg[w_addr] <= w_data;
    assign r_data = array_reg[r_addr];
endmodule

module univ_shift_reg
#(parameter N = 8)
(
    input wire clk, reset,
    input wire [1:0] ctrl,
    input wire [N-1:0] d,
    output wire [N-1:0] q
);
    reg [N-1:0] r_reg, r_next;

    always @(posedge clk, posedge reset) begin
        if(reset)
            r_reg <= 0;
        else
            r_reg <= r_next;
    end

    always @*
        case(ctrl)
            2'b00: r_next = r_reg;
            2'b01: r_next = {r_reg[N-2:0], d[0]};
            2'b10: r_next = {d[N-1], r_reg[N-1:1]};
            default: r_next = d;
        endcase

    assign q = r_reg;

endmodule