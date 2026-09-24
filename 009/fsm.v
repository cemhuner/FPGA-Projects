
module fsm_eg_mult_seg (
    input wire clk, reset,
    input wire a, b,
    output wire y0, y1
);
    localparam [1:0] s0 = 2'b00
                     s1 = 2'b01,
                     s2 = 2'b10;
    reg [1:0] state_reg, state_next;

    always @(posedge clk, posedge reset) begin
        if (reset)
            state_reg <= s0;
        else 
            state_reg <= state_next;
    end

    always @*
        case (state_reg)
            s0: if (a)
                    if(b)
                        state_next = s2;
                    else
                        state_next = s1;
                else 
                    state_next = s0;
        
            s1: if (a)
                    state_next = s0;
                else 
                    state_next = s1;
            s2: state_next = s0;
            default: state_next = s0;
        endcase
    
    assign y1 = (state_reg == s0) || (state_reg == s1);

    assign y0 = (state_reg == s0) & a & b;

endmodule


module fsm_eg_2_seg
(
    input wire clk, reset,
    input wire a, b,
    output reg y0, y1
);

    localparam [1:0] s0 = 2'b00,
                     s1 = 2'b01,
                     s2 = 2'b10;
                    
    reg [1:0] state_reg, state_next;

    always @(posedge clk, posedge reset) begin
        if (reset)
            state_reg <= s0;
        else 
            state_reg <= state_next;
    end

    always @* begin
        state_next = state_reg;
        y1 = 1'b0;
        y0 = 1'b0;
        case (state_reg)
            s0: begin 
                    y1 = 1'b1;
                    if (a)
                        if (b)
                            begin
                                state_next = s2;
                                y0 = 1'b1;
                            end
                        else 
                            state_next = s1;
                end
            s1: begin
                    y1 = 1'b1;
                    if (a)
                        state_next = s0;
                    end
            s2: state_next = s0;
            default: state_next = s0;
        endcase
    end
endmodule