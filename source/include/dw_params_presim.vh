
`define SYNTH_MINI // 2 PEB function
// `define SYNTH_FREQ
// `define SYNTH_AC

`ifdef SYNTH_AC
  `define NUMPEB 16 //?
  `define GBFWEI_ADDRWIDTH 8  //? 9 KBSSS< `BLOCK_DEPTH * `NUMPEC = 32 * 48 = 1536
  `define GBFACT_ADDRWIDTH 11 //? 16KB
`elsif SYNTH_FREQ
  `define NUMPEB 16
  `define GBFWEI_ADDRWIDTH 1  //?64 > 16*3
  `define GBFACT_ADDRWIDTH 2 //?
`elsif SYNTH_MINI
  `define NUMPEB 2
  `define GBFWEI_ADDRWIDTH 8  //?64 > log2(BLOCK_DEPTH* KERNEL_SIZE * NumPEC * NumPEB * NumBlk) = 32x9x3x2x2 = 3456
  `define GBFACT_ADDRWIDTH 8 // log2( 16x16x32x NumBlk x NumFrmx (1-sparsity) )= 2048x32
`endif

`define BLOCK_DEPTH 32
`define DATA_WIDTH 8

`define NUMPEC 3*`NUMPEB

`define KERNEL_SIZE 9
`define MAX_DEPTH 1024 // c3d 512 i3d 1024
`define GBFWEI_DATAWIDTH `DATA_WIDTH * `KERNEL_SIZE // avoid * 9
`define GBFFLGWEI_DATAWIDTH `BLOCK_DEPTH * `KERNEL_SIZE //288
`define PORT_DATAWIDTH `DATA_WIDTH * 12
// `define GBFFLGACT_ADDRWIDTH 8


`define LENROW 16
`define LENPSUM 14

// POOL parameters
//`define POOL_WIDTH 2//Stride
`define POOL_KERNEL_WIDTH 3 // 2 3 7
`define GBFOFM_ADDRWIDTH  `C_LOG_2(`LENPSUM*`LENPSUM*`NUMPEB/(`PORT_DATAWIDTH/`DATA_WIDTH))
`define GBFFLGOFM_ADDRWIDTH  `C_LOG_2(`LENPSUM*`LENPSUM*`NUMPEB/`PORT_DATAWIDTH)

`define BUSPEC_WIDTH (8 + `BLOCK_DEPTH + `DATA_WIDTH * `BLOCK_DEPTH)
`define BUSPEB_WIDTH `BUSPEC_WIDTH
`define PSUM_WIDTH (`DATA_WIDTH *2 + `C_LOG_2(`KERNEL_SIZE*`MAX_DEPTH) )

// Config parameters

`define FRAME_WIDTH 5
`define PATCH_WIDTH 8
`define BLK_WIDTH   `C_LOG_2(1024/`BLOCK_DEPTH)   //ONLY FOR CONV, FC? 5
`define LAYER_WIDTH 8 //256 layers
`define NUM_CFG_WIDTH `LAYER_WIDTH
`define ASYSFIFO_ADDRWIDTH 5

// Interface
`define IFCODE_CFG 0
`define IFCODE_FLGWEI 8
`define IFCODE_WEI 6
`define IFCODE_FLGACT 4
`define IFCODE_ACT 2
`define IFCODE_FLGOFM 10
`define IFCODE_OFM 11

//`define GBFFLGWEI_ADDRWIDTH =

`define RD_SIZE_CFG 2**`NUM_CFG_WIDTH //12B x 256
`define RD_SIZE_FLGWEI  2**`GBFWEI_ADDRWIDTH/8 //read half and juge 1/4; 1/8 wei
`define RD_SIZE_WEI 2**`GBFWEI_ADDRWIDTH/2
`define RD_SIZE_FLGACT 2** `GBFACT_ADDRWIDTH/8/2
`define RD_SIZE_ACT 2** `GBFACT_ADDRWIDTH/2
`define WR_SIZE_FLGOFM 2**`GBFFLGOFM_ADDRWIDTH/2
//`define WR_SIZE_OFM 2**`GBFOFM_ADDRWIDTH/2
`define WR_SIZE_OFM 16

`define ACT_ADDR        32'h0800_0000
`define FLGACT_ADDR   32'h0801_0000
`define WEI_ADDR         32'h0802_0000
`define FLGWEI_ADDR   32'h0803_0000
`define CFG_ADDR        32'h0804_0000

//-----------------------------------------------------------
//Simple Log2 calculation function
//-----------------------------------------------------------
//up compute <=16 =>4
`define C_LOG_2(n) (\
(n) <= (1<<0) ? 0 : (n) <= (1<<1) ? 1 :\
(n) <= (1<<2) ? 2 : (n) <= (1<<3) ? 3 :\
(n) <= (1<<4) ? 4 : (n) <= (1<<5) ? 5 :\
(n) <= (1<<6) ? 6 : (n) <= (1<<7) ? 7 :\
(n) <= (1<<8) ? 8 : (n) <= (1<<9) ? 9 :\
(n) <= (1<<10) ? 10 : (n) <= (1<<11) ? 11 :\
(n) <= (1<<12) ? 12 : (n) <= (1<<13) ? 13 :\
(n) <= (1<<14) ? 14 : (n) <= (1<<15) ? 15 :\
(n) <= (1<<16) ? 16 : (n) <= (1<<17) ? 17 :\
(n) <= (1<<18) ? 18 : (n) <= (1<<19) ? 19 :\
(n) <= (1<<20) ? 20 : (n) <= (1<<21) ? 21 :\
(n) <= (1<<22) ? 22 : (n) <= (1<<23) ? 23 :\
(n) <= (1<<24) ? 24 : (n) <= (1<<25) ? 25 :\
(n) <= (1<<26) ? 26 : (n) <= (1<<27) ? 27 :\
(n) <= (1<<28) ? 28 : (n) <= (1<<29) ? 29 :\
(n) <= (1<<30) ? 30 : (n) <= (1<<31) ? 31 : 32)
//-----------------------------------------------------------

`define CEIL(a,b) ( \
 (a%b)? (a/b+1):(a/b) \
)