// -----------------------------Details----------------------------------- // 
// File        : uart_top.v
// Author      : flyjancy
// Date        : 20201210
// Version     : 1.1
// Description : uart top module
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201203  flyjancy   1.0      Initial Release. 
// 20201210  flyjancy   1.1      Add uart_tx(with some testing) modules
// 20210809  flyjancy   1.2      update clkuart_gen module, modify keyboard_inst
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

clkuart_gen clk_uart_inst (
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
wire [4 : 0] key_pulse;
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
    ,.key_pulse      (key_pulse)
);

assign start_gen = key_pulse[3];
assign start_tx  = key_pulse[2];

endmodule