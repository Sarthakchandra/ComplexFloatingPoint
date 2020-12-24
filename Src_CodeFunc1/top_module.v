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
   .aclk(aclk),                             // input wire aclk
   .aresetn(aresetn),                       // input wire aresetn
   .s_axis_a_tvalid(N_valid),               // input wire s_axis_a_tvalid
   .s_axis_a_tready(N_ready),               // output wire s_axis_a_tready
   .s_axis_a_tdata(N),                      // input wire [31 : 0] s_axis_a_tdata
   .m_axis_result_tvalid(FN_valid),         // output wire m_axis_result_tvalid
   .m_axis_result_tready(FN_ready),         // input wire m_axis_result_tready
   .m_axis_result_tdata(FN)                 // output wire [31 : 0] m_axis_result_tdata
 );
   
   wire [31:0] FT;
   wire FT_ready, FT_valid;
   // Converting T to floating point
   fixed_to_float T_Float(
     .aclk(aclk),                           // input wire aclk
     .aresetn(aresetn),                     // input wire aresetn
     .s_axis_a_tvalid(T_valid),             // input wire s_axis_a_tvalid
     .s_axis_a_tready(T_ready),             // output wire s_axis_a_tready
     .s_axis_a_tdata(T),                    // input wire [31 : 0] s_axis_a_tdata
     .m_axis_result_tvalid(FT_valid),       // output wire m_axis_result_tvalid
     .m_axis_result_tready(FT_ready),       // input wire m_axis_result_tready
     .m_axis_result_tdata(FT)               // output wire [31 : 0] m_axis_result_tdata
   );
   
     wire [31:0] FX;
     wire FX_ready, FX_valid;
     // Converting X to floating point
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
     //Doing X/T (in floating point)
     wire[31:0] X_div_T;
     wire X_div_T_ready,X_div_T_valid;
     divide X_division_T (
       .aclk(aclk),                         // input wire aclk
       .aresetn(aresetn),                   // input wire aresetn
       .s_axis_a_tvalid(FX_valid),          // input wire s_axis_a_tvalid
       .s_axis_a_tready(FX_ready),          // output wire s_axis_a_tready
       .s_axis_a_tdata(FX),                 // input wire [31 : 0] s_axis_a_tdata
       .s_axis_b_tvalid(FT_valid),          // input wire s_axis_b_tvalid
       .s_axis_b_tready(FT_ready),          // output wire s_axis_b_tready
       .s_axis_b_tdata(FT),                 // input wire [31 : 0] s_axis_b_tdata
       .m_axis_result_tvalid(X_div_T_valid),// output wire m_axis_result_tvalid
       .m_axis_result_tready(X_div_T_ready),// input wire m_axis_result_tready
       .m_axis_result_tdata(X_div_T)        // output wire [31 : 0] m_axis_result_tdata
        );
     wire[31:0] log_N;
     wire log_N_ready,log_N_valid;
     //taking Log(N) in floating point
     logarithm log_t2 (
       .aclk(aclk),                         // input wire aclk
       .aresetn(aresetn),                   // input wire aresetn
       .s_axis_a_tvalid(FN_valid),          // input wire s_axis_a_tvalid
       .s_axis_a_tready(FN_ready),          // output wire s_axis_a_tready
       .s_axis_a_tdata(FN),                 // input wire [31 : 0] s_axis_a_tdata
       .m_axis_result_tvalid(log_N_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(log_N_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(log_N)          // output wire [31 : 0] m_axis_result_tdata
     );
     wire[31:0] log_div_T;
     wire log_div_T_ready,log_div_T_valid;
     //log10(n)/T (infloating point)
     divide log_division (
       .aclk(aclk),                             // input wire aclk
       .aresetn(aresetn),                       // input wire aresetn
       .s_axis_a_tvalid(log_N_valid),           // input wire s_axis_a_tvalid
       .s_axis_a_tready(log_N_ready),           // output wire s_axis_a_tready
       .s_axis_a_tdata(log_N),                  // input wire [31 : 0] s_axis_a_tdata
       .s_axis_b_tvalid(FT_valid),              // input wire s_axis_b_tvalid
       //.s_axis_b_tready(FT_ready),              // output wire s_axis_b_tready
       .s_axis_b_tdata(FT),                     // input wire [31 : 0] s_axis_b_tdata
       .m_axis_result_tvalid(log_div_T_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(log_div_T_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(log_div_T)          // output wire [31 : 0] m_axis_result_tdata
        );
        wire[31:0] four_log_div_T;
        wire four_log_div_T_ready,four_log_div_T_valid; 
        //Multiplication of the Minimum value by log10(N)/T
        multiplication by4 (
               .aclk(aclk),                                  // input wire aclk
               .aresetn(aresetn),                            // input wire aresetn
               .s_axis_a_tvalid(log_div_T_valid),            // input wire s_axis_a_tvalid
               .s_axis_a_tready(log_div_T_ready),            // output wire s_axis_a_tready
               .s_axis_a_tdata(log_div_T),              // input wire [31 : 0] s_axis_a_tdata
               .s_axis_b_tvalid(log_div_T_valid),            // input wire s_axis_b_tvalid
               //.s_axis_b_tready(t2_net_ready),            // output wire s_axis_b_tready
               .s_axis_b_tdata(32'b01000000100000000000000000000000),              // input wire [31 : 0] s_axis_b_tdata
               .m_axis_result_tvalid(four_log_div_T_valid),  // output wire m_axis_result_tvalid
               .m_axis_result_tready(four_log_div_T_ready),  // input wire m_axis_result_tready
               .m_axis_result_tdata(four_log_div_T)    // output wire [31 : 0] m_axis_result_tdata
             );
      wire[31:0] root_t2;
      wire root_t2_ready,root_t2_valid;
      //Root(log10(n)/T) in floating Point
      root sqrt1 (
          .aclk(aclk),                          // input wire aclk
          .aresetn(aresetn),                    // input wire aresetn
          .s_axis_a_tvalid(four_log_div_T_valid),    // input wire s_axis_a_tvalid
          .s_axis_a_tready(four_log_div_T_ready),    // output wire s_axis_a_tready
          .s_axis_a_tdata(four_log_div_T),           // input wire [31 : 0] s_axis_a_tdata
          .m_axis_result_tvalid(root_t2_valid), // output wire m_axis_result_tvalid
          .m_axis_result_tready(root_t2_ready), // input wire m_axis_result_tready
          .m_axis_result_tdata(root_t2)         // output wire [31 : 0] m_axis_result_tdata
        );
     wire[31:0] t2_net;
     wire t2_net_valid,t2_net_ready;
     //X/T-root(log10(N)/T)
     subtraction net (
          .aclk(aclk),                          // input wire aclk
          .aresetn(aresetn),                    // input wire aresetn
          .s_axis_a_tvalid(X_div_T_valid),      // input wire s_axis_a_tvalid
          .s_axis_a_tready(X_div_T_ready),      // output wire s_axis_a_tready
          .s_axis_a_tdata(X_div_T),             // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(root_t2_valid),      // input wire s_axis_b_tvalid
          .s_axis_b_tready(root_t2_ready),      // output wire s_axis_b_tready
          .s_axis_b_tdata(root_t2),             // input wire [31 : 0] s_axis_b_tdata
          .m_axis_result_tvalid(t2_net_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(t2_net_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(t2_net)          // output wire [31 : 0] m_axis_result_tdata
        );
        //Finding Minimum between 1/4 and X/T-root(log10(N)/T)
        wire[31:0] minm;
        wire minm_valid,minm_ready;
        smaller minimum (
          .aclk(aclk),                                  // input wire aclk
          .aresetn(aresetn),                            // input wire aresetn
          .s_axis_a_tvalid(t2_net_valid),            // input wire s_axis_a_tvalid
          //.s_axis_a_tready(s_axis_a_tready),            // output wire s_axis_a_tready
          .s_axis_a_tdata(32'b00111110100000000000000000000000),              // input wire [31 : 0] s_axis_a_tdata
          .s_axis_b_tvalid(t2_net_valid),            // input wire s_axis_b_tvalid
          .s_axis_b_tready(t2_net_ready),            // output wire s_axis_b_tready
          .s_axis_b_tdata(t2_net),              // input wire [31 : 0] s_axis_b_tdata
          .m_axis_result_tvalid(minm_valid),  // output wire m_axis_result_tvalid
          .m_axis_result_tready(minm_ready),  // input wire m_axis_result_tready
          .m_axis_result_tdata(minm)    // output wire [7 : 0] m_axis_result_tdata
        );
        
     wire [31:0] min;
     wire min_ready, min_valid;
     assign min = minm?32'b00111110100000000000000000000000:t2_net;
     
     wire[31:0] t2;
     wire t2_ready,t2_valid; 
     //Multiplication of the Minimum value by log10(N)/T
     multiplication term2 (
            .aclk(aclk),                                  // input wire aclk
            .aresetn(aresetn),                            // input wire aresetn
            .s_axis_a_tvalid(log_div_T_valid),            // input wire s_axis_a_tvalid
            //.s_axis_a_tready(log_div_T_ready),            // output wire s_axis_a_tready
            .s_axis_a_tdata(log_div_T),              // input wire [31 : 0] s_axis_a_tdata
            .s_axis_b_tvalid(minm_valid),            // input wire s_axis_b_tvalid
            .s_axis_b_tready(minm_ready),            // output wire s_axis_b_tready
            .s_axis_b_tdata(min),              // input wire [31 : 0] s_axis_b_tdata
            .m_axis_result_tvalid(t2_valid),  // output wire m_axis_result_tvalid
            .m_axis_result_tready(t2_ready),  // input wire m_axis_result_tready
            .m_axis_result_tdata(t2)    // output wire [31 : 0] m_axis_result_tdata
          );
    //Root(log10(N)/T*Minimum
     wire[31:0] root_whole;
     wire root_whole_ready,root_whole_valid;
     root sqrt (
       .aclk(aclk),                                  // input wire aclk
       .aresetn(aresetn),                            // input wire aresetn
       .s_axis_a_tvalid(t2_valid),            // input wire s_axis_a_tvalid
       .s_axis_a_tready(t2_ready),            // output wire s_axis_a_tready
       .s_axis_a_tdata(t2),              // input wire [31 : 0] s_axis_a_tdata
       .m_axis_result_tvalid(root_whole_valid),  // output wire m_axis_result_tvalid
       .m_axis_result_tready(root_whole_ready),  // input wire m_axis_result_tready
       .m_axis_result_tdata(root_whole)    // output wire [31 : 0] m_axis_result_tdata
     );
     //Addition of X/T + Root(log10(N)/T*Minimum
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