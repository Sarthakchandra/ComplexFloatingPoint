`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.10.2020 01:32:05
// Design Name: 
// Module Name: Q_tb
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


module Q_tb(
    );
    reg aclk,aresetn,N_valid,X_valid,T_valid,Q_ready;
    reg [31:0] N,X,T;
    wire [31:0] Q;
    wire N_ready, X_ready, T_ready, Q_valid;
    
    top_module tb1(.aclk(aclk),.aresetn(aresetn),.N(N),.X(X),.T(T),.Q(Q),.N_valid(N_valid),.X_valid(X_valid),.T_valid(T_valid),.Q_valid(Q_valid),.N_ready(N_ready),.X_ready(X_ready),.T_ready(T_ready),.Q_ready(Q_ready));
    
    initial
        begin
            aclk =0;
            aresetn= 0;
            N=0;
            N_valid=0;
            X=0;
            X_valid =0;
            T=0;
            T_valid =0;
            Q_ready = 0;
        end
        always #5 aclk = ~aclk;
        initial
            begin
                #100 aresetn =1;
                #10 N=200;
                #5 N_valid = 1;
                while(N_ready==0)       //Wait for ready signal from the IP
                    #5 N_valid =1;  
                #10 N_valid = 0;             //Set Valid as 0 once handshake is complete
             
               #50 N=103;
               #5 N_valid = 1;
               while(N_ready==0)       //Wait for ready signal from the IP
                   #5 N_valid =1;  
               #10 N_valid = 0;             //Set Valid as 0 once handshake is complete
            end
        initial
            begin
                #110 T=199;
                #5 T_valid = 1;
                while(T_ready==0)           //Wait for ready signal from the IP
                    #5 T_valid =1;  
                #10 T_valid = 0;             //Set Valid as 0 once handshake is complete
                #50 T=102;
                #5 T_valid = 1;
                while(T_ready==0)       //Wait for ready signal from the IP
                    #5 T_valid =1;  
                #10 T_valid = 0;             //Set Valid as 0 once handshake is complete
            end
        initial
            begin
                #110 X=198;
                #5 X_valid = 1;
                    while(X_ready==0)       //Wait for ready signal from the IP
                        #5 X_valid =1;  
                #10 X_valid = 0;             //Set Valid as 0 once handshake is complete
                #5 Q_ready =1'b1;
        
             wait(Q_valid==1'b1)                 // Wait for QValid (Will be set by IP) to go high
                #5 Q_ready = 1'b1;             //Keep QReady high for one clock cycle for the handshake to take place
             #5 Q_ready = 1'b0;
             
             #110 X=98;
             #5 X_valid = 1;
                 while(X_ready==0)          //Wait for reset signal from the IP
                     #5 X_valid =1;  
             #10 X_valid = 0;               //Set Valid as 0 once handshake is complete
             #5 Q_ready =1'b1;
     
             wait(Q_valid==1'b1)             // Wait for QValid (Will be set by IP) to go high
                 #5 Q_ready = 1'b1;          //Keep QReady high for one clock cycle for the handshake to take place
              #5 Q_ready =1'b0;
                end           
endmodule
