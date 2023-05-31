module SRAM_weight_16384x32b( 
    input wire clk,
    input wire [ 3:0] wea0,
    input wire [15:0] addr0,
    input wire [31:0] wdata0,
    output reg [31:0] rdata0,
    input wire [ 3:0] wea1,
    input wire [15:0] addr1,
    input wire [31:0] wdata1,
    output reg [31:0] rdata1
);

reg [15:0] delay_addr0, delay_addr1;

reg [3:0] wea0_0, wea0_1, wea0_2, wea0_3, wea0_4, wea0_5, wea0_6, wea0_7;
reg [3:0] wea1_0, wea1_1, wea1_2, wea1_3, wea1_4, wea1_5, wea1_6, wea1_7;

reg [31:0] rdata0_0, rdata0_1, rdata0_2, rdata0_3, rdata0_4, rdata0_5, rdata0_6, rdata0_7;
reg [31:0] rdata1_0, rdata1_1, rdata1_2, rdata1_3, rdata1_4, rdata1_5, rdata1_6, rdata1_7;

always @* begin
    wea0_0 = 0;
    wea0_1 = 0;
    wea0_2 = 0;
    wea0_3 = 0;
    wea0_4 = 0;
    wea0_5 = 0;
    wea0_6 = 0;
    wea0_7 = 0;
    wea1_0 = 0;
    wea1_1 = 0;
    wea1_2 = 0;
    wea1_3 = 0;
    wea1_4 = 0;
    wea1_5 = 0;
    wea1_6 = 0;
    wea1_7 = 0;
    //BRAM_0
    if (addr1 < 2048)begin
        wea0_0 = wea0;
        wea1_0 = wea1;
    end
    //BRAM_1
    else if (addr1 < 4096)begin
        wea0_1 = wea0;
        wea1_1 = wea1;
    end
    //BRAM_2
    else if (addr1 < 6144)begin
        wea0_2 = wea0;
        wea1_2 = wea1;
    end
    //BRAM_3
    else if (addr1 < 8192)begin
        wea0_3 = wea0;
        wea1_3 = wea1;
    end
    //BRAM_4
    else if (addr1 < 10240)begin
        wea0_4 = wea0;
        wea1_4 = wea1;
    end
    //BRAM_5
    else if (addr1 < 12288)begin
        wea0_5 = wea0;
        wea1_5 = wea1;
    end
    //BRAM_6
    else if (addr1 < 14336)begin
        wea0_6 = wea0;
        wea1_6 = wea1;
    end
    //BRAM_7
    else if (addr1 < 16384)begin
        wea0_7 = wea0;
        wea1_7 = wea1;
    end
end

//radta  delay 1 cycle
always @(posedge clk) begin
    delay_addr0 <= addr0;
    delay_addr1 <= addr1;
end

always @* begin
    rdata0 = 0;
    rdata1 = 0;
    //BRAM_0
    if (delay_addr1 < 2048)begin
        rdata0 = rdata0_0;
        rdata1 = rdata1_0;
    end
    //BRAM_1
    else if (delay_addr1 < 4096)begin
        rdata0 = rdata0_1;
        rdata1 = rdata1_1;
    end
    //BRAM_2
    else if (delay_addr1 < 6144)begin
        rdata0 = rdata0_2;
        rdata1 = rdata1_2;
    end
    //BRAM_3
    else if (delay_addr1 < 8192)begin
        rdata0 = rdata0_3;
        rdata1 = rdata1_3;
    end
    //BRAM_4
    else if (delay_addr1 < 10240)begin
        rdata0 = rdata0_4;
        rdata1 = rdata1_4;
    end
    //BRAM_5
    else if (delay_addr1 < 12288)begin
        rdata0 = rdata0_5;
        rdata1 = rdata1_5;
    end
    //BRAM_6
    else if (delay_addr1 < 14336)begin
        rdata0 = rdata0_6;
        rdata1 = rdata1_6;
    end
    //BRAM_7
    else if (delay_addr1 < 16384)begin
        rdata0 = rdata0_7;
        rdata1 = rdata1_7;
    end
end

