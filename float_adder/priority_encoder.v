// -----------------------------Details----------------------------------- // 
// File        : priority_encoder.v
// Author      : pastglory
// Date        : 20200127
// Version     : 1.0
// Description : find the MSB(1) 
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20200127  pastglory   1.0      Initial Release. 
//   
// ----------------------------------------------------------------------- //

module priority_encoder (
    input     [24 : 0]     DataIn,
    output    [4 : 0]      DataOut
);

assign        DataOut     =     DataIn[24] ? 5'd24 : (
                                DataIn[23] ? 5'd23 : (
                                DataIn[22] ? 5'd22 : (
                                DataIn[21] ? 5'd21 : (
                                DataIn[20] ? 5'd20 : (
                                DataIn[19] ? 5'd19 : (
                                DataIn[18] ? 5'd18 : (
                                DataIn[17] ? 5'd17 : (
                                DataIn[16] ? 5'd16 : (
                                DataIn[15] ? 5'd15 : (
                                DataIn[14] ? 5'd14 : (
                                DataIn[13] ? 5'd13 : (
                                DataIn[12] ? 5'd12 : (
                                DataIn[11] ? 5'd11 : (
                                DataIn[10] ? 5'd10 : (
                                DataIn[9]  ? 5'd9  : (
                                DataIn[8]  ? 5'd8  : (
                                DataIn[7]  ? 5'd7  : (
                                DataIn[6]  ? 5'd6  : (
                                DataIn[5]  ? 5'd5  : (
                                DataIn[4]  ? 5'd4  : (
                                DataIn[3]  ? 5'd3  : (
                                DataIn[2]  ? 5'd2  : (
                                DataIn[1]  ? 5'd1  : (
                                DataIn[0]  ? 5'd0  : 5'd23 ))))))))))))))))))))))));

endmodule