// lab2_AL_tb.sv
// Amy Liu
// amyliu01@g.hmc.edu
// 9/11/24
//  testbenches testing TMD and sum of 
// leds for lab2_AL.sv


`timescale 1ns/1ns
`default_nettype none
`define N_TV 8

module lab2_AL_tb();
 // Set up test signals
    logic clk, reset, clock_sub;
	logic [3:0] s1, s2;
	logic [6:0]	seg_expected, seg;
	logic [4:0] sum,sum_expected;
	logic [1:0] anode, anode_expected;
	logic [31:0] vectornum, errors;
	 logic [21:0] testvectors[10000:0]; //s1[3:0]_s2[3:0]_seg[6:0]_anode[1:0]_sum[4:0]
	logic int_osc;
	  HSOSC #(.CLKHF_DIV(2'b01)) 
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

 // Instantiate the device under test
 // Instantiate the device under test
 lab2_AL dut( .reset(reset), .s1(s1),.s2(s2),.seg(seg),.sum(sum),.anode(anode));

 // Generate clock signal with a period of 10 timesteps.
 always
   begin
     clk = 1; #5;
     clk = 0; #5;
   end
  
    initial begin
        // Initialize test vectors manually
testvectors[0] = 22'b0110_0110_0100000_10_01100;// input 6, 6  sum 12
testvectors[1] = 22'b1000_0001_1001111_10_01001;// input 1, 8  sum 9
testvectors[2] = 22'b0001_1000_0000000_10_01001;// input 1, 8  sum 9
testvectors[3] = 22'b1100_1010_0001000_10_10110;// input C, A (display 1st digit, A), sum A(10)+C(12)=22
testvectors[4] = 22'b1111_0011_0000110_10_10010; // input F, 3 (display 2nd digit, 3), sum F(15) + 3 =18
testvectors[5] = 22'b1100_1100_0110001_10_11000; // input c, c (dsplay 1st digit, c), sum b(12)+b(12)=24
     vectornum = 0; errors = 0;
     reset = 1; #27; reset = 0;
   end
  // Apply test vector on the rising edge of clk
 always @(posedge clk)
   begin
       #1; {s1, s2, seg_expected, anode_expected, sum_expected} = testvectors[vectornum];
   end
  initial
 begin
   // Create dumpfile for signals
   $dumpfile("lab2_AL_tb.vcd");
   $dumpvars(0, lab2_AL_tb);
 end
  // Check results on the falling edge of clk
 always @(negedge clk)
   begin
     if (~reset) // skip during reset
       begin
         if (seg != seg_expected || sum !=sum_expected || anode!=anode_expected)
           begin
             $display("Error: inputs1: s1=%b, inputs2: s2=%b", s1, s2);
             $display(" outputs: seg=%b (%b expected), anode=%b (%b expected),sum=%b (%b expected)", seg, seg_expected,anode, anode_expected,sum, sum_expected);
             errors = errors + 1;
           end

      
       vectornum = vectornum + 1;
      
       if (testvectors[vectornum] === 11'bx)
         begin
           $display("%d tests completed with %d errors.", vectornum, errors);
           $finish;
         end
     end
   end
endmodule