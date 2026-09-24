
`timescale 1 ns / 1ps

module mag_comp2_testbench;

    reg [1:0] test_in0, test_in1;
    wire test_out0, test_out1, test_out2;

    mag_comp2 uut
        (.a(test_in0), .b(test_in1), .agreb(test_out0), .aeqb(test_out1), .alessb(test_out2));
    
    initial begin
        test_in0 = 2'b00;
        test_in1 = 2'b00;
        #200;
        test_in0 = 2'b01;
        test_in1 = 2'b00;
        #200;
        test_in0 = 2'b01;
        test_in1 = 2'b11;
        #200;
        test_in0 = 2'b10;
        test_in1 = 2'b10;
        #200;
        test_in0 = 2'b10;
        test_in1 = 2'b00;
        #200;
        test_in0 = 2'b11;
        test_in1 = 2'b11;
        #200;
        test_in0 = 2'b11;
        test_in1 = 2'b01;
        #200;
        $stop;
    end
endmodule