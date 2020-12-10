// -----------------------------Details----------------------------------- // 
// File        : float_adder.v
// Author      : pastglory
// Date        : 20200127
// Version     : 1.0
// Description : 32-bit float point adder 
// -----------------------------History----------------------------------- //
// Date      BY          Version  Change Description
//
// 20200127  pastglory   1.0      Initial Release. 
// ----------------------------------------------------------------------- //

module float_adder #(
  parameter   E     =     8,  //  Exponent
  parameter   M     =     23, //  Mantissa
  parameter   Width =     32
)(
  input       [Width - 1 : 0]       a,
  input       [Width - 1 : 0]       b,
  output      [Width - 1 : 0]       c
);

wire                                as, bs;
assign        as      =             a[Width - 1];
assign        bs      =             b[Width - 1];

wire          [E - 1 : 0]           ae, be, ce;
wire          [M - 1: 0]            am, bm;

assign        ae      =             a[Width - 2 : M];
assign        be      =             b[Width - 2 : M];
assign        am      =             a[M - 1 : 0];
assign        bm      =             b[M - 1 : 0];

//  greater e, lesser e, difference e
wire          [E - 1 : 0]           ge, le, de;
wire                                agtb;

assign        agtb    =             ae >= be;
assign        ge      =             agtb ? ae : be;
assign        le      =             agtb ? be : ae;
assign        de      =             ge - le;

//  greater s, lesser s
wire                                gs, ls;

assign        gs      =             agtb ? as : bs;
assign        ls      =             agtb ? bs : as;

//  greater m, lesser m, shifted m
wire          [M : 0]               gm, lm, alm;

assign        gm      =             {(ge == 8'b0 ? 1'b0 : 1'b1), (agtb ? am : bm)};
assign        lm      =             {(le == 8'b0 ? 1'b0 : 1'b1), (agtb ? bm : am)};
assign        alm     =             lm >> de;

wire          [M + 2 : 0]           gmout, almout;
ComplementEncoder #(
     .Width           (M + 3)  
)   Encoder_g     (
     .DataIn          ({2'b0, gm})
    ,.Enable          (gs)
    ,.DataOut         (gmout)
);

ComplementEncoder #(
     .Width           (M + 3)
)   Encoder_l     (
     .DataIn          ({2'b0, alm})
    ,.Enable          (ls)
    ,.DataOut         (almout)
);

wire          [M + 2 : 0]           cm_com, cm;
assign        cm_com      =         gmout + almout;

//  sign of output
assign        c[Width - 1] =        cm_com[M + 2];

ComplementEncoder #(
     .Width           (M + 3)
)   Encoder_out   (
     .DataIn          (cm_com)
    ,.Enable          (cm_com[M + 2])
    ,.DataOut         (cm)
);

wire          [4 : 0]               sc;
PriorityEncoder  PE (
     .DataIn          (cm[24:0])
    ,.DataOut         (sc)
);

wire          [4 : 0]               ShiftDelta;
assign        ShiftDelta          =    5'd23 - sc;

//   Output Mantissa
assign        c[Width - 2 : M]    =    (sc > 5'd23) ? ge + 1 : (
                                       (sc < 5'd23) ? ge - ShiftDelta : ge);

//   Output Exponent
wire          [M : 0]               tmp;
assign        tmp                 =    (sc > 5'd23) ? (cm >> 1) : (
                                       (sc < 5'd23) ? (cm << (ShiftDelta)) : cm);

//   Cut
assign        c[M - 1 : 0]        =    tmp[M - 1 : 0];                                       

endmodule