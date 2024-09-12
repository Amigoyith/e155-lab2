// lab2_AL.sv
// Amy Liu
// amyliu01@g.hmc.edu
// 9/10/24
//  Controls dual 7 sgement display
// through time multiplexing

module lab2_AL (
    input logic reset,   
    input logic [3:0] s1, //switch 1 
    input logic [3:0] s2,     //switch 2 
    output logic [6:0] seg,     
    output logic [1:0] anode,   
    output logic [4:0] sum
);
logic freq_switch; // toggles freq cycles for 2 digits
logic int_osc;
logic [11:0] mux_counter;
logic [3:0] cur_num; // current number to be displayed
	
  always_ff @(posedge int_osc) begin
        if (!reset)
            mux_counter <= 0;
        else
            mux_counter <= mux_counter + 1;
    end
	
    seven_segdisplay decoder (
        .reset(reset),
        .s(cur_num),
        .seg(seg)
    );
	
	  HSOSC #(.CLKHF_DIV(2'b01)) 
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));
		 
assign freq_switch = mux_counter[11]; 	 
//assign number to display at time cycle
    always_comb begin
        if (freq_switch)
cur_num = s1;
        else
            cur_num = s2;
end

 //At time cycles, turn one annode for displaying 1st or 2nd digit
    always_comb begin
        if (freq_switch) 
	anode = 2'b01; //enable digit 1 (s1)
else 
	anode = 2'b10; //enable digit 2 (s2)
	end
    
    assign sum = s1 + s2;
endmodule