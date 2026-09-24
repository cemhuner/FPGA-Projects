

module prio_encoder_if
(
    input wire [4:1] r,
    output reg [2:0] y
);
    always @(*) begin
        if (r[4] == 1'b1) // r[4] ensures exact same output
            y = 3'b100;
        else if (r[3] == 1'b1)
            y = 3'b011;
        else if (r[2] == 1'b1)
            y = 3'b010;
        else if (r[1] == 1'b1)
            y = 3'b001;
        else 
            y = 3'b000;           
    end

endmodule

module prio_encoder_case
(
    input wire [4:1] r,
    output reg [2:0] y
);
    always @*
        case(r)
            4'b1000, 4'b1001, 4'b1010, 4'b1011,
            4'b1100, 4'b1101, 4'b1110, 4'b1111:
                y = 3'b100;
            4'b0100, 4'b0101, 4'b0110, 4'0111:
                y = 3'b011;
            4'b0010, 4'b0011:
                y = 3'b010;
            4'b0001:
                y = 3'b001;
            4'b000:
                y = 3'b000;
        endcase
endmodule

module prio_encoder_casez
(
    input wire [4:1] r,
    output reg [2:0] y
);
    always @*
        casez (r)
            4'b1???: y = 3'b100;
            4'b01??: y = 3'b011;
            4'b001?: y = 3'b010;
            4'b0001: y = 3'b001;
            4'b0000: y = 3'b000; 
             
        endcase
endmodule




module decoder_2_4_if
(
    input wire [1:0] a,
    input wire en, 
    output reg [3:0] y
);

    always @*
        if (en == 1'b0)
            y = 4'b0000;
        else if (a == 2'b00)
            y = 4'b0001;
        else if (a == 2'b01)
            y = 4'b0010;
        else if (a == 2'b10)
            y = 4'b0100;
        else 
            y = 4'b1000;

endmodule


module decoder_2_4_case
(
    input wire [1:0] a,
    input wire en,
    output reg [3:0] y
);
    always @*
        case ({en, a}) // 3-bit vector
            3'b000, 3'b001, 3'b010, 3'b011: y = 4'b0000;
            3'b100: y = 4'b0001;
            3'b101: y = 4'b0010;
            3'b110: y = 4'b0100;
            3'b111: y = 4'b1000;            
        endcase
endmodule

