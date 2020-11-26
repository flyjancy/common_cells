//---------------------------------------------------------
//  If Enable, change DataIn to its 2's complement Code
//  2020.1.27
//---------------------------------------------------------

module ComplementEncoder #(
  parameter   Width         =     26
)(
  input       [Width - 1 : 0]       DataIn,
  input                             Enable,
  output      [Width - 1 : 0]       DataOut
);

wire          [Width - 1 : 0]       DataTmp;
assign        DataTmp       =       ~DataIn;

assign        DataOut       =       Enable ? (DataTmp + 1'b1) : DataIn;

endmodule