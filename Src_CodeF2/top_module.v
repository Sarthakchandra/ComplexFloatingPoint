`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.10.2020 08:59:23
// Design Name: 
// Module Name: top_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_module(
    input aclk,
    input aresetn,
    input [31:0] N,
    input [31:0] X,
    input [31:0] T,
    output [31:0] Q,
    input N_valid,
    input X_valid,
    input T_valid,
    output Q_valid,
    output N_ready,
    output X_ready,
    output T_ready,
    input Q_ready
    );
    wire [31:0] FN;
    wire FN_ready, FN_valid;
       fixed_to_float N_Float(
   .aclk(aclk),                                  // input wire aclk
   .aresetn(aresetn),                            // input wire aresetn
   .s_axis_a_tvalid(N_valid),            // input wire s_axis_a_tvalid
   .s_axis_a_tready(N_ready),            // output wire s_axis_a_tready
   .s_axis_a_tdata(N),               // input wire [31 : 0] s_axis_a_tdata
   .m_axis_result_tvalid(FN_valid),  // output wire m_axis_result_tvalid
   .m_axis_result_tready(FN_ready),  // input wire m_axis_result_tready
   .m_axis_result_tdata(FN)          // output wire [31 : 0] m_axis_result_tdata
 );
 
   wire [31:0] FT;
   wire FT_ready, FT_valid;
   
   fixed_to_float T_Float(
     .aclk(aclk),                                  // input wire aclk
     .aresetn(aresetn),                            // input wire aresetn
     .s_axis_a_tvalid(T_valid),            // input wire s_axis_a_tvalid
     .s_axis_a_tready(T_ready),            // output wire s_axis_a_tready
     .s_axis_a_tdata(T),              // input wire [31 : 0] s_axis_a_tdata
     .m_axis_result_tvalid(FT_valid),  // output wire m_axis_result_tvalid
     .m_axis_result_tready(FT_ready),    // input wire m_axis_result_tready
     .m_axis_result_tdata(FT)            // output wire [31 : 0] m_axis_result_tdata
   );
     wire [31:0] FX;
     wire FX_ready, FX_valid;
     
     fixed_to_float X_Float(
       .aclk(aclk),                          //input wire aclk
       .aresetn(aresetn),                    // input wire aresetn
       .s_axis_a_tvalid(X_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(X_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(X),                   // input wire [31 : 0] s_axis_a_tdata
       .m_axis_result_tvalid(FX_valid),      // output wire m_axis_result_tvalid
       .m_axis_result_tready(FX_ready),      // input wire m_axis_result_tready
       .m_axis_result_tdata(FX)              // output wire [31 : 0] m_axis_result_tdata
     );
     wire[31:0] X_div_T;
     wire X_div_T_ready,X_div_T_valid;
     divide X_division_T (
       .aclk(aclk),                                  // input wire aclk
       .aresetn(aresetn),                            // input wire aresetn
       .s_axis_a_tvalid(FX_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(FX_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(FX),              // input wire [31 : 0] s_axis_a_tdata
       .s_axis_b_tvalid(FT_valid),            // input wire s_axis_b_tvalid
       .s_axis_b_tready(FT_ready),            // output wire s_axis_b_tready
       .s_axis_b_tdata(FT),              // input wire [31 : 0] s_axis_b_tdata
       .m_axis_result_tvalid(X_div_T_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(X_div_T_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(X_div_T)    // output wire [31 : 0] m_axis_result_tdata
        );
     wire[31:0] div_square;
     wire div_square_ready,div_square_valid; 
     mulitply square (
       .aclk(aclk),                                  // input wire aclk
       .aresetn(aresetn),                            // input wire aresetn
       .s_axis_a_tvalid(X_div_T_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(X_div_T_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(X_div_T),              // input wire [31 : 0] s_axis_a_tdata
       .s_axis_b_tvalid(X_div_T_valid),            // input wire s_axis_b_tvalid
       .s_axis_b_tready(X_div_T_ready),            // output wire s_axis_b_tready
       .s_axis_b_tdata(X_div_T),              // input wire [31 : 0] s_axis_b_tdata
       .m_axis_result_tvalid(div_square_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(div_square_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(div_square)    // output wire [31 : 0] m_axis_result_tdata
     );
     wire[31:0] div_sub_square;
     wire div_sub_square_ready,div_sub_square_valid;
     
     subtract normal_square (
       .aclk(aclk),                                  // input wire aclk
       .aresetn(aresetn),                            // input wire aresetn
       .s_axis_a_tvalid(X_div_T_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(X_div_T_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(X_div_T),              // input wire [31 : 0] s_axis_a_tdata
       .s_axis_b_tvalid(div_square_valid),            // input wire s_axis_b_tvalid
       .s_axis_b_tready(div_square_ready),            // output wire s_axis_b_tready
       .s_axis_b_tdata(div_square),              // input wire [31 : 0] s_axis_b_tdata
       .m_axis_result_tvalid(div_sub_square_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(div_sub_square_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(div_sub_square)    // output wire [31 : 0] m_axis_result_tdata
     );
     
     wire[31:0] root_whole;
     wire root_whole_ready,root_whole_valid;
     root sqrt (
       .aclk(aclk),                                  // input wire aclk
       .aresetn(aresetn),                            // input wire aresetn
       .s_axis_a_tvalid(div_sub_square_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(div_sub_square_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(div_sub_square),              // input wire [31 : 0] s_axis_a_tdata
       .m_axis_result_tvalid(root_whole_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(root_whole_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(root_whole)    // output wire [31 : 0] m_axis_result_tdata
     );
     addition result (
       .aclk(aclk),                                  // input wire aclk
       .aresetn(aresetn),                            // input wire aresetn
       .s_axis_a_tvalid(X_div_T_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(X_div_T_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(X_div_T),              // input wire [31 : 0] s_axis_a_tdata
       .s_axis_b_tvalid(root_whole_valid),            // input wire s_axis_b_tvalid
       .s_axis_b_tready(root_whole_ready),            // output wire s_axis_b_tready
       .s_axis_b_tdata(root_whole),              // input wire [31 : 0] s_axis_b_tdata
       .m_axis_result_tvalid(Q_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(Q_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(Q)    // output wire [31 : 0] m_axis_result_tdata
     );
endmodule