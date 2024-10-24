// lab2_AL.sv
// Amy Liu
// amyliu01@g.hmc.edu
// 9/10/24
//  Controls dual 7 sgement display
// through time multiplexing
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

    assign freq_switch = mux_counter[11];
    seven_segdisplay decoder (
        .clk(clk),
        .reset(reset),
        .s(cur_num),
        .seg(seg)
    );
    seg_select seg_select (
        .freq_switch(freq_switch),
        .s1(s1),
        .s2(s2),
        .cur_num(cur_num),
        .anode(anode)
    );
    HSOSC #(.CLKHF_DIV(2'b01)) 
         hf_osc (.CLKHFPU(1'b1), .CLKHFEN(1'b1), .CLKHF(int_osc));

    // Sum output
    assign sum = s1 + s2;
endmodule
