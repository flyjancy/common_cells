//--------------------------------------------------------------------------
//  Float Point Multiplication
//  IEEE 754 Float Point Standard
//  For 32bit Float Point Multiplication Operation
//  2020.1.27
//--------------------------------------------------------------------------
module FloatMul #(
  //  IEEE 754 float standard
  parameter   E     =     8,  //  Exponent
  parameter   M     =     23, //  Mantissa
  parameter   Width =     32
)(
  input       [Width - 1 : 0]       a,
  input       [Width - 1 : 0]       b,
  output      [Width - 1 : 0]       c
);

//  Sign
wire                                as, bs, cs;
assign        as                =   a[Width - 1];
assign        bs                =   b[Width - 1];
assign        cs                =   as ^ bs;

//  Exponent
wire          [E - 1 : 0]           ae, be;
wire          [E : 0]               cetmp;
assign        ae                =   a[Width - 2 : M];
assign        be                =   b[Width - 2 : M];
assign        cetmp             =   ae + be - 127;

//  Mantissa with extend MSB - 1/0
wire          [M : 0]               am, bm;
wire          [2 * M + 1 : 0]       cmtmp;
assign        am                =   {((ae == 8'b0) ? 1'b0 : 1'b1), a[M - 1 : 0]};
assign        bm                =   {((be == 8'b0) ? 1'b0 : 1'b1), b[M - 1 : 0]};
assign        cmtmp             =   am * bm;

wire          [M : 0]               cm;
wire          [E - 1 : 0]           ce;

FloatMulNormal #(
         .E         (E)
        ,.M         (M)
)       Nor(
         .ine       (cetmp)
        ,.inm       (cmtmp)
        ,.oute      (ce)
        ,.outm      (cm)
);

//  Output
assign        c[Width - 1]      =   cs;
assign        c[Width - 2 : M]  =   (a == 32'b0 || b == 32'b0) ? 8'b0 : ce;
assign        c[M - 1 : 0]      =   (a == 32'b0 || b == 32'b0) ? 23'b0 : cm;

endmodule