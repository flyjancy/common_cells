`timescale 1ns/1ps
module iicm_tb();

reg clk, rstn, start_sys;
reg [4:0] v_in;
wire sda, scl;

iicm iicm_uut(
     .clk       (clk)
    ,.rstn      (rstn)
    ,.v_in      (v_in)
    ,.start_sys (start_sys)
    ,.sda       (sda)
    ,.scl       (scl)
);

initial
begin            
    $dumpfile("wave.vcd");        
    $dumpvars(0, iicm_tb);
end

initial begin
    rstn = 1'b0;
    v_in = 5'd0;
    start_sys = 1'b0;
    clk = 1'b0;
    #31;
    rstn = 1'b1;
    #21;
    start_sys = 1'b1;
    #6;
    start_sys = 1'b0;
end

always #5 clk = ~clk;

initial 
    #2000 $finish;

endmodule