BRAM_2048x8 BRAM_W1( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_0[7:0]),   .WE0(wea0_0[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_0[7:0]),   .WE1(wea1_0[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W2( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_0[15:8]),  .WE0(wea0_0[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_0[15:8]),  .WE1(wea1_0[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W3( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_0[23:16]), .WE0(wea0_0[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_0[23:16]), .WE1(wea1_0[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W4( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_0[31:24]), .WE0(wea0_0[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_0[31:24]), .WE1(wea1_0[3]), .WEM1(8'b0), .CE1(1'b1) );

BRAM_2048x8 BRAM_W5( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_1[7:0]),   .WE0(wea0_1[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_1[7:0]),   .WE1(wea1_1[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W6( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_1[15:8]),  .WE0(wea0_1[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_1[15:8]),  .WE1(wea1_1[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W7( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_1[23:16]), .WE0(wea0_1[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_1[23:16]), .WE1(wea1_1[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W8( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_1[31:24]), .WE0(wea0_1[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_1[31:24]), .WE1(wea1_1[3]), .WEM1(8'b0), .CE1(1'b1) );

BRAM_2048x8 BRAM_W9( .CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_2[7:0]),   .WE0(wea0_2[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_2[7:0]),   .WE1(wea1_2[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W10(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_2[15:8]),  .WE0(wea0_2[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_2[15:8]),  .WE1(wea1_2[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W11(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_2[23:16]), .WE0(wea0_2[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_2[23:16]), .WE1(wea1_2[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W12(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_2[31:24]), .WE0(wea0_2[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_2[31:24]), .WE1(wea1_2[3]), .WEM1(8'b0), .CE1(1'b1) );                              

BRAM_2048x8 BRAM_W13(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_3[7:0]),   .WE0(wea0_3[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_3[7:0]),   .WE1(wea1_3[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W14(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_3[15:8]),  .WE0(wea0_3[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_3[15:8]),  .WE1(wea1_3[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W15(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_3[23:16]), .WE0(wea0_3[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_3[23:16]), .WE1(wea1_3[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W16(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_3[31:24]), .WE0(wea0_3[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_3[31:24]), .WE1(wea1_3[3]), .WEM1(8'b0), .CE1(1'b1) );

BRAM_2048x8 BRAM_W17(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_4[7:0]),   .WE0(wea0_4[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_4[7:0]),   .WE1(wea1_4[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W18(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_4[15:8]),  .WE0(wea0_4[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_4[15:8]),  .WE1(wea1_4[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W19(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_4[23:16]), .WE0(wea0_4[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_4[23:16]), .WE1(wea1_4[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W20(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_4[31:24]), .WE0(wea0_4[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_4[31:24]), .WE1(wea1_4[3]), .WEM1(8'b0), .CE1(1'b1) );

BRAM_2048x8 BRAM_W21(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_5[7:0]),   .WE0(wea0_5[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_5[7:0]),   .WE1(wea1_5[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W22(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_5[15:8]),  .WE0(wea0_5[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_5[15:8]),  .WE1(wea1_5[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W23(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_5[23:16]), .WE0(wea0_5[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_5[23:16]), .WE1(wea1_5[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W24(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_5[31:24]), .WE0(wea0_5[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_5[31:24]), .WE1(wea1_5[3]), .WEM1(8'b0), .CE1(1'b1) );

BRAM_2048x8 BRAM_W25(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_6[7:0]),   .WE0(wea0_6[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_6[7:0]),   .WE1(wea1_6[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W26(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_6[15:8]),  .WE0(wea0_6[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_6[15:8]),  .WE1(wea1_6[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W27(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_6[23:16]), .WE0(wea0_6[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_6[23:16]), .WE1(wea1_6[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W28(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_6[31:24]), .WE0(wea0_6[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_6[31:24]), .WE1(wea1_6[3]), .WEM1(8'b0), .CE1(1'b1) );

BRAM_2048x8 BRAM_W29(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[7:0]),   .Q0(rdata0_7[7:0]),   .WE0(wea0_7[0]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[7:0]),   .Q1(rdata1_7[7:0]),   .WE1(wea1_7[0]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W30(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[15:8]),  .Q0(rdata0_7[15:8]),  .WE0(wea0_7[1]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[15:8]),  .Q1(rdata1_7[15:8]),  .WE1(wea1_7[1]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W31(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[23:16]), .Q0(rdata0_7[23:16]), .WE0(wea0_7[2]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[23:16]), .Q1(rdata1_7[23:16]), .WE1(wea1_7[2]), .WEM1(8'b0), .CE1(1'b1) );
BRAM_2048x8 BRAM_W32(.CLK(clk), .A0(addr0[10:0]), .D0(wdata0[31:24]), .Q0(rdata0_7[31:24]), .WE0(wea0_7[3]), .WEM0(8'b0), .CE0(1'b1),
                                .A1(addr1[10:0]), .D1(wdata1[31:24]), .Q1(rdata1_7[31:24]), .WE1(wea1_7[3]), .WEM1(8'b0), .CE1(1'b1) );

endmodule