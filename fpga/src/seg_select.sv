//seg_select.sv
// Amy Liu
// amyliu01@g.hmc.edu
// 9/10/24
// Select the current digit (s1 or s2) to display
// and controls anode switching for time-multiplexing
module seg_select (
    input logic freq_switch,      // Signal to switch between the two digits
    input logic [3:0] s1,         // First digit
    input logic [3:0] s2,         // Second digit
    output logic [3:0] cur_num,  
    output logic [1:0] anode   
);
    always_comb begin
        if (freq_switch)
            cur_num = s1;
        else
            cur_num = s2;
    en
    always_comb begin
        if (freq_switch) anode = 2'b01;   // Enable first digit
        else
anode = 2'b10;   // Enable second digit
    end
endmodule
