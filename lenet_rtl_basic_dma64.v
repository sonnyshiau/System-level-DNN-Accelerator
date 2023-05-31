module lenet_rtl_basic_dma64( clk, rst, dma_read_chnl_valid, dma_read_chnl_data, dma_read_chnl_ready,
/* <<--params-list-->> */
conf_info_scale_CONV2,
conf_info_scale_CONV3,
conf_info_scale_CONV1,
conf_info_scale_FC2,
conf_info_scale_FC1,
conf_done, acc_done, debug, dma_read_ctrl_valid, dma_read_ctrl_data_index, dma_read_ctrl_data_length, dma_read_ctrl_data_size, dma_read_ctrl_ready, dma_write_ctrl_valid, dma_write_ctrl_data_index, dma_write_ctrl_data_length, dma_write_ctrl_data_size, dma_write_ctrl_ready, dma_write_chnl_valid, dma_write_chnl_data, dma_write_chnl_ready);

   input clk;
   input rst;

   /* <<--params-def-->> */
   input wire [31:0]  conf_info_scale_CONV2;
   input wire [31:0]  conf_info_scale_CONV3;
   input wire [31:0]  conf_info_scale_CONV1;
   input wire [31:0]  conf_info_scale_FC2;
   input wire [31:0]  conf_info_scale_FC1;
   input wire 	       conf_done;

   input wire 	       dma_read_ctrl_ready;
   output reg	       dma_read_ctrl_valid;
   output reg [31:0]  dma_read_ctrl_data_index;
   output reg [31:0]  dma_read_ctrl_data_length;
   output reg [ 2:0]  dma_read_ctrl_data_size;

   output reg	       dma_read_chnl_ready;
   input wire 	       dma_read_chnl_valid;
   input wire [63:0]  dma_read_chnl_data;

   input wire         dma_write_ctrl_ready;
   output reg	       dma_write_ctrl_valid;
   output reg [31:0]  dma_write_ctrl_data_index;
   output reg [31:0]  dma_write_ctrl_data_length;
   output reg [ 2:0]  dma_write_ctrl_data_size;

   input wire 	       dma_write_chnl_ready;
   output reg	       dma_write_chnl_valid;
   output reg [63:0]  dma_write_chnl_data;

   output reg     	 acc_done;
   output reg [31:0]  debug;
   
   ///////////////////////////////////
   // Add your design here

   reg read, write;

   //*** parameter_tmp => let acc_exeparameters without delay ***//
   reg [15:0] sram_weight_addr0_tmp, sram_weight_addr1_tmp;
   reg [3:0] sram_weight_wea0_tmp, sram_weight_wea1_tmp;  
   // lenet acc doesn't use the wdata

   reg [15:0] sram_act_addr0_tmp, sram_act_addr1_tmp;
   reg [3:0] sram_act_wea0_tmp, sram_act_wea1_tmp;
   reg [31:0] sram_act_wdata0_tmp, sram_act_wdata1_tmp;

   //*** Module ***//
   // Activation sram, dual port  
   reg [15:0] sram_act_addr0, sram_act_addr1;
   reg [3:0] sram_act_wea0, sram_act_wea1;
   reg [31:0] sram_act_wdata0, sram_act_wdata1;
   wire [31:0] sram_act_rdata0, sram_act_rdata1;

   SRAM_activation_1024x32b act_sram( 
      .clk(clk),
      .wea0(sram_act_wea0),
      .addr0(sram_act_addr0),
      .wdata0(sram_act_wdata0),
      .rdata0(sram_act_rdata0),
      .wea1(sram_act_wea1),
      .addr1(sram_act_addr1),
      .wdata1(sram_act_wdata1),
      .rdata1(sram_act_rdata1)
   );

   // Weight sram, dual port
   reg [15:0] sram_weight_addr0, sram_weight_addr1;
   reg [3:0] sram_weight_wea0, sram_weight_wea1;
   reg [31:0] sram_weight_wdata0, sram_weight_wdata1;
   wire [31:0] sram_weight_rdata0, sram_weight_rdata1;

   SRAM_weight_16384x32b weight_sram( 
      .clk(clk),
      .wea0(sram_weight_wea0),
      .addr0(sram_weight_addr0),
      .wdata0(sram_weight_wdata0),
      .rdata0(sram_weight_rdata0),
      .wea1(sram_weight_wea1),
      .addr1(sram_weight_addr1),
      .wdata1(sram_weight_wdata1),
      .rdata1(sram_weight_rdata1)
   );

   // lenet
   reg compute_start;
   reg compute_finish;

   // Weight acc, dual port
   reg [ 3:0] acc_weight_wea0, acc_weight_wea1;
   reg [15:0] acc_weight_addr0, acc_weight_addr1;
   reg [31:0] acc_weight_wdata0, acc_weight_wdata1;
   reg [31:0] acc_weight_rdata0, acc_weight_rdata1;

   // Activation acc, dual port
   reg [ 3:0] acc_act_wea0, acc_act_wea1;
   reg [15:0] acc_act_addr0, acc_act_addr1;
   reg [31:0] acc_act_wdata0, acc_act_wdata1;
   reg [31:0] acc_act_rdata0, acc_act_rdata1;

   lenet lenet_U(
    .clk(clk),
    .rst_n(rst),

    .compute_start(compute_start),
    .compute_finish(compute_finish),

    // Quantization scale
    .scale_CONV1(conf_info_scale_CONV1),
    .scale_CONV2(conf_info_scale_CONV2),
    .scale_CONV3(conf_info_scale_CONV3),
    .scale_FC1(conf_info_scale_FC1),
    .scale_FC2(conf_info_scale_FC2),

    // Weight sram, dual port
    .sram_weight_wea0(acc_weight_wea0),
    .sram_weight_addr0(acc_weight_addr0),
    .sram_weight_wdata0(acc_weight_wdata0),
    .sram_weight_rdata0(acc_weight_rdata0),
    .sram_weight_wea1(acc_weight_wea1),
    .sram_weight_addr1(acc_weight_addr1),
    .sram_weight_wdata1(acc_weight_wdata1),
    .sram_weight_rdata1(acc_weight_rdata1),

    // Activation sram, dual port
    .sram_act_wea0(acc_act_wea0),
    .sram_act_addr0(acc_act_addr0),
    .sram_act_wdata0(acc_act_wdata0),
    .sram_act_rdata0(acc_act_rdata0),
    .sram_act_wea1(acc_act_wea1),
    .sram_act_addr1(acc_act_addr1),
    .sram_act_wdata1(acc_act_wdata1),
    .sram_act_rdata1(acc_act_rdata1)
);

    //-------------------------FSM ------------------------//
    reg [3:0] state, next_state;

    parameter IDLE = 4'd0;
    parameter read_act = 4'd1;
    parameter read_weight = 4'd2;
    parameter acc_exe= 4'd3;  
    parameter w2dram = 4'd4;
    parameter FINISH = 4'd5;

    // State Update
    always @(posedge clk or negedge rst) begin
        if(~rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    //state transition
    always @* begin
        case (state)
            IDLE        : next_state = conf_done ? read_act : IDLE;
            read_act    : next_state = sram_act_addr1 == 16'd255 ? read_weight : read_act;
            read_weight : next_state = sram_weight_addr1 == 16'd15759 ? acc_exe: read_weight;
            acc_exe     : next_state = compute_finish ? w2dram : acc_exe;
            w2dram      : next_state = sram_act_addr1 == 16'd755 ? FINISH : w2dram;
            FINISH      : next_state = FINISH;
            default     : next_state = IDLE;
        endcase
    end

    // DMA Read enable
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            read <= 0;
        end
        else if (dma_read_ctrl_ready == 1)begin
            read <= 1;
        end
        else if ((state == read_act && sram_act_addr1 == 16'd255)||(state == read_weight && sram_weight_addr1 == 16'd15759))begin
            read <= 0;
        end
        else begin
            read <= read;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            dma_read_ctrl_data_index <= 0;
            dma_read_ctrl_data_length <= 0;
            dma_read_ctrl_data_size <= 0;
            dma_read_ctrl_valid <= 0;
            dma_read_chnl_ready <= 0;
        end
        else begin
        case(state)
        read_act:begin
            if (read)begin
                dma_read_ctrl_data_index <= 0;
                dma_read_ctrl_data_length <=  0 ; 
                dma_read_ctrl_data_size <=  0 ; 
                dma_read_chnl_ready <= 1 ;
                dma_read_ctrl_valid <= 0;
            end
            else begin
                dma_read_ctrl_data_index <= 10000;
                dma_read_ctrl_data_length <= 128; 
                dma_read_ctrl_data_size <= 3'b010; 
                dma_read_chnl_ready <= 0;
                dma_read_ctrl_valid <= 1;
            end
        end
        read_weight:begin
            if (read)begin
                dma_read_ctrl_data_index <= 0;
                dma_read_ctrl_data_length <=  0 ; 
                dma_read_ctrl_data_size <=  0 ; 
                dma_read_chnl_ready <= 1 ;
                dma_read_ctrl_valid <= 0;
            end
            else begin
                dma_read_ctrl_data_index <= 0;
                dma_read_ctrl_data_length <= 7880; 
                dma_read_ctrl_data_size <= 3'b010; 
                dma_read_chnl_ready <= 0;
                dma_read_ctrl_valid <= 1;
            end
        end
        default: begin
            dma_read_ctrl_data_index <= 0;
            dma_read_ctrl_data_length <= 0;
            dma_read_ctrl_data_size <= 0;
            dma_read_ctrl_valid <= 0;
            dma_read_chnl_ready <= 0;
        end
        endcase
        end
    end

    // DMA Write enable
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            write <= 0;
        end
        else if (dma_write_ctrl_ready)begin
            write <= 1;
        end
        else if (sram_act_addr1 == 16'd755)begin
            write <= 0;
        end
        else begin
            write <= write;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            dma_write_ctrl_data_index <= 0;
            dma_write_ctrl_data_length <= 0;
            dma_write_ctrl_data_size <= 0;
            dma_write_ctrl_valid <= 0;
        end  
        else begin
            case(state)
            w2dram:begin
                if (write)begin
                    dma_write_ctrl_data_index <= 0;
                    dma_write_ctrl_data_length <= 0;
                    dma_write_ctrl_data_size <= 0;
                    dma_write_ctrl_valid <= 0;
                end
                else begin
                    dma_write_ctrl_data_index <= 10000;
                    dma_write_ctrl_data_length <= 377; 
                    dma_write_ctrl_data_size <= 3'b010;
                    dma_write_ctrl_valid <= 1;
                end
            end
            default:begin
                dma_write_ctrl_data_index <= 0;
                dma_write_ctrl_data_length <= 0;
                dma_write_ctrl_data_size <= 0;
                dma_write_ctrl_valid <= 0;
            end
            endcase
        end    
    end

    // SRAM_act address Control
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            sram_act_addr0_tmp <= 16'd0;
            sram_act_addr1_tmp <= 16'd1; 
        end
        else if (state == read_act && sram_act_wea0 == 4'b1111)begin
            if (sram_act_addr1 < 16'd255)begin
                sram_act_addr0_tmp <= sram_act_addr0_tmp + 16'd2;
                sram_act_addr1_tmp <= sram_act_addr1_tmp + 16'd2;
            end
            else begin
                sram_act_addr0_tmp <= 16'd0;
                sram_act_addr1_tmp <= 16'd1;            
            end
        end
        else if (state == w2dram)begin
            if (dma_write_chnl_ready && sram_act_addr1 < 755)begin
                sram_act_addr0_tmp <= sram_act_addr0_tmp + 16'd2;
                sram_act_addr1_tmp <= sram_act_addr1_tmp + 16'd2;
            end
            else begin
                sram_act_addr0_tmp <= 16'd0;
                sram_act_addr1_tmp <= 16'd1;            
            end
        end
        else begin
                sram_act_addr0_tmp <= 16'd0;
                sram_act_addr1_tmp <= 16'd1;        
        end
    end

    always @* begin
            case(state)
            read_act:begin
                sram_act_addr0 = sram_act_addr0_tmp;
                sram_act_addr1 = sram_act_addr1_tmp;
            end
            w2dram:begin
                sram_act_addr0 = sram_act_addr0_tmp;
                sram_act_addr1 = sram_act_addr1_tmp;
            end
            acc_exe:begin
                sram_act_addr0 = acc_act_addr0;
                sram_act_addr1 = acc_act_addr1;
            end
            default:begin
                sram_act_addr0 = sram_act_addr0_tmp;
                sram_act_addr1 = sram_act_addr1_tmp;
            end
            endcase
    end
   
    // SRAM_weight address Control
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            sram_weight_addr0_tmp <= 16'd0;
            sram_weight_addr1_tmp <= 16'd1; 
        end     
        else if (state == read_weight && sram_weight_wea0 == 4'b1111)begin
            if (sram_weight_addr1 < 16'd15759)begin
                sram_weight_addr0_tmp <= sram_weight_addr0_tmp + 16'd2;
                sram_weight_addr1_tmp <= sram_weight_addr1_tmp + 16'd2;
            end
            else begin
                sram_weight_addr0_tmp <= 16'd0;
                sram_weight_addr1_tmp <= 16'd1;            
            end
        end
        else begin
            sram_weight_addr0_tmp <= 16'd0;
            sram_weight_addr1_tmp <= 16'd1;        
        end
    end

    always @* begin
        case(state)
        read_weight:begin
            sram_weight_addr0 = sram_weight_addr0_tmp;
            sram_weight_addr1 = sram_weight_addr1_tmp;
        end
        acc_exe:begin
            sram_weight_addr0 = acc_weight_addr0;
            sram_weight_addr1 = acc_weight_addr1;       
        end
        default: begin
            sram_weight_addr0 = sram_weight_addr0_tmp;
            sram_weight_addr1 = sram_weight_addr1_tmp;         
        end
        endcase
    end

    // act_wea Control
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            sram_act_wea0_tmp <= 4'b0000;
            sram_act_wea1_tmp <= 4'b0000;
            sram_weight_wea0_tmp <= 4'b0000;
            sram_weight_wea1_tmp <= 4'b0000;
        end  
        else begin
            case(state)
            read_act:begin
                if(dma_read_chnl_valid)begin
                    sram_act_wea0_tmp <= 4'b1111;
                    sram_act_wea1_tmp <= 4'b1111;
                end
                else begin
                    sram_act_wea0_tmp <= 4'b0000;
                    sram_act_wea1_tmp <= 4'b0000;
                end
            end
            read_weight:begin
                if(dma_read_chnl_valid)begin
                    sram_weight_wea0_tmp <= 4'b1111;
                    sram_weight_wea1_tmp <= 4'b1111;
                end
                else begin
                    sram_weight_wea0_tmp <= 4'b0000;
                    sram_weight_wea1_tmp <= 4'b0000;
                end
            end
            default: begin
                sram_act_wea0_tmp <= 4'b0000;
                sram_act_wea1_tmp <= 4'b0000;
                sram_weight_wea0_tmp <= 4'b0000;
                sram_weight_wea1_tmp <= 4'b0000;
            end
            endcase
        end
    end

    always @* begin
        case(state)
        read_act:begin
            sram_act_wea0 = read ? sram_act_wea0_tmp : 0;
            sram_act_wea1 = read ? sram_act_wea1_tmp : 0;
        end
        acc_exe:begin
            sram_act_wea0 = acc_act_wea0;
            sram_act_wea1 = acc_act_wea1;  
        end
        default:begin
            sram_act_wea0 = 4'b0000;
            sram_act_wea1 = 4'b0000;
        end
        endcase
    end

    always @* begin
        case(state)
        read_weight:begin
            sram_weight_wea0 = read ? sram_weight_wea0_tmp : 0;
            sram_weight_wea1 = read ? sram_weight_wea1_tmp : 0;
        end
        acc_exe:begin
            sram_weight_wea0 = acc_weight_wea0;
            sram_weight_wea1 = acc_weight_wea1;  
        end
        default:begin
            sram_weight_wea0 = 4'b0000;
            sram_weight_wea1 = 4'b0000;
        end
        endcase
    end

    // DRAM or Lenet => SRAM_act
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            sram_act_wdata0_tmp <= 0;
            sram_act_wdata1_tmp <= 0;
        end
        else begin
        case(state)
            read_act:begin
                sram_act_wdata0_tmp <=  read ? dma_read_chnl_data[31:0] : 0;
                sram_act_wdata1_tmp <=  read ? dma_read_chnl_data[63:32] : 0;
            end
            default: begin
                sram_act_wdata0_tmp <= 0;
                sram_act_wdata1_tmp <= 0;
            end
        endcase
        end
    end
    //將sram中的data拿去計算
    always @* begin
        case(state)
        read_act:begin
            sram_act_wdata0 = read ? sram_act_wdata0_tmp : 0;
            sram_act_wdata1 = read ? sram_act_wdata1_tmp : 0;
        end
        default:begin
            sram_act_wdata0 = 0;
            sram_act_wdata1 = 0;
        end
        endcase
    end

    always @* begin
        case(state)
        acc_exe:begin
            acc_act_rdata0 = sram_act_rdata0;
            acc_act_rdata1 = sram_act_rdata1;
            acc_weight_rdata0 = sram_weight_rdata0;
            acc_weight_rdata1 = sram_weight_rdata1 ;
        end
        default:begin
            acc_act_rdata0 = 0;
            acc_act_rdata1 = 0;
            acc_weight_rdata0 = 0;
            acc_weight_rdata1 = 0;
        end
        endcase
    end

    // 將dma_channel的值拿出道sram並寫入sram_weight
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            sram_weight_wdata0 <= 0;
            sram_weight_wdata1 <= 0;
        end
        else begin
        case(state)
            read_weight:
                if(dma_read_chnl_valid )begin
                    sram_weight_wdata0 <= dma_read_chnl_data[31:0];
                    sram_weight_wdata1 <= dma_read_chnl_data[63:32];
                end 
                else begin
                    sram_weight_wdata0 <= 0;
                    sram_weight_wdata1 <= 0;
                end
            default: begin
                sram_weight_wdata0 <= 0;
                sram_weight_wdata1 <= 0;
            end
        endcase
        end
    end

    // SRAM_act => DRAM
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            dma_write_chnl_valid <= 0;
        end
        else if (state == w2dram && sram_act_addr0 > 0)begin
            dma_write_chnl_valid <= 1;
        end
        else begin
            dma_write_chnl_valid <= 0;
        end
    end

    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            dma_write_chnl_data[31:0] <= 0;
            dma_write_chnl_data[63:32] <= 0;   
        end 
        else begin
            case(state)  
            w2dram:begin
                dma_write_chnl_data[31:0]  <= write ? sram_act_rdata0 : 0;
                dma_write_chnl_data[63:32] <= write ? sram_act_rdata1 : 0;
            end
            default: begin
                dma_write_chnl_data[31:0] <= 0;
                dma_write_chnl_data[63:32] <= 0;     
            end
            endcase
        end 
    end

    // compute_start
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            compute_start <= 0;
        end   
        else begin
        case(state)
            acc_exe:begin
                compute_start <= 1;
            end  
            default:begin
                compute_start <= 0;
            end 
        endcase 
        end
    end

    // acc_done
    always @(posedge clk or negedge rst) begin
        if (~rst)begin
            acc_done <= 0;
        end        
        else begin
        case(state)
            FINISH:begin
                acc_done <= 1;
            end
            default: begin
                acc_done <= 0;
            end 
        endcase  
        end
    end
   
    // debug
    always @* begin
        debug = 0;
    end
endmodule

