`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2014/05/23 16:24:31
// Design Name: 
// Module Name: ov7725_top
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


module ov7670_top(

		  input 	   BTNU,
		  input 	   BTNC,
		  input 	   BTND,
		  input 	   CPU_RESETN,
		  input 	   clk,
		  input 	   OV7670_VSYNC,
		  input 	   OV7670_HREF,
		  input 	   OV7670_PCLK,
		  output 	   OV7670_XCLK,
		  output 	   OV7670_SIOC,
		  inout 	   OV7670_SIOD,
		  input [7:0] 	   OV7670_D,

		  output [3:0] 	   LED,
		  output reg [3:0] vga444_red,
		  output reg [3:0] vga444_green,
		  output reg [3:0] vga444_blue,
		  output reg 	   vga_hsync,
		  output reg 	   vga_vsync,
		  output 	   pwdn,
		  output 	   reset,
		  output [7:0]cathode,
		  output [7:0]AN
);

//BTNU = calibration mode

   wire [16:0] 			   frame_addr;
   wire [16:0] 			   capture_addr;   
   //wire  capture_we;  
   wire 			   config_finished;
   wire                CLK100MHZ;
   wire                CLK100MHZ_1;  
   wire 			   CLK25MHZ; 
   wire 			   CLK50MHZ;     
   wire 			   CLK108MHZ;
   wire 			   resend;        
   wire [15:0] 			   frame_pixel;  
   wire [15:0] 			   data_16;
   wire [11:0] 			   X;
   wire [11:0] 			   Y;
   wire [64:0] 			   X_position;
   wire [64:0] 			   Y_position;
   //reg [16:0] 			   X_position_reg;
   //reg [16:0]              Y_position_reg;
   wire [64:0]             avg_X_smooth;
   wire [64:0]             avg_Y_smooth;
   //reg [16:0]               avg_X_reg;
   //reg [16:0]               avg_Y_reg; 
   //reg clk_50_reg;
   assign pwdn = 0;
   assign reset = 1;
   assign X[11:0]=1280-((X_position[11:0])*(1280/320));
   assign Y[11:0]=(Y_position[11:0])*(1024/240);
   
   assign LED = {3'b0,config_finished};  // LED0 indicates camera configuration is done
   assign  	OV7670_XCLK = CLK25MHZ;
   assign CLK100MHZ = clk;
   assign CLK100MHZ_2 = clk;
   
   reg calib;
   reg [23:0]calib_counter;
   initial begin
      calib=1'b1;
   end
   
   wire reset1 = 0;
   wire locked1;
   wire clk_108;
   
   wire [3:0] vga444_red1;
   wire [3:0] vga444_green1;
   wire [3:0] vga444_blue1;
   wire       vga_hsync1;
   wire       vga_vsync1;
   wire [3:0] vga444_red2;
   wire [3:0] vga444_green2;
   wire [3:0] vga444_blue2;
   wire       vga_hsync2;
   wire       vga_vsync2;
   
   /*test registers*/
   /*reg [16:0]posX, posY;
   assign LED[1] = (| posX) | (|posY);
   reg [11:0]counterXY;
   
   always @ (posedge CLK108MHZ) begin
        counterXY <= counterXY + 1;
   end*/
   
   
   
   debounce   btn_debounce(
			   .clk(CLK50MHZ),
			   .i(BTNC),
			   .o(resend)
			   );
   always@(posedge CLK25MHZ or negedge CPU_RESETN) begin
        if(~CPU_RESETN) begin
            calib <= 1;
            //posX <= 0;
            //posY <= 0;
        end
        else begin
            //posX <= X_position;
            //posY <= Y_position;
            if(BTNU==1) begin
                if(calib_counter == 24'h4C4B40) begin
                    calib <= ~calib;
                end
                else begin
                    calib_counter <= calib_counter + 1;
                end
	        end
	        else begin
	           calib_counter <= 0;
	        end
	    end
   end
   
   
   vga444   Inst_vga(
		     
		     .clk25       (CLK25MHZ),
		     .vga_red    (vga444_red1),
		     .vga_green   (vga444_green1),
		     .vga_blue    (vga444_blue1),
		     .vga_hsync   (vga_hsync1),
		     .vga_vsync  (vga_vsync1),
		     .HCnt       (),
		     .VCnt       (),
		     
		     .frame_addr   (frame_addr),
		     .frame_pixel  (frame_pixel)
		     );
   
   // BRAM using memory generator from IP catalog
   // dual-port, 16 bits wide, 76800 deep 
   
   blk_mem_gen_0 u_frame_buffer (
				 .clka(OV7670_PCLK),    // input wire clka
				 .wea(1'b1),      // input wire [0 : 0] wea
				 .addra(capture_addr),  // input wire [16 : 0] addra
				 .dina(data_16),    // input wire [15 : 0] dina
				 .clkb(CLK25MHZ),    // input wire clkb
				 .addrb(frame_addr),  // input wire [16 : 0] addrb
				 .doutb(frame_pixel)  // output wire [15 : 0] doutb
				 );
   
   
   
   ov7670_capture capture(
			  .calibration(calib),
 			  .pclk  (OV7670_PCLK),
 			  .vsync (OV7670_VSYNC),
 			  .href  (OV7670_HREF),
 			  .d     ( OV7670_D),
 			  .addr  (capture_addr),
 			  .dout( data_16),
 			  .we   (),
 			  .avg_X_smooth(X_position),
 			  .avg_Y_smooth(Y_position)
 			  );
   
   I2C_AV_Config IIC(
 		     .iCLK   ( CLK25MHZ),    
 		     .iRST_N (! resend),    
 		     .Config_Done ( config_finished),
 		     .I2C_SDAT  ( OV7670_SIOD),    
 		     .I2C_SCLK  ( OV7670_SIOC),
 		     .LUT_INDEX (),
 		     .I2C_RDATA ()
 		     ); 
   
   
   // Derive two clocks for the board provided 100 MHz clock.
   // Generated using clock wizard in IP Catalog
   
   //clock_wrapper clock_wrapper_inst(.clk_in(clk), .clk_50(CLK50MHZ), .clk_25(CLK25MHZ), .clk_108(CLK108MHZ));
    //clk_adjusted clk_adjusted_inst(.clk_in(clk), .clk_25(CLK25MHZ), .clk_50(CLK50MHZ));
    clk_wiz_0 u_clock
             (
              // Clock in ports
              .clk_in1(clk),      // input clk_in1
              // Clock out ports
              .clk_out1(CLK50MHZ),     // output clk_out1
              .clk_out2(CLK25MHZ),
              .clk_out3(CLK108MHZ)
              //.reset(reset),
              //.locked(locked)
              );    // output clk_out2
              
    /*clk_wiz_1 clk_wiz_1_inst
                (
                .clk_in1(clk),
                .clk_out1(CLK108MHZ)
                );
                */

   top_mod sam_s_vga
     (
      //.clk_new(clk108),
      .clk(CLK108MHZ),
      .resetn(CPU_RESETN),
      .start(BTND),
      .X_position(X),
      .Y_position(Y),
      .vgaRed(vga444_red2),
      .vgaGreen(vga444_green2),
      .vgaBlue(vga444_blue2),
      .Hsync(vga_hsync2),
      .Vsync(vga_vsync2),
      .cathode(cathode),
      .anode(AN)
      
      );
   always@(posedge CLK108MHZ)begin
      if(calib==1)begin
         vga444_red<=vga444_red1;
         vga444_green<=vga444_green1;
         vga444_blue<=vga444_blue1;
         vga_hsync<=vga_hsync1;
	 vga_vsync<=vga_vsync1;
      end
      else begin
         vga444_red<=vga444_red2;
         vga444_green<=vga444_green2;
         vga444_blue<=vga444_blue2;
         vga_hsync<=vga_hsync2;
         vga_vsync<=vga_vsync2;
      end
   end
   
   /*
    reg [16:0] window_size=16'd10000;
    reg [16:0] avg_count;
    reg [16:0] smoothened_X_sum;
    reg [16:0] smoothened_Y_sum;
    
   initial begin
      smoothened_X_sum=16'b0;
      smoothened_Y_sum=16'b0;
      avg_count=16'b0;
   end
   always@*begin
    avg_X_reg=avg_X;
    avg_Y_reg=avg_Y;
   end
   always@(posedge CLK25MHZ)begin
       if(avg_count < window_size)begin
                   avg_count<=avg_count+1;
                   smoothened_X_sum<=smoothened_X_sum+avg_X_reg;
                   smoothened_Y_sum<=smoothened_Y_sum+avg_Y_reg;
              end
              else begin
                   avg_count<=0;
                   X_position_reg<=smoothened_X_sum/(window_size);
                   Y_position_reg<=smoothened_Y_sum/(window_size);
                   smoothened_X_sum<=0;
                   smoothened_Y_sum<=0;
              
              end
   end
   */
endmodule





