module lab2_AL (
    input logic reset,   
    input logic [3:0] s1,       
    input logic [3:0] s2,      
    output logic [6:0] seg,     
    output logic [1:0] anode,   
    output logic [4:0] sum
);
logic freq_switch;
logic int_osc;
logic [11:0] mux_counter;
logic [3:0] cur_num;
	
  always_ff @(posedge int_osc) begin
        if (!reset)
            mux_counter <= 0;
        else
            mux_counter <= mux_counter + 1;
    end
	
    seven_segdisplay decoder (
        .clk(clk),
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
	anode = 2'b01;
else 
	anode = 2'b10; 
	end
    
    assign sum = s1 + s2;
endmodule