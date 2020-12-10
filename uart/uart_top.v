// -----------------------------Details----------------------------------- // 
// File        : uart_top.v
// Author      : pastglory
// Date        : 20201210
// Version     : 1.1
// Description : uart top module
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201203  pastglory   1.0      Initial Release. 
// 20201210  pastglory   1.1      Add uart_tx(with some testing) modules
// ----------------------------------------------------------------------- // 

module uart_top (
    input            clk,
    input            rst_n,
    input            rxd,
    input  [3 : 0]   col, // keyboard column
    output [7 : 0]   data_rec, // received data
    output           txd,
    output           row // keyboard row
);

// keyboard output 
assign row = 1'b0;

wire clk_uart;

clk_div clk_div_inst (
     .clk_in         (clk)
    ,.rst_n          (rst_n)
    ,.clk_out        (clk_uart)
);

uart_rx uart_rx_inst (
     .clk            (clk)
    ,.clk_uart       (clk_uart)
    ,.rst_n          (rst_n)
    ,.rxd            (rxd)
    ,.data           (data_rec)
);

wire [7 : 0] data_gen; // generated data
wire start_gen; // data generator enable
wire start_tx;  // uart tx enable

data_generator data_generator_inst (
     .clk            (clk)
    ,.rst_n          (rst_n)
    ,.start          (start_gen)
    ,.data           (data_gen)
);

uart_tx uart_tx_inst (
     .clk            (clk)
    ,.clk_uart       (clk_uart)
    ,.rst_n          (rst_n)
    ,.start          (start_tx)
    ,.data           (data_gen)
    ,.txd            (txd)
);

keyboard keyboard_inst (
     .clk            (clk)
    ,.rst_n          (rst_n)
    ,.col            (~col)
    ,.key_pulse      ({start_gen, start_tx, 2'b0})
);

endmodule