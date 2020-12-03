// -----------------------------Details----------------------------------- // 
// File        : complement_encoder.v
// Author      : pastglory
// Date        : 20200127
// Version     : 1.0
// Description : get 2's complement code
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20200128  pastglory   1.0      Initial Release. 
//
// ----------------------------------------------------------------------- // 

module complement_encoder #(
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