// -----------------------------Details----------------------------------- // 
// File        : uart_top.v
// Author      : pastglory
// Date        : 20201203
// Version     : 1.0
// Description : uart top module
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20201203  pastglory   1.0      Initial Release. 
// ----------------------------------------------------------------------- // 

module uart_top (
    input            clk,
    input            rst_n,
    input            rxd,
    output [7:0]     data
);

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
    ,.data           (data)
);

endmodule