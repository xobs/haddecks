// Generator : SpinalHDL v1.3.6    git head : 9bf01e7f360e003fac1dd5ca8b8f4bffec0e52b8
// Date      : 04/10/2019, 19:19:18
// Component : VexRiscv


`define Src1CtrlEnum_defaultEncoding_type [1:0]
`define Src1CtrlEnum_defaultEncoding_RS 2'b00
`define Src1CtrlEnum_defaultEncoding_IMU 2'b01
`define Src1CtrlEnum_defaultEncoding_PC_INCREMENT 2'b10
`define Src1CtrlEnum_defaultEncoding_URS1 2'b11

`define AluCtrlEnum_defaultEncoding_type [1:0]
`define AluCtrlEnum_defaultEncoding_ADD_SUB 2'b00
`define AluCtrlEnum_defaultEncoding_SLT_SLTU 2'b01
`define AluCtrlEnum_defaultEncoding_BITWISE 2'b10

`define AluBitwiseCtrlEnum_defaultEncoding_type [1:0]
`define AluBitwiseCtrlEnum_defaultEncoding_XOR_1 2'b00
`define AluBitwiseCtrlEnum_defaultEncoding_OR_1 2'b01
`define AluBitwiseCtrlEnum_defaultEncoding_AND_1 2'b10

`define BranchCtrlEnum_defaultEncoding_type [1:0]
`define BranchCtrlEnum_defaultEncoding_INC 2'b00
`define BranchCtrlEnum_defaultEncoding_B 2'b01
`define BranchCtrlEnum_defaultEncoding_JAL 2'b10
`define BranchCtrlEnum_defaultEncoding_JALR 2'b11

`define ShiftCtrlEnum_defaultEncoding_type [1:0]
`define ShiftCtrlEnum_defaultEncoding_DISABLE_1 2'b00
`define ShiftCtrlEnum_defaultEncoding_SLL_1 2'b01
`define ShiftCtrlEnum_defaultEncoding_SRL_1 2'b10
`define ShiftCtrlEnum_defaultEncoding_SRA_1 2'b11

`define EnvCtrlEnum_defaultEncoding_type [2:0]
`define EnvCtrlEnum_defaultEncoding_NONE 3'b000
`define EnvCtrlEnum_defaultEncoding_XRET 3'b001
`define EnvCtrlEnum_defaultEncoding_WFI 3'b010
`define EnvCtrlEnum_defaultEncoding_ECALL 3'b011
`define EnvCtrlEnum_defaultEncoding_EBREAK 3'b100

`define Src2CtrlEnum_defaultEncoding_type [1:0]
`define Src2CtrlEnum_defaultEncoding_RS 2'b00
`define Src2CtrlEnum_defaultEncoding_IMI 2'b01
`define Src2CtrlEnum_defaultEncoding_IMS 2'b10
`define Src2CtrlEnum_defaultEncoding_PC 2'b11

`define MmuPlugin_shared_State_defaultEncoding_type [2:0]
`define MmuPlugin_shared_State_defaultEncoding_IDLE 3'b000
`define MmuPlugin_shared_State_defaultEncoding_L1_CMD 3'b001
`define MmuPlugin_shared_State_defaultEncoding_L1_RSP 3'b010
`define MmuPlugin_shared_State_defaultEncoding_L0_CMD 3'b011
`define MmuPlugin_shared_State_defaultEncoding_L0_RSP 3'b100

module InstructionCache (
      input   io_flush,
      input   io_cpu_prefetch_isValid,
      output reg  io_cpu_prefetch_haltIt,
      input  [31:0] io_cpu_prefetch_pc,
      input   io_cpu_fetch_isValid,
      input   io_cpu_fetch_isStuck,
      input   io_cpu_fetch_isRemoved,
      input  [31:0] io_cpu_fetch_pc,
      output [31:0] io_cpu_fetch_data,
      input   io_cpu_fetch_dataBypassValid,
      input  [31:0] io_cpu_fetch_dataBypass,
      output  io_cpu_fetch_mmuBus_cmd_isValid,
      output [31:0] io_cpu_fetch_mmuBus_cmd_virtualAddress,
      output  io_cpu_fetch_mmuBus_cmd_bypassTranslation,
      input  [31:0] io_cpu_fetch_mmuBus_rsp_physicalAddress,
      input   io_cpu_fetch_mmuBus_rsp_isIoAccess,
      input   io_cpu_fetch_mmuBus_rsp_allowRead,
      input   io_cpu_fetch_mmuBus_rsp_allowWrite,
      input   io_cpu_fetch_mmuBus_rsp_allowExecute,
      input   io_cpu_fetch_mmuBus_rsp_exception,
      input   io_cpu_fetch_mmuBus_rsp_refilling,
      output  io_cpu_fetch_mmuBus_end,
      input   io_cpu_fetch_mmuBus_busy,
      output [31:0] io_cpu_fetch_physicalAddress,
      output  io_cpu_fetch_haltIt,
      input   io_cpu_decode_isValid,
      input   io_cpu_decode_isStuck,
      input  [31:0] io_cpu_decode_pc,
      output [31:0] io_cpu_decode_physicalAddress,
      output [31:0] io_cpu_decode_data,
      output  io_cpu_decode_cacheMiss,
      output  io_cpu_decode_error,
      output  io_cpu_decode_mmuRefilling,
      output  io_cpu_decode_mmuException,
      input   io_cpu_decode_isUser,
      input   io_cpu_fill_valid,
      input  [31:0] io_cpu_fill_payload,
      output  io_mem_cmd_valid,
      input   io_mem_cmd_ready,
      output [31:0] io_mem_cmd_payload_address,
      output [2:0] io_mem_cmd_payload_size,
      input   io_mem_rsp_valid,
      input  [31:0] io_mem_rsp_payload_data,
      input   io_mem_rsp_payload_error,
      input   clk,
      input   reset);
  reg [21:0] _zz_11_;
  reg [31:0] _zz_12_;
  wire  _zz_13_;
  wire  _zz_14_;
  wire [0:0] _zz_15_;
  wire [0:0] _zz_16_;
  wire [21:0] _zz_17_;
  reg  _zz_1_;
  reg  _zz_2_;
  reg  lineLoader_fire;
  reg  lineLoader_valid;
  reg [31:0] lineLoader_address;
  reg  lineLoader_hadError;
  reg  lineLoader_flushPending;
  reg [7:0] lineLoader_flushCounter;
  reg  _zz_3_;
  reg  lineLoader_cmdSent;
  reg  lineLoader_wayToAllocate_willIncrement;
  wire  lineLoader_wayToAllocate_willClear;
  wire  lineLoader_wayToAllocate_willOverflowIfInc;
  wire  lineLoader_wayToAllocate_willOverflow;
  reg [2:0] lineLoader_wordIndex;
  wire  lineLoader_write_tag_0_valid;
  wire [6:0] lineLoader_write_tag_0_payload_address;
  wire  lineLoader_write_tag_0_payload_data_valid;
  wire  lineLoader_write_tag_0_payload_data_error;
  wire [19:0] lineLoader_write_tag_0_payload_data_address;
  wire  lineLoader_write_data_0_valid;
  wire [9:0] lineLoader_write_data_0_payload_address;
  wire [31:0] lineLoader_write_data_0_payload_data;
  wire  _zz_4_;
  wire [6:0] _zz_5_;
  wire  _zz_6_;
  wire  fetchStage_read_waysValues_0_tag_valid;
  wire  fetchStage_read_waysValues_0_tag_error;
  wire [19:0] fetchStage_read_waysValues_0_tag_address;
  wire [21:0] _zz_7_;
  wire [9:0] _zz_8_;
  wire  _zz_9_;
  wire [31:0] fetchStage_read_waysValues_0_data;
  reg [31:0] decodeStage_mmuRsp_physicalAddress;
  reg  decodeStage_mmuRsp_isIoAccess;
  reg  decodeStage_mmuRsp_allowRead;
  reg  decodeStage_mmuRsp_allowWrite;
  reg  decodeStage_mmuRsp_allowExecute;
  reg  decodeStage_mmuRsp_exception;
  reg  decodeStage_mmuRsp_refilling;
  reg  decodeStage_hit_tags_0_valid;
  reg  decodeStage_hit_tags_0_error;
  reg [19:0] decodeStage_hit_tags_0_address;
  wire  decodeStage_hit_hits_0;
  wire  decodeStage_hit_valid;
  wire  decodeStage_hit_error;
  reg [31:0] _zz_10_;
  wire [31:0] decodeStage_hit_data;
  reg [31:0] decodeStage_hit_word;
  reg  io_cpu_fetch_dataBypassValid_regNextWhen;
  reg [31:0] io_cpu_fetch_dataBypass_regNextWhen;
  (* ram_style = "block" *) reg [21:0] ways_0_tags [0:127];
  (* ram_style = "block" *) reg [31:0] ways_0_datas [0:1023];
  assign _zz_13_ = (! lineLoader_flushCounter[7]);
  assign _zz_14_ = (lineLoader_flushPending && (! (lineLoader_valid || io_cpu_fetch_isValid)));
  assign _zz_15_ = _zz_7_[0 : 0];
  assign _zz_16_ = _zz_7_[1 : 1];
  assign _zz_17_ = {lineLoader_write_tag_0_payload_data_address,{lineLoader_write_tag_0_payload_data_error,lineLoader_write_tag_0_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[lineLoader_write_tag_0_payload_address] <= _zz_17_;
    end
  end

  always @ (posedge clk) begin
    if(_zz_6_) begin
      _zz_11_ <= ways_0_tags[_zz_5_];
    end
  end

  always @ (posedge clk) begin
    if(_zz_1_) begin
      ways_0_datas[lineLoader_write_data_0_payload_address] <= lineLoader_write_data_0_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_9_) begin
      _zz_12_ <= ways_0_datas[_zz_8_];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if(lineLoader_write_data_0_valid)begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if(lineLoader_write_tag_0_valid)begin
      _zz_2_ = 1'b1;
    end
  end

  assign io_cpu_fetch_haltIt = io_cpu_fetch_mmuBus_busy;
  always @ (*) begin
    lineLoader_fire = 1'b0;
    if(io_mem_rsp_valid)begin
      if((lineLoader_wordIndex == (3'b111)))begin
        lineLoader_fire = 1'b1;
      end
    end
  end

  always @ (*) begin
    io_cpu_prefetch_haltIt = (lineLoader_valid || lineLoader_flushPending);
    if(_zz_13_)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if((! _zz_3_))begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
    if(io_flush)begin
      io_cpu_prefetch_haltIt = 1'b1;
    end
  end

  assign io_mem_cmd_valid = (lineLoader_valid && (! lineLoader_cmdSent));
  assign io_mem_cmd_payload_address = {lineLoader_address[31 : 5],(5'b00000)};
  assign io_mem_cmd_payload_size = (3'b101);
  always @ (*) begin
    lineLoader_wayToAllocate_willIncrement = 1'b0;
    if((! lineLoader_valid))begin
      lineLoader_wayToAllocate_willIncrement = 1'b1;
    end
  end

  assign lineLoader_wayToAllocate_willClear = 1'b0;
  assign lineLoader_wayToAllocate_willOverflowIfInc = 1'b1;
  assign lineLoader_wayToAllocate_willOverflow = (lineLoader_wayToAllocate_willOverflowIfInc && lineLoader_wayToAllocate_willIncrement);
  assign _zz_4_ = 1'b1;
  assign lineLoader_write_tag_0_valid = ((_zz_4_ && lineLoader_fire) || (! lineLoader_flushCounter[7]));
  assign lineLoader_write_tag_0_payload_address = (lineLoader_flushCounter[7] ? lineLoader_address[11 : 5] : lineLoader_flushCounter[6 : 0]);
  assign lineLoader_write_tag_0_payload_data_valid = lineLoader_flushCounter[7];
  assign lineLoader_write_tag_0_payload_data_error = (lineLoader_hadError || io_mem_rsp_payload_error);
  assign lineLoader_write_tag_0_payload_data_address = lineLoader_address[31 : 12];
  assign lineLoader_write_data_0_valid = (io_mem_rsp_valid && _zz_4_);
  assign lineLoader_write_data_0_payload_address = {lineLoader_address[11 : 5],lineLoader_wordIndex};
  assign lineLoader_write_data_0_payload_data = io_mem_rsp_payload_data;
  assign _zz_5_ = io_cpu_prefetch_pc[11 : 5];
  assign _zz_6_ = (! io_cpu_fetch_isStuck);
  assign _zz_7_ = _zz_11_;
  assign fetchStage_read_waysValues_0_tag_valid = _zz_15_[0];
  assign fetchStage_read_waysValues_0_tag_error = _zz_16_[0];
  assign fetchStage_read_waysValues_0_tag_address = _zz_7_[21 : 2];
  assign _zz_8_ = io_cpu_prefetch_pc[11 : 2];
  assign _zz_9_ = (! io_cpu_fetch_isStuck);
  assign fetchStage_read_waysValues_0_data = _zz_12_;
  assign io_cpu_fetch_data = (io_cpu_fetch_dataBypassValid ? io_cpu_fetch_dataBypass : fetchStage_read_waysValues_0_data[31 : 0]);
  assign io_cpu_fetch_mmuBus_cmd_isValid = io_cpu_fetch_isValid;
  assign io_cpu_fetch_mmuBus_cmd_virtualAddress = io_cpu_fetch_pc;
  assign io_cpu_fetch_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_fetch_mmuBus_end = ((! io_cpu_fetch_isStuck) || io_cpu_fetch_isRemoved);
  assign io_cpu_fetch_physicalAddress = io_cpu_fetch_mmuBus_rsp_physicalAddress;
  assign decodeStage_hit_hits_0 = (decodeStage_hit_tags_0_valid && (decodeStage_hit_tags_0_address == decodeStage_mmuRsp_physicalAddress[31 : 12]));
  assign decodeStage_hit_valid = (decodeStage_hit_hits_0 != (1'b0));
  assign decodeStage_hit_error = decodeStage_hit_tags_0_error;
  assign decodeStage_hit_data = _zz_10_;
  always @ (*) begin
    decodeStage_hit_word = decodeStage_hit_data[31 : 0];
    if(io_cpu_fetch_dataBypassValid_regNextWhen)begin
      decodeStage_hit_word = io_cpu_fetch_dataBypass_regNextWhen;
    end
  end

  assign io_cpu_decode_data = decodeStage_hit_word;
  assign io_cpu_decode_cacheMiss = (! decodeStage_hit_valid);
  assign io_cpu_decode_error = decodeStage_hit_error;
  assign io_cpu_decode_mmuRefilling = decodeStage_mmuRsp_refilling;
  assign io_cpu_decode_mmuException = ((! decodeStage_mmuRsp_refilling) && (decodeStage_mmuRsp_exception || (! decodeStage_mmuRsp_allowExecute)));
  assign io_cpu_decode_physicalAddress = decodeStage_mmuRsp_physicalAddress;
  always @ (posedge clk) begin
    if(reset) begin
      lineLoader_valid <= 1'b0;
      lineLoader_hadError <= 1'b0;
      lineLoader_flushPending <= 1'b1;
      lineLoader_cmdSent <= 1'b0;
      lineLoader_wordIndex <= (3'b000);
    end else begin
      if(lineLoader_fire)begin
        lineLoader_valid <= 1'b0;
      end
      if(lineLoader_fire)begin
        lineLoader_hadError <= 1'b0;
      end
      if(io_cpu_fill_valid)begin
        lineLoader_valid <= 1'b1;
      end
      if(io_flush)begin
        lineLoader_flushPending <= 1'b1;
      end
      if(_zz_14_)begin
        lineLoader_flushPending <= 1'b0;
      end
      if((io_mem_cmd_valid && io_mem_cmd_ready))begin
        lineLoader_cmdSent <= 1'b1;
      end
      if(lineLoader_fire)begin
        lineLoader_cmdSent <= 1'b0;
      end
      if(io_mem_rsp_valid)begin
        lineLoader_wordIndex <= (lineLoader_wordIndex + (3'b001));
        if(io_mem_rsp_payload_error)begin
          lineLoader_hadError <= 1'b1;
        end
      end
    end
  end

  always @ (posedge clk) begin
    if(io_cpu_fill_valid)begin
      lineLoader_address <= io_cpu_fill_payload;
    end
    if(_zz_13_)begin
      lineLoader_flushCounter <= (lineLoader_flushCounter + (8'b00000001));
    end
    _zz_3_ <= lineLoader_flushCounter[7];
    if(_zz_14_)begin
      lineLoader_flushCounter <= (8'b00000000);
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_mmuRsp_physicalAddress <= io_cpu_fetch_mmuBus_rsp_physicalAddress;
      decodeStage_mmuRsp_isIoAccess <= io_cpu_fetch_mmuBus_rsp_isIoAccess;
      decodeStage_mmuRsp_allowRead <= io_cpu_fetch_mmuBus_rsp_allowRead;
      decodeStage_mmuRsp_allowWrite <= io_cpu_fetch_mmuBus_rsp_allowWrite;
      decodeStage_mmuRsp_allowExecute <= io_cpu_fetch_mmuBus_rsp_allowExecute;
      decodeStage_mmuRsp_exception <= io_cpu_fetch_mmuBus_rsp_exception;
      decodeStage_mmuRsp_refilling <= io_cpu_fetch_mmuBus_rsp_refilling;
    end
    if((! io_cpu_decode_isStuck))begin
      decodeStage_hit_tags_0_valid <= fetchStage_read_waysValues_0_tag_valid;
      decodeStage_hit_tags_0_error <= fetchStage_read_waysValues_0_tag_error;
      decodeStage_hit_tags_0_address <= fetchStage_read_waysValues_0_tag_address;
    end
    if((! io_cpu_decode_isStuck))begin
      _zz_10_ <= fetchStage_read_waysValues_0_data;
    end
    if((! io_cpu_decode_isStuck))begin
      io_cpu_fetch_dataBypassValid_regNextWhen <= io_cpu_fetch_dataBypassValid;
    end
  end

  always @ (posedge clk) begin
    if((! io_cpu_decode_isStuck))begin
      io_cpu_fetch_dataBypass_regNextWhen <= io_cpu_fetch_dataBypass;
    end
  end

endmodule

module DataCache (
      input   io_cpu_execute_isValid,
      input  [31:0] io_cpu_execute_address,
      input   io_cpu_execute_args_wr,
      input  [31:0] io_cpu_execute_args_data,
      input  [1:0] io_cpu_execute_args_size,
      input   io_cpu_execute_args_isLrsc,
      input   io_cpu_execute_args_isAmo,
      input   io_cpu_execute_args_amoCtrl_swap,
      input  [2:0] io_cpu_execute_args_amoCtrl_alu,
      input   io_cpu_memory_isValid,
      input   io_cpu_memory_isStuck,
      input   io_cpu_memory_isRemoved,
      output  io_cpu_memory_isWrite,
      input  [31:0] io_cpu_memory_address,
      output  io_cpu_memory_mmuBus_cmd_isValid,
      output [31:0] io_cpu_memory_mmuBus_cmd_virtualAddress,
      output  io_cpu_memory_mmuBus_cmd_bypassTranslation,
      input  [31:0] io_cpu_memory_mmuBus_rsp_physicalAddress,
      input   io_cpu_memory_mmuBus_rsp_isIoAccess,
      input   io_cpu_memory_mmuBus_rsp_allowRead,
      input   io_cpu_memory_mmuBus_rsp_allowWrite,
      input   io_cpu_memory_mmuBus_rsp_allowExecute,
      input   io_cpu_memory_mmuBus_rsp_exception,
      input   io_cpu_memory_mmuBus_rsp_refilling,
      output  io_cpu_memory_mmuBus_end,
      input   io_cpu_memory_mmuBus_busy,
      input   io_cpu_writeBack_isValid,
      input   io_cpu_writeBack_isStuck,
      input   io_cpu_writeBack_isUser,
      output reg  io_cpu_writeBack_haltIt,
      output  io_cpu_writeBack_isWrite,
      output reg [31:0] io_cpu_writeBack_data,
      input  [31:0] io_cpu_writeBack_address,
      output  io_cpu_writeBack_mmuException,
      output  io_cpu_writeBack_unalignedAccess,
      output reg  io_cpu_writeBack_accessError,
      input   io_cpu_writeBack_clearLrsc,
      output reg  io_cpu_redo,
      input   io_cpu_flush_valid,
      output reg  io_cpu_flush_ready,
      output reg  io_mem_cmd_valid,
      input   io_mem_cmd_ready,
      output reg  io_mem_cmd_payload_wr,
      output reg [31:0] io_mem_cmd_payload_address,
      output [31:0] io_mem_cmd_payload_data,
      output [3:0] io_mem_cmd_payload_mask,
      output reg [2:0] io_mem_cmd_payload_length,
      output reg  io_mem_cmd_payload_last,
      input   io_mem_rsp_valid,
      input  [31:0] io_mem_rsp_payload_data,
      input   io_mem_rsp_payload_error,
      input   clk,
      input   reset);
  reg [21:0] _zz_10_;
  reg [31:0] _zz_11_;
  wire  _zz_12_;
  wire  _zz_13_;
  wire  _zz_14_;
  wire  _zz_15_;
  wire  _zz_16_;
  wire  _zz_17_;
  wire  _zz_18_;
  wire  _zz_19_;
  wire  _zz_20_;
  wire  _zz_21_;
  wire [2:0] _zz_22_;
  wire [0:0] _zz_23_;
  wire [0:0] _zz_24_;
  wire [31:0] _zz_25_;
  wire [31:0] _zz_26_;
  wire [31:0] _zz_27_;
  wire [31:0] _zz_28_;
  wire [1:0] _zz_29_;
  wire [31:0] _zz_30_;
  wire [1:0] _zz_31_;
  wire [1:0] _zz_32_;
  wire [0:0] _zz_33_;
  wire [0:0] _zz_34_;
  wire [2:0] _zz_35_;
  wire [1:0] _zz_36_;
  wire [21:0] _zz_37_;
  reg  _zz_1_;
  reg  _zz_2_;
  wire  haltCpu;
  reg  tagsReadCmd_valid;
  reg [6:0] tagsReadCmd_payload;
  reg  tagsWriteCmd_valid;
  reg [0:0] tagsWriteCmd_payload_way;
  reg [6:0] tagsWriteCmd_payload_address;
  reg  tagsWriteCmd_payload_data_valid;
  reg  tagsWriteCmd_payload_data_error;
  reg [19:0] tagsWriteCmd_payload_data_address;
  reg  tagsWriteLastCmd_valid;
  reg [0:0] tagsWriteLastCmd_payload_way;
  reg [6:0] tagsWriteLastCmd_payload_address;
  reg  tagsWriteLastCmd_payload_data_valid;
  reg  tagsWriteLastCmd_payload_data_error;
  reg [19:0] tagsWriteLastCmd_payload_data_address;
  reg  dataReadCmd_valid;
  reg [9:0] dataReadCmd_payload;
  reg  dataWriteCmd_valid;
  reg [0:0] dataWriteCmd_payload_way;
  reg [9:0] dataWriteCmd_payload_address;
  reg [31:0] dataWriteCmd_payload_data;
  reg [3:0] dataWriteCmd_payload_mask;
  wire  _zz_3_;
  wire  ways_0_tagsReadRsp_valid;
  wire  ways_0_tagsReadRsp_error;
  wire [19:0] ways_0_tagsReadRsp_address;
  wire [21:0] _zz_4_;
  wire  _zz_5_;
  wire [31:0] ways_0_dataReadRsp;
  reg [3:0] _zz_6_;
  wire [3:0] stage0_mask;
  wire [0:0] stage0_colisions;
  reg  stageA_request_wr;
  reg [31:0] stageA_request_data;
  reg [1:0] stageA_request_size;
  reg  stageA_request_isLrsc;
  reg  stageA_request_isAmo;
  reg  stageA_request_amoCtrl_swap;
  reg [2:0] stageA_request_amoCtrl_alu;
  reg [3:0] stageA_mask;
  wire  stageA_wayHits_0;
  reg [0:0] stage0_colisions_regNextWhen;
  wire [0:0] _zz_7_;
  wire [0:0] stageA_colisions;
  reg  stageB_request_wr;
  reg [31:0] stageB_request_data;
  reg [1:0] stageB_request_size;
  reg  stageB_request_isLrsc;
  reg  stageB_isAmo;
  reg  stageB_request_amoCtrl_swap;
  reg [2:0] stageB_request_amoCtrl_alu;
  reg  stageB_mmuRspFreeze;
  reg [31:0] stageB_mmuRsp_physicalAddress;
  reg  stageB_mmuRsp_isIoAccess;
  reg  stageB_mmuRsp_allowRead;
  reg  stageB_mmuRsp_allowWrite;
  reg  stageB_mmuRsp_allowExecute;
  reg  stageB_mmuRsp_exception;
  reg  stageB_mmuRsp_refilling;
  reg  stageB_tagsReadRsp_0_valid;
  reg  stageB_tagsReadRsp_0_error;
  reg [19:0] stageB_tagsReadRsp_0_address;
  reg [31:0] stageB_dataReadRsp_0;
  wire [0:0] _zz_8_;
  reg [0:0] stageB_waysHits;
  wire  stageB_waysHit;
  wire [31:0] stageB_dataMux;
  reg [3:0] stageB_mask;
  reg [0:0] stageB_colisions;
  reg  stageB_loaderValid;
  reg  stageB_flusher_valid;
  reg  stageB_lrsc_reserved;
  reg [31:0] stageB_requestDataBypass;
  wire  stageB_amo_compare;
  wire  stageB_amo_unsigned;
  wire [31:0] stageB_amo_addSub;
  wire  stageB_amo_less;
  wire  stageB_amo_selectRf;
  reg [31:0] stageB_amo_result;
  reg  stageB_amo_resultRegValid;
  reg [31:0] stageB_amo_resultReg;
  reg  stageB_memCmdSent;
  wire [0:0] _zz_9_;
  reg  loader_valid;
  reg  loader_counter_willIncrement;
  wire  loader_counter_willClear;
  reg [2:0] loader_counter_valueNext;
  reg [2:0] loader_counter_value;
  wire  loader_counter_willOverflowIfInc;
  wire  loader_counter_willOverflow;
  reg [0:0] loader_waysAllocator;
  reg  loader_error;
  (* ram_style = "block" *) reg [21:0] ways_0_tags [0:127];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol0 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol1 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol2 [0:1023];
  (* ram_style = "block" *) reg [7:0] ways_0_data_symbol3 [0:1023];
  reg [7:0] _zz_38_;
  reg [7:0] _zz_39_;
  reg [7:0] _zz_40_;
  reg [7:0] _zz_41_;
  assign _zz_12_ = (io_cpu_execute_isValid && (! io_cpu_memory_isStuck));
  assign _zz_13_ = (((stageB_mmuRsp_refilling || io_cpu_writeBack_accessError) || io_cpu_writeBack_mmuException) || io_cpu_writeBack_unalignedAccess);
  assign _zz_14_ = (stageB_waysHit || (stageB_request_wr && (! stageB_isAmo)));
  assign _zz_15_ = (! stageB_amo_resultRegValid);
  assign _zz_16_ = (stageB_request_isLrsc && (! stageB_lrsc_reserved));
  assign _zz_17_ = (loader_valid && io_mem_rsp_valid);
  assign _zz_18_ = (stageB_request_isLrsc && (! stageB_lrsc_reserved));
  assign _zz_19_ = ((((io_cpu_flush_valid && (! io_cpu_execute_isValid)) && (! io_cpu_memory_isValid)) && (! io_cpu_writeBack_isValid)) && (! io_cpu_redo));
  assign _zz_20_ = (((! stageB_request_wr) || stageB_isAmo) && ((stageB_colisions & stageB_waysHits) != (1'b0)));
  assign _zz_21_ = ((! io_cpu_writeBack_isStuck) && (! stageB_mmuRspFreeze));
  assign _zz_22_ = (stageB_request_amoCtrl_alu | {stageB_request_amoCtrl_swap,(2'b00)});
  assign _zz_23_ = _zz_4_[0 : 0];
  assign _zz_24_ = _zz_4_[1 : 1];
  assign _zz_25_ = ($signed(_zz_26_) + $signed(_zz_30_));
  assign _zz_26_ = ($signed(_zz_27_) + $signed(_zz_28_));
  assign _zz_27_ = stageB_request_data;
  assign _zz_28_ = (stageB_amo_compare ? (~ stageB_dataMux) : stageB_dataMux);
  assign _zz_29_ = (stageB_amo_compare ? _zz_31_ : _zz_32_);
  assign _zz_30_ = {{30{_zz_29_[1]}}, _zz_29_};
  assign _zz_31_ = (2'b01);
  assign _zz_32_ = (2'b00);
  assign _zz_33_ = (! stageB_lrsc_reserved);
  assign _zz_34_ = loader_counter_willIncrement;
  assign _zz_35_ = {2'd0, _zz_34_};
  assign _zz_36_ = {loader_waysAllocator,loader_waysAllocator[0]};
  assign _zz_37_ = {tagsWriteCmd_payload_data_address,{tagsWriteCmd_payload_data_error,tagsWriteCmd_payload_data_valid}};
  always @ (posedge clk) begin
    if(_zz_2_) begin
      ways_0_tags[tagsWriteCmd_payload_address] <= _zz_37_;
    end
  end

  always @ (posedge clk) begin
    if(_zz_3_) begin
      _zz_10_ <= ways_0_tags[tagsReadCmd_payload];
    end
  end

  always @ (*) begin
    _zz_11_ = {_zz_41_, _zz_40_, _zz_39_, _zz_38_};
  end
  always @ (posedge clk) begin
    if(dataWriteCmd_payload_mask[0] && _zz_1_) begin
      ways_0_data_symbol0[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[7 : 0];
    end
    if(dataWriteCmd_payload_mask[1] && _zz_1_) begin
      ways_0_data_symbol1[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[15 : 8];
    end
    if(dataWriteCmd_payload_mask[2] && _zz_1_) begin
      ways_0_data_symbol2[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[23 : 16];
    end
    if(dataWriteCmd_payload_mask[3] && _zz_1_) begin
      ways_0_data_symbol3[dataWriteCmd_payload_address] <= dataWriteCmd_payload_data[31 : 24];
    end
  end

  always @ (posedge clk) begin
    if(_zz_5_) begin
      _zz_38_ <= ways_0_data_symbol0[dataReadCmd_payload];
      _zz_39_ <= ways_0_data_symbol1[dataReadCmd_payload];
      _zz_40_ <= ways_0_data_symbol2[dataReadCmd_payload];
      _zz_41_ <= ways_0_data_symbol3[dataReadCmd_payload];
    end
  end

  always @ (*) begin
    _zz_1_ = 1'b0;
    if((dataWriteCmd_valid && dataWriteCmd_payload_way[0]))begin
      _zz_1_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_2_ = 1'b0;
    if((tagsWriteCmd_valid && tagsWriteCmd_payload_way[0]))begin
      _zz_2_ = 1'b1;
    end
  end

  assign haltCpu = 1'b0;
  assign _zz_3_ = (tagsReadCmd_valid && (! io_cpu_memory_isStuck));
  assign _zz_4_ = _zz_10_;
  assign ways_0_tagsReadRsp_valid = _zz_23_[0];
  assign ways_0_tagsReadRsp_error = _zz_24_[0];
  assign ways_0_tagsReadRsp_address = _zz_4_[21 : 2];
  assign _zz_5_ = (dataReadCmd_valid && (! io_cpu_memory_isStuck));
  assign ways_0_dataReadRsp = _zz_11_;
  always @ (*) begin
    tagsReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      tagsReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsReadCmd_payload = (7'bxxxxxxx);
    if(_zz_12_)begin
      tagsReadCmd_payload = io_cpu_execute_address[11 : 5];
    end
  end

  always @ (*) begin
    dataReadCmd_valid = 1'b0;
    if(_zz_12_)begin
      dataReadCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataReadCmd_payload = (10'bxxxxxxxxxx);
    if(_zz_12_)begin
      dataReadCmd_payload = io_cpu_execute_address[11 : 2];
    end
  end

  always @ (*) begin
    tagsWriteCmd_valid = 1'b0;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_valid = stageB_flusher_valid;
    end
    if(_zz_13_)begin
      tagsWriteCmd_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_way = (1'bx);
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_way = (1'b1);
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_address = (7'bxxxxxxx);
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 5];
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_valid = 1'bx;
    if(stageB_flusher_valid)begin
      tagsWriteCmd_payload_data_valid = 1'b0;
    end
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_valid = 1'b1;
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_error = 1'bx;
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_error = (loader_error || io_mem_rsp_payload_error);
    end
  end

  always @ (*) begin
    tagsWriteCmd_payload_data_address = (20'bxxxxxxxxxxxxxxxxxxxx);
    if(loader_counter_willOverflow)begin
      tagsWriteCmd_payload_data_address = stageB_mmuRsp_physicalAddress[31 : 12];
    end
  end

  always @ (*) begin
    dataWriteCmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if((stageB_request_wr && stageB_waysHit))begin
            dataWriteCmd_valid = 1'b1;
          end
          if(stageB_isAmo)begin
            if(_zz_15_)begin
              dataWriteCmd_valid = 1'b0;
            end
          end
          if(_zz_16_)begin
            dataWriteCmd_valid = 1'b0;
          end
        end
      end
    end
    if(_zz_13_)begin
      dataWriteCmd_valid = 1'b0;
    end
    if(_zz_17_)begin
      dataWriteCmd_valid = 1'b1;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_way = (1'bx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_way = stageB_waysHits;
        end
      end
    end
    if(_zz_17_)begin
      dataWriteCmd_payload_way = loader_waysAllocator;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_address = (10'bxxxxxxxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_address = stageB_mmuRsp_physicalAddress[11 : 2];
        end
      end
    end
    if(_zz_17_)begin
      dataWriteCmd_payload_address = {stageB_mmuRsp_physicalAddress[11 : 5],loader_counter_value};
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_data = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_data = stageB_requestDataBypass;
        end
      end
    end
    if(_zz_17_)begin
      dataWriteCmd_payload_data = io_mem_rsp_payload_data;
    end
  end

  always @ (*) begin
    dataWriteCmd_payload_mask = (4'bxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          dataWriteCmd_payload_mask = stageB_mask;
        end
      end
    end
    if(_zz_17_)begin
      dataWriteCmd_payload_mask = (4'b1111);
    end
  end

  always @ (*) begin
    case(io_cpu_execute_args_size)
      2'b00 : begin
        _zz_6_ = (4'b0001);
      end
      2'b01 : begin
        _zz_6_ = (4'b0011);
      end
      default : begin
        _zz_6_ = (4'b1111);
      end
    endcase
  end

  assign stage0_mask = (_zz_6_ <<< io_cpu_execute_address[1 : 0]);
  assign stage0_colisions[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_execute_address[11 : 2])) && ((stage0_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign io_cpu_memory_mmuBus_cmd_isValid = io_cpu_memory_isValid;
  assign io_cpu_memory_mmuBus_cmd_virtualAddress = io_cpu_memory_address;
  assign io_cpu_memory_mmuBus_cmd_bypassTranslation = 1'b0;
  assign io_cpu_memory_mmuBus_end = ((! io_cpu_memory_isStuck) || io_cpu_memory_isRemoved);
  assign io_cpu_memory_isWrite = stageA_request_wr;
  assign stageA_wayHits_0 = ((io_cpu_memory_mmuBus_rsp_physicalAddress[31 : 12] == ways_0_tagsReadRsp_address) && ways_0_tagsReadRsp_valid);
  assign _zz_7_[0] = (((dataWriteCmd_valid && dataWriteCmd_payload_way[0]) && (dataWriteCmd_payload_address == io_cpu_memory_address[11 : 2])) && ((stageA_mask & dataWriteCmd_payload_mask) != (4'b0000)));
  assign stageA_colisions = (stage0_colisions_regNextWhen | _zz_7_);
  always @ (*) begin
    stageB_mmuRspFreeze = 1'b0;
    if((stageB_loaderValid || loader_valid))begin
      stageB_mmuRspFreeze = 1'b1;
    end
  end

  assign _zz_8_[0] = stageA_wayHits_0;
  assign stageB_waysHit = (stageB_waysHits != (1'b0));
  assign stageB_dataMux = stageB_dataReadRsp_0;
  always @ (*) begin
    stageB_loaderValid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          if(io_mem_cmd_ready)begin
            stageB_loaderValid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      stageB_loaderValid = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_haltIt = io_cpu_writeBack_isValid;
    if(stageB_flusher_valid)begin
      io_cpu_writeBack_haltIt = 1'b1;
    end
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        if((stageB_request_wr ? io_mem_cmd_ready : io_mem_rsp_valid))begin
          io_cpu_writeBack_haltIt = 1'b0;
        end
        if(_zz_18_)begin
          io_cpu_writeBack_haltIt = 1'b0;
        end
      end else begin
        if(_zz_14_)begin
          if(((! stageB_request_wr) || io_mem_cmd_ready))begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
          if(stageB_isAmo)begin
            if(_zz_15_)begin
              io_cpu_writeBack_haltIt = 1'b1;
            end
          end
          if(_zz_16_)begin
            io_cpu_writeBack_haltIt = 1'b0;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_cpu_writeBack_haltIt = 1'b0;
    end
  end

  always @ (*) begin
    io_cpu_flush_ready = 1'b0;
    if(_zz_19_)begin
      io_cpu_flush_ready = 1'b1;
    end
  end

  always @ (*) begin
    stageB_requestDataBypass = stageB_request_data;
    if(stageB_isAmo)begin
      stageB_requestDataBypass = stageB_amo_resultReg;
    end
  end

  assign stageB_amo_compare = stageB_request_amoCtrl_alu[2];
  assign stageB_amo_unsigned = (stageB_request_amoCtrl_alu[2 : 1] == (2'b11));
  assign stageB_amo_addSub = _zz_25_;
  assign stageB_amo_less = ((stageB_request_data[31] == stageB_dataMux[31]) ? stageB_amo_addSub[31] : (stageB_amo_unsigned ? stageB_dataMux[31] : stageB_request_data[31]));
  assign stageB_amo_selectRf = (stageB_request_amoCtrl_swap ? 1'b1 : (stageB_request_amoCtrl_alu[0] ^ stageB_amo_less));
  always @ (*) begin
    case(_zz_22_)
      3'b000 : begin
        stageB_amo_result = stageB_amo_addSub;
      end
      3'b001 : begin
        stageB_amo_result = (stageB_request_data ^ stageB_dataMux);
      end
      3'b010 : begin
        stageB_amo_result = (stageB_request_data | stageB_dataMux);
      end
      3'b011 : begin
        stageB_amo_result = (stageB_request_data & stageB_dataMux);
      end
      default : begin
        stageB_amo_result = (stageB_amo_selectRf ? stageB_request_data : stageB_dataMux);
      end
    endcase
  end

  always @ (*) begin
    io_cpu_redo = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(_zz_14_)begin
          if(_zz_20_)begin
            io_cpu_redo = 1'b1;
          end
        end
      end
    end
    if((io_cpu_writeBack_isValid && stageB_mmuRsp_refilling))begin
      io_cpu_redo = 1'b1;
    end
    if(loader_valid)begin
      io_cpu_redo = 1'b1;
    end
  end

  always @ (*) begin
    io_cpu_writeBack_accessError = 1'b0;
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_accessError = (io_mem_rsp_valid && io_mem_rsp_payload_error);
    end else begin
      io_cpu_writeBack_accessError = ((stageB_waysHits & _zz_9_) != (1'b0));
    end
  end

  assign io_cpu_writeBack_mmuException = (io_cpu_writeBack_isValid && ((stageB_mmuRsp_exception || ((! stageB_mmuRsp_allowWrite) && stageB_request_wr)) || ((! stageB_mmuRsp_allowRead) && ((! stageB_request_wr) || stageB_isAmo))));
  assign io_cpu_writeBack_unalignedAccess = (io_cpu_writeBack_isValid && (((stageB_request_size == (2'b10)) && (stageB_mmuRsp_physicalAddress[1 : 0] != (2'b00))) || ((stageB_request_size == (2'b01)) && (stageB_mmuRsp_physicalAddress[0 : 0] != (1'b0)))));
  assign io_cpu_writeBack_isWrite = stageB_request_wr;
  always @ (*) begin
    io_mem_cmd_valid = 1'b0;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_valid = (! stageB_memCmdSent);
        if(_zz_18_)begin
          io_mem_cmd_valid = 1'b0;
        end
      end else begin
        if(_zz_14_)begin
          if(stageB_request_wr)begin
            io_mem_cmd_valid = 1'b1;
          end
          if(stageB_isAmo)begin
            if(_zz_15_)begin
              io_mem_cmd_valid = 1'b0;
            end
          end
          if(_zz_20_)begin
            io_mem_cmd_valid = 1'b0;
          end
          if(_zz_16_)begin
            io_mem_cmd_valid = 1'b0;
          end
        end else begin
          if((! stageB_memCmdSent))begin
            io_mem_cmd_valid = 1'b1;
          end
        end
      end
    end
    if(_zz_13_)begin
      io_mem_cmd_valid = 1'b0;
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_address = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 2],(2'b00)};
        end else begin
          io_mem_cmd_payload_address = {stageB_mmuRsp_physicalAddress[31 : 5],(5'b00000)};
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_length = (3'bxxx);
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_length = (3'b000);
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_length = (3'b000);
        end else begin
          io_mem_cmd_payload_length = (3'b111);
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_last = 1'bx;
    if(io_cpu_writeBack_isValid)begin
      if(stageB_mmuRsp_isIoAccess)begin
        io_mem_cmd_payload_last = 1'b1;
      end else begin
        if(_zz_14_)begin
          io_mem_cmd_payload_last = 1'b1;
        end else begin
          io_mem_cmd_payload_last = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    io_mem_cmd_payload_wr = stageB_request_wr;
    if(io_cpu_writeBack_isValid)begin
      if(! stageB_mmuRsp_isIoAccess) begin
        if(! _zz_14_) begin
          io_mem_cmd_payload_wr = 1'b0;
        end
      end
    end
  end

  assign io_mem_cmd_payload_mask = stageB_mask;
  assign io_mem_cmd_payload_data = stageB_requestDataBypass;
  always @ (*) begin
    if(stageB_mmuRsp_isIoAccess)begin
      io_cpu_writeBack_data = io_mem_rsp_payload_data;
    end else begin
      io_cpu_writeBack_data = stageB_dataMux;
    end
    if((stageB_request_isLrsc && stageB_request_wr))begin
      io_cpu_writeBack_data = {31'd0, _zz_33_};
    end
  end

  assign _zz_9_[0] = stageB_tagsReadRsp_0_error;
  always @ (*) begin
    loader_counter_willIncrement = 1'b0;
    if(_zz_17_)begin
      loader_counter_willIncrement = 1'b1;
    end
  end

  assign loader_counter_willClear = 1'b0;
  assign loader_counter_willOverflowIfInc = (loader_counter_value == (3'b111));
  assign loader_counter_willOverflow = (loader_counter_willOverflowIfInc && loader_counter_willIncrement);
  always @ (*) begin
    loader_counter_valueNext = (loader_counter_value + _zz_35_);
    if(loader_counter_willClear)begin
      loader_counter_valueNext = (3'b000);
    end
  end

  always @ (posedge clk) begin
    tagsWriteLastCmd_valid <= tagsWriteCmd_valid;
    tagsWriteLastCmd_payload_way <= tagsWriteCmd_payload_way;
    tagsWriteLastCmd_payload_address <= tagsWriteCmd_payload_address;
    tagsWriteLastCmd_payload_data_valid <= tagsWriteCmd_payload_data_valid;
    tagsWriteLastCmd_payload_data_error <= tagsWriteCmd_payload_data_error;
    tagsWriteLastCmd_payload_data_address <= tagsWriteCmd_payload_data_address;
    if((! io_cpu_memory_isStuck))begin
      stageA_request_wr <= io_cpu_execute_args_wr;
      stageA_request_data <= io_cpu_execute_args_data;
      stageA_request_size <= io_cpu_execute_args_size;
      stageA_request_isLrsc <= io_cpu_execute_args_isLrsc;
      stageA_request_isAmo <= io_cpu_execute_args_isAmo;
      stageA_request_amoCtrl_swap <= io_cpu_execute_args_amoCtrl_swap;
      stageA_request_amoCtrl_alu <= io_cpu_execute_args_amoCtrl_alu;
    end
    if((! io_cpu_memory_isStuck))begin
      stageA_mask <= stage0_mask;
    end
    if((! io_cpu_memory_isStuck))begin
      stage0_colisions_regNextWhen <= stage0_colisions;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_request_wr <= stageA_request_wr;
      stageB_request_data <= stageA_request_data;
      stageB_request_size <= stageA_request_size;
      stageB_request_isLrsc <= stageA_request_isLrsc;
      stageB_isAmo <= stageA_request_isAmo;
      stageB_request_amoCtrl_swap <= stageA_request_amoCtrl_swap;
      stageB_request_amoCtrl_alu <= stageA_request_amoCtrl_alu;
    end
    if(_zz_21_)begin
      stageB_mmuRsp_isIoAccess <= io_cpu_memory_mmuBus_rsp_isIoAccess;
      stageB_mmuRsp_allowRead <= io_cpu_memory_mmuBus_rsp_allowRead;
      stageB_mmuRsp_allowWrite <= io_cpu_memory_mmuBus_rsp_allowWrite;
      stageB_mmuRsp_allowExecute <= io_cpu_memory_mmuBus_rsp_allowExecute;
      stageB_mmuRsp_exception <= io_cpu_memory_mmuBus_rsp_exception;
      stageB_mmuRsp_refilling <= io_cpu_memory_mmuBus_rsp_refilling;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_tagsReadRsp_0_valid <= ways_0_tagsReadRsp_valid;
      stageB_tagsReadRsp_0_error <= ways_0_tagsReadRsp_error;
      stageB_tagsReadRsp_0_address <= ways_0_tagsReadRsp_address;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_dataReadRsp_0 <= ways_0_dataReadRsp;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_waysHits <= _zz_8_;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_mask <= stageA_mask;
    end
    if((! io_cpu_writeBack_isStuck))begin
      stageB_colisions <= stageA_colisions;
    end
    stageB_amo_resultRegValid <= 1'b1;
    if((! io_cpu_writeBack_isStuck))begin
      stageB_amo_resultRegValid <= 1'b0;
    end
    stageB_amo_resultReg <= stageB_amo_result;
    if(!(! ((io_cpu_writeBack_isValid && (! io_cpu_writeBack_haltIt)) && io_cpu_writeBack_isStuck))) begin
      $display("ERROR writeBack stuck by another plugin is not allowed");
    end
  end

  always @ (posedge clk) begin
    if(reset) begin
      stageB_flusher_valid <= 1'b1;
      stageB_mmuRsp_physicalAddress <= (32'b00000000000000000000000000000000);
      stageB_lrsc_reserved <= 1'b0;
      stageB_memCmdSent <= 1'b0;
      loader_valid <= 1'b0;
      loader_counter_value <= (3'b000);
      loader_waysAllocator <= (1'b1);
      loader_error <= 1'b0;
    end else begin
      if(_zz_21_)begin
        stageB_mmuRsp_physicalAddress <= io_cpu_memory_mmuBus_rsp_physicalAddress;
      end
      if(stageB_flusher_valid)begin
        if((stageB_mmuRsp_physicalAddress[11 : 5] != (7'b1111111)))begin
          stageB_mmuRsp_physicalAddress[11 : 5] <= (stageB_mmuRsp_physicalAddress[11 : 5] + (7'b0000001));
        end else begin
          stageB_flusher_valid <= 1'b0;
        end
      end
      if(_zz_19_)begin
        stageB_mmuRsp_physicalAddress[11 : 5] <= (7'b0000000);
        stageB_flusher_valid <= 1'b1;
      end
      if(((((io_cpu_writeBack_isValid && (! io_cpu_writeBack_isStuck)) && (! io_cpu_redo)) && stageB_request_isLrsc) && (! stageB_request_wr)))begin
        stageB_lrsc_reserved <= 1'b1;
      end
      if(io_cpu_writeBack_clearLrsc)begin
        stageB_lrsc_reserved <= 1'b0;
      end
      if(io_mem_cmd_ready)begin
        stageB_memCmdSent <= 1'b1;
      end
      if((! io_cpu_writeBack_isStuck))begin
        stageB_memCmdSent <= 1'b0;
      end
      if(stageB_loaderValid)begin
        loader_valid <= 1'b1;
      end
      loader_counter_value <= loader_counter_valueNext;
      if(_zz_17_)begin
        loader_error <= (loader_error || io_mem_rsp_payload_error);
      end
      if(loader_counter_willOverflow)begin
        loader_valid <= 1'b0;
        loader_error <= 1'b0;
      end
      if((! loader_valid))begin
        loader_waysAllocator <= _zz_36_[0:0];
      end
    end
  end

endmodule

module VexRiscv (
      input  [31:0] externalResetVector,
      input   timerInterrupt,
      input   softwareInterrupt,
      input  [31:0] externalInterruptArray,
      output reg  iBusWishbone_CYC,
      output reg  iBusWishbone_STB,
      input   iBusWishbone_ACK,
      output  iBusWishbone_WE,
      output [29:0] iBusWishbone_ADR,
      input  [31:0] iBusWishbone_DAT_MISO,
      output [31:0] iBusWishbone_DAT_MOSI,
      output [3:0] iBusWishbone_SEL,
      input   iBusWishbone_ERR,
      output [1:0] iBusWishbone_BTE,
      output [2:0] iBusWishbone_CTI,
      output  dBusWishbone_CYC,
      output  dBusWishbone_STB,
      input   dBusWishbone_ACK,
      output  dBusWishbone_WE,
      output [29:0] dBusWishbone_ADR,
      input  [31:0] dBusWishbone_DAT_MISO,
      output [31:0] dBusWishbone_DAT_MOSI,
      output [3:0] dBusWishbone_SEL,
      input   dBusWishbone_ERR,
      output [1:0] dBusWishbone_BTE,
      output [2:0] dBusWishbone_CTI,
      input   clk,
      input   reset);
  wire  _zz_239_;
  wire  _zz_240_;
  wire  _zz_241_;
  wire  _zz_242_;
  wire [31:0] _zz_243_;
  wire  _zz_244_;
  wire  _zz_245_;
  wire  _zz_246_;
  reg  _zz_247_;
  reg  _zz_248_;
  reg [31:0] _zz_249_;
  reg  _zz_250_;
  reg [31:0] _zz_251_;
  reg [1:0] _zz_252_;
  reg  _zz_253_;
  reg  _zz_254_;
  wire  _zz_255_;
  wire [2:0] _zz_256_;
  reg  _zz_257_;
  wire [31:0] _zz_258_;
  reg  _zz_259_;
  reg  _zz_260_;
  wire  _zz_261_;
  wire [31:0] _zz_262_;
  wire  _zz_263_;
  wire  _zz_264_;
  reg [31:0] _zz_265_;
  reg [31:0] _zz_266_;
  reg [31:0] _zz_267_;
  reg  _zz_268_;
  reg  _zz_269_;
  reg  _zz_270_;
  reg [9:0] _zz_271_;
  reg [9:0] _zz_272_;
  reg [9:0] _zz_273_;
  reg [9:0] _zz_274_;
  reg  _zz_275_;
  reg  _zz_276_;
  reg  _zz_277_;
  reg  _zz_278_;
  reg  _zz_279_;
  reg  _zz_280_;
  reg  _zz_281_;
  reg [9:0] _zz_282_;
  reg [9:0] _zz_283_;
  reg [9:0] _zz_284_;
  reg [9:0] _zz_285_;
  reg  _zz_286_;
  reg  _zz_287_;
  reg  _zz_288_;
  reg  _zz_289_;
  wire  IBusCachedPlugin_cache_io_cpu_prefetch_haltIt;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_data;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_haltIt;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  wire  IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  wire  IBusCachedPlugin_cache_io_cpu_decode_error;
  wire  IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling;
  wire  IBusCachedPlugin_cache_io_cpu_decode_mmuException;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_decode_data;
  wire  IBusCachedPlugin_cache_io_cpu_decode_cacheMiss;
  wire [31:0] IBusCachedPlugin_cache_io_cpu_decode_physicalAddress;
  wire  IBusCachedPlugin_cache_io_mem_cmd_valid;
  wire [31:0] IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  wire [2:0] IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  wire  dataCache_1__io_cpu_memory_isWrite;
  wire  dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  wire [31:0] dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  wire  dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
  wire  dataCache_1__io_cpu_memory_mmuBus_end;
  wire  dataCache_1__io_cpu_writeBack_haltIt;
  wire [31:0] dataCache_1__io_cpu_writeBack_data;
  wire  dataCache_1__io_cpu_writeBack_mmuException;
  wire  dataCache_1__io_cpu_writeBack_unalignedAccess;
  wire  dataCache_1__io_cpu_writeBack_accessError;
  wire  dataCache_1__io_cpu_writeBack_isWrite;
  wire  dataCache_1__io_cpu_flush_ready;
  wire  dataCache_1__io_cpu_redo;
  wire  dataCache_1__io_mem_cmd_valid;
  wire  dataCache_1__io_mem_cmd_payload_wr;
  wire [31:0] dataCache_1__io_mem_cmd_payload_address;
  wire [31:0] dataCache_1__io_mem_cmd_payload_data;
  wire [3:0] dataCache_1__io_mem_cmd_payload_mask;
  wire [2:0] dataCache_1__io_mem_cmd_payload_length;
  wire  dataCache_1__io_mem_cmd_payload_last;
  wire  _zz_290_;
  wire  _zz_291_;
  wire  _zz_292_;
  wire  _zz_293_;
  wire  _zz_294_;
  wire  _zz_295_;
  wire  _zz_296_;
  wire  _zz_297_;
  wire  _zz_298_;
  wire  _zz_299_;
  wire  _zz_300_;
  wire  _zz_301_;
  wire  _zz_302_;
  wire  _zz_303_;
  wire  _zz_304_;
  wire  _zz_305_;
  wire [1:0] _zz_306_;
  wire  _zz_307_;
  wire  _zz_308_;
  wire  _zz_309_;
  wire  _zz_310_;
  wire  _zz_311_;
  wire  _zz_312_;
  wire  _zz_313_;
  wire  _zz_314_;
  wire  _zz_315_;
  wire  _zz_316_;
  wire [1:0] _zz_317_;
  wire  _zz_318_;
  wire  _zz_319_;
  wire  _zz_320_;
  wire  _zz_321_;
  wire  _zz_322_;
  wire  _zz_323_;
  wire  _zz_324_;
  wire  _zz_325_;
  wire  _zz_326_;
  wire  _zz_327_;
  wire  _zz_328_;
  wire  _zz_329_;
  wire  _zz_330_;
  wire  _zz_331_;
  wire  _zz_332_;
  wire  _zz_333_;
  wire  _zz_334_;
  wire  _zz_335_;
  wire  _zz_336_;
  wire  _zz_337_;
  wire  _zz_338_;
  wire  _zz_339_;
  wire  _zz_340_;
  wire  _zz_341_;
  wire  _zz_342_;
  wire  _zz_343_;
  wire  _zz_344_;
  wire  _zz_345_;
  wire  _zz_346_;
  wire  _zz_347_;
  wire [1:0] _zz_348_;
  wire [1:0] _zz_349_;
  wire  _zz_350_;
  wire [4:0] _zz_351_;
  wire [2:0] _zz_352_;
  wire [31:0] _zz_353_;
  wire [11:0] _zz_354_;
  wire [31:0] _zz_355_;
  wire [19:0] _zz_356_;
  wire [11:0] _zz_357_;
  wire [31:0] _zz_358_;
  wire [31:0] _zz_359_;
  wire [19:0] _zz_360_;
  wire [11:0] _zz_361_;
  wire [2:0] _zz_362_;
  wire [2:0] _zz_363_;
  wire [0:0] _zz_364_;
  wire [0:0] _zz_365_;
  wire [0:0] _zz_366_;
  wire [0:0] _zz_367_;
  wire [0:0] _zz_368_;
  wire [0:0] _zz_369_;
  wire [0:0] _zz_370_;
  wire [0:0] _zz_371_;
  wire [0:0] _zz_372_;
  wire [0:0] _zz_373_;
  wire [0:0] _zz_374_;
  wire [0:0] _zz_375_;
  wire [0:0] _zz_376_;
  wire [0:0] _zz_377_;
  wire [0:0] _zz_378_;
  wire [0:0] _zz_379_;
  wire [0:0] _zz_380_;
  wire [0:0] _zz_381_;
  wire [0:0] _zz_382_;
  wire [0:0] _zz_383_;
  wire [0:0] _zz_384_;
  wire [2:0] _zz_385_;
  wire [4:0] _zz_386_;
  wire [11:0] _zz_387_;
  wire [11:0] _zz_388_;
  wire [31:0] _zz_389_;
  wire [31:0] _zz_390_;
  wire [31:0] _zz_391_;
  wire [31:0] _zz_392_;
  wire [31:0] _zz_393_;
  wire [31:0] _zz_394_;
  wire [31:0] _zz_395_;
  wire [32:0] _zz_396_;
  wire [31:0] _zz_397_;
  wire [32:0] _zz_398_;
  wire [51:0] _zz_399_;
  wire [51:0] _zz_400_;
  wire [51:0] _zz_401_;
  wire [32:0] _zz_402_;
  wire [51:0] _zz_403_;
  wire [49:0] _zz_404_;
  wire [51:0] _zz_405_;
  wire [49:0] _zz_406_;
  wire [51:0] _zz_407_;
  wire [65:0] _zz_408_;
  wire [65:0] _zz_409_;
  wire [31:0] _zz_410_;
  wire [31:0] _zz_411_;
  wire [0:0] _zz_412_;
  wire [5:0] _zz_413_;
  wire [32:0] _zz_414_;
  wire [32:0] _zz_415_;
  wire [31:0] _zz_416_;
  wire [31:0] _zz_417_;
  wire [32:0] _zz_418_;
  wire [32:0] _zz_419_;
  wire [32:0] _zz_420_;
  wire [0:0] _zz_421_;
  wire [32:0] _zz_422_;
  wire [0:0] _zz_423_;
  wire [32:0] _zz_424_;
  wire [0:0] _zz_425_;
  wire [31:0] _zz_426_;
  wire [1:0] _zz_427_;
  wire [1:0] _zz_428_;
  wire [1:0] _zz_429_;
  wire [1:0] _zz_430_;
  wire [11:0] _zz_431_;
  wire [19:0] _zz_432_;
  wire [11:0] _zz_433_;
  wire [31:0] _zz_434_;
  wire [31:0] _zz_435_;
  wire [31:0] _zz_436_;
  wire [11:0] _zz_437_;
  wire [19:0] _zz_438_;
  wire [11:0] _zz_439_;
  wire [2:0] _zz_440_;
  wire [0:0] _zz_441_;
  wire [1:0] _zz_442_;
  wire [0:0] _zz_443_;
  wire [1:0] _zz_444_;
  wire [0:0] _zz_445_;
  wire [0:0] _zz_446_;
  wire [0:0] _zz_447_;
  wire [0:0] _zz_448_;
  wire [0:0] _zz_449_;
  wire [0:0] _zz_450_;
  wire [0:0] _zz_451_;
  wire [0:0] _zz_452_;
  wire [0:0] _zz_453_;
  wire [0:0] _zz_454_;
  wire [0:0] _zz_455_;
  wire [0:0] _zz_456_;
  wire [0:0] _zz_457_;
  wire [0:0] _zz_458_;
  wire [0:0] _zz_459_;
  wire [0:0] _zz_460_;
  wire [0:0] _zz_461_;
  wire [0:0] _zz_462_;
  wire [0:0] _zz_463_;
  wire [0:0] _zz_464_;
  wire [0:0] _zz_465_;
  wire [0:0] _zz_466_;
  wire [0:0] _zz_467_;
  wire [0:0] _zz_468_;
  wire [0:0] _zz_469_;
  wire [0:0] _zz_470_;
  wire [0:0] _zz_471_;
  wire [0:0] _zz_472_;
  wire [0:0] _zz_473_;
  wire [0:0] _zz_474_;
  wire [0:0] _zz_475_;
  wire [0:0] _zz_476_;
  wire [0:0] _zz_477_;
  wire [0:0] _zz_478_;
  wire [0:0] _zz_479_;
  wire [0:0] _zz_480_;
  wire [0:0] _zz_481_;
  wire [0:0] _zz_482_;
  wire [0:0] _zz_483_;
  wire [0:0] _zz_484_;
  wire [0:0] _zz_485_;
  wire [0:0] _zz_486_;
  wire [0:0] _zz_487_;
  wire [0:0] _zz_488_;
  wire [0:0] _zz_489_;
  wire [0:0] _zz_490_;
  wire [0:0] _zz_491_;
  wire [0:0] _zz_492_;
  wire [0:0] _zz_493_;
  wire [0:0] _zz_494_;
  wire [0:0] _zz_495_;
  wire [0:0] _zz_496_;
  wire [0:0] _zz_497_;
  wire [0:0] _zz_498_;
  wire [26:0] _zz_499_;
  wire  _zz_500_;
  wire  _zz_501_;
  wire [2:0] _zz_502_;
  wire  _zz_503_;
  wire  _zz_504_;
  wire  _zz_505_;
  wire  _zz_506_;
  wire  _zz_507_;
  wire [0:0] _zz_508_;
  wire [1:0] _zz_509_;
  wire [0:0] _zz_510_;
  wire [0:0] _zz_511_;
  wire  _zz_512_;
  wire [0:0] _zz_513_;
  wire [29:0] _zz_514_;
  wire [31:0] _zz_515_;
  wire [31:0] _zz_516_;
  wire [31:0] _zz_517_;
  wire [31:0] _zz_518_;
  wire [31:0] _zz_519_;
  wire [31:0] _zz_520_;
  wire  _zz_521_;
  wire  _zz_522_;
  wire [2:0] _zz_523_;
  wire [2:0] _zz_524_;
  wire  _zz_525_;
  wire [0:0] _zz_526_;
  wire [26:0] _zz_527_;
  wire  _zz_528_;
  wire  _zz_529_;
  wire [0:0] _zz_530_;
  wire [0:0] _zz_531_;
  wire [1:0] _zz_532_;
  wire [1:0] _zz_533_;
  wire  _zz_534_;
  wire [0:0] _zz_535_;
  wire [23:0] _zz_536_;
  wire [31:0] _zz_537_;
  wire [31:0] _zz_538_;
  wire [31:0] _zz_539_;
  wire  _zz_540_;
  wire [0:0] _zz_541_;
  wire [0:0] _zz_542_;
  wire [0:0] _zz_543_;
  wire [4:0] _zz_544_;
  wire [0:0] _zz_545_;
  wire [0:0] _zz_546_;
  wire  _zz_547_;
  wire [0:0] _zz_548_;
  wire [20:0] _zz_549_;
  wire [31:0] _zz_550_;
  wire [31:0] _zz_551_;
  wire [31:0] _zz_552_;
  wire [31:0] _zz_553_;
  wire [31:0] _zz_554_;
  wire [31:0] _zz_555_;
  wire [31:0] _zz_556_;
  wire  _zz_557_;
  wire [0:0] _zz_558_;
  wire [2:0] _zz_559_;
  wire [31:0] _zz_560_;
  wire [31:0] _zz_561_;
  wire  _zz_562_;
  wire [1:0] _zz_563_;
  wire [1:0] _zz_564_;
  wire  _zz_565_;
  wire [0:0] _zz_566_;
  wire [18:0] _zz_567_;
  wire [31:0] _zz_568_;
  wire [31:0] _zz_569_;
  wire [31:0] _zz_570_;
  wire  _zz_571_;
  wire [0:0] _zz_572_;
  wire [0:0] _zz_573_;
  wire [31:0] _zz_574_;
  wire  _zz_575_;
  wire  _zz_576_;
  wire  _zz_577_;
  wire [1:0] _zz_578_;
  wire [1:0] _zz_579_;
  wire  _zz_580_;
  wire [0:0] _zz_581_;
  wire [16:0] _zz_582_;
  wire [31:0] _zz_583_;
  wire [31:0] _zz_584_;
  wire [31:0] _zz_585_;
  wire [31:0] _zz_586_;
  wire [31:0] _zz_587_;
  wire [31:0] _zz_588_;
  wire [31:0] _zz_589_;
  wire [31:0] _zz_590_;
  wire  _zz_591_;
  wire  _zz_592_;
  wire [0:0] _zz_593_;
  wire [0:0] _zz_594_;
  wire  _zz_595_;
  wire [0:0] _zz_596_;
  wire [14:0] _zz_597_;
  wire [31:0] _zz_598_;
  wire  _zz_599_;
  wire [0:0] _zz_600_;
  wire [2:0] _zz_601_;
  wire  _zz_602_;
  wire [2:0] _zz_603_;
  wire [2:0] _zz_604_;
  wire  _zz_605_;
  wire [0:0] _zz_606_;
  wire [11:0] _zz_607_;
  wire [31:0] _zz_608_;
  wire  _zz_609_;
  wire [31:0] _zz_610_;
  wire [31:0] _zz_611_;
  wire  _zz_612_;
  wire  _zz_613_;
  wire  _zz_614_;
  wire [0:0] _zz_615_;
  wire [2:0] _zz_616_;
  wire [0:0] _zz_617_;
  wire [2:0] _zz_618_;
  wire [1:0] _zz_619_;
  wire [1:0] _zz_620_;
  wire  _zz_621_;
  wire [0:0] _zz_622_;
  wire [8:0] _zz_623_;
  wire [31:0] _zz_624_;
  wire [31:0] _zz_625_;
  wire [31:0] _zz_626_;
  wire [31:0] _zz_627_;
  wire [31:0] _zz_628_;
  wire [31:0] _zz_629_;
  wire  _zz_630_;
  wire [0:0] _zz_631_;
  wire [0:0] _zz_632_;
  wire [31:0] _zz_633_;
  wire [31:0] _zz_634_;
  wire  _zz_635_;
  wire [0:0] _zz_636_;
  wire [0:0] _zz_637_;
  wire  _zz_638_;
  wire  _zz_639_;
  wire [0:0] _zz_640_;
  wire [5:0] _zz_641_;
  wire [0:0] _zz_642_;
  wire [0:0] _zz_643_;
  wire  _zz_644_;
  wire [0:0] _zz_645_;
  wire [6:0] _zz_646_;
  wire [31:0] _zz_647_;
  wire [31:0] _zz_648_;
  wire [31:0] _zz_649_;
  wire [31:0] _zz_650_;
  wire [31:0] _zz_651_;
  wire [31:0] _zz_652_;
  wire [31:0] _zz_653_;
  wire [31:0] _zz_654_;
  wire [31:0] _zz_655_;
  wire [31:0] _zz_656_;
  wire  _zz_657_;
  wire [0:0] _zz_658_;
  wire [3:0] _zz_659_;
  wire [31:0] _zz_660_;
  wire [31:0] _zz_661_;
  wire  _zz_662_;
  wire [0:0] _zz_663_;
  wire [0:0] _zz_664_;
  wire  _zz_665_;
  wire [0:0] _zz_666_;
  wire [4:0] _zz_667_;
  wire [31:0] _zz_668_;
  wire [31:0] _zz_669_;
  wire [31:0] _zz_670_;
  wire  _zz_671_;
  wire [0:0] _zz_672_;
  wire [1:0] _zz_673_;
  wire [31:0] _zz_674_;
  wire [31:0] _zz_675_;
  wire [31:0] _zz_676_;
  wire  _zz_677_;
  wire [2:0] _zz_678_;
  wire [2:0] _zz_679_;
  wire  _zz_680_;
  wire [0:0] _zz_681_;
  wire [2:0] _zz_682_;
  wire [31:0] _zz_683_;
  wire [31:0] _zz_684_;
  wire [31:0] _zz_685_;
  wire  _zz_686_;
  wire  _zz_687_;
  wire  _zz_688_;
  wire [0:0] _zz_689_;
  wire [0:0] _zz_690_;
  wire  _zz_691_;
  wire  _zz_692_;
  wire [31:0] _zz_693_;
  wire [31:0] _zz_694_;
  wire [31:0] _zz_695_;
  wire  _zz_696_;
  wire [0:0] _zz_697_;
  wire [17:0] _zz_698_;
  wire [31:0] _zz_699_;
  wire [31:0] _zz_700_;
  wire [31:0] _zz_701_;
  wire  _zz_702_;
  wire [0:0] _zz_703_;
  wire [11:0] _zz_704_;
  wire [31:0] _zz_705_;
  wire [31:0] _zz_706_;
  wire [31:0] _zz_707_;
  wire  _zz_708_;
  wire [0:0] _zz_709_;
  wire [5:0] _zz_710_;
  wire [31:0] _zz_711_;
  wire [31:0] _zz_712_;
  wire [31:0] _zz_713_;
  wire  _zz_714_;
  wire  _zz_715_;
  wire  _zz_716_;
  wire  _zz_717_;
  wire  _zz_718_;
  wire  decode_CSR_WRITE_OPCODE;
  wire `Src1CtrlEnum_defaultEncoding_type decode_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_1_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_2_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_3_;
  wire  execute_BYPASSABLE_MEMORY_STAGE;
  wire  decode_BYPASSABLE_MEMORY_STAGE;
  wire  decode_PREDICTION_HAD_BRANCHED2;
  wire [31:0] execute_MUL_LL;
  wire  decode_IS_DIV;
  wire  decode_BYPASSABLE_EXECUTE_STAGE;
  wire  decode_IS_CSR;
  wire  memory_MEMORY_WR;
  wire  decode_MEMORY_WR;
  wire [31:0] writeBack_FORMAL_PC_NEXT;
  wire [31:0] memory_FORMAL_PC_NEXT;
  wire [31:0] execute_FORMAL_PC_NEXT;
  wire [31:0] decode_FORMAL_PC_NEXT;
  wire  decode_SRC2_FORCE_ZERO;
  wire `AluCtrlEnum_defaultEncoding_type decode_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_4_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_5_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_6_;
  wire [31:0] execute_REGFILE_WRITE_DATA;
  wire [1:0] memory_MEMORY_ADDRESS_LOW;
  wire [1:0] execute_MEMORY_ADDRESS_LOW;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type decode_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_7_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_8_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_9_;
  wire  execute_IS_DBUS_SHARING;
  wire  decode_MEMORY_LRSC;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_10_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_11_;
  wire [33:0] execute_MUL_LH;
  wire `ShiftCtrlEnum_defaultEncoding_type decode_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_12_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_13_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_14_;
  wire  decode_IS_RS2_SIGNED;
  wire  decode_CSR_READ_OPCODE;
  wire  decode_MEMORY_AMO;
  wire  memory_IS_SFENCE_VMA;
  wire  execute_IS_SFENCE_VMA;
  wire  decode_IS_SFENCE_VMA;
  wire [33:0] execute_MUL_HL;
  wire  memory_IS_MUL;
  wire  execute_IS_MUL;
  wire  decode_IS_MUL;
  wire [31:0] memory_PC;
  wire [51:0] memory_MUL_LOW;
  wire  decode_MEMORY_MANAGMENT;
  wire  decode_SRC_LESS_UNSIGNED;
  wire [33:0] memory_MUL_HH;
  wire [33:0] execute_MUL_HH;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_15_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_16_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_17_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_18_;
  wire `EnvCtrlEnum_defaultEncoding_type decode_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_19_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_20_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_21_;
  wire `Src2CtrlEnum_defaultEncoding_type decode_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_22_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_23_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_24_;
  wire  decode_IS_RS1_SIGNED;
  wire  writeBack_IS_SFENCE_VMA;
  wire [31:0] execute_BRANCH_CALC;
  wire  execute_BRANCH_DO;
  wire [31:0] _zz_25_;
  wire [31:0] execute_PC;
  wire  execute_PREDICTION_HAD_BRANCHED2;
  wire  _zz_26_;
  wire  execute_BRANCH_COND_RESULT;
  wire `BranchCtrlEnum_defaultEncoding_type execute_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_27_;
  wire  _zz_28_;
  wire  _zz_29_;
  wire  execute_CSR_READ_OPCODE;
  wire  execute_CSR_WRITE_OPCODE;
  wire  execute_IS_CSR;
  wire `EnvCtrlEnum_defaultEncoding_type memory_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_30_;
  wire `EnvCtrlEnum_defaultEncoding_type execute_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_31_;
  wire  _zz_32_;
  wire  _zz_33_;
  wire `EnvCtrlEnum_defaultEncoding_type writeBack_ENV_CTRL;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_34_;
  wire  execute_IS_RS1_SIGNED;
  wire [31:0] execute_RS1;
  wire  execute_IS_DIV;
  wire  execute_IS_RS2_SIGNED;
  wire  memory_IS_DIV;
  wire  writeBack_IS_MUL;
  wire [33:0] writeBack_MUL_HH;
  wire [51:0] writeBack_MUL_LOW;
  wire [33:0] memory_MUL_HL;
  wire [33:0] memory_MUL_LH;
  wire [31:0] memory_MUL_LL;
  wire [51:0] _zz_35_;
  wire [33:0] _zz_36_;
  wire [33:0] _zz_37_;
  wire [33:0] _zz_38_;
  wire [31:0] _zz_39_;
  wire  decode_RS2_USE;
  wire  decode_RS1_USE;
  wire  execute_REGFILE_WRITE_VALID;
  wire  execute_BYPASSABLE_EXECUTE_STAGE;
  reg [31:0] _zz_40_;
  wire  memory_REGFILE_WRITE_VALID;
  wire [31:0] memory_INSTRUCTION;
  wire  memory_BYPASSABLE_MEMORY_STAGE;
  wire  writeBack_REGFILE_WRITE_VALID;
  reg [31:0] decode_RS2;
  reg [31:0] decode_RS1;
  wire [31:0] execute_SHIFT_RIGHT;
  reg [31:0] _zz_41_;
  wire [31:0] _zz_42_;
  wire `ShiftCtrlEnum_defaultEncoding_type execute_SHIFT_CTRL;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_43_;
  wire  _zz_44_;
  wire [31:0] _zz_45_;
  wire [31:0] _zz_46_;
  wire  execute_SRC_LESS_UNSIGNED;
  wire  execute_SRC2_FORCE_ZERO;
  wire  execute_SRC_USE_SUB_LESS;
  wire [31:0] _zz_47_;
  wire `Src2CtrlEnum_defaultEncoding_type execute_SRC2_CTRL;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_48_;
  wire [31:0] _zz_49_;
  wire `Src1CtrlEnum_defaultEncoding_type execute_SRC1_CTRL;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_50_;
  wire [31:0] _zz_51_;
  wire  decode_SRC_USE_SUB_LESS;
  wire  decode_SRC_ADD_ZERO;
  wire  _zz_52_;
  wire [31:0] execute_SRC_ADD_SUB;
  wire  execute_SRC_LESS;
  wire `AluCtrlEnum_defaultEncoding_type execute_ALU_CTRL;
  wire `AluCtrlEnum_defaultEncoding_type _zz_53_;
  wire [31:0] _zz_54_;
  wire [31:0] execute_SRC2;
  wire [31:0] execute_SRC1;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type execute_ALU_BITWISE_CTRL;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_55_;
  wire [31:0] _zz_56_;
  wire  _zz_57_;
  reg  _zz_58_;
  wire [31:0] _zz_59_;
  wire [31:0] _zz_60_;
  wire [31:0] decode_INSTRUCTION_ANTICIPATED;
  reg  decode_REGFILE_WRITE_VALID;
  wire  decode_LEGAL_INSTRUCTION;
  wire  decode_INSTRUCTION_READY;
  wire  _zz_61_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_62_;
  wire  _zz_63_;
  wire  _zz_64_;
  wire  _zz_65_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_66_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_67_;
  wire  _zz_68_;
  wire  _zz_69_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_70_;
  wire  _zz_71_;
  wire  _zz_72_;
  wire  _zz_73_;
  wire  _zz_74_;
  wire  _zz_75_;
  wire  _zz_76_;
  wire  _zz_77_;
  wire  _zz_78_;
  wire  _zz_79_;
  wire  _zz_80_;
  wire  _zz_81_;
  wire  _zz_82_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_83_;
  wire  _zz_84_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_85_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_86_;
  wire  _zz_87_;
  wire  _zz_88_;
  wire  writeBack_IS_DBUS_SHARING;
  wire  memory_IS_DBUS_SHARING;
  wire  _zz_89_;
  reg [31:0] _zz_90_;
  wire [1:0] writeBack_MEMORY_ADDRESS_LOW;
  wire  writeBack_MEMORY_WR;
  wire [31:0] writeBack_REGFILE_WRITE_DATA;
  wire  writeBack_MEMORY_ENABLE;
  wire [31:0] memory_REGFILE_WRITE_DATA;
  wire  memory_MEMORY_ENABLE;
  wire [1:0] _zz_91_;
  wire  execute_MEMORY_AMO;
  wire  execute_MEMORY_LRSC;
  wire  execute_MEMORY_MANAGMENT;
  wire [31:0] execute_RS2;
  wire  execute_MEMORY_WR;
  wire [31:0] execute_SRC_ADD;
  wire  execute_MEMORY_ENABLE;
  wire [31:0] execute_INSTRUCTION;
  wire  decode_MEMORY_ENABLE;
  wire  decode_FLUSH_ALL;
  reg  IBusCachedPlugin_rsp_issueDetected;
  reg  _zz_92_;
  reg  _zz_93_;
  reg  _zz_94_;
  wire [31:0] _zz_95_;
  wire `BranchCtrlEnum_defaultEncoding_type decode_BRANCH_CTRL;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_96_;
  wire [31:0] decode_INSTRUCTION;
  reg [31:0] _zz_97_;
  reg [31:0] _zz_98_;
  wire [31:0] decode_PC;
  wire [31:0] _zz_99_;
  wire [31:0] _zz_100_;
  wire [31:0] _zz_101_;
  wire [31:0] writeBack_PC;
  wire [31:0] writeBack_INSTRUCTION;
  reg  decode_arbitration_haltItself;
  reg  decode_arbitration_haltByOther;
  reg  decode_arbitration_removeIt;
  wire  decode_arbitration_flushIt;
  reg  decode_arbitration_flushNext;
  wire  decode_arbitration_isValid;
  wire  decode_arbitration_isStuck;
  wire  decode_arbitration_isStuckByOthers;
  wire  decode_arbitration_isFlushed;
  wire  decode_arbitration_isMoving;
  wire  decode_arbitration_isFiring;
  reg  execute_arbitration_haltItself;
  wire  execute_arbitration_haltByOther;
  reg  execute_arbitration_removeIt;
  wire  execute_arbitration_flushIt;
  reg  execute_arbitration_flushNext;
  reg  execute_arbitration_isValid;
  wire  execute_arbitration_isStuck;
  wire  execute_arbitration_isStuckByOthers;
  wire  execute_arbitration_isFlushed;
  wire  execute_arbitration_isMoving;
  wire  execute_arbitration_isFiring;
  reg  memory_arbitration_haltItself;
  wire  memory_arbitration_haltByOther;
  reg  memory_arbitration_removeIt;
  wire  memory_arbitration_flushIt;
  wire  memory_arbitration_flushNext;
  reg  memory_arbitration_isValid;
  wire  memory_arbitration_isStuck;
  wire  memory_arbitration_isStuckByOthers;
  wire  memory_arbitration_isFlushed;
  wire  memory_arbitration_isMoving;
  wire  memory_arbitration_isFiring;
  reg  writeBack_arbitration_haltItself;
  wire  writeBack_arbitration_haltByOther;
  reg  writeBack_arbitration_removeIt;
  reg  writeBack_arbitration_flushIt;
  reg  writeBack_arbitration_flushNext;
  reg  writeBack_arbitration_isValid;
  wire  writeBack_arbitration_isStuck;
  wire  writeBack_arbitration_isStuckByOthers;
  wire  writeBack_arbitration_isFlushed;
  wire  writeBack_arbitration_isMoving;
  wire  writeBack_arbitration_isFiring;
  wire [31:0] lastStageInstruction /* verilator public */ ;
  wire [31:0] lastStagePc /* verilator public */ ;
  wire  lastStageIsValid /* verilator public */ ;
  wire  lastStageIsFiring /* verilator public */ ;
  reg  IBusCachedPlugin_fetcherHalt;
  reg  IBusCachedPlugin_fetcherflushIt;
  reg  IBusCachedPlugin_incomingInstruction;
  wire  IBusCachedPlugin_predictionJumpInterface_valid;
  (* syn_keep , keep *) wire [31:0] IBusCachedPlugin_predictionJumpInterface_payload /* synthesis syn_keep = 1 */ ;
  reg  IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  wire  IBusCachedPlugin_decodePrediction_rsp_wasWrong;
  wire  IBusCachedPlugin_pcValids_0;
  wire  IBusCachedPlugin_pcValids_1;
  wire  IBusCachedPlugin_pcValids_2;
  wire  IBusCachedPlugin_pcValids_3;
  wire  IBusCachedPlugin_redoBranch_valid;
  wire [31:0] IBusCachedPlugin_redoBranch_payload;
  reg  IBusCachedPlugin_decodeExceptionPort_valid;
  reg [3:0] IBusCachedPlugin_decodeExceptionPort_payload_code;
  wire [31:0] IBusCachedPlugin_decodeExceptionPort_payload_badAddr;
  wire  IBusCachedPlugin_mmuBus_cmd_isValid;
  wire [31:0] IBusCachedPlugin_mmuBus_cmd_virtualAddress;
  wire  IBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  reg [31:0] IBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire  IBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg  IBusCachedPlugin_mmuBus_rsp_allowRead;
  reg  IBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg  IBusCachedPlugin_mmuBus_rsp_allowExecute;
  reg  IBusCachedPlugin_mmuBus_rsp_exception;
  reg  IBusCachedPlugin_mmuBus_rsp_refilling;
  wire  IBusCachedPlugin_mmuBus_end;
  wire  IBusCachedPlugin_mmuBus_busy;
  wire  DBusCachedPlugin_mmuBus_cmd_isValid;
  wire [31:0] DBusCachedPlugin_mmuBus_cmd_virtualAddress;
  reg  DBusCachedPlugin_mmuBus_cmd_bypassTranslation;
  reg [31:0] DBusCachedPlugin_mmuBus_rsp_physicalAddress;
  wire  DBusCachedPlugin_mmuBus_rsp_isIoAccess;
  reg  DBusCachedPlugin_mmuBus_rsp_allowRead;
  reg  DBusCachedPlugin_mmuBus_rsp_allowWrite;
  reg  DBusCachedPlugin_mmuBus_rsp_allowExecute;
  reg  DBusCachedPlugin_mmuBus_rsp_exception;
  reg  DBusCachedPlugin_mmuBus_rsp_refilling;
  wire  DBusCachedPlugin_mmuBus_end;
  wire  DBusCachedPlugin_mmuBus_busy;
  reg  DBusCachedPlugin_redoBranch_valid;
  wire [31:0] DBusCachedPlugin_redoBranch_payload;
  reg  DBusCachedPlugin_exceptionBus_valid;
  reg [3:0] DBusCachedPlugin_exceptionBus_payload_code;
  wire [31:0] DBusCachedPlugin_exceptionBus_payload_badAddr;
  wire  decodeExceptionPort_valid;
  wire [3:0] decodeExceptionPort_payload_code;
  wire [31:0] decodeExceptionPort_payload_badAddr;
  reg  CsrPlugin_jumpInterface_valid;
  reg [31:0] CsrPlugin_jumpInterface_payload;
  wire  CsrPlugin_exceptionPendings_0;
  wire  CsrPlugin_exceptionPendings_1;
  wire  CsrPlugin_exceptionPendings_2;
  wire  CsrPlugin_exceptionPendings_3;
  wire  externalInterrupt;
  wire  externalInterruptS;
  wire  contextSwitching;
  reg [1:0] CsrPlugin_privilege;
  wire  CsrPlugin_forceMachineWire;
  reg  CsrPlugin_selfException_valid;
  reg [3:0] CsrPlugin_selfException_payload_code;
  wire [31:0] CsrPlugin_selfException_payload_badAddr;
  wire  CsrPlugin_allowInterrupts;
  wire  CsrPlugin_allowException;
  wire  BranchPlugin_jumpInterface_valid;
  wire [31:0] BranchPlugin_jumpInterface_payload;
  reg  BranchPlugin_branchExceptionPort_valid;
  wire [3:0] BranchPlugin_branchExceptionPort_payload_code;
  wire [31:0] BranchPlugin_branchExceptionPort_payload_badAddr;
  reg  MmuPlugin_dBusAccess_cmd_valid;
  reg  MmuPlugin_dBusAccess_cmd_ready;
  reg [31:0] MmuPlugin_dBusAccess_cmd_payload_address;
  wire [1:0] MmuPlugin_dBusAccess_cmd_payload_size;
  wire  MmuPlugin_dBusAccess_cmd_payload_write;
  wire [31:0] MmuPlugin_dBusAccess_cmd_payload_data;
  wire [3:0] MmuPlugin_dBusAccess_cmd_payload_writeMask;
  wire  MmuPlugin_dBusAccess_rsp_valid;
  wire [31:0] MmuPlugin_dBusAccess_rsp_payload_data;
  wire  MmuPlugin_dBusAccess_rsp_payload_error;
  wire  MmuPlugin_dBusAccess_rsp_payload_redo;
  wire  IBusCachedPlugin_jump_pcLoad_valid;
  wire [31:0] IBusCachedPlugin_jump_pcLoad_payload;
  wire [4:0] _zz_102_;
  wire [4:0] _zz_103_;
  wire  _zz_104_;
  wire  _zz_105_;
  wire  _zz_106_;
  wire  _zz_107_;
  wire  IBusCachedPlugin_fetchPc_output_valid;
  wire  IBusCachedPlugin_fetchPc_output_ready;
  wire [31:0] IBusCachedPlugin_fetchPc_output_payload;
  reg [31:0] IBusCachedPlugin_fetchPc_pcReg /* verilator public */ ;
  reg  IBusCachedPlugin_fetchPc_corrected;
  reg  IBusCachedPlugin_fetchPc_pcRegPropagate;
  reg  IBusCachedPlugin_fetchPc_booted;
  reg  IBusCachedPlugin_fetchPc_inc;
  reg [31:0] IBusCachedPlugin_fetchPc_pc;
  wire  IBusCachedPlugin_iBusRsp_stages_0_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_0_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_0_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_0_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_0_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_0_inputSample;
  wire  IBusCachedPlugin_iBusRsp_stages_1_input_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_1_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  wire  IBusCachedPlugin_iBusRsp_stages_1_output_valid;
  wire  IBusCachedPlugin_iBusRsp_stages_1_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_stages_1_output_payload;
  reg  IBusCachedPlugin_iBusRsp_stages_1_halt;
  wire  IBusCachedPlugin_iBusRsp_stages_1_inputSample;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_valid;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_payload;
  reg  IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt;
  wire  IBusCachedPlugin_iBusRsp_cacheRspArbitration_inputSample;
  wire  _zz_108_;
  wire  _zz_109_;
  wire  _zz_110_;
  wire  _zz_111_;
  wire  _zz_112_;
  reg  _zz_113_;
  wire  _zz_114_;
  reg  _zz_115_;
  reg [31:0] _zz_116_;
  reg  IBusCachedPlugin_iBusRsp_readyForError;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_valid;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_ready;
  wire [31:0] IBusCachedPlugin_iBusRsp_decodeInput_payload_pc;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_error;
  wire [31:0] IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_inst;
  wire  IBusCachedPlugin_iBusRsp_decodeInput_payload_isRvc;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_0;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_1;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_2;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_3;
  reg  IBusCachedPlugin_injector_nextPcCalc_valids_4;
  reg  IBusCachedPlugin_injector_decodeRemoved;
  wire  _zz_117_;
  reg [18:0] _zz_118_;
  wire  _zz_119_;
  reg [10:0] _zz_120_;
  wire  _zz_121_;
  reg [18:0] _zz_122_;
  reg  _zz_123_;
  wire  _zz_124_;
  reg [10:0] _zz_125_;
  wire  _zz_126_;
  reg [18:0] _zz_127_;
  wire  iBus_cmd_valid;
  wire  iBus_cmd_ready;
  reg [31:0] iBus_cmd_payload_address;
  wire [2:0] iBus_cmd_payload_size;
  wire  iBus_rsp_valid;
  wire [31:0] iBus_rsp_payload_data;
  wire  iBus_rsp_payload_error;
  wire [31:0] _zz_128_;
  reg [31:0] IBusCachedPlugin_rspCounter;
  wire  IBusCachedPlugin_s0_tightlyCoupledHit;
  reg  IBusCachedPlugin_s1_tightlyCoupledHit;
  reg  IBusCachedPlugin_s2_tightlyCoupledHit;
  wire  IBusCachedPlugin_rsp_iBusRspOutputHalt;
  reg  IBusCachedPlugin_rsp_redoFetch;
  wire  dBus_cmd_valid;
  wire  dBus_cmd_ready;
  wire  dBus_cmd_payload_wr;
  wire [31:0] dBus_cmd_payload_address;
  wire [31:0] dBus_cmd_payload_data;
  wire [3:0] dBus_cmd_payload_mask;
  wire [2:0] dBus_cmd_payload_length;
  wire  dBus_cmd_payload_last;
  wire  dBus_rsp_valid;
  wire [31:0] dBus_rsp_payload_data;
  wire  dBus_rsp_payload_error;
  wire  dataCache_1__io_mem_cmd_s2mPipe_valid;
  wire  dataCache_1__io_mem_cmd_s2mPipe_ready;
  wire  dataCache_1__io_mem_cmd_s2mPipe_payload_wr;
  wire [31:0] dataCache_1__io_mem_cmd_s2mPipe_payload_address;
  wire [31:0] dataCache_1__io_mem_cmd_s2mPipe_payload_data;
  wire [3:0] dataCache_1__io_mem_cmd_s2mPipe_payload_mask;
  wire [2:0] dataCache_1__io_mem_cmd_s2mPipe_payload_length;
  wire  dataCache_1__io_mem_cmd_s2mPipe_payload_last;
  reg  _zz_129_;
  reg  _zz_130_;
  reg [31:0] _zz_131_;
  reg [31:0] _zz_132_;
  reg [3:0] _zz_133_;
  reg [2:0] _zz_134_;
  reg  _zz_135_;
  wire  dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid;
  wire  dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready;
  wire  dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr;
  wire [31:0] dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address;
  wire [31:0] dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data;
  wire [3:0] dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask;
  wire [2:0] dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length;
  wire  dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last;
  reg  _zz_136_;
  reg  _zz_137_;
  reg [31:0] _zz_138_;
  reg [31:0] _zz_139_;
  reg [3:0] _zz_140_;
  reg [2:0] _zz_141_;
  reg  _zz_142_;
  wire [31:0] _zz_143_;
  reg [31:0] DBusCachedPlugin_rspCounter;
  wire [1:0] execute_DBusCachedPlugin_size;
  reg [31:0] _zz_144_;
  reg [31:0] writeBack_DBusCachedPlugin_rspShifted;
  wire  _zz_145_;
  reg [31:0] _zz_146_;
  wire  _zz_147_;
  reg [31:0] _zz_148_;
  reg [31:0] writeBack_DBusCachedPlugin_rspFormated;
  reg  DBusCachedPlugin_forceDatapath;
  wire [35:0] _zz_149_;
  wire  _zz_150_;
  wire  _zz_151_;
  wire  _zz_152_;
  wire  _zz_153_;
  wire  _zz_154_;
  wire  _zz_155_;
  wire  _zz_156_;
  wire `AluBitwiseCtrlEnum_defaultEncoding_type _zz_157_;
  wire `BranchCtrlEnum_defaultEncoding_type _zz_158_;
  wire `AluCtrlEnum_defaultEncoding_type _zz_159_;
  wire `EnvCtrlEnum_defaultEncoding_type _zz_160_;
  wire `Src2CtrlEnum_defaultEncoding_type _zz_161_;
  wire `Src1CtrlEnum_defaultEncoding_type _zz_162_;
  wire `ShiftCtrlEnum_defaultEncoding_type _zz_163_;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress1;
  wire [4:0] decode_RegFilePlugin_regFileReadAddress2;
  wire [31:0] decode_RegFilePlugin_rs1Data;
  wire [31:0] decode_RegFilePlugin_rs2Data;
  reg  lastStageRegFileWrite_valid /* verilator public */ ;
  wire [4:0] lastStageRegFileWrite_payload_address /* verilator public */ ;
  wire [31:0] lastStageRegFileWrite_payload_data /* verilator public */ ;
  reg  _zz_164_;
  reg [31:0] execute_IntAluPlugin_bitwise;
  reg [31:0] _zz_165_;
  reg [31:0] _zz_166_;
  wire  _zz_167_;
  reg [19:0] _zz_168_;
  wire  _zz_169_;
  reg [19:0] _zz_170_;
  reg [31:0] _zz_171_;
  reg [31:0] execute_SrcPlugin_addSub;
  wire  execute_SrcPlugin_less;
  wire [4:0] execute_FullBarrelShifterPlugin_amplitude;
  reg [31:0] _zz_172_;
  wire [31:0] execute_FullBarrelShifterPlugin_reversed;
  reg [31:0] _zz_173_;
  reg  _zz_174_;
  reg  _zz_175_;
  wire  _zz_176_;
  reg  _zz_177_;
  reg [4:0] _zz_178_;
  reg [31:0] _zz_179_;
  wire  _zz_180_;
  wire  _zz_181_;
  wire  _zz_182_;
  wire  _zz_183_;
  wire  _zz_184_;
  wire  _zz_185_;
  reg  execute_MulPlugin_aSigned;
  reg  execute_MulPlugin_bSigned;
  wire [31:0] execute_MulPlugin_a;
  wire [31:0] execute_MulPlugin_b;
  wire [15:0] execute_MulPlugin_aULow;
  wire [15:0] execute_MulPlugin_bULow;
  wire [16:0] execute_MulPlugin_aSLow;
  wire [16:0] execute_MulPlugin_bSLow;
  wire [16:0] execute_MulPlugin_aHigh;
  wire [16:0] execute_MulPlugin_bHigh;
  wire [65:0] writeBack_MulPlugin_result;
  reg [32:0] memory_DivPlugin_rs1;
  reg [31:0] memory_DivPlugin_rs2;
  reg [64:0] memory_DivPlugin_accumulator;
  reg  memory_DivPlugin_div_needRevert;
  reg  memory_DivPlugin_div_counter_willIncrement;
  reg  memory_DivPlugin_div_counter_willClear;
  reg [5:0] memory_DivPlugin_div_counter_valueNext;
  reg [5:0] memory_DivPlugin_div_counter_value;
  wire  memory_DivPlugin_div_counter_willOverflowIfInc;
  wire  memory_DivPlugin_div_counter_willOverflow;
  reg  memory_DivPlugin_div_done;
  reg [31:0] memory_DivPlugin_div_result;
  wire [31:0] _zz_186_;
  wire [32:0] _zz_187_;
  wire [32:0] _zz_188_;
  wire [31:0] _zz_189_;
  wire  _zz_190_;
  wire  _zz_191_;
  reg [32:0] _zz_192_;
  reg [1:0] _zz_193_;
  reg [1:0] CsrPlugin_misa_base;
  reg [25:0] CsrPlugin_misa_extensions;
  reg [1:0] CsrPlugin_mtvec_mode;
  reg [29:0] CsrPlugin_mtvec_base;
  reg [31:0] CsrPlugin_mepc;
  reg  CsrPlugin_mstatus_MIE;
  reg  CsrPlugin_mstatus_MPIE;
  reg [1:0] CsrPlugin_mstatus_MPP;
  reg  CsrPlugin_mip_MEIP;
  reg  CsrPlugin_mip_MTIP;
  reg  CsrPlugin_mip_MSIP;
  reg  CsrPlugin_mie_MEIE;
  reg  CsrPlugin_mie_MTIE;
  reg  CsrPlugin_mie_MSIE;
  reg [31:0] CsrPlugin_mscratch;
  reg  CsrPlugin_mcause_interrupt;
  reg [3:0] CsrPlugin_mcause_exceptionCode;
  reg [31:0] CsrPlugin_mtval;
  reg [63:0] CsrPlugin_mcycle = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg [63:0] CsrPlugin_minstret = 64'b0000000000000000000000000000000000000000000000000000000000000000;
  reg  CsrPlugin_medeleg_IAM;
  reg  CsrPlugin_medeleg_IAF;
  reg  CsrPlugin_medeleg_II;
  reg  CsrPlugin_medeleg_LAM;
  reg  CsrPlugin_medeleg_LAF;
  reg  CsrPlugin_medeleg_SAM;
  reg  CsrPlugin_medeleg_SAF;
  reg  CsrPlugin_medeleg_EU;
  reg  CsrPlugin_medeleg_ES;
  reg  CsrPlugin_medeleg_IPF;
  reg  CsrPlugin_medeleg_LPF;
  reg  CsrPlugin_medeleg_SPF;
  reg  CsrPlugin_mideleg_ST;
  reg  CsrPlugin_mideleg_SE;
  reg  CsrPlugin_mideleg_SS;
  reg  CsrPlugin_sstatus_SIE;
  reg  CsrPlugin_sstatus_SPIE;
  reg [0:0] CsrPlugin_sstatus_SPP;
  reg  CsrPlugin_sip_SEIP_SOFT;
  reg  CsrPlugin_sip_SEIP_INPUT;
  wire  CsrPlugin_sip_SEIP_OR;
  reg  CsrPlugin_sip_STIP;
  reg  CsrPlugin_sip_SSIP;
  reg  CsrPlugin_sie_SEIE;
  reg  CsrPlugin_sie_STIE;
  reg  CsrPlugin_sie_SSIE;
  reg [1:0] CsrPlugin_stvec_mode;
  reg [29:0] CsrPlugin_stvec_base;
  reg [31:0] CsrPlugin_sscratch;
  reg  CsrPlugin_scause_interrupt;
  reg [3:0] CsrPlugin_scause_exceptionCode;
  reg [31:0] CsrPlugin_stval;
  reg [31:0] CsrPlugin_sepc;
  reg [21:0] CsrPlugin_satp_PPN;
  reg [8:0] CsrPlugin_satp_ASID;
  reg [0:0] CsrPlugin_satp_MODE;
  wire  _zz_194_;
  wire  _zz_195_;
  wire  _zz_196_;
  wire  _zz_197_;
  wire  _zz_198_;
  wire  _zz_199_;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  reg  CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  reg [3:0] CsrPlugin_exceptionPortCtrl_exceptionContext_code;
  reg [31:0] CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
  reg [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped;
  wire [1:0] CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
  wire [1:0] _zz_200_;
  wire  _zz_201_;
  wire [1:0] _zz_202_;
  wire  _zz_203_;
  reg  CsrPlugin_interrupt_valid;
  reg [3:0] CsrPlugin_interrupt_code /* verilator public */ ;
  reg [1:0] CsrPlugin_interrupt_targetPrivilege;
  wire  CsrPlugin_exception;
  reg  CsrPlugin_lastStageWasWfi;
  reg  CsrPlugin_pipelineLiberator_done;
  wire  CsrPlugin_interruptJump /* verilator public */ ;
  reg  CsrPlugin_hadException;
  reg [1:0] CsrPlugin_targetPrivilege;
  reg [3:0] CsrPlugin_trapCause;
  reg [1:0] CsrPlugin_xtvec_mode;
  reg [29:0] CsrPlugin_xtvec_base;
  reg  execute_CsrPlugin_inWfi /* verilator public */ ;
  reg  execute_CsrPlugin_wfiWake;
  wire  execute_CsrPlugin_blockedBySideEffects;
  reg  execute_CsrPlugin_illegalAccess;
  reg  execute_CsrPlugin_illegalInstruction;
  reg [31:0] execute_CsrPlugin_readData;
  wire  execute_CsrPlugin_writeInstruction;
  wire  execute_CsrPlugin_readInstruction;
  wire  execute_CsrPlugin_writeEnable;
  wire  execute_CsrPlugin_readEnable;
  reg [31:0] execute_CsrPlugin_readToWriteData;
  reg [31:0] execute_CsrPlugin_writeData;
  wire [11:0] execute_CsrPlugin_csrAddress;
  wire  execute_BranchPlugin_eq;
  wire [2:0] _zz_204_;
  reg  _zz_205_;
  reg  _zz_206_;
  wire  _zz_207_;
  reg [19:0] _zz_208_;
  wire  _zz_209_;
  reg [10:0] _zz_210_;
  wire  _zz_211_;
  reg [18:0] _zz_212_;
  reg  _zz_213_;
  wire  execute_BranchPlugin_missAlignedTarget;
  reg [31:0] execute_BranchPlugin_branch_src1;
  reg [31:0] execute_BranchPlugin_branch_src2;
  wire  _zz_214_;
  reg [19:0] _zz_215_;
  wire  _zz_216_;
  reg [10:0] _zz_217_;
  wire  _zz_218_;
  reg [18:0] _zz_219_;
  wire [31:0] execute_BranchPlugin_branchAdder;
  reg  MmuPlugin_status_sum;
  reg  MmuPlugin_status_mxr;
  reg  MmuPlugin_status_mprv;
  reg  MmuPlugin_satp_mode;
  reg [19:0] MmuPlugin_satp_ppn;
  reg  MmuPlugin_ports_0_cache_0_valid;
  reg  MmuPlugin_ports_0_cache_0_exception;
  reg  MmuPlugin_ports_0_cache_0_superPage;
  reg [9:0] MmuPlugin_ports_0_cache_0_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_0_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_0_cache_0_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_0_physicalAddress_1;
  reg  MmuPlugin_ports_0_cache_0_allowRead;
  reg  MmuPlugin_ports_0_cache_0_allowWrite;
  reg  MmuPlugin_ports_0_cache_0_allowExecute;
  reg  MmuPlugin_ports_0_cache_0_allowUser;
  reg  MmuPlugin_ports_0_cache_1_valid;
  reg  MmuPlugin_ports_0_cache_1_exception;
  reg  MmuPlugin_ports_0_cache_1_superPage;
  reg [9:0] MmuPlugin_ports_0_cache_1_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_1_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_0_cache_1_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_1_physicalAddress_1;
  reg  MmuPlugin_ports_0_cache_1_allowRead;
  reg  MmuPlugin_ports_0_cache_1_allowWrite;
  reg  MmuPlugin_ports_0_cache_1_allowExecute;
  reg  MmuPlugin_ports_0_cache_1_allowUser;
  reg  MmuPlugin_ports_0_cache_2_valid;
  reg  MmuPlugin_ports_0_cache_2_exception;
  reg  MmuPlugin_ports_0_cache_2_superPage;
  reg [9:0] MmuPlugin_ports_0_cache_2_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_2_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_0_cache_2_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_2_physicalAddress_1;
  reg  MmuPlugin_ports_0_cache_2_allowRead;
  reg  MmuPlugin_ports_0_cache_2_allowWrite;
  reg  MmuPlugin_ports_0_cache_2_allowExecute;
  reg  MmuPlugin_ports_0_cache_2_allowUser;
  reg  MmuPlugin_ports_0_cache_3_valid;
  reg  MmuPlugin_ports_0_cache_3_exception;
  reg  MmuPlugin_ports_0_cache_3_superPage;
  reg [9:0] MmuPlugin_ports_0_cache_3_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_3_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_0_cache_3_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_0_cache_3_physicalAddress_1;
  reg  MmuPlugin_ports_0_cache_3_allowRead;
  reg  MmuPlugin_ports_0_cache_3_allowWrite;
  reg  MmuPlugin_ports_0_cache_3_allowExecute;
  reg  MmuPlugin_ports_0_cache_3_allowUser;
  wire  MmuPlugin_ports_0_cacheHits_0;
  wire  MmuPlugin_ports_0_cacheHits_1;
  wire  MmuPlugin_ports_0_cacheHits_2;
  wire  MmuPlugin_ports_0_cacheHits_3;
  wire  MmuPlugin_ports_0_cacheHit;
  wire  _zz_220_;
  wire  _zz_221_;
  wire [1:0] _zz_222_;
  wire  MmuPlugin_ports_0_cacheLine_valid;
  wire  MmuPlugin_ports_0_cacheLine_exception;
  wire  MmuPlugin_ports_0_cacheLine_superPage;
  wire [9:0] MmuPlugin_ports_0_cacheLine_virtualAddress_0;
  wire [9:0] MmuPlugin_ports_0_cacheLine_virtualAddress_1;
  wire [9:0] MmuPlugin_ports_0_cacheLine_physicalAddress_0;
  wire [9:0] MmuPlugin_ports_0_cacheLine_physicalAddress_1;
  wire  MmuPlugin_ports_0_cacheLine_allowRead;
  wire  MmuPlugin_ports_0_cacheLine_allowWrite;
  wire  MmuPlugin_ports_0_cacheLine_allowExecute;
  wire  MmuPlugin_ports_0_cacheLine_allowUser;
  reg  MmuPlugin_ports_0_entryToReplace_willIncrement;
  wire  MmuPlugin_ports_0_entryToReplace_willClear;
  reg [1:0] MmuPlugin_ports_0_entryToReplace_valueNext;
  reg [1:0] MmuPlugin_ports_0_entryToReplace_value;
  wire  MmuPlugin_ports_0_entryToReplace_willOverflowIfInc;
  wire  MmuPlugin_ports_0_entryToReplace_willOverflow;
  reg  MmuPlugin_ports_0_requireMmuLockup;
  reg  MmuPlugin_ports_1_cache_0_valid;
  reg  MmuPlugin_ports_1_cache_0_exception;
  reg  MmuPlugin_ports_1_cache_0_superPage;
  reg [9:0] MmuPlugin_ports_1_cache_0_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_0_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_1_cache_0_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_0_physicalAddress_1;
  reg  MmuPlugin_ports_1_cache_0_allowRead;
  reg  MmuPlugin_ports_1_cache_0_allowWrite;
  reg  MmuPlugin_ports_1_cache_0_allowExecute;
  reg  MmuPlugin_ports_1_cache_0_allowUser;
  reg  MmuPlugin_ports_1_cache_1_valid;
  reg  MmuPlugin_ports_1_cache_1_exception;
  reg  MmuPlugin_ports_1_cache_1_superPage;
  reg [9:0] MmuPlugin_ports_1_cache_1_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_1_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_1_cache_1_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_1_physicalAddress_1;
  reg  MmuPlugin_ports_1_cache_1_allowRead;
  reg  MmuPlugin_ports_1_cache_1_allowWrite;
  reg  MmuPlugin_ports_1_cache_1_allowExecute;
  reg  MmuPlugin_ports_1_cache_1_allowUser;
  reg  MmuPlugin_ports_1_cache_2_valid;
  reg  MmuPlugin_ports_1_cache_2_exception;
  reg  MmuPlugin_ports_1_cache_2_superPage;
  reg [9:0] MmuPlugin_ports_1_cache_2_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_2_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_1_cache_2_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_2_physicalAddress_1;
  reg  MmuPlugin_ports_1_cache_2_allowRead;
  reg  MmuPlugin_ports_1_cache_2_allowWrite;
  reg  MmuPlugin_ports_1_cache_2_allowExecute;
  reg  MmuPlugin_ports_1_cache_2_allowUser;
  reg  MmuPlugin_ports_1_cache_3_valid;
  reg  MmuPlugin_ports_1_cache_3_exception;
  reg  MmuPlugin_ports_1_cache_3_superPage;
  reg [9:0] MmuPlugin_ports_1_cache_3_virtualAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_3_virtualAddress_1;
  reg [9:0] MmuPlugin_ports_1_cache_3_physicalAddress_0;
  reg [9:0] MmuPlugin_ports_1_cache_3_physicalAddress_1;
  reg  MmuPlugin_ports_1_cache_3_allowRead;
  reg  MmuPlugin_ports_1_cache_3_allowWrite;
  reg  MmuPlugin_ports_1_cache_3_allowExecute;
  reg  MmuPlugin_ports_1_cache_3_allowUser;
  wire  MmuPlugin_ports_1_cacheHits_0;
  wire  MmuPlugin_ports_1_cacheHits_1;
  wire  MmuPlugin_ports_1_cacheHits_2;
  wire  MmuPlugin_ports_1_cacheHits_3;
  wire  MmuPlugin_ports_1_cacheHit;
  wire  _zz_223_;
  wire  _zz_224_;
  wire [1:0] _zz_225_;
  wire  MmuPlugin_ports_1_cacheLine_valid;
  wire  MmuPlugin_ports_1_cacheLine_exception;
  wire  MmuPlugin_ports_1_cacheLine_superPage;
  wire [9:0] MmuPlugin_ports_1_cacheLine_virtualAddress_0;
  wire [9:0] MmuPlugin_ports_1_cacheLine_virtualAddress_1;
  wire [9:0] MmuPlugin_ports_1_cacheLine_physicalAddress_0;
  wire [9:0] MmuPlugin_ports_1_cacheLine_physicalAddress_1;
  wire  MmuPlugin_ports_1_cacheLine_allowRead;
  wire  MmuPlugin_ports_1_cacheLine_allowWrite;
  wire  MmuPlugin_ports_1_cacheLine_allowExecute;
  wire  MmuPlugin_ports_1_cacheLine_allowUser;
  reg  MmuPlugin_ports_1_entryToReplace_willIncrement;
  wire  MmuPlugin_ports_1_entryToReplace_willClear;
  reg [1:0] MmuPlugin_ports_1_entryToReplace_valueNext;
  reg [1:0] MmuPlugin_ports_1_entryToReplace_value;
  wire  MmuPlugin_ports_1_entryToReplace_willOverflowIfInc;
  wire  MmuPlugin_ports_1_entryToReplace_willOverflow;
  reg  MmuPlugin_ports_1_requireMmuLockup;
  reg `MmuPlugin_shared_State_defaultEncoding_type MmuPlugin_shared_state_1_;
  reg [9:0] MmuPlugin_shared_vpn_0;
  reg [9:0] MmuPlugin_shared_vpn_1;
  reg [0:0] MmuPlugin_shared_portId;
  wire  MmuPlugin_shared_dBusRsp_pte_V;
  wire  MmuPlugin_shared_dBusRsp_pte_R;
  wire  MmuPlugin_shared_dBusRsp_pte_W;
  wire  MmuPlugin_shared_dBusRsp_pte_X;
  wire  MmuPlugin_shared_dBusRsp_pte_U;
  wire  MmuPlugin_shared_dBusRsp_pte_G;
  wire  MmuPlugin_shared_dBusRsp_pte_A;
  wire  MmuPlugin_shared_dBusRsp_pte_D;
  wire [1:0] MmuPlugin_shared_dBusRsp_pte_RSW;
  wire [9:0] MmuPlugin_shared_dBusRsp_pte_PPN0;
  wire [11:0] MmuPlugin_shared_dBusRsp_pte_PPN1;
  wire  MmuPlugin_shared_dBusRsp_exception;
  wire  MmuPlugin_shared_dBusRsp_leaf;
  reg  MmuPlugin_shared_pteBuffer_V;
  reg  MmuPlugin_shared_pteBuffer_R;
  reg  MmuPlugin_shared_pteBuffer_W;
  reg  MmuPlugin_shared_pteBuffer_X;
  reg  MmuPlugin_shared_pteBuffer_U;
  reg  MmuPlugin_shared_pteBuffer_G;
  reg  MmuPlugin_shared_pteBuffer_A;
  reg  MmuPlugin_shared_pteBuffer_D;
  reg [1:0] MmuPlugin_shared_pteBuffer_RSW;
  reg [9:0] MmuPlugin_shared_pteBuffer_PPN0;
  reg [11:0] MmuPlugin_shared_pteBuffer_PPN1;
  reg [31:0] externalInterruptArray_regNext;
  reg [31:0] _zz_226_;
  wire [31:0] _zz_227_;
  reg [31:0] _zz_228_;
  wire [31:0] _zz_229_;
  reg  decode_to_execute_IS_RS1_SIGNED;
  reg `Src2CtrlEnum_defaultEncoding_type decode_to_execute_SRC2_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type decode_to_execute_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type execute_to_memory_ENV_CTRL;
  reg `EnvCtrlEnum_defaultEncoding_type memory_to_writeBack_ENV_CTRL;
  reg [33:0] execute_to_memory_MUL_HH;
  reg [33:0] memory_to_writeBack_MUL_HH;
  reg  decode_to_execute_SRC_LESS_UNSIGNED;
  reg  decode_to_execute_MEMORY_MANAGMENT;
  reg [51:0] memory_to_writeBack_MUL_LOW;
  reg [31:0] decode_to_execute_PC;
  reg [31:0] execute_to_memory_PC;
  reg [31:0] memory_to_writeBack_PC;
  reg  decode_to_execute_MEMORY_ENABLE;
  reg  execute_to_memory_MEMORY_ENABLE;
  reg  memory_to_writeBack_MEMORY_ENABLE;
  reg  decode_to_execute_IS_MUL;
  reg  execute_to_memory_IS_MUL;
  reg  memory_to_writeBack_IS_MUL;
  reg [33:0] execute_to_memory_MUL_HL;
  reg  decode_to_execute_IS_SFENCE_VMA;
  reg  execute_to_memory_IS_SFENCE_VMA;
  reg  memory_to_writeBack_IS_SFENCE_VMA;
  reg  decode_to_execute_MEMORY_AMO;
  reg  decode_to_execute_CSR_READ_OPCODE;
  reg  decode_to_execute_IS_RS2_SIGNED;
  reg `ShiftCtrlEnum_defaultEncoding_type decode_to_execute_SHIFT_CTRL;
  reg [31:0] decode_to_execute_RS2;
  reg [33:0] execute_to_memory_MUL_LH;
  reg `BranchCtrlEnum_defaultEncoding_type decode_to_execute_BRANCH_CTRL;
  reg  decode_to_execute_MEMORY_LRSC;
  reg  decode_to_execute_REGFILE_WRITE_VALID;
  reg  execute_to_memory_REGFILE_WRITE_VALID;
  reg  memory_to_writeBack_REGFILE_WRITE_VALID;
  reg  execute_to_memory_IS_DBUS_SHARING;
  reg  memory_to_writeBack_IS_DBUS_SHARING;
  reg `AluBitwiseCtrlEnum_defaultEncoding_type decode_to_execute_ALU_BITWISE_CTRL;
  reg [1:0] execute_to_memory_MEMORY_ADDRESS_LOW;
  reg [1:0] memory_to_writeBack_MEMORY_ADDRESS_LOW;
  reg [31:0] execute_to_memory_REGFILE_WRITE_DATA;
  reg [31:0] memory_to_writeBack_REGFILE_WRITE_DATA;
  reg `AluCtrlEnum_defaultEncoding_type decode_to_execute_ALU_CTRL;
  reg  decode_to_execute_SRC2_FORCE_ZERO;
  reg [31:0] decode_to_execute_FORMAL_PC_NEXT;
  reg [31:0] execute_to_memory_FORMAL_PC_NEXT;
  reg [31:0] memory_to_writeBack_FORMAL_PC_NEXT;
  reg  decode_to_execute_MEMORY_WR;
  reg  execute_to_memory_MEMORY_WR;
  reg  memory_to_writeBack_MEMORY_WR;
  reg  decode_to_execute_IS_CSR;
  reg  decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  reg  decode_to_execute_IS_DIV;
  reg  execute_to_memory_IS_DIV;
  reg [31:0] decode_to_execute_INSTRUCTION;
  reg [31:0] execute_to_memory_INSTRUCTION;
  reg [31:0] memory_to_writeBack_INSTRUCTION;
  reg [31:0] execute_to_memory_MUL_LL;
  reg  decode_to_execute_PREDICTION_HAD_BRANCHED2;
  reg  decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  reg  execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  reg `Src1CtrlEnum_defaultEncoding_type decode_to_execute_SRC1_CTRL;
  reg [31:0] decode_to_execute_RS1;
  reg  decode_to_execute_CSR_WRITE_OPCODE;
  reg  decode_to_execute_SRC_USE_SUB_LESS;
  reg [2:0] _zz_230_;
  reg  _zz_231_;
  reg [31:0] iBusWishbone_DAT_MISO_regNext;
  reg [2:0] _zz_232_;
  wire  _zz_233_;
  wire  _zz_234_;
  wire  _zz_235_;
  wire  _zz_236_;
  wire  _zz_237_;
  reg  _zz_238_;
  reg [31:0] dBusWishbone_DAT_MISO_regNext;
  `ifndef SYNTHESIS
  reg [95:0] decode_SRC1_CTRL_string;
  reg [95:0] _zz_1__string;
  reg [95:0] _zz_2__string;
  reg [95:0] _zz_3__string;
  reg [63:0] decode_ALU_CTRL_string;
  reg [63:0] _zz_4__string;
  reg [63:0] _zz_5__string;
  reg [63:0] _zz_6__string;
  reg [39:0] decode_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_7__string;
  reg [39:0] _zz_8__string;
  reg [39:0] _zz_9__string;
  reg [31:0] _zz_10__string;
  reg [31:0] _zz_11__string;
  reg [71:0] decode_SHIFT_CTRL_string;
  reg [71:0] _zz_12__string;
  reg [71:0] _zz_13__string;
  reg [71:0] _zz_14__string;
  reg [47:0] _zz_15__string;
  reg [47:0] _zz_16__string;
  reg [47:0] _zz_17__string;
  reg [47:0] _zz_18__string;
  reg [47:0] decode_ENV_CTRL_string;
  reg [47:0] _zz_19__string;
  reg [47:0] _zz_20__string;
  reg [47:0] _zz_21__string;
  reg [23:0] decode_SRC2_CTRL_string;
  reg [23:0] _zz_22__string;
  reg [23:0] _zz_23__string;
  reg [23:0] _zz_24__string;
  reg [31:0] execute_BRANCH_CTRL_string;
  reg [31:0] _zz_27__string;
  reg [47:0] memory_ENV_CTRL_string;
  reg [47:0] _zz_30__string;
  reg [47:0] execute_ENV_CTRL_string;
  reg [47:0] _zz_31__string;
  reg [47:0] writeBack_ENV_CTRL_string;
  reg [47:0] _zz_34__string;
  reg [71:0] execute_SHIFT_CTRL_string;
  reg [71:0] _zz_43__string;
  reg [23:0] execute_SRC2_CTRL_string;
  reg [23:0] _zz_48__string;
  reg [95:0] execute_SRC1_CTRL_string;
  reg [95:0] _zz_50__string;
  reg [63:0] execute_ALU_CTRL_string;
  reg [63:0] _zz_53__string;
  reg [39:0] execute_ALU_BITWISE_CTRL_string;
  reg [39:0] _zz_55__string;
  reg [71:0] _zz_62__string;
  reg [95:0] _zz_66__string;
  reg [23:0] _zz_67__string;
  reg [47:0] _zz_70__string;
  reg [63:0] _zz_83__string;
  reg [31:0] _zz_85__string;
  reg [39:0] _zz_86__string;
  reg [31:0] decode_BRANCH_CTRL_string;
  reg [31:0] _zz_96__string;
  reg [39:0] _zz_157__string;
  reg [31:0] _zz_158__string;
  reg [63:0] _zz_159__string;
  reg [47:0] _zz_160__string;
  reg [23:0] _zz_161__string;
  reg [95:0] _zz_162__string;
  reg [71:0] _zz_163__string;
  reg [47:0] MmuPlugin_shared_state_1__string;
  reg [23:0] decode_to_execute_SRC2_CTRL_string;
  reg [47:0] decode_to_execute_ENV_CTRL_string;
  reg [47:0] execute_to_memory_ENV_CTRL_string;
  reg [47:0] memory_to_writeBack_ENV_CTRL_string;
  reg [71:0] decode_to_execute_SHIFT_CTRL_string;
  reg [31:0] decode_to_execute_BRANCH_CTRL_string;
  reg [39:0] decode_to_execute_ALU_BITWISE_CTRL_string;
  reg [63:0] decode_to_execute_ALU_CTRL_string;
  reg [95:0] decode_to_execute_SRC1_CTRL_string;
  `endif

  (* ram_style = "block" *) reg [31:0] RegFilePlugin_regFile [0:31] /* verilator public */ ;
  assign _zz_290_ = (memory_arbitration_isValid && memory_IS_DIV);
  assign _zz_291_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_292_ = 1'b1;
  assign _zz_293_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_294_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_295_ = (execute_arbitration_isValid && execute_IS_CSR);
  assign _zz_296_ = ((_zz_244_ && IBusCachedPlugin_cache_io_cpu_decode_error) && (! _zz_92_));
  assign _zz_297_ = ((_zz_244_ && IBusCachedPlugin_cache_io_cpu_decode_cacheMiss) && (! _zz_93_));
  assign _zz_298_ = ((_zz_244_ && IBusCachedPlugin_cache_io_cpu_decode_mmuException) && (! _zz_94_));
  assign _zz_299_ = ((_zz_244_ && IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling) && (! 1'b0));
  assign _zz_300_ = ({decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid} != (2'b00));
  assign _zz_301_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_WFI));
  assign _zz_302_ = ({BranchPlugin_branchExceptionPort_valid,CsrPlugin_selfException_valid} != (2'b00));
  assign _zz_303_ = (! memory_DivPlugin_div_done);
  assign _zz_304_ = (CsrPlugin_hadException || CsrPlugin_interruptJump);
  assign _zz_305_ = (writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET));
  assign _zz_306_ = writeBack_INSTRUCTION[29 : 28];
  assign _zz_307_ = (! IBusCachedPlugin_iBusRsp_readyForError);
  assign _zz_308_ = (! ({(writeBack_arbitration_isValid || CsrPlugin_exceptionPendings_3),{(memory_arbitration_isValid || CsrPlugin_exceptionPendings_2),(execute_arbitration_isValid || CsrPlugin_exceptionPendings_1)}} != (3'b000)));
  assign _zz_309_ = (! dataCache_1__io_cpu_redo);
  assign _zz_310_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
  assign _zz_311_ = (writeBack_arbitration_isValid && writeBack_REGFILE_WRITE_VALID);
  assign _zz_312_ = (1'b0 || (! 1'b1));
  assign _zz_313_ = (memory_arbitration_isValid && memory_REGFILE_WRITE_VALID);
  assign _zz_314_ = (1'b0 || (! memory_BYPASSABLE_MEMORY_STAGE));
  assign _zz_315_ = (execute_arbitration_isValid && execute_REGFILE_WRITE_VALID);
  assign _zz_316_ = (1'b0 || (! execute_BYPASSABLE_EXECUTE_STAGE));
  assign _zz_317_ = execute_INSTRUCTION[13 : 12];
  assign _zz_318_ = (! memory_arbitration_isStuck);
  assign _zz_319_ = (execute_CsrPlugin_illegalAccess || execute_CsrPlugin_illegalInstruction);
  assign _zz_320_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_ECALL));
  assign _zz_321_ = (execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_EBREAK));
  assign _zz_322_ = ((MmuPlugin_dBusAccess_rsp_valid && (! MmuPlugin_dBusAccess_rsp_payload_redo)) && (MmuPlugin_shared_dBusRsp_leaf || MmuPlugin_shared_dBusRsp_exception));
  assign _zz_323_ = (MmuPlugin_shared_portId == (1'b1));
  assign _zz_324_ = (MmuPlugin_shared_portId == (1'b0));
  assign _zz_325_ = (iBus_cmd_valid || (_zz_230_ != (3'b000)));
  assign _zz_326_ = (_zz_264_ && (! dataCache_1__io_mem_cmd_s2mPipe_ready));
  assign _zz_327_ = ((CsrPlugin_sstatus_SIE && (CsrPlugin_privilege == (2'b01))) || (CsrPlugin_privilege < (2'b01)));
  assign _zz_328_ = ((_zz_194_ && (1'b1 && CsrPlugin_mideleg_ST)) && (! 1'b0));
  assign _zz_329_ = ((_zz_195_ && (1'b1 && CsrPlugin_mideleg_SS)) && (! 1'b0));
  assign _zz_330_ = ((_zz_196_ && (1'b1 && CsrPlugin_mideleg_SE)) && (! 1'b0));
  assign _zz_331_ = (CsrPlugin_mstatus_MIE || (CsrPlugin_privilege < (2'b11)));
  assign _zz_332_ = ((_zz_194_ && 1'b1) && (! (CsrPlugin_mideleg_ST != (1'b0))));
  assign _zz_333_ = ((_zz_195_ && 1'b1) && (! (CsrPlugin_mideleg_SS != (1'b0))));
  assign _zz_334_ = ((_zz_196_ && 1'b1) && (! (CsrPlugin_mideleg_SE != (1'b0))));
  assign _zz_335_ = ((_zz_197_ && 1'b1) && (! 1'b0));
  assign _zz_336_ = ((_zz_198_ && 1'b1) && (! 1'b0));
  assign _zz_337_ = ((_zz_199_ && 1'b1) && (! 1'b0));
  assign _zz_338_ = (IBusCachedPlugin_mmuBus_cmd_isValid && IBusCachedPlugin_mmuBus_rsp_refilling);
  assign _zz_339_ = (DBusCachedPlugin_mmuBus_cmd_isValid && DBusCachedPlugin_mmuBus_rsp_refilling);
  assign _zz_340_ = (MmuPlugin_ports_0_entryToReplace_value == (2'b00));
  assign _zz_341_ = (MmuPlugin_ports_0_entryToReplace_value == (2'b01));
  assign _zz_342_ = (MmuPlugin_ports_0_entryToReplace_value == (2'b10));
  assign _zz_343_ = (MmuPlugin_ports_0_entryToReplace_value == (2'b11));
  assign _zz_344_ = (MmuPlugin_ports_1_entryToReplace_value == (2'b00));
  assign _zz_345_ = (MmuPlugin_ports_1_entryToReplace_value == (2'b01));
  assign _zz_346_ = (MmuPlugin_ports_1_entryToReplace_value == (2'b10));
  assign _zz_347_ = (MmuPlugin_ports_1_entryToReplace_value == (2'b11));
  assign _zz_348_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_349_ = writeBack_INSTRUCTION[13 : 12];
  assign _zz_350_ = execute_INSTRUCTION[13];
  assign _zz_351_ = (_zz_102_ - (5'b00001));
  assign _zz_352_ = {IBusCachedPlugin_fetchPc_inc,(2'b00)};
  assign _zz_353_ = {29'd0, _zz_352_};
  assign _zz_354_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_355_ = {{_zz_118_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_356_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_357_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_358_ = {{_zz_120_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_359_ = {{_zz_122_,{{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_360_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]};
  assign _zz_361_ = {{{decode_INSTRUCTION[31],decode_INSTRUCTION[7]},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]};
  assign _zz_362_ = (writeBack_MEMORY_WR ? (3'b111) : (3'b101));
  assign _zz_363_ = (writeBack_MEMORY_WR ? (3'b110) : (3'b100));
  assign _zz_364_ = _zz_149_[0 : 0];
  assign _zz_365_ = _zz_149_[5 : 5];
  assign _zz_366_ = _zz_149_[8 : 8];
  assign _zz_367_ = _zz_149_[9 : 9];
  assign _zz_368_ = _zz_149_[10 : 10];
  assign _zz_369_ = _zz_149_[11 : 11];
  assign _zz_370_ = _zz_149_[12 : 12];
  assign _zz_371_ = _zz_149_[13 : 13];
  assign _zz_372_ = _zz_149_[14 : 14];
  assign _zz_373_ = _zz_149_[15 : 15];
  assign _zz_374_ = _zz_149_[16 : 16];
  assign _zz_375_ = _zz_149_[17 : 17];
  assign _zz_376_ = _zz_149_[18 : 18];
  assign _zz_377_ = _zz_149_[19 : 19];
  assign _zz_378_ = _zz_149_[23 : 23];
  assign _zz_379_ = _zz_149_[25 : 25];
  assign _zz_380_ = _zz_149_[30 : 30];
  assign _zz_381_ = _zz_149_[31 : 31];
  assign _zz_382_ = _zz_149_[32 : 32];
  assign _zz_383_ = _zz_149_[35 : 35];
  assign _zz_384_ = execute_SRC_LESS;
  assign _zz_385_ = (3'b100);
  assign _zz_386_ = execute_INSTRUCTION[19 : 15];
  assign _zz_387_ = execute_INSTRUCTION[31 : 20];
  assign _zz_388_ = {execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]};
  assign _zz_389_ = ($signed(_zz_390_) + $signed(_zz_393_));
  assign _zz_390_ = ($signed(_zz_391_) + $signed(_zz_392_));
  assign _zz_391_ = execute_SRC1;
  assign _zz_392_ = (execute_SRC_USE_SUB_LESS ? (~ execute_SRC2) : execute_SRC2);
  assign _zz_393_ = (execute_SRC_USE_SUB_LESS ? _zz_394_ : _zz_395_);
  assign _zz_394_ = (32'b00000000000000000000000000000001);
  assign _zz_395_ = (32'b00000000000000000000000000000000);
  assign _zz_396_ = ($signed(_zz_398_) >>> execute_FullBarrelShifterPlugin_amplitude);
  assign _zz_397_ = _zz_396_[31 : 0];
  assign _zz_398_ = {((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SRA_1) && execute_FullBarrelShifterPlugin_reversed[31]),execute_FullBarrelShifterPlugin_reversed};
  assign _zz_399_ = ($signed(_zz_400_) + $signed(_zz_405_));
  assign _zz_400_ = ($signed(_zz_401_) + $signed(_zz_403_));
  assign _zz_401_ = (52'b0000000000000000000000000000000000000000000000000000);
  assign _zz_402_ = {1'b0,memory_MUL_LL};
  assign _zz_403_ = {{19{_zz_402_[32]}}, _zz_402_};
  assign _zz_404_ = ({16'd0,memory_MUL_LH} <<< 16);
  assign _zz_405_ = {{2{_zz_404_[49]}}, _zz_404_};
  assign _zz_406_ = ({16'd0,memory_MUL_HL} <<< 16);
  assign _zz_407_ = {{2{_zz_406_[49]}}, _zz_406_};
  assign _zz_408_ = {{14{writeBack_MUL_LOW[51]}}, writeBack_MUL_LOW};
  assign _zz_409_ = ({32'd0,writeBack_MUL_HH} <<< 32);
  assign _zz_410_ = writeBack_MUL_LOW[31 : 0];
  assign _zz_411_ = writeBack_MulPlugin_result[63 : 32];
  assign _zz_412_ = memory_DivPlugin_div_counter_willIncrement;
  assign _zz_413_ = {5'd0, _zz_412_};
  assign _zz_414_ = {1'd0, memory_DivPlugin_rs2};
  assign _zz_415_ = {_zz_186_,(! _zz_188_[32])};
  assign _zz_416_ = _zz_188_[31:0];
  assign _zz_417_ = _zz_187_[31:0];
  assign _zz_418_ = _zz_419_;
  assign _zz_419_ = _zz_420_;
  assign _zz_420_ = ({1'b0,(memory_DivPlugin_div_needRevert ? (~ _zz_189_) : _zz_189_)} + _zz_422_);
  assign _zz_421_ = memory_DivPlugin_div_needRevert;
  assign _zz_422_ = {32'd0, _zz_421_};
  assign _zz_423_ = _zz_191_;
  assign _zz_424_ = {32'd0, _zz_423_};
  assign _zz_425_ = _zz_190_;
  assign _zz_426_ = {31'd0, _zz_425_};
  assign _zz_427_ = (_zz_200_ & (~ _zz_428_));
  assign _zz_428_ = (_zz_200_ - (2'b01));
  assign _zz_429_ = (_zz_202_ & (~ _zz_430_));
  assign _zz_430_ = (_zz_202_ - (2'b01));
  assign _zz_431_ = execute_INSTRUCTION[31 : 20];
  assign _zz_432_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_433_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_434_ = {_zz_208_,execute_INSTRUCTION[31 : 20]};
  assign _zz_435_ = {{_zz_210_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0};
  assign _zz_436_ = {{_zz_212_,{{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0};
  assign _zz_437_ = execute_INSTRUCTION[31 : 20];
  assign _zz_438_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]};
  assign _zz_439_ = {{{execute_INSTRUCTION[31],execute_INSTRUCTION[7]},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]};
  assign _zz_440_ = (3'b100);
  assign _zz_441_ = MmuPlugin_ports_0_entryToReplace_willIncrement;
  assign _zz_442_ = {1'd0, _zz_441_};
  assign _zz_443_ = MmuPlugin_ports_1_entryToReplace_willIncrement;
  assign _zz_444_ = {1'd0, _zz_443_};
  assign _zz_445_ = MmuPlugin_dBusAccess_rsp_payload_data[0 : 0];
  assign _zz_446_ = MmuPlugin_dBusAccess_rsp_payload_data[1 : 1];
  assign _zz_447_ = MmuPlugin_dBusAccess_rsp_payload_data[2 : 2];
  assign _zz_448_ = MmuPlugin_dBusAccess_rsp_payload_data[3 : 3];
  assign _zz_449_ = MmuPlugin_dBusAccess_rsp_payload_data[4 : 4];
  assign _zz_450_ = MmuPlugin_dBusAccess_rsp_payload_data[5 : 5];
  assign _zz_451_ = MmuPlugin_dBusAccess_rsp_payload_data[6 : 6];
  assign _zz_452_ = MmuPlugin_dBusAccess_rsp_payload_data[7 : 7];
  assign _zz_453_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_454_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_455_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_456_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_457_ = execute_CsrPlugin_writeData[19 : 19];
  assign _zz_458_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_459_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_460_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_461_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_462_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_463_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_464_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_465_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_466_ = execute_CsrPlugin_writeData[19 : 19];
  assign _zz_467_ = execute_CsrPlugin_writeData[18 : 18];
  assign _zz_468_ = execute_CsrPlugin_writeData[17 : 17];
  assign _zz_469_ = execute_CsrPlugin_writeData[8 : 8];
  assign _zz_470_ = execute_CsrPlugin_writeData[2 : 2];
  assign _zz_471_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_472_ = execute_CsrPlugin_writeData[13 : 13];
  assign _zz_473_ = execute_CsrPlugin_writeData[4 : 4];
  assign _zz_474_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_475_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_476_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_477_ = execute_CsrPlugin_writeData[12 : 12];
  assign _zz_478_ = execute_CsrPlugin_writeData[15 : 15];
  assign _zz_479_ = execute_CsrPlugin_writeData[6 : 6];
  assign _zz_480_ = execute_CsrPlugin_writeData[0 : 0];
  assign _zz_481_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_482_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_483_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_484_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_485_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_486_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_487_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_488_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_489_ = execute_CsrPlugin_writeData[11 : 11];
  assign _zz_490_ = execute_CsrPlugin_writeData[7 : 7];
  assign _zz_491_ = execute_CsrPlugin_writeData[3 : 3];
  assign _zz_492_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_493_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_494_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_495_ = execute_CsrPlugin_writeData[31 : 31];
  assign _zz_496_ = execute_CsrPlugin_writeData[9 : 9];
  assign _zz_497_ = execute_CsrPlugin_writeData[5 : 5];
  assign _zz_498_ = execute_CsrPlugin_writeData[1 : 1];
  assign _zz_499_ = (iBus_cmd_payload_address >>> 5);
  assign _zz_500_ = 1'b1;
  assign _zz_501_ = 1'b1;
  assign _zz_502_ = {_zz_105_,{_zz_107_,_zz_106_}};
  assign _zz_503_ = decode_INSTRUCTION[31];
  assign _zz_504_ = decode_INSTRUCTION[31];
  assign _zz_505_ = decode_INSTRUCTION[7];
  assign _zz_506_ = ((decode_INSTRUCTION & (32'b00000000000000000111000000110100)) == (32'b00000000000000000101000000010000));
  assign _zz_507_ = ((decode_INSTRUCTION & (32'b00000010000000000111000001100100)) == (32'b00000000000000000101000000100000));
  assign _zz_508_ = ((decode_INSTRUCTION & _zz_515_) == (32'b01000000000000000001000000010000));
  assign _zz_509_ = {(_zz_516_ == _zz_517_),(_zz_518_ == _zz_519_)};
  assign _zz_510_ = ((decode_INSTRUCTION & _zz_520_) == (32'b00000010000000000100000000100000));
  assign _zz_511_ = (1'b0);
  assign _zz_512_ = ({_zz_153_,_zz_521_} != (2'b00));
  assign _zz_513_ = (_zz_522_ != (1'b0));
  assign _zz_514_ = {(_zz_523_ != _zz_524_),{_zz_525_,{_zz_526_,_zz_527_}}};
  assign _zz_515_ = (32'b01000000000000000011000001010100);
  assign _zz_516_ = (decode_INSTRUCTION & (32'b00000000000000000111000000110100));
  assign _zz_517_ = (32'b00000000000000000001000000010000);
  assign _zz_518_ = (decode_INSTRUCTION & (32'b00000010000000000111000001010100));
  assign _zz_519_ = (32'b00000000000000000001000000010000);
  assign _zz_520_ = (32'b00000010000000000100000001100100);
  assign _zz_521_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000000000000));
  assign _zz_522_ = ((decode_INSTRUCTION & (32'b00000010000000000100000001110100)) == (32'b00000010000000000000000000110000));
  assign _zz_523_ = {_zz_150_,{_zz_156_,_zz_528_}};
  assign _zz_524_ = (3'b000);
  assign _zz_525_ = ({_zz_156_,_zz_529_} != (2'b00));
  assign _zz_526_ = ({_zz_530_,_zz_531_} != (2'b00));
  assign _zz_527_ = {(_zz_532_ != _zz_533_),{_zz_534_,{_zz_535_,_zz_536_}}};
  assign _zz_528_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000010100)) == (32'b00000000000000000000000000000100));
  assign _zz_529_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001001100)) == (32'b00000000000000000000000000000100));
  assign _zz_530_ = _zz_155_;
  assign _zz_531_ = ((decode_INSTRUCTION & _zz_537_) == (32'b00000000000000000000000000100000));
  assign _zz_532_ = {_zz_155_,(_zz_538_ == _zz_539_)};
  assign _zz_533_ = (2'b00);
  assign _zz_534_ = ({_zz_540_,{_zz_541_,_zz_542_}} != (3'b000));
  assign _zz_535_ = ({_zz_543_,_zz_544_} != (6'b000000));
  assign _zz_536_ = {(_zz_545_ != _zz_546_),{_zz_547_,{_zz_548_,_zz_549_}}};
  assign _zz_537_ = (32'b00000000000000000000000001110000);
  assign _zz_538_ = (decode_INSTRUCTION & (32'b00000000000000000000000000100000));
  assign _zz_539_ = (32'b00000000000000000000000000000000);
  assign _zz_540_ = ((decode_INSTRUCTION & _zz_550_) == (32'b00000000000000000000000001000000));
  assign _zz_541_ = (_zz_551_ == _zz_552_);
  assign _zz_542_ = (_zz_553_ == _zz_554_);
  assign _zz_543_ = (_zz_555_ == _zz_556_);
  assign _zz_544_ = {_zz_557_,{_zz_558_,_zz_559_}};
  assign _zz_545_ = (_zz_560_ == _zz_561_);
  assign _zz_546_ = (1'b0);
  assign _zz_547_ = (_zz_562_ != (1'b0));
  assign _zz_548_ = (_zz_563_ != _zz_564_);
  assign _zz_549_ = {_zz_565_,{_zz_566_,_zz_567_}};
  assign _zz_550_ = (32'b00000000000000000000000001000100);
  assign _zz_551_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010100));
  assign _zz_552_ = (32'b00000000000000000010000000010000);
  assign _zz_553_ = (decode_INSTRUCTION & (32'b01000000000000000000000000110100));
  assign _zz_554_ = (32'b01000000000000000000000000110000);
  assign _zz_555_ = (decode_INSTRUCTION & (32'b00000000000000000010000001000000));
  assign _zz_556_ = (32'b00000000000000000010000001000000);
  assign _zz_557_ = ((decode_INSTRUCTION & _zz_568_) == (32'b00000000000000000001000001000000));
  assign _zz_558_ = (_zz_569_ == _zz_570_);
  assign _zz_559_ = {_zz_571_,{_zz_572_,_zz_573_}};
  assign _zz_560_ = (decode_INSTRUCTION & (32'b00010000000000000000000000001000));
  assign _zz_561_ = (32'b00000000000000000000000000001000);
  assign _zz_562_ = ((decode_INSTRUCTION & _zz_574_) == (32'b00000000000100000000000001010000));
  assign _zz_563_ = {_zz_575_,_zz_576_};
  assign _zz_564_ = (2'b00);
  assign _zz_565_ = (_zz_577_ != (1'b0));
  assign _zz_566_ = (_zz_578_ != _zz_579_);
  assign _zz_567_ = {_zz_580_,{_zz_581_,_zz_582_}};
  assign _zz_568_ = (32'b00000000000000000001000001000000);
  assign _zz_569_ = (decode_INSTRUCTION & (32'b00000000000000000000000001010000));
  assign _zz_570_ = (32'b00000000000000000000000001000000);
  assign _zz_571_ = ((decode_INSTRUCTION & _zz_583_) == (32'b00000000000000000000000001000000));
  assign _zz_572_ = (_zz_584_ == _zz_585_);
  assign _zz_573_ = (_zz_586_ == _zz_587_);
  assign _zz_574_ = (32'b00010000000100000011000001010000);
  assign _zz_575_ = ((decode_INSTRUCTION & _zz_588_) == (32'b00000000000000000000000001010000));
  assign _zz_576_ = ((decode_INSTRUCTION & _zz_589_) == (32'b00010000000000000000000001010000));
  assign _zz_577_ = ((decode_INSTRUCTION & _zz_590_) == (32'b00000000000000000000000001010000));
  assign _zz_578_ = {_zz_591_,_zz_592_};
  assign _zz_579_ = (2'b00);
  assign _zz_580_ = (_zz_154_ != (1'b0));
  assign _zz_581_ = (_zz_593_ != _zz_594_);
  assign _zz_582_ = {_zz_595_,{_zz_596_,_zz_597_}};
  assign _zz_583_ = (32'b00000010010000000000000001000000);
  assign _zz_584_ = (decode_INSTRUCTION & (32'b00000000000000000000000000111000));
  assign _zz_585_ = (32'b00000000000000000000000000000000);
  assign _zz_586_ = (decode_INSTRUCTION & (32'b00011000000000000010000000001000));
  assign _zz_587_ = (32'b00010000000000000010000000001000);
  assign _zz_588_ = (32'b00010000000100000011000001010000);
  assign _zz_589_ = (32'b00010010001000000011000001010000);
  assign _zz_590_ = (32'b00000010000100000011000001010000);
  assign _zz_591_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000010000)) == (32'b00000000000000000010000000000000));
  assign _zz_592_ = ((decode_INSTRUCTION & (32'b00000000000000000101000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_593_ = ((decode_INSTRUCTION & _zz_598_) == (32'b00000000000000000100000000001000));
  assign _zz_594_ = (1'b0);
  assign _zz_595_ = ({_zz_599_,{_zz_600_,_zz_601_}} != (5'b00000));
  assign _zz_596_ = (_zz_602_ != (1'b0));
  assign _zz_597_ = {(_zz_603_ != _zz_604_),{_zz_605_,{_zz_606_,_zz_607_}}};
  assign _zz_598_ = (32'b00000000000000000100000001001000);
  assign _zz_599_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001000000)) == (32'b00000000000000000000000001000000));
  assign _zz_600_ = ((decode_INSTRUCTION & _zz_608_) == (32'b00000000000000000100000000100000));
  assign _zz_601_ = {_zz_152_,{_zz_151_,_zz_609_}};
  assign _zz_602_ = ((decode_INSTRUCTION & (32'b00000010000000000011000001010000)) == (32'b00000010000000000000000001010000));
  assign _zz_603_ = {(_zz_610_ == _zz_611_),{_zz_612_,_zz_613_}};
  assign _zz_604_ = (3'b000);
  assign _zz_605_ = ({_zz_614_,{_zz_615_,_zz_616_}} != (5'b00000));
  assign _zz_606_ = ({_zz_617_,_zz_618_} != (4'b0000));
  assign _zz_607_ = {(_zz_619_ != _zz_620_),{_zz_621_,{_zz_622_,_zz_623_}}};
  assign _zz_608_ = (32'b00000000000000000100000000100000);
  assign _zz_609_ = ((decode_INSTRUCTION & _zz_624_) == (32'b00000000000000000000000000100000));
  assign _zz_610_ = (decode_INSTRUCTION & (32'b00001000000000000000000000100000));
  assign _zz_611_ = (32'b00001000000000000000000000100000);
  assign _zz_612_ = ((decode_INSTRUCTION & _zz_625_) == (32'b00000000000000000000000000100000));
  assign _zz_613_ = ((decode_INSTRUCTION & _zz_626_) == (32'b00000000000000000000000000100000));
  assign _zz_614_ = ((decode_INSTRUCTION & _zz_627_) == (32'b00000000000000000000000000000000));
  assign _zz_615_ = (_zz_628_ == _zz_629_);
  assign _zz_616_ = {_zz_630_,{_zz_631_,_zz_632_}};
  assign _zz_617_ = (_zz_633_ == _zz_634_);
  assign _zz_618_ = {_zz_635_,{_zz_636_,_zz_637_}};
  assign _zz_619_ = {_zz_638_,_zz_639_};
  assign _zz_620_ = (2'b00);
  assign _zz_621_ = ({_zz_640_,_zz_641_} != (7'b0000000));
  assign _zz_622_ = (_zz_642_ != _zz_643_);
  assign _zz_623_ = {_zz_644_,{_zz_645_,_zz_646_}};
  assign _zz_624_ = (32'b00000010000000000000000000101000);
  assign _zz_625_ = (32'b00010000000000000000000000100000);
  assign _zz_626_ = (32'b00000000000000000000000000101000);
  assign _zz_627_ = (32'b00000000000000000000000001000100);
  assign _zz_628_ = (decode_INSTRUCTION & (32'b00000000000000000000000000011000));
  assign _zz_629_ = (32'b00000000000000000000000000000000);
  assign _zz_630_ = ((decode_INSTRUCTION & _zz_647_) == (32'b00000000000000000010000000000000));
  assign _zz_631_ = (_zz_648_ == _zz_649_);
  assign _zz_632_ = _zz_153_;
  assign _zz_633_ = (decode_INSTRUCTION & (32'b00000000000000000000000000110100));
  assign _zz_634_ = (32'b00000000000000000000000000100000);
  assign _zz_635_ = ((decode_INSTRUCTION & _zz_650_) == (32'b00000000000000000000000000100000));
  assign _zz_636_ = (_zz_651_ == _zz_652_);
  assign _zz_637_ = (_zz_653_ == _zz_654_);
  assign _zz_638_ = ((decode_INSTRUCTION & _zz_655_) == (32'b00000000000000000001000001010000));
  assign _zz_639_ = ((decode_INSTRUCTION & _zz_656_) == (32'b00000000000000000010000001010000));
  assign _zz_640_ = _zz_150_;
  assign _zz_641_ = {_zz_657_,{_zz_658_,_zz_659_}};
  assign _zz_642_ = (_zz_660_ == _zz_661_);
  assign _zz_643_ = (1'b0);
  assign _zz_644_ = (_zz_662_ != (1'b0));
  assign _zz_645_ = (_zz_663_ != _zz_664_);
  assign _zz_646_ = {_zz_665_,{_zz_666_,_zz_667_}};
  assign _zz_647_ = (32'b00000000000000000110000000000100);
  assign _zz_648_ = (decode_INSTRUCTION & (32'b00000000000000000101000000000100));
  assign _zz_649_ = (32'b00000000000000000001000000000000);
  assign _zz_650_ = (32'b00000000000000000000000001100100);
  assign _zz_651_ = (decode_INSTRUCTION & (32'b00001000000000000000000001110000));
  assign _zz_652_ = (32'b00001000000000000000000000100000);
  assign _zz_653_ = (decode_INSTRUCTION & (32'b00010000000000000000000001110000));
  assign _zz_654_ = (32'b00000000000000000000000000100000);
  assign _zz_655_ = (32'b00000000000000000001000001010000);
  assign _zz_656_ = (32'b00000000000000000010000001010000);
  assign _zz_657_ = ((decode_INSTRUCTION & _zz_668_) == (32'b00000000000000000001000000010000));
  assign _zz_658_ = (_zz_669_ == _zz_670_);
  assign _zz_659_ = {_zz_671_,{_zz_672_,_zz_673_}};
  assign _zz_660_ = (decode_INSTRUCTION & (32'b00010000000000000000000000001000));
  assign _zz_661_ = (32'b00010000000000000000000000001000);
  assign _zz_662_ = ((decode_INSTRUCTION & _zz_674_) == (32'b00000000000000000001000000001000));
  assign _zz_663_ = (_zz_675_ == _zz_676_);
  assign _zz_664_ = (1'b0);
  assign _zz_665_ = (_zz_677_ != (1'b0));
  assign _zz_666_ = (_zz_678_ != _zz_679_);
  assign _zz_667_ = {_zz_680_,{_zz_681_,_zz_682_}};
  assign _zz_668_ = (32'b00000000000000000001000000010000);
  assign _zz_669_ = (decode_INSTRUCTION & (32'b00000000000000000010000000010000));
  assign _zz_670_ = (32'b00000000000000000010000000010000);
  assign _zz_671_ = ((decode_INSTRUCTION & (32'b00000000000000000010000000001000)) == (32'b00000000000000000010000000001000));
  assign _zz_672_ = ((decode_INSTRUCTION & _zz_683_) == (32'b00000000000000000000000000010000));
  assign _zz_673_ = {_zz_151_,(_zz_684_ == _zz_685_)};
  assign _zz_674_ = (32'b00000000000000000101000001001000);
  assign _zz_675_ = (decode_INSTRUCTION & (32'b00000000000000000100000000010100));
  assign _zz_676_ = (32'b00000000000000000100000000010000);
  assign _zz_677_ = ((decode_INSTRUCTION & (32'b00000000000000000110000000010100)) == (32'b00000000000000000010000000010000));
  assign _zz_678_ = {_zz_152_,{_zz_151_,_zz_686_}};
  assign _zz_679_ = (3'b000);
  assign _zz_680_ = ({_zz_150_,_zz_687_} != (2'b00));
  assign _zz_681_ = (_zz_688_ != (1'b0));
  assign _zz_682_ = {(_zz_689_ != _zz_690_),{_zz_691_,_zz_692_}};
  assign _zz_683_ = (32'b00000000000000000000000001010000);
  assign _zz_684_ = (decode_INSTRUCTION & (32'b00000000000000000000000000101000));
  assign _zz_685_ = (32'b00000000000000000000000000000000);
  assign _zz_686_ = ((decode_INSTRUCTION & (32'b00000010000000000000000001101000)) == (32'b00000000000000000000000000100000));
  assign _zz_687_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000011100)) == (32'b00000000000000000000000000000100));
  assign _zz_688_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001011000)) == (32'b00000000000000000000000001000000));
  assign _zz_689_ = ((decode_INSTRUCTION & (32'b00000000000000000001000000000000)) == (32'b00000000000000000001000000000000));
  assign _zz_690_ = (1'b0);
  assign _zz_691_ = (((decode_INSTRUCTION & (32'b00000000000000000011000000000000)) == (32'b00000000000000000010000000000000)) != (1'b0));
  assign _zz_692_ = (((decode_INSTRUCTION & (32'b00000000000000000000000001100100)) == (32'b00000000000000000000000000100100)) != (1'b0));
  assign _zz_693_ = (32'b00000000000000000001000001111111);
  assign _zz_694_ = (decode_INSTRUCTION & (32'b00000000000000000010000001111111));
  assign _zz_695_ = (32'b00000000000000000010000001110011);
  assign _zz_696_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001111111)) == (32'b00000000000000000100000001100011));
  assign _zz_697_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000010000000010011));
  assign _zz_698_ = {((decode_INSTRUCTION & (32'b00000000000000000110000000111111)) == (32'b00000000000000000000000000100011)),{((decode_INSTRUCTION & (32'b00000000000000000010000001111111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_699_) == (32'b00000000000000000000000000000011)),{(_zz_700_ == _zz_701_),{_zz_702_,{_zz_703_,_zz_704_}}}}}};
  assign _zz_699_ = (32'b00000000000000000101000001011111);
  assign _zz_700_ = (decode_INSTRUCTION & (32'b00000000000000000111000001111011));
  assign _zz_701_ = (32'b00000000000000000000000001100011);
  assign _zz_702_ = ((decode_INSTRUCTION & (32'b00000000000000000110000001111111)) == (32'b00000000000000000000000000001111));
  assign _zz_703_ = ((decode_INSTRUCTION & (32'b00011000000000000111000001111111)) == (32'b00000000000000000010000000101111));
  assign _zz_704_ = {((decode_INSTRUCTION & (32'b11111100000000000000000001111111)) == (32'b00000000000000000000000000110011)),{((decode_INSTRUCTION & (32'b11101000000000000111000001111111)) == (32'b00001000000000000010000000101111)),{((decode_INSTRUCTION & _zz_705_) == (32'b00000000000000000101000000001111)),{(_zz_706_ == _zz_707_),{_zz_708_,{_zz_709_,_zz_710_}}}}}};
  assign _zz_705_ = (32'b00000001111100000111000001111111);
  assign _zz_706_ = (decode_INSTRUCTION & (32'b10111100000000000111000001111111));
  assign _zz_707_ = (32'b00000000000000000101000000010011);
  assign _zz_708_ = ((decode_INSTRUCTION & (32'b11111100000000000011000001111111)) == (32'b00000000000000000001000000010011));
  assign _zz_709_ = ((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000101000000110011));
  assign _zz_710_ = {((decode_INSTRUCTION & (32'b10111110000000000111000001111111)) == (32'b00000000000000000000000000110011)),{((decode_INSTRUCTION & (32'b11111001111100000111000001111111)) == (32'b00010000000000000010000000101111)),{((decode_INSTRUCTION & _zz_711_) == (32'b00010010000000000000000001110011)),{(_zz_712_ == _zz_713_),{_zz_714_,_zz_715_}}}}};
  assign _zz_711_ = (32'b11111110000000000111111111111111);
  assign _zz_712_ = (decode_INSTRUCTION & (32'b11011111111111111111111111111111));
  assign _zz_713_ = (32'b00010000001000000000000001110011);
  assign _zz_714_ = ((decode_INSTRUCTION & (32'b11111111111011111111111111111111)) == (32'b00000000000000000000000001110011));
  assign _zz_715_ = ((decode_INSTRUCTION & (32'b11111111111111111111111111111111)) == (32'b00010000010100000000000001110011));
  assign _zz_716_ = execute_INSTRUCTION[31];
  assign _zz_717_ = execute_INSTRUCTION[31];
  assign _zz_718_ = execute_INSTRUCTION[7];
  always @ (posedge clk) begin
    if(_zz_58_) begin
      RegFilePlugin_regFile[lastStageRegFileWrite_payload_address] <= lastStageRegFileWrite_payload_data;
    end
  end

  always @ (posedge clk) begin
    if(_zz_500_) begin
      _zz_265_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress1];
    end
  end

  always @ (posedge clk) begin
    if(_zz_501_) begin
      _zz_266_ <= RegFilePlugin_regFile[decode_RegFilePlugin_regFileReadAddress2];
    end
  end

  InstructionCache IBusCachedPlugin_cache ( 
    .io_flush(_zz_239_),
    .io_cpu_prefetch_isValid(_zz_240_),
    .io_cpu_prefetch_haltIt(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt),
    .io_cpu_prefetch_pc(IBusCachedPlugin_iBusRsp_stages_0_input_payload),
    .io_cpu_fetch_isValid(_zz_241_),
    .io_cpu_fetch_isStuck(_zz_242_),
    .io_cpu_fetch_isRemoved(IBusCachedPlugin_fetcherflushIt),
    .io_cpu_fetch_pc(IBusCachedPlugin_iBusRsp_stages_1_input_payload),
    .io_cpu_fetch_data(IBusCachedPlugin_cache_io_cpu_fetch_data),
    .io_cpu_fetch_dataBypassValid(IBusCachedPlugin_s1_tightlyCoupledHit),
    .io_cpu_fetch_dataBypass(_zz_243_),
    .io_cpu_fetch_mmuBus_cmd_isValid(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid),
    .io_cpu_fetch_mmuBus_cmd_virtualAddress(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress),
    .io_cpu_fetch_mmuBus_cmd_bypassTranslation(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation),
    .io_cpu_fetch_mmuBus_rsp_physicalAddress(IBusCachedPlugin_mmuBus_rsp_physicalAddress),
    .io_cpu_fetch_mmuBus_rsp_isIoAccess(IBusCachedPlugin_mmuBus_rsp_isIoAccess),
    .io_cpu_fetch_mmuBus_rsp_allowRead(IBusCachedPlugin_mmuBus_rsp_allowRead),
    .io_cpu_fetch_mmuBus_rsp_allowWrite(IBusCachedPlugin_mmuBus_rsp_allowWrite),
    .io_cpu_fetch_mmuBus_rsp_allowExecute(IBusCachedPlugin_mmuBus_rsp_allowExecute),
    .io_cpu_fetch_mmuBus_rsp_exception(IBusCachedPlugin_mmuBus_rsp_exception),
    .io_cpu_fetch_mmuBus_rsp_refilling(IBusCachedPlugin_mmuBus_rsp_refilling),
    .io_cpu_fetch_mmuBus_end(IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end),
    .io_cpu_fetch_mmuBus_busy(IBusCachedPlugin_mmuBus_busy),
    .io_cpu_fetch_physicalAddress(IBusCachedPlugin_cache_io_cpu_fetch_physicalAddress),
    .io_cpu_fetch_haltIt(IBusCachedPlugin_cache_io_cpu_fetch_haltIt),
    .io_cpu_decode_isValid(_zz_244_),
    .io_cpu_decode_isStuck(_zz_245_),
    .io_cpu_decode_pc(IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload),
    .io_cpu_decode_physicalAddress(IBusCachedPlugin_cache_io_cpu_decode_physicalAddress),
    .io_cpu_decode_data(IBusCachedPlugin_cache_io_cpu_decode_data),
    .io_cpu_decode_cacheMiss(IBusCachedPlugin_cache_io_cpu_decode_cacheMiss),
    .io_cpu_decode_error(IBusCachedPlugin_cache_io_cpu_decode_error),
    .io_cpu_decode_mmuRefilling(IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling),
    .io_cpu_decode_mmuException(IBusCachedPlugin_cache_io_cpu_decode_mmuException),
    .io_cpu_decode_isUser(_zz_246_),
    .io_cpu_fill_valid(_zz_247_),
    .io_cpu_fill_payload(IBusCachedPlugin_cache_io_cpu_decode_physicalAddress),
    .io_mem_cmd_valid(IBusCachedPlugin_cache_io_mem_cmd_valid),
    .io_mem_cmd_ready(iBus_cmd_ready),
    .io_mem_cmd_payload_address(IBusCachedPlugin_cache_io_mem_cmd_payload_address),
    .io_mem_cmd_payload_size(IBusCachedPlugin_cache_io_mem_cmd_payload_size),
    .io_mem_rsp_valid(iBus_rsp_valid),
    .io_mem_rsp_payload_data(iBus_rsp_payload_data),
    .io_mem_rsp_payload_error(iBus_rsp_payload_error),
    .clk(clk),
    .reset(reset) 
  );
  DataCache dataCache_1_ ( 
    .io_cpu_execute_isValid(_zz_248_),
    .io_cpu_execute_address(_zz_249_),
    .io_cpu_execute_args_wr(_zz_250_),
    .io_cpu_execute_args_data(_zz_251_),
    .io_cpu_execute_args_size(_zz_252_),
    .io_cpu_execute_args_isLrsc(_zz_253_),
    .io_cpu_execute_args_isAmo(_zz_254_),
    .io_cpu_execute_args_amoCtrl_swap(_zz_255_),
    .io_cpu_execute_args_amoCtrl_alu(_zz_256_),
    .io_cpu_memory_isValid(_zz_257_),
    .io_cpu_memory_isStuck(memory_arbitration_isStuck),
    .io_cpu_memory_isRemoved(memory_arbitration_removeIt),
    .io_cpu_memory_isWrite(dataCache_1__io_cpu_memory_isWrite),
    .io_cpu_memory_address(_zz_258_),
    .io_cpu_memory_mmuBus_cmd_isValid(dataCache_1__io_cpu_memory_mmuBus_cmd_isValid),
    .io_cpu_memory_mmuBus_cmd_virtualAddress(dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress),
    .io_cpu_memory_mmuBus_cmd_bypassTranslation(dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation),
    .io_cpu_memory_mmuBus_rsp_physicalAddress(DBusCachedPlugin_mmuBus_rsp_physicalAddress),
    .io_cpu_memory_mmuBus_rsp_isIoAccess(_zz_259_),
    .io_cpu_memory_mmuBus_rsp_allowRead(DBusCachedPlugin_mmuBus_rsp_allowRead),
    .io_cpu_memory_mmuBus_rsp_allowWrite(DBusCachedPlugin_mmuBus_rsp_allowWrite),
    .io_cpu_memory_mmuBus_rsp_allowExecute(DBusCachedPlugin_mmuBus_rsp_allowExecute),
    .io_cpu_memory_mmuBus_rsp_exception(DBusCachedPlugin_mmuBus_rsp_exception),
    .io_cpu_memory_mmuBus_rsp_refilling(DBusCachedPlugin_mmuBus_rsp_refilling),
    .io_cpu_memory_mmuBus_end(dataCache_1__io_cpu_memory_mmuBus_end),
    .io_cpu_memory_mmuBus_busy(DBusCachedPlugin_mmuBus_busy),
    .io_cpu_writeBack_isValid(_zz_260_),
    .io_cpu_writeBack_isStuck(writeBack_arbitration_isStuck),
    .io_cpu_writeBack_isUser(_zz_261_),
    .io_cpu_writeBack_haltIt(dataCache_1__io_cpu_writeBack_haltIt),
    .io_cpu_writeBack_isWrite(dataCache_1__io_cpu_writeBack_isWrite),
    .io_cpu_writeBack_data(dataCache_1__io_cpu_writeBack_data),
    .io_cpu_writeBack_address(_zz_262_),
    .io_cpu_writeBack_mmuException(dataCache_1__io_cpu_writeBack_mmuException),
    .io_cpu_writeBack_unalignedAccess(dataCache_1__io_cpu_writeBack_unalignedAccess),
    .io_cpu_writeBack_accessError(dataCache_1__io_cpu_writeBack_accessError),
    .io_cpu_writeBack_clearLrsc(contextSwitching),
    .io_cpu_redo(dataCache_1__io_cpu_redo),
    .io_cpu_flush_valid(_zz_263_),
    .io_cpu_flush_ready(dataCache_1__io_cpu_flush_ready),
    .io_mem_cmd_valid(dataCache_1__io_mem_cmd_valid),
    .io_mem_cmd_ready(_zz_264_),
    .io_mem_cmd_payload_wr(dataCache_1__io_mem_cmd_payload_wr),
    .io_mem_cmd_payload_address(dataCache_1__io_mem_cmd_payload_address),
    .io_mem_cmd_payload_data(dataCache_1__io_mem_cmd_payload_data),
    .io_mem_cmd_payload_mask(dataCache_1__io_mem_cmd_payload_mask),
    .io_mem_cmd_payload_length(dataCache_1__io_mem_cmd_payload_length),
    .io_mem_cmd_payload_last(dataCache_1__io_mem_cmd_payload_last),
    .io_mem_rsp_valid(dBus_rsp_valid),
    .io_mem_rsp_payload_data(dBus_rsp_payload_data),
    .io_mem_rsp_payload_error(dBus_rsp_payload_error),
    .clk(clk),
    .reset(reset) 
  );
  always @(*) begin
    case(_zz_502_)
      3'b000 : begin
        _zz_267_ = DBusCachedPlugin_redoBranch_payload;
      end
      3'b001 : begin
        _zz_267_ = CsrPlugin_jumpInterface_payload;
      end
      3'b010 : begin
        _zz_267_ = BranchPlugin_jumpInterface_payload;
      end
      3'b011 : begin
        _zz_267_ = IBusCachedPlugin_redoBranch_payload;
      end
      default : begin
        _zz_267_ = IBusCachedPlugin_predictionJumpInterface_payload;
      end
    endcase
  end

  always @(*) begin
    case(_zz_222_)
      2'b00 : begin
        _zz_268_ = MmuPlugin_ports_0_cache_0_valid;
        _zz_269_ = MmuPlugin_ports_0_cache_0_exception;
        _zz_270_ = MmuPlugin_ports_0_cache_0_superPage;
        _zz_271_ = MmuPlugin_ports_0_cache_0_virtualAddress_0;
        _zz_272_ = MmuPlugin_ports_0_cache_0_virtualAddress_1;
        _zz_273_ = MmuPlugin_ports_0_cache_0_physicalAddress_0;
        _zz_274_ = MmuPlugin_ports_0_cache_0_physicalAddress_1;
        _zz_275_ = MmuPlugin_ports_0_cache_0_allowRead;
        _zz_276_ = MmuPlugin_ports_0_cache_0_allowWrite;
        _zz_277_ = MmuPlugin_ports_0_cache_0_allowExecute;
        _zz_278_ = MmuPlugin_ports_0_cache_0_allowUser;
      end
      2'b01 : begin
        _zz_268_ = MmuPlugin_ports_0_cache_1_valid;
        _zz_269_ = MmuPlugin_ports_0_cache_1_exception;
        _zz_270_ = MmuPlugin_ports_0_cache_1_superPage;
        _zz_271_ = MmuPlugin_ports_0_cache_1_virtualAddress_0;
        _zz_272_ = MmuPlugin_ports_0_cache_1_virtualAddress_1;
        _zz_273_ = MmuPlugin_ports_0_cache_1_physicalAddress_0;
        _zz_274_ = MmuPlugin_ports_0_cache_1_physicalAddress_1;
        _zz_275_ = MmuPlugin_ports_0_cache_1_allowRead;
        _zz_276_ = MmuPlugin_ports_0_cache_1_allowWrite;
        _zz_277_ = MmuPlugin_ports_0_cache_1_allowExecute;
        _zz_278_ = MmuPlugin_ports_0_cache_1_allowUser;
      end
      2'b10 : begin
        _zz_268_ = MmuPlugin_ports_0_cache_2_valid;
        _zz_269_ = MmuPlugin_ports_0_cache_2_exception;
        _zz_270_ = MmuPlugin_ports_0_cache_2_superPage;
        _zz_271_ = MmuPlugin_ports_0_cache_2_virtualAddress_0;
        _zz_272_ = MmuPlugin_ports_0_cache_2_virtualAddress_1;
        _zz_273_ = MmuPlugin_ports_0_cache_2_physicalAddress_0;
        _zz_274_ = MmuPlugin_ports_0_cache_2_physicalAddress_1;
        _zz_275_ = MmuPlugin_ports_0_cache_2_allowRead;
        _zz_276_ = MmuPlugin_ports_0_cache_2_allowWrite;
        _zz_277_ = MmuPlugin_ports_0_cache_2_allowExecute;
        _zz_278_ = MmuPlugin_ports_0_cache_2_allowUser;
      end
      default : begin
        _zz_268_ = MmuPlugin_ports_0_cache_3_valid;
        _zz_269_ = MmuPlugin_ports_0_cache_3_exception;
        _zz_270_ = MmuPlugin_ports_0_cache_3_superPage;
        _zz_271_ = MmuPlugin_ports_0_cache_3_virtualAddress_0;
        _zz_272_ = MmuPlugin_ports_0_cache_3_virtualAddress_1;
        _zz_273_ = MmuPlugin_ports_0_cache_3_physicalAddress_0;
        _zz_274_ = MmuPlugin_ports_0_cache_3_physicalAddress_1;
        _zz_275_ = MmuPlugin_ports_0_cache_3_allowRead;
        _zz_276_ = MmuPlugin_ports_0_cache_3_allowWrite;
        _zz_277_ = MmuPlugin_ports_0_cache_3_allowExecute;
        _zz_278_ = MmuPlugin_ports_0_cache_3_allowUser;
      end
    endcase
  end

  always @(*) begin
    case(_zz_225_)
      2'b00 : begin
        _zz_279_ = MmuPlugin_ports_1_cache_0_valid;
        _zz_280_ = MmuPlugin_ports_1_cache_0_exception;
        _zz_281_ = MmuPlugin_ports_1_cache_0_superPage;
        _zz_282_ = MmuPlugin_ports_1_cache_0_virtualAddress_0;
        _zz_283_ = MmuPlugin_ports_1_cache_0_virtualAddress_1;
        _zz_284_ = MmuPlugin_ports_1_cache_0_physicalAddress_0;
        _zz_285_ = MmuPlugin_ports_1_cache_0_physicalAddress_1;
        _zz_286_ = MmuPlugin_ports_1_cache_0_allowRead;
        _zz_287_ = MmuPlugin_ports_1_cache_0_allowWrite;
        _zz_288_ = MmuPlugin_ports_1_cache_0_allowExecute;
        _zz_289_ = MmuPlugin_ports_1_cache_0_allowUser;
      end
      2'b01 : begin
        _zz_279_ = MmuPlugin_ports_1_cache_1_valid;
        _zz_280_ = MmuPlugin_ports_1_cache_1_exception;
        _zz_281_ = MmuPlugin_ports_1_cache_1_superPage;
        _zz_282_ = MmuPlugin_ports_1_cache_1_virtualAddress_0;
        _zz_283_ = MmuPlugin_ports_1_cache_1_virtualAddress_1;
        _zz_284_ = MmuPlugin_ports_1_cache_1_physicalAddress_0;
        _zz_285_ = MmuPlugin_ports_1_cache_1_physicalAddress_1;
        _zz_286_ = MmuPlugin_ports_1_cache_1_allowRead;
        _zz_287_ = MmuPlugin_ports_1_cache_1_allowWrite;
        _zz_288_ = MmuPlugin_ports_1_cache_1_allowExecute;
        _zz_289_ = MmuPlugin_ports_1_cache_1_allowUser;
      end
      2'b10 : begin
        _zz_279_ = MmuPlugin_ports_1_cache_2_valid;
        _zz_280_ = MmuPlugin_ports_1_cache_2_exception;
        _zz_281_ = MmuPlugin_ports_1_cache_2_superPage;
        _zz_282_ = MmuPlugin_ports_1_cache_2_virtualAddress_0;
        _zz_283_ = MmuPlugin_ports_1_cache_2_virtualAddress_1;
        _zz_284_ = MmuPlugin_ports_1_cache_2_physicalAddress_0;
        _zz_285_ = MmuPlugin_ports_1_cache_2_physicalAddress_1;
        _zz_286_ = MmuPlugin_ports_1_cache_2_allowRead;
        _zz_287_ = MmuPlugin_ports_1_cache_2_allowWrite;
        _zz_288_ = MmuPlugin_ports_1_cache_2_allowExecute;
        _zz_289_ = MmuPlugin_ports_1_cache_2_allowUser;
      end
      default : begin
        _zz_279_ = MmuPlugin_ports_1_cache_3_valid;
        _zz_280_ = MmuPlugin_ports_1_cache_3_exception;
        _zz_281_ = MmuPlugin_ports_1_cache_3_superPage;
        _zz_282_ = MmuPlugin_ports_1_cache_3_virtualAddress_0;
        _zz_283_ = MmuPlugin_ports_1_cache_3_virtualAddress_1;
        _zz_284_ = MmuPlugin_ports_1_cache_3_physicalAddress_0;
        _zz_285_ = MmuPlugin_ports_1_cache_3_physicalAddress_1;
        _zz_286_ = MmuPlugin_ports_1_cache_3_allowRead;
        _zz_287_ = MmuPlugin_ports_1_cache_3_allowWrite;
        _zz_288_ = MmuPlugin_ports_1_cache_3_allowExecute;
        _zz_289_ = MmuPlugin_ports_1_cache_3_allowUser;
      end
    endcase
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(decode_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_SRC1_CTRL_string = "URS1        ";
      default : decode_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_1_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_1__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_1__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_1__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_1__string = "URS1        ";
      default : _zz_1__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_2_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_2__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_2__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_2__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_2__string = "URS1        ";
      default : _zz_2__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_3_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_3__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_3__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_3__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_3__string = "URS1        ";
      default : _zz_3__string = "????????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_ALU_CTRL_string = "BITWISE ";
      default : decode_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_4_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_4__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_4__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_4__string = "BITWISE ";
      default : _zz_4__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_5_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_5__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_5__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_5__string = "BITWISE ";
      default : _zz_5__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_6_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_6__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_6__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_6__string = "BITWISE ";
      default : _zz_6__string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_7_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_7__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_7__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_7__string = "AND_1";
      default : _zz_7__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_8_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_8__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_8__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_8__string = "AND_1";
      default : _zz_8__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_9_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_9__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_9__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_9__string = "AND_1";
      default : _zz_9__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_10_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_10__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_10__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_10__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_10__string = "JALR";
      default : _zz_10__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_11_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_11__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_11__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_11__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_11__string = "JALR";
      default : _zz_11__string = "????";
    endcase
  end
  always @(*) begin
    case(decode_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_12_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_12__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_12__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_12__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_12__string = "SRA_1    ";
      default : _zz_12__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_13_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_13__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_13__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_13__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_13__string = "SRA_1    ";
      default : _zz_13__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_14_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_14__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_14__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_14__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_14__string = "SRA_1    ";
      default : _zz_14__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_15_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_15__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_15__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_15__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_15__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_15__string = "EBREAK";
      default : _zz_15__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_16_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_16__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_16__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_16__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_16__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_16__string = "EBREAK";
      default : _zz_16__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_17_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_17__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_17__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_17__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_17__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_17__string = "EBREAK";
      default : _zz_17__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_18_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_18__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_18__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_18__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_18__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_18__string = "EBREAK";
      default : _zz_18__string = "??????";
    endcase
  end
  always @(*) begin
    case(decode_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : decode_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : decode_ENV_CTRL_string = "EBREAK";
      default : decode_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_19_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_19__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_19__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_19__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_19__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_19__string = "EBREAK";
      default : _zz_19__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_20_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_20__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_20__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_20__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_20__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_20__string = "EBREAK";
      default : _zz_20__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_21_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_21__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_21__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_21__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_21__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_21__string = "EBREAK";
      default : _zz_21__string = "??????";
    endcase
  end
  always @(*) begin
    case(decode_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_SRC2_CTRL_string = "PC ";
      default : decode_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_22_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_22__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_22__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_22__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_22__string = "PC ";
      default : _zz_22__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_23_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_23__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_23__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_23__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_23__string = "PC ";
      default : _zz_23__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_24_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_24__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_24__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_24__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_24__string = "PC ";
      default : _zz_24__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : execute_BRANCH_CTRL_string = "JALR";
      default : execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_27_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_27__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_27__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_27__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_27__string = "JALR";
      default : _zz_27__string = "????";
    endcase
  end
  always @(*) begin
    case(memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : memory_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : memory_ENV_CTRL_string = "EBREAK";
      default : memory_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_30_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_30__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_30__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_30__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_30__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_30__string = "EBREAK";
      default : _zz_30__string = "??????";
    endcase
  end
  always @(*) begin
    case(execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : execute_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : execute_ENV_CTRL_string = "EBREAK";
      default : execute_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_31_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_31__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_31__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_31__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_31__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_31__string = "EBREAK";
      default : _zz_31__string = "??????";
    endcase
  end
  always @(*) begin
    case(writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : writeBack_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : writeBack_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : writeBack_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : writeBack_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : writeBack_ENV_CTRL_string = "EBREAK";
      default : writeBack_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_34_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_34__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_34__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_34__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_34__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_34__string = "EBREAK";
      default : _zz_34__string = "??????";
    endcase
  end
  always @(*) begin
    case(execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : execute_SHIFT_CTRL_string = "SRA_1    ";
      default : execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_43_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_43__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_43__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_43__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_43__string = "SRA_1    ";
      default : _zz_43__string = "?????????";
    endcase
  end
  always @(*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : execute_SRC2_CTRL_string = "PC ";
      default : execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_48_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_48__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_48__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_48__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_48__string = "PC ";
      default : _zz_48__string = "???";
    endcase
  end
  always @(*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : execute_SRC1_CTRL_string = "URS1        ";
      default : execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_50_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_50__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_50__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_50__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_50__string = "URS1        ";
      default : _zz_50__string = "????????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : execute_ALU_CTRL_string = "BITWISE ";
      default : execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_53_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_53__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_53__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_53__string = "BITWISE ";
      default : _zz_53__string = "????????";
    endcase
  end
  always @(*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_55_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_55__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_55__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_55__string = "AND_1";
      default : _zz_55__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_62_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_62__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_62__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_62__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_62__string = "SRA_1    ";
      default : _zz_62__string = "?????????";
    endcase
  end
  always @(*) begin
    case(_zz_66_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_66__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_66__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_66__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_66__string = "URS1        ";
      default : _zz_66__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_67_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_67__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_67__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_67__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_67__string = "PC ";
      default : _zz_67__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_70_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_70__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_70__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_70__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_70__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_70__string = "EBREAK";
      default : _zz_70__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_83_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_83__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_83__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_83__string = "BITWISE ";
      default : _zz_83__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_85_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_85__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_85__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_85__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_85__string = "JALR";
      default : _zz_85__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_86_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_86__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_86__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_86__string = "AND_1";
      default : _zz_86__string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_BRANCH_CTRL_string = "JALR";
      default : decode_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_96_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_96__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_96__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_96__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_96__string = "JALR";
      default : _zz_96__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_157_)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : _zz_157__string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : _zz_157__string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : _zz_157__string = "AND_1";
      default : _zz_157__string = "?????";
    endcase
  end
  always @(*) begin
    case(_zz_158_)
      `BranchCtrlEnum_defaultEncoding_INC : _zz_158__string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : _zz_158__string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : _zz_158__string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : _zz_158__string = "JALR";
      default : _zz_158__string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_159_)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : _zz_159__string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : _zz_159__string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : _zz_159__string = "BITWISE ";
      default : _zz_159__string = "????????";
    endcase
  end
  always @(*) begin
    case(_zz_160_)
      `EnvCtrlEnum_defaultEncoding_NONE : _zz_160__string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : _zz_160__string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : _zz_160__string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : _zz_160__string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : _zz_160__string = "EBREAK";
      default : _zz_160__string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_161_)
      `Src2CtrlEnum_defaultEncoding_RS : _zz_161__string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : _zz_161__string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : _zz_161__string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : _zz_161__string = "PC ";
      default : _zz_161__string = "???";
    endcase
  end
  always @(*) begin
    case(_zz_162_)
      `Src1CtrlEnum_defaultEncoding_RS : _zz_162__string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : _zz_162__string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : _zz_162__string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : _zz_162__string = "URS1        ";
      default : _zz_162__string = "????????????";
    endcase
  end
  always @(*) begin
    case(_zz_163_)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : _zz_163__string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : _zz_163__string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : _zz_163__string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : _zz_163__string = "SRA_1    ";
      default : _zz_163__string = "?????????";
    endcase
  end
  always @(*) begin
    case(MmuPlugin_shared_state_1_)
      `MmuPlugin_shared_State_defaultEncoding_IDLE : MmuPlugin_shared_state_1__string = "IDLE  ";
      `MmuPlugin_shared_State_defaultEncoding_L1_CMD : MmuPlugin_shared_state_1__string = "L1_CMD";
      `MmuPlugin_shared_State_defaultEncoding_L1_RSP : MmuPlugin_shared_state_1__string = "L1_RSP";
      `MmuPlugin_shared_State_defaultEncoding_L0_CMD : MmuPlugin_shared_state_1__string = "L0_CMD";
      `MmuPlugin_shared_State_defaultEncoding_L0_RSP : MmuPlugin_shared_state_1__string = "L0_RSP";
      default : MmuPlugin_shared_state_1__string = "??????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC2_CTRL_string = "RS ";
      `Src2CtrlEnum_defaultEncoding_IMI : decode_to_execute_SRC2_CTRL_string = "IMI";
      `Src2CtrlEnum_defaultEncoding_IMS : decode_to_execute_SRC2_CTRL_string = "IMS";
      `Src2CtrlEnum_defaultEncoding_PC : decode_to_execute_SRC2_CTRL_string = "PC ";
      default : decode_to_execute_SRC2_CTRL_string = "???";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : decode_to_execute_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : decode_to_execute_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : decode_to_execute_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : decode_to_execute_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : decode_to_execute_ENV_CTRL_string = "EBREAK";
      default : decode_to_execute_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(execute_to_memory_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : execute_to_memory_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : execute_to_memory_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : execute_to_memory_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : execute_to_memory_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : execute_to_memory_ENV_CTRL_string = "EBREAK";
      default : execute_to_memory_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(memory_to_writeBack_ENV_CTRL)
      `EnvCtrlEnum_defaultEncoding_NONE : memory_to_writeBack_ENV_CTRL_string = "NONE  ";
      `EnvCtrlEnum_defaultEncoding_XRET : memory_to_writeBack_ENV_CTRL_string = "XRET  ";
      `EnvCtrlEnum_defaultEncoding_WFI : memory_to_writeBack_ENV_CTRL_string = "WFI   ";
      `EnvCtrlEnum_defaultEncoding_ECALL : memory_to_writeBack_ENV_CTRL_string = "ECALL ";
      `EnvCtrlEnum_defaultEncoding_EBREAK : memory_to_writeBack_ENV_CTRL_string = "EBREAK";
      default : memory_to_writeBack_ENV_CTRL_string = "??????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SHIFT_CTRL)
      `ShiftCtrlEnum_defaultEncoding_DISABLE_1 : decode_to_execute_SHIFT_CTRL_string = "DISABLE_1";
      `ShiftCtrlEnum_defaultEncoding_SLL_1 : decode_to_execute_SHIFT_CTRL_string = "SLL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRL_1 : decode_to_execute_SHIFT_CTRL_string = "SRL_1    ";
      `ShiftCtrlEnum_defaultEncoding_SRA_1 : decode_to_execute_SHIFT_CTRL_string = "SRA_1    ";
      default : decode_to_execute_SHIFT_CTRL_string = "?????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : decode_to_execute_BRANCH_CTRL_string = "INC ";
      `BranchCtrlEnum_defaultEncoding_B : decode_to_execute_BRANCH_CTRL_string = "B   ";
      `BranchCtrlEnum_defaultEncoding_JAL : decode_to_execute_BRANCH_CTRL_string = "JAL ";
      `BranchCtrlEnum_defaultEncoding_JALR : decode_to_execute_BRANCH_CTRL_string = "JALR";
      default : decode_to_execute_BRANCH_CTRL_string = "????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_XOR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "XOR_1";
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "OR_1 ";
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : decode_to_execute_ALU_BITWISE_CTRL_string = "AND_1";
      default : decode_to_execute_ALU_BITWISE_CTRL_string = "?????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_ADD_SUB : decode_to_execute_ALU_CTRL_string = "ADD_SUB ";
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : decode_to_execute_ALU_CTRL_string = "SLT_SLTU";
      `AluCtrlEnum_defaultEncoding_BITWISE : decode_to_execute_ALU_CTRL_string = "BITWISE ";
      default : decode_to_execute_ALU_CTRL_string = "????????";
    endcase
  end
  always @(*) begin
    case(decode_to_execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : decode_to_execute_SRC1_CTRL_string = "RS          ";
      `Src1CtrlEnum_defaultEncoding_IMU : decode_to_execute_SRC1_CTRL_string = "IMU         ";
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : decode_to_execute_SRC1_CTRL_string = "PC_INCREMENT";
      `Src1CtrlEnum_defaultEncoding_URS1 : decode_to_execute_SRC1_CTRL_string = "URS1        ";
      default : decode_to_execute_SRC1_CTRL_string = "????????????";
    endcase
  end
  `endif

  assign decode_CSR_WRITE_OPCODE = _zz_33_;
  assign decode_SRC1_CTRL = _zz_1_;
  assign _zz_2_ = _zz_3_;
  assign execute_BYPASSABLE_MEMORY_STAGE = decode_to_execute_BYPASSABLE_MEMORY_STAGE;
  assign decode_BYPASSABLE_MEMORY_STAGE = _zz_74_;
  assign decode_PREDICTION_HAD_BRANCHED2 = _zz_29_;
  assign execute_MUL_LL = _zz_39_;
  assign decode_IS_DIV = _zz_63_;
  assign decode_BYPASSABLE_EXECUTE_STAGE = _zz_84_;
  assign decode_IS_CSR = _zz_79_;
  assign memory_MEMORY_WR = execute_to_memory_MEMORY_WR;
  assign decode_MEMORY_WR = _zz_76_;
  assign writeBack_FORMAL_PC_NEXT = memory_to_writeBack_FORMAL_PC_NEXT;
  assign memory_FORMAL_PC_NEXT = execute_to_memory_FORMAL_PC_NEXT;
  assign execute_FORMAL_PC_NEXT = decode_to_execute_FORMAL_PC_NEXT;
  assign decode_FORMAL_PC_NEXT = _zz_99_;
  assign decode_SRC2_FORCE_ZERO = _zz_52_;
  assign decode_ALU_CTRL = _zz_4_;
  assign _zz_5_ = _zz_6_;
  assign execute_REGFILE_WRITE_DATA = _zz_54_;
  assign memory_MEMORY_ADDRESS_LOW = execute_to_memory_MEMORY_ADDRESS_LOW;
  assign execute_MEMORY_ADDRESS_LOW = _zz_91_;
  assign decode_ALU_BITWISE_CTRL = _zz_7_;
  assign _zz_8_ = _zz_9_;
  assign execute_IS_DBUS_SHARING = _zz_89_;
  assign decode_MEMORY_LRSC = _zz_81_;
  assign _zz_10_ = _zz_11_;
  assign execute_MUL_LH = _zz_38_;
  assign decode_SHIFT_CTRL = _zz_12_;
  assign _zz_13_ = _zz_14_;
  assign decode_IS_RS2_SIGNED = _zz_61_;
  assign decode_CSR_READ_OPCODE = _zz_32_;
  assign decode_MEMORY_AMO = _zz_69_;
  assign memory_IS_SFENCE_VMA = execute_to_memory_IS_SFENCE_VMA;
  assign execute_IS_SFENCE_VMA = decode_to_execute_IS_SFENCE_VMA;
  assign decode_IS_SFENCE_VMA = _zz_75_;
  assign execute_MUL_HL = _zz_37_;
  assign memory_IS_MUL = execute_to_memory_IS_MUL;
  assign execute_IS_MUL = decode_to_execute_IS_MUL;
  assign decode_IS_MUL = _zz_65_;
  assign memory_PC = execute_to_memory_PC;
  assign memory_MUL_LOW = _zz_35_;
  assign decode_MEMORY_MANAGMENT = _zz_73_;
  assign decode_SRC_LESS_UNSIGNED = _zz_71_;
  assign memory_MUL_HH = execute_to_memory_MUL_HH;
  assign execute_MUL_HH = _zz_36_;
  assign _zz_15_ = _zz_16_;
  assign _zz_17_ = _zz_18_;
  assign decode_ENV_CTRL = _zz_19_;
  assign _zz_20_ = _zz_21_;
  assign decode_SRC2_CTRL = _zz_22_;
  assign _zz_23_ = _zz_24_;
  assign decode_IS_RS1_SIGNED = _zz_72_;
  assign writeBack_IS_SFENCE_VMA = memory_to_writeBack_IS_SFENCE_VMA;
  assign execute_BRANCH_CALC = _zz_25_;
  assign execute_BRANCH_DO = _zz_26_;
  assign execute_PC = decode_to_execute_PC;
  assign execute_PREDICTION_HAD_BRANCHED2 = decode_to_execute_PREDICTION_HAD_BRANCHED2;
  assign execute_BRANCH_COND_RESULT = _zz_28_;
  assign execute_BRANCH_CTRL = _zz_27_;
  assign execute_CSR_READ_OPCODE = decode_to_execute_CSR_READ_OPCODE;
  assign execute_CSR_WRITE_OPCODE = decode_to_execute_CSR_WRITE_OPCODE;
  assign execute_IS_CSR = decode_to_execute_IS_CSR;
  assign memory_ENV_CTRL = _zz_30_;
  assign execute_ENV_CTRL = _zz_31_;
  assign writeBack_ENV_CTRL = _zz_34_;
  assign execute_IS_RS1_SIGNED = decode_to_execute_IS_RS1_SIGNED;
  assign execute_RS1 = decode_to_execute_RS1;
  assign execute_IS_DIV = decode_to_execute_IS_DIV;
  assign execute_IS_RS2_SIGNED = decode_to_execute_IS_RS2_SIGNED;
  assign memory_IS_DIV = execute_to_memory_IS_DIV;
  assign writeBack_IS_MUL = memory_to_writeBack_IS_MUL;
  assign writeBack_MUL_HH = memory_to_writeBack_MUL_HH;
  assign writeBack_MUL_LOW = memory_to_writeBack_MUL_LOW;
  assign memory_MUL_HL = execute_to_memory_MUL_HL;
  assign memory_MUL_LH = execute_to_memory_MUL_LH;
  assign memory_MUL_LL = execute_to_memory_MUL_LL;
  assign decode_RS2_USE = _zz_78_;
  assign decode_RS1_USE = _zz_77_;
  assign execute_REGFILE_WRITE_VALID = decode_to_execute_REGFILE_WRITE_VALID;
  assign execute_BYPASSABLE_EXECUTE_STAGE = decode_to_execute_BYPASSABLE_EXECUTE_STAGE;
  always @ (*) begin
    _zz_40_ = memory_REGFILE_WRITE_DATA;
    if(_zz_290_)begin
      _zz_40_ = memory_DivPlugin_div_result;
    end
  end

  assign memory_REGFILE_WRITE_VALID = execute_to_memory_REGFILE_WRITE_VALID;
  assign memory_INSTRUCTION = execute_to_memory_INSTRUCTION;
  assign memory_BYPASSABLE_MEMORY_STAGE = execute_to_memory_BYPASSABLE_MEMORY_STAGE;
  assign writeBack_REGFILE_WRITE_VALID = memory_to_writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    decode_RS2 = _zz_59_;
    if(_zz_177_)begin
      if((_zz_178_ == decode_INSTRUCTION[24 : 20]))begin
        decode_RS2 = _zz_179_;
      end
    end
    if(_zz_291_)begin
      if(_zz_292_)begin
        if(_zz_181_)begin
          decode_RS2 = _zz_90_;
        end
      end
    end
    if(_zz_293_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_183_)begin
          decode_RS2 = _zz_40_;
        end
      end
    end
    if(_zz_294_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_185_)begin
          decode_RS2 = _zz_41_;
        end
      end
    end
  end

  always @ (*) begin
    decode_RS1 = _zz_60_;
    if(_zz_177_)begin
      if((_zz_178_ == decode_INSTRUCTION[19 : 15]))begin
        decode_RS1 = _zz_179_;
      end
    end
    if(_zz_291_)begin
      if(_zz_292_)begin
        if(_zz_180_)begin
          decode_RS1 = _zz_90_;
        end
      end
    end
    if(_zz_293_)begin
      if(memory_BYPASSABLE_MEMORY_STAGE)begin
        if(_zz_182_)begin
          decode_RS1 = _zz_40_;
        end
      end
    end
    if(_zz_294_)begin
      if(execute_BYPASSABLE_EXECUTE_STAGE)begin
        if(_zz_184_)begin
          decode_RS1 = _zz_41_;
        end
      end
    end
  end

  assign execute_SHIFT_RIGHT = _zz_42_;
  always @ (*) begin
    _zz_41_ = execute_REGFILE_WRITE_DATA;
    if(execute_arbitration_isValid)begin
      case(execute_SHIFT_CTRL)
        `ShiftCtrlEnum_defaultEncoding_SLL_1 : begin
          _zz_41_ = _zz_173_;
        end
        `ShiftCtrlEnum_defaultEncoding_SRL_1, `ShiftCtrlEnum_defaultEncoding_SRA_1 : begin
          _zz_41_ = execute_SHIFT_RIGHT;
        end
        default : begin
        end
      endcase
    end
    if(_zz_295_)begin
      _zz_41_ = execute_CsrPlugin_readData;
    end
    if(DBusCachedPlugin_forceDatapath)begin
      _zz_41_ = MmuPlugin_dBusAccess_cmd_payload_address;
    end
  end

  assign execute_SHIFT_CTRL = _zz_43_;
  assign execute_SRC_LESS_UNSIGNED = decode_to_execute_SRC_LESS_UNSIGNED;
  assign execute_SRC2_FORCE_ZERO = decode_to_execute_SRC2_FORCE_ZERO;
  assign execute_SRC_USE_SUB_LESS = decode_to_execute_SRC_USE_SUB_LESS;
  assign _zz_47_ = execute_PC;
  assign execute_SRC2_CTRL = _zz_48_;
  assign execute_SRC1_CTRL = _zz_50_;
  assign decode_SRC_USE_SUB_LESS = _zz_68_;
  assign decode_SRC_ADD_ZERO = _zz_87_;
  assign execute_SRC_ADD_SUB = _zz_46_;
  assign execute_SRC_LESS = _zz_44_;
  assign execute_ALU_CTRL = _zz_53_;
  assign execute_SRC2 = _zz_49_;
  assign execute_SRC1 = _zz_51_;
  assign execute_ALU_BITWISE_CTRL = _zz_55_;
  assign _zz_56_ = writeBack_INSTRUCTION;
  assign _zz_57_ = writeBack_REGFILE_WRITE_VALID;
  always @ (*) begin
    _zz_58_ = 1'b0;
    if(lastStageRegFileWrite_valid)begin
      _zz_58_ = 1'b1;
    end
  end

  assign decode_INSTRUCTION_ANTICIPATED = _zz_95_;
  always @ (*) begin
    decode_REGFILE_WRITE_VALID = _zz_80_;
    if((decode_INSTRUCTION[11 : 7] == (5'b00000)))begin
      decode_REGFILE_WRITE_VALID = 1'b0;
    end
  end

  assign decode_LEGAL_INSTRUCTION = _zz_88_;
  assign decode_INSTRUCTION_READY = 1'b1;
  assign writeBack_IS_DBUS_SHARING = memory_to_writeBack_IS_DBUS_SHARING;
  assign memory_IS_DBUS_SHARING = execute_to_memory_IS_DBUS_SHARING;
  always @ (*) begin
    _zz_90_ = writeBack_REGFILE_WRITE_DATA;
    if((writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE))begin
      _zz_90_ = writeBack_DBusCachedPlugin_rspFormated;
    end
    if((writeBack_arbitration_isValid && writeBack_IS_MUL))begin
      case(_zz_349_)
        2'b00 : begin
          _zz_90_ = _zz_410_;
        end
        default : begin
          _zz_90_ = _zz_411_;
        end
      endcase
    end
  end

  assign writeBack_MEMORY_ADDRESS_LOW = memory_to_writeBack_MEMORY_ADDRESS_LOW;
  assign writeBack_MEMORY_WR = memory_to_writeBack_MEMORY_WR;
  assign writeBack_REGFILE_WRITE_DATA = memory_to_writeBack_REGFILE_WRITE_DATA;
  assign writeBack_MEMORY_ENABLE = memory_to_writeBack_MEMORY_ENABLE;
  assign memory_REGFILE_WRITE_DATA = execute_to_memory_REGFILE_WRITE_DATA;
  assign memory_MEMORY_ENABLE = execute_to_memory_MEMORY_ENABLE;
  assign execute_MEMORY_AMO = decode_to_execute_MEMORY_AMO;
  assign execute_MEMORY_LRSC = decode_to_execute_MEMORY_LRSC;
  assign execute_MEMORY_MANAGMENT = decode_to_execute_MEMORY_MANAGMENT;
  assign execute_RS2 = decode_to_execute_RS2;
  assign execute_MEMORY_WR = decode_to_execute_MEMORY_WR;
  assign execute_SRC_ADD = _zz_45_;
  assign execute_MEMORY_ENABLE = decode_to_execute_MEMORY_ENABLE;
  assign execute_INSTRUCTION = decode_to_execute_INSTRUCTION;
  assign decode_MEMORY_ENABLE = _zz_64_;
  assign decode_FLUSH_ALL = _zz_82_;
  always @ (*) begin
    IBusCachedPlugin_rsp_issueDetected = _zz_92_;
    if(_zz_296_)begin
      IBusCachedPlugin_rsp_issueDetected = 1'b1;
    end
  end

  always @ (*) begin
    _zz_92_ = _zz_93_;
    if(_zz_297_)begin
      _zz_92_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_93_ = _zz_94_;
    if(_zz_298_)begin
      _zz_93_ = 1'b1;
    end
  end

  always @ (*) begin
    _zz_94_ = 1'b0;
    if(_zz_299_)begin
      _zz_94_ = 1'b1;
    end
  end

  assign decode_BRANCH_CTRL = _zz_96_;
  assign decode_INSTRUCTION = _zz_100_;
  always @ (*) begin
    _zz_97_ = execute_FORMAL_PC_NEXT;
    if(BranchPlugin_jumpInterface_valid)begin
      _zz_97_ = BranchPlugin_jumpInterface_payload;
    end
  end

  always @ (*) begin
    _zz_98_ = decode_FORMAL_PC_NEXT;
    if(IBusCachedPlugin_predictionJumpInterface_valid)begin
      _zz_98_ = IBusCachedPlugin_predictionJumpInterface_payload;
    end
    if(IBusCachedPlugin_redoBranch_valid)begin
      _zz_98_ = IBusCachedPlugin_redoBranch_payload;
    end
  end

  assign decode_PC = _zz_101_;
  assign writeBack_PC = memory_to_writeBack_PC;
  assign writeBack_INSTRUCTION = memory_to_writeBack_INSTRUCTION;
  always @ (*) begin
    decode_arbitration_haltItself = 1'b0;
    if(((DBusCachedPlugin_mmuBus_busy && decode_arbitration_isValid) && decode_MEMORY_ENABLE))begin
      decode_arbitration_haltItself = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_haltByOther = 1'b0;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((decode_arbitration_isValid && (_zz_174_ || _zz_175_)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
    if((CsrPlugin_interrupt_valid && CsrPlugin_allowInterrupts))begin
      decode_arbitration_haltByOther = decode_arbitration_isValid;
    end
    if(({(writeBack_arbitration_isValid && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),{(memory_arbitration_isValid && (memory_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)),(execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET))}} != (3'b000)))begin
      decode_arbitration_haltByOther = 1'b1;
    end
  end

  always @ (*) begin
    decode_arbitration_removeIt = 1'b0;
    if(_zz_300_)begin
      decode_arbitration_removeIt = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      decode_arbitration_removeIt = 1'b1;
    end
  end

  assign decode_arbitration_flushIt = 1'b0;
  always @ (*) begin
    decode_arbitration_flushNext = 1'b0;
    if(IBusCachedPlugin_redoBranch_valid)begin
      decode_arbitration_flushNext = 1'b1;
    end
    if(_zz_300_)begin
      decode_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    execute_arbitration_haltItself = 1'b0;
    if((_zz_263_ && (! dataCache_1__io_cpu_flush_ready)))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(((dataCache_1__io_cpu_redo && execute_arbitration_isValid) && execute_MEMORY_ENABLE))begin
      execute_arbitration_haltItself = 1'b1;
    end
    if(_zz_301_)begin
      if((! execute_CsrPlugin_wfiWake))begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
    if(_zz_295_)begin
      if(execute_CsrPlugin_blockedBySideEffects)begin
        execute_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign execute_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    execute_arbitration_removeIt = 1'b0;
    if(_zz_302_)begin
      execute_arbitration_removeIt = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      execute_arbitration_removeIt = 1'b1;
    end
  end

  assign execute_arbitration_flushIt = 1'b0;
  always @ (*) begin
    execute_arbitration_flushNext = 1'b0;
    if(_zz_302_)begin
      execute_arbitration_flushNext = 1'b1;
    end
    if(BranchPlugin_jumpInterface_valid)begin
      execute_arbitration_flushNext = 1'b1;
    end
  end

  always @ (*) begin
    memory_arbitration_haltItself = 1'b0;
    if(_zz_290_)begin
      if(_zz_303_)begin
        memory_arbitration_haltItself = 1'b1;
      end
    end
  end

  assign memory_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    memory_arbitration_removeIt = 1'b0;
    if(memory_arbitration_isFlushed)begin
      memory_arbitration_removeIt = 1'b1;
    end
  end

  assign memory_arbitration_flushIt = 1'b0;
  assign memory_arbitration_flushNext = 1'b0;
  always @ (*) begin
    writeBack_arbitration_haltItself = 1'b0;
    if(dataCache_1__io_cpu_writeBack_haltIt)begin
      writeBack_arbitration_haltItself = 1'b1;
    end
  end

  assign writeBack_arbitration_haltByOther = 1'b0;
  always @ (*) begin
    writeBack_arbitration_removeIt = 1'b0;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      writeBack_arbitration_removeIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushIt = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushIt = 1'b1;
    end
  end

  always @ (*) begin
    writeBack_arbitration_flushNext = 1'b0;
    if(DBusCachedPlugin_redoBranch_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_304_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
    if(_zz_305_)begin
      writeBack_arbitration_flushNext = 1'b1;
    end
  end

  assign lastStageInstruction = writeBack_INSTRUCTION;
  assign lastStagePc = writeBack_PC;
  assign lastStageIsValid = writeBack_arbitration_isValid;
  assign lastStageIsFiring = writeBack_arbitration_isFiring;
  always @ (*) begin
    IBusCachedPlugin_fetcherHalt = 1'b0;
    if(({CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValids_memory,{CsrPlugin_exceptionPortCtrl_exceptionValids_execute,CsrPlugin_exceptionPortCtrl_exceptionValids_decode}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_304_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
    if(_zz_305_)begin
      IBusCachedPlugin_fetcherHalt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetcherflushIt = 1'b0;
    if(({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,{execute_arbitration_flushNext,decode_arbitration_flushNext}}} != (4'b0000)))begin
      IBusCachedPlugin_fetcherflushIt = 1'b1;
    end
    if((IBusCachedPlugin_predictionJumpInterface_valid && decode_arbitration_isFiring))begin
      IBusCachedPlugin_fetcherflushIt = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_incomingInstruction = 1'b0;
    if((IBusCachedPlugin_iBusRsp_stages_1_input_valid || IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid))begin
      IBusCachedPlugin_incomingInstruction = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_valid = 1'b0;
    if(_zz_304_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
    if(_zz_305_)begin
      CsrPlugin_jumpInterface_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_jumpInterface_payload = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    if(_zz_304_)begin
      CsrPlugin_jumpInterface_payload = {CsrPlugin_xtvec_base,(2'b00)};
    end
    if(_zz_305_)begin
      case(_zz_306_)
        2'b11 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_mepc;
        end
        2'b01 : begin
          CsrPlugin_jumpInterface_payload = CsrPlugin_sepc;
        end
        default : begin
        end
      endcase
    end
  end

  assign CsrPlugin_forceMachineWire = 1'b0;
  assign CsrPlugin_allowInterrupts = 1'b1;
  assign CsrPlugin_allowException = 1'b1;
  assign IBusCachedPlugin_jump_pcLoad_valid = ({BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,{DBusCachedPlugin_redoBranch_valid,{IBusCachedPlugin_redoBranch_valid,IBusCachedPlugin_predictionJumpInterface_valid}}}} != (5'b00000));
  assign _zz_102_ = {IBusCachedPlugin_predictionJumpInterface_valid,{IBusCachedPlugin_redoBranch_valid,{BranchPlugin_jumpInterface_valid,{CsrPlugin_jumpInterface_valid,DBusCachedPlugin_redoBranch_valid}}}};
  assign _zz_103_ = (_zz_102_ & (~ _zz_351_));
  assign _zz_104_ = _zz_103_[3];
  assign _zz_105_ = _zz_103_[4];
  assign _zz_106_ = (_zz_103_[1] || _zz_104_);
  assign _zz_107_ = (_zz_103_[2] || _zz_104_);
  assign IBusCachedPlugin_jump_pcLoad_payload = _zz_267_;
  always @ (*) begin
    IBusCachedPlugin_fetchPc_corrected = 1'b0;
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_corrected = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b0;
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_fetchPc_pcRegPropagate = 1'b1;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_fetchPc_pc = (IBusCachedPlugin_fetchPc_pcReg + _zz_353_);
    if(IBusCachedPlugin_jump_pcLoad_valid)begin
      IBusCachedPlugin_fetchPc_pc = IBusCachedPlugin_jump_pcLoad_payload;
    end
    IBusCachedPlugin_fetchPc_pc[0] = 1'b0;
    IBusCachedPlugin_fetchPc_pc[1] = 1'b0;
  end

  assign IBusCachedPlugin_fetchPc_output_valid = ((! IBusCachedPlugin_fetcherHalt) && IBusCachedPlugin_fetchPc_booted);
  assign IBusCachedPlugin_fetchPc_output_payload = IBusCachedPlugin_fetchPc_pc;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_valid = IBusCachedPlugin_fetchPc_output_valid;
  assign IBusCachedPlugin_fetchPc_output_ready = IBusCachedPlugin_iBusRsp_stages_0_input_ready;
  assign IBusCachedPlugin_iBusRsp_stages_0_input_payload = IBusCachedPlugin_fetchPc_output_payload;
  assign IBusCachedPlugin_iBusRsp_stages_0_inputSample = 1'b1;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_prefetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_0_halt = 1'b1;
    end
  end

  assign _zz_108_ = (! IBusCachedPlugin_iBusRsp_stages_0_halt);
  assign IBusCachedPlugin_iBusRsp_stages_0_input_ready = (IBusCachedPlugin_iBusRsp_stages_0_output_ready && _zz_108_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_valid = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && _zz_108_);
  assign IBusCachedPlugin_iBusRsp_stages_0_output_payload = IBusCachedPlugin_iBusRsp_stages_0_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b0;
    if(IBusCachedPlugin_cache_io_cpu_fetch_haltIt)begin
      IBusCachedPlugin_iBusRsp_stages_1_halt = 1'b1;
    end
  end

  assign _zz_109_ = (! IBusCachedPlugin_iBusRsp_stages_1_halt);
  assign IBusCachedPlugin_iBusRsp_stages_1_input_ready = (IBusCachedPlugin_iBusRsp_stages_1_output_ready && _zz_109_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_valid = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && _zz_109_);
  assign IBusCachedPlugin_iBusRsp_stages_1_output_payload = IBusCachedPlugin_iBusRsp_stages_1_input_payload;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt = 1'b0;
    if((IBusCachedPlugin_rsp_issueDetected || IBusCachedPlugin_rsp_iBusRspOutputHalt))begin
      IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt = 1'b1;
    end
  end

  assign _zz_110_ = (! IBusCachedPlugin_iBusRsp_cacheRspArbitration_halt);
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready = (IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_ready && _zz_110_);
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_valid = (IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid && _zz_110_);
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_payload = IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload;
  assign IBusCachedPlugin_iBusRsp_stages_0_output_ready = _zz_111_;
  assign _zz_111_ = ((1'b0 && (! _zz_112_)) || IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_112_ = _zz_113_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_valid = _zz_112_;
  assign IBusCachedPlugin_iBusRsp_stages_1_input_payload = IBusCachedPlugin_fetchPc_pcReg;
  assign IBusCachedPlugin_iBusRsp_stages_1_output_ready = ((1'b0 && (! _zz_114_)) || IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready);
  assign _zz_114_ = _zz_115_;
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid = _zz_114_;
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload = _zz_116_;
  always @ (*) begin
    IBusCachedPlugin_iBusRsp_readyForError = 1'b1;
    if((! IBusCachedPlugin_pcValids_0))begin
      IBusCachedPlugin_iBusRsp_readyForError = 1'b0;
    end
  end

  assign IBusCachedPlugin_pcValids_0 = IBusCachedPlugin_injector_nextPcCalc_valids_1;
  assign IBusCachedPlugin_pcValids_1 = IBusCachedPlugin_injector_nextPcCalc_valids_2;
  assign IBusCachedPlugin_pcValids_2 = IBusCachedPlugin_injector_nextPcCalc_valids_3;
  assign IBusCachedPlugin_pcValids_3 = IBusCachedPlugin_injector_nextPcCalc_valids_4;
  assign IBusCachedPlugin_iBusRsp_decodeInput_ready = (! decode_arbitration_isStuck);
  assign decode_arbitration_isValid = (IBusCachedPlugin_iBusRsp_decodeInput_valid && (! IBusCachedPlugin_injector_decodeRemoved));
  assign _zz_101_ = IBusCachedPlugin_iBusRsp_decodeInput_payload_pc;
  assign _zz_100_ = IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_inst;
  assign _zz_99_ = (decode_PC + (32'b00000000000000000000000000000100));
  assign _zz_117_ = _zz_354_[11];
  always @ (*) begin
    _zz_118_[18] = _zz_117_;
    _zz_118_[17] = _zz_117_;
    _zz_118_[16] = _zz_117_;
    _zz_118_[15] = _zz_117_;
    _zz_118_[14] = _zz_117_;
    _zz_118_[13] = _zz_117_;
    _zz_118_[12] = _zz_117_;
    _zz_118_[11] = _zz_117_;
    _zz_118_[10] = _zz_117_;
    _zz_118_[9] = _zz_117_;
    _zz_118_[8] = _zz_117_;
    _zz_118_[7] = _zz_117_;
    _zz_118_[6] = _zz_117_;
    _zz_118_[5] = _zz_117_;
    _zz_118_[4] = _zz_117_;
    _zz_118_[3] = _zz_117_;
    _zz_118_[2] = _zz_117_;
    _zz_118_[1] = _zz_117_;
    _zz_118_[0] = _zz_117_;
  end

  always @ (*) begin
    IBusCachedPlugin_decodePrediction_cmd_hadBranch = ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) || ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_B) && _zz_355_[31]));
    if(_zz_123_)begin
      IBusCachedPlugin_decodePrediction_cmd_hadBranch = 1'b0;
    end
  end

  assign _zz_119_ = _zz_356_[19];
  always @ (*) begin
    _zz_120_[10] = _zz_119_;
    _zz_120_[9] = _zz_119_;
    _zz_120_[8] = _zz_119_;
    _zz_120_[7] = _zz_119_;
    _zz_120_[6] = _zz_119_;
    _zz_120_[5] = _zz_119_;
    _zz_120_[4] = _zz_119_;
    _zz_120_[3] = _zz_119_;
    _zz_120_[2] = _zz_119_;
    _zz_120_[1] = _zz_119_;
    _zz_120_[0] = _zz_119_;
  end

  assign _zz_121_ = _zz_357_[11];
  always @ (*) begin
    _zz_122_[18] = _zz_121_;
    _zz_122_[17] = _zz_121_;
    _zz_122_[16] = _zz_121_;
    _zz_122_[15] = _zz_121_;
    _zz_122_[14] = _zz_121_;
    _zz_122_[13] = _zz_121_;
    _zz_122_[12] = _zz_121_;
    _zz_122_[11] = _zz_121_;
    _zz_122_[10] = _zz_121_;
    _zz_122_[9] = _zz_121_;
    _zz_122_[8] = _zz_121_;
    _zz_122_[7] = _zz_121_;
    _zz_122_[6] = _zz_121_;
    _zz_122_[5] = _zz_121_;
    _zz_122_[4] = _zz_121_;
    _zz_122_[3] = _zz_121_;
    _zz_122_[2] = _zz_121_;
    _zz_122_[1] = _zz_121_;
    _zz_122_[0] = _zz_121_;
  end

  always @ (*) begin
    case(decode_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_123_ = _zz_358_[1];
      end
      default : begin
        _zz_123_ = _zz_359_[1];
      end
    endcase
  end

  assign IBusCachedPlugin_predictionJumpInterface_valid = (decode_arbitration_isValid && IBusCachedPlugin_decodePrediction_cmd_hadBranch);
  assign _zz_124_ = _zz_360_[19];
  always @ (*) begin
    _zz_125_[10] = _zz_124_;
    _zz_125_[9] = _zz_124_;
    _zz_125_[8] = _zz_124_;
    _zz_125_[7] = _zz_124_;
    _zz_125_[6] = _zz_124_;
    _zz_125_[5] = _zz_124_;
    _zz_125_[4] = _zz_124_;
    _zz_125_[3] = _zz_124_;
    _zz_125_[2] = _zz_124_;
    _zz_125_[1] = _zz_124_;
    _zz_125_[0] = _zz_124_;
  end

  assign _zz_126_ = _zz_361_[11];
  always @ (*) begin
    _zz_127_[18] = _zz_126_;
    _zz_127_[17] = _zz_126_;
    _zz_127_[16] = _zz_126_;
    _zz_127_[15] = _zz_126_;
    _zz_127_[14] = _zz_126_;
    _zz_127_[13] = _zz_126_;
    _zz_127_[12] = _zz_126_;
    _zz_127_[11] = _zz_126_;
    _zz_127_[10] = _zz_126_;
    _zz_127_[9] = _zz_126_;
    _zz_127_[8] = _zz_126_;
    _zz_127_[7] = _zz_126_;
    _zz_127_[6] = _zz_126_;
    _zz_127_[5] = _zz_126_;
    _zz_127_[4] = _zz_126_;
    _zz_127_[3] = _zz_126_;
    _zz_127_[2] = _zz_126_;
    _zz_127_[1] = _zz_126_;
    _zz_127_[0] = _zz_126_;
  end

  assign IBusCachedPlugin_predictionJumpInterface_payload = (decode_PC + ((decode_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_125_,{{{_zz_503_,decode_INSTRUCTION[19 : 12]},decode_INSTRUCTION[20]},decode_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_127_,{{{_zz_504_,_zz_505_},decode_INSTRUCTION[30 : 25]},decode_INSTRUCTION[11 : 8]}},1'b0}));
  assign iBus_cmd_valid = IBusCachedPlugin_cache_io_mem_cmd_valid;
  always @ (*) begin
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
    iBus_cmd_payload_address = IBusCachedPlugin_cache_io_mem_cmd_payload_address;
  end

  assign iBus_cmd_payload_size = IBusCachedPlugin_cache_io_mem_cmd_payload_size;
  assign IBusCachedPlugin_s0_tightlyCoupledHit = 1'b0;
  assign _zz_240_ = (IBusCachedPlugin_iBusRsp_stages_0_input_valid && (! IBusCachedPlugin_s0_tightlyCoupledHit));
  assign _zz_243_ = (32'b00000000000000000000000000000000);
  assign _zz_241_ = (IBusCachedPlugin_iBusRsp_stages_1_input_valid && (! IBusCachedPlugin_s1_tightlyCoupledHit));
  assign _zz_242_ = (! IBusCachedPlugin_iBusRsp_stages_1_input_ready);
  assign _zz_244_ = (IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_valid && (! IBusCachedPlugin_s2_tightlyCoupledHit));
  assign _zz_245_ = (! IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready);
  assign _zz_246_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_95_ = (decode_arbitration_isStuck ? decode_INSTRUCTION : IBusCachedPlugin_cache_io_cpu_fetch_data);
  assign IBusCachedPlugin_rsp_iBusRspOutputHalt = 1'b0;
  always @ (*) begin
    IBusCachedPlugin_rsp_redoFetch = 1'b0;
    if(_zz_299_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_297_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b1;
    end
    if(_zz_307_)begin
      IBusCachedPlugin_rsp_redoFetch = 1'b0;
    end
  end

  always @ (*) begin
    _zz_247_ = (IBusCachedPlugin_rsp_redoFetch && (! IBusCachedPlugin_cache_io_cpu_decode_mmuRefilling));
    if(_zz_297_)begin
      _zz_247_ = 1'b1;
    end
    if(_zz_307_)begin
      _zz_247_ = 1'b0;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_valid = 1'b0;
    if(_zz_298_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
    if(_zz_296_)begin
      IBusCachedPlugin_decodeExceptionPort_valid = IBusCachedPlugin_iBusRsp_readyForError;
    end
  end

  always @ (*) begin
    IBusCachedPlugin_decodeExceptionPort_payload_code = (4'bxxxx);
    if(_zz_298_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b1100);
    end
    if(_zz_296_)begin
      IBusCachedPlugin_decodeExceptionPort_payload_code = (4'b0001);
    end
  end

  assign IBusCachedPlugin_decodeExceptionPort_payload_badAddr = {IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload[31 : 2],(2'b00)};
  assign IBusCachedPlugin_redoBranch_valid = IBusCachedPlugin_rsp_redoFetch;
  assign IBusCachedPlugin_redoBranch_payload = IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_payload;
  assign IBusCachedPlugin_iBusRsp_decodeInput_valid = IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_valid;
  assign IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_ready = IBusCachedPlugin_iBusRsp_decodeInput_ready;
  assign IBusCachedPlugin_iBusRsp_decodeInput_payload_rsp_inst = IBusCachedPlugin_cache_io_cpu_decode_data;
  assign IBusCachedPlugin_iBusRsp_decodeInput_payload_pc = IBusCachedPlugin_iBusRsp_cacheRspArbitration_output_payload;
  assign IBusCachedPlugin_mmuBus_cmd_isValid = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_isValid;
  assign IBusCachedPlugin_mmuBus_cmd_virtualAddress = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_virtualAddress;
  assign IBusCachedPlugin_mmuBus_cmd_bypassTranslation = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_cmd_bypassTranslation;
  assign IBusCachedPlugin_mmuBus_end = IBusCachedPlugin_cache_io_cpu_fetch_mmuBus_end;
  assign _zz_239_ = (decode_arbitration_isValid && decode_FLUSH_ALL);
  assign dataCache_1__io_mem_cmd_s2mPipe_valid = (dataCache_1__io_mem_cmd_valid || _zz_129_);
  assign _zz_264_ = (! _zz_129_);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_wr = (_zz_129_ ? _zz_130_ : dataCache_1__io_mem_cmd_payload_wr);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_address = (_zz_129_ ? _zz_131_ : dataCache_1__io_mem_cmd_payload_address);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_data = (_zz_129_ ? _zz_132_ : dataCache_1__io_mem_cmd_payload_data);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_mask = (_zz_129_ ? _zz_133_ : dataCache_1__io_mem_cmd_payload_mask);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_length = (_zz_129_ ? _zz_134_ : dataCache_1__io_mem_cmd_payload_length);
  assign dataCache_1__io_mem_cmd_s2mPipe_payload_last = (_zz_129_ ? _zz_135_ : dataCache_1__io_mem_cmd_payload_last);
  assign dataCache_1__io_mem_cmd_s2mPipe_ready = ((1'b1 && (! dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid)) || dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready);
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid = _zz_136_;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr = _zz_137_;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address = _zz_138_;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data = _zz_139_;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask = _zz_140_;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length = _zz_141_;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last = _zz_142_;
  assign dBus_cmd_valid = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_valid;
  assign dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_ready = dBus_cmd_ready;
  assign dBus_cmd_payload_wr = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_wr;
  assign dBus_cmd_payload_address = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_address;
  assign dBus_cmd_payload_data = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_data;
  assign dBus_cmd_payload_mask = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_mask;
  assign dBus_cmd_payload_length = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_length;
  assign dBus_cmd_payload_last = dataCache_1__io_mem_cmd_s2mPipe_m2sPipe_payload_last;
  assign execute_DBusCachedPlugin_size = execute_INSTRUCTION[13 : 12];
  always @ (*) begin
    _zz_248_ = (execute_arbitration_isValid && execute_MEMORY_ENABLE);
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        if(_zz_309_)begin
          _zz_248_ = 1'b1;
        end
      end
    end
  end

  always @ (*) begin
    _zz_249_ = execute_SRC_ADD;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        _zz_249_ = MmuPlugin_dBusAccess_cmd_payload_address;
      end
    end
  end

  always @ (*) begin
    _zz_250_ = execute_MEMORY_WR;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        _zz_250_ = MmuPlugin_dBusAccess_cmd_payload_write;
      end
    end
  end

  always @ (*) begin
    case(execute_DBusCachedPlugin_size)
      2'b00 : begin
        _zz_144_ = {{{execute_RS2[7 : 0],execute_RS2[7 : 0]},execute_RS2[7 : 0]},execute_RS2[7 : 0]};
      end
      2'b01 : begin
        _zz_144_ = {execute_RS2[15 : 0],execute_RS2[15 : 0]};
      end
      default : begin
        _zz_144_ = execute_RS2[31 : 0];
      end
    endcase
  end

  always @ (*) begin
    _zz_251_ = _zz_144_;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        _zz_251_ = MmuPlugin_dBusAccess_cmd_payload_data;
      end
    end
  end

  always @ (*) begin
    _zz_252_ = execute_DBusCachedPlugin_size;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        _zz_252_ = MmuPlugin_dBusAccess_cmd_payload_size;
      end
    end
  end

  assign _zz_263_ = (execute_arbitration_isValid && execute_MEMORY_MANAGMENT);
  always @ (*) begin
    _zz_253_ = 1'b0;
    if(execute_MEMORY_LRSC)begin
      _zz_253_ = 1'b1;
    end
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        _zz_253_ = 1'b0;
      end
    end
  end

  always @ (*) begin
    _zz_254_ = execute_MEMORY_AMO;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        _zz_254_ = 1'b0;
      end
    end
  end

  assign _zz_256_ = execute_INSTRUCTION[31 : 29];
  assign _zz_255_ = execute_INSTRUCTION[27];
  assign _zz_91_ = _zz_249_[1 : 0];
  always @ (*) begin
    _zz_257_ = (memory_arbitration_isValid && memory_MEMORY_ENABLE);
    if(memory_IS_DBUS_SHARING)begin
      _zz_257_ = 1'b1;
    end
  end

  assign _zz_258_ = memory_REGFILE_WRITE_DATA;
  assign DBusCachedPlugin_mmuBus_cmd_isValid = dataCache_1__io_cpu_memory_mmuBus_cmd_isValid;
  assign DBusCachedPlugin_mmuBus_cmd_virtualAddress = dataCache_1__io_cpu_memory_mmuBus_cmd_virtualAddress;
  always @ (*) begin
    DBusCachedPlugin_mmuBus_cmd_bypassTranslation = dataCache_1__io_cpu_memory_mmuBus_cmd_bypassTranslation;
    if(memory_IS_DBUS_SHARING)begin
      DBusCachedPlugin_mmuBus_cmd_bypassTranslation = 1'b1;
    end
  end

  always @ (*) begin
    _zz_259_ = DBusCachedPlugin_mmuBus_rsp_isIoAccess;
    if((1'b0 && (! dataCache_1__io_cpu_memory_isWrite)))begin
      _zz_259_ = 1'b1;
    end
  end

  assign DBusCachedPlugin_mmuBus_end = dataCache_1__io_cpu_memory_mmuBus_end;
  always @ (*) begin
    _zz_260_ = (writeBack_arbitration_isValid && writeBack_MEMORY_ENABLE);
    if(writeBack_IS_DBUS_SHARING)begin
      _zz_260_ = 1'b1;
    end
  end

  assign _zz_261_ = (CsrPlugin_privilege == (2'b00));
  assign _zz_262_ = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_redoBranch_valid = 1'b0;
    if(_zz_310_)begin
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_redoBranch_valid = 1'b1;
      end
    end
  end

  assign DBusCachedPlugin_redoBranch_payload = writeBack_PC;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_valid = 1'b0;
    if(_zz_310_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b1;
      end
      if(dataCache_1__io_cpu_redo)begin
        DBusCachedPlugin_exceptionBus_valid = 1'b0;
      end
    end
  end

  assign DBusCachedPlugin_exceptionBus_payload_badAddr = writeBack_REGFILE_WRITE_DATA;
  always @ (*) begin
    DBusCachedPlugin_exceptionBus_payload_code = (4'bxxxx);
    if(_zz_310_)begin
      if(dataCache_1__io_cpu_writeBack_accessError)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_362_};
      end
      if(dataCache_1__io_cpu_writeBack_unalignedAccess)begin
        DBusCachedPlugin_exceptionBus_payload_code = {1'd0, _zz_363_};
      end
      if(dataCache_1__io_cpu_writeBack_mmuException)begin
        DBusCachedPlugin_exceptionBus_payload_code = (writeBack_MEMORY_WR ? (4'b1111) : (4'b1101));
      end
    end
  end

  always @ (*) begin
    writeBack_DBusCachedPlugin_rspShifted = dataCache_1__io_cpu_writeBack_data;
    case(writeBack_MEMORY_ADDRESS_LOW)
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_1__io_cpu_writeBack_data[15 : 8];
      end
      2'b10 : begin
        writeBack_DBusCachedPlugin_rspShifted[15 : 0] = dataCache_1__io_cpu_writeBack_data[31 : 16];
      end
      2'b11 : begin
        writeBack_DBusCachedPlugin_rspShifted[7 : 0] = dataCache_1__io_cpu_writeBack_data[31 : 24];
      end
      default : begin
      end
    endcase
  end

  assign _zz_145_ = (writeBack_DBusCachedPlugin_rspShifted[7] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_146_[31] = _zz_145_;
    _zz_146_[30] = _zz_145_;
    _zz_146_[29] = _zz_145_;
    _zz_146_[28] = _zz_145_;
    _zz_146_[27] = _zz_145_;
    _zz_146_[26] = _zz_145_;
    _zz_146_[25] = _zz_145_;
    _zz_146_[24] = _zz_145_;
    _zz_146_[23] = _zz_145_;
    _zz_146_[22] = _zz_145_;
    _zz_146_[21] = _zz_145_;
    _zz_146_[20] = _zz_145_;
    _zz_146_[19] = _zz_145_;
    _zz_146_[18] = _zz_145_;
    _zz_146_[17] = _zz_145_;
    _zz_146_[16] = _zz_145_;
    _zz_146_[15] = _zz_145_;
    _zz_146_[14] = _zz_145_;
    _zz_146_[13] = _zz_145_;
    _zz_146_[12] = _zz_145_;
    _zz_146_[11] = _zz_145_;
    _zz_146_[10] = _zz_145_;
    _zz_146_[9] = _zz_145_;
    _zz_146_[8] = _zz_145_;
    _zz_146_[7 : 0] = writeBack_DBusCachedPlugin_rspShifted[7 : 0];
  end

  assign _zz_147_ = (writeBack_DBusCachedPlugin_rspShifted[15] && (! writeBack_INSTRUCTION[14]));
  always @ (*) begin
    _zz_148_[31] = _zz_147_;
    _zz_148_[30] = _zz_147_;
    _zz_148_[29] = _zz_147_;
    _zz_148_[28] = _zz_147_;
    _zz_148_[27] = _zz_147_;
    _zz_148_[26] = _zz_147_;
    _zz_148_[25] = _zz_147_;
    _zz_148_[24] = _zz_147_;
    _zz_148_[23] = _zz_147_;
    _zz_148_[22] = _zz_147_;
    _zz_148_[21] = _zz_147_;
    _zz_148_[20] = _zz_147_;
    _zz_148_[19] = _zz_147_;
    _zz_148_[18] = _zz_147_;
    _zz_148_[17] = _zz_147_;
    _zz_148_[16] = _zz_147_;
    _zz_148_[15 : 0] = writeBack_DBusCachedPlugin_rspShifted[15 : 0];
  end

  always @ (*) begin
    case(_zz_348_)
      2'b00 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_146_;
      end
      2'b01 : begin
        writeBack_DBusCachedPlugin_rspFormated = _zz_148_;
      end
      default : begin
        writeBack_DBusCachedPlugin_rspFormated = writeBack_DBusCachedPlugin_rspShifted;
      end
    endcase
  end

  always @ (*) begin
    MmuPlugin_dBusAccess_cmd_ready = 1'b0;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        if(_zz_309_)begin
          MmuPlugin_dBusAccess_cmd_ready = (! execute_arbitration_isStuck);
        end
      end
    end
  end

  always @ (*) begin
    DBusCachedPlugin_forceDatapath = 1'b0;
    if(MmuPlugin_dBusAccess_cmd_valid)begin
      if(_zz_308_)begin
        DBusCachedPlugin_forceDatapath = 1'b1;
      end
    end
  end

  assign _zz_89_ = (MmuPlugin_dBusAccess_cmd_valid && MmuPlugin_dBusAccess_cmd_ready);
  assign MmuPlugin_dBusAccess_rsp_valid = ((writeBack_IS_DBUS_SHARING && (! dataCache_1__io_cpu_writeBack_isWrite)) && (dataCache_1__io_cpu_redo || (! dataCache_1__io_cpu_writeBack_haltIt)));
  assign MmuPlugin_dBusAccess_rsp_payload_data = dataCache_1__io_cpu_writeBack_data;
  assign MmuPlugin_dBusAccess_rsp_payload_error = (dataCache_1__io_cpu_writeBack_unalignedAccess || dataCache_1__io_cpu_writeBack_accessError);
  assign MmuPlugin_dBusAccess_rsp_payload_redo = dataCache_1__io_cpu_redo;
  assign _zz_150_ = ((decode_INSTRUCTION & (32'b00000000000000000000000001001000)) == (32'b00000000000000000000000001001000));
  assign _zz_151_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000001100)) == (32'b00000000000000000000000000000100));
  assign _zz_152_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000110000)) == (32'b00000000000000000000000000010000));
  assign _zz_153_ = ((decode_INSTRUCTION & (32'b00000000000000000010000001010000)) == (32'b00000000000000000010000000000000));
  assign _zz_154_ = ((decode_INSTRUCTION & (32'b00000000000000000001000000000000)) == (32'b00000000000000000000000000000000));
  assign _zz_155_ = ((decode_INSTRUCTION & (32'b00000000000000000000000000000100)) == (32'b00000000000000000000000000000100));
  assign _zz_156_ = ((decode_INSTRUCTION & (32'b00000000000000000100000001010000)) == (32'b00000000000000000100000001010000));
  assign _zz_149_ = {(_zz_154_ != (1'b0)),{({_zz_506_,_zz_507_} != (2'b00)),{({_zz_508_,_zz_509_} != (3'b000)),{(_zz_510_ != _zz_511_),{_zz_512_,{_zz_513_,_zz_514_}}}}}};
  assign _zz_88_ = ({((decode_INSTRUCTION & (32'b00000000000000000000000001011111)) == (32'b00000000000000000000000000010111)),{((decode_INSTRUCTION & (32'b00000000000000000000000001111111)) == (32'b00000000000000000000000001101111)),{((decode_INSTRUCTION & (32'b00000000000000000001000001101111)) == (32'b00000000000000000000000000000011)),{((decode_INSTRUCTION & _zz_693_) == (32'b00000000000000000001000001110011)),{(_zz_694_ == _zz_695_),{_zz_696_,{_zz_697_,_zz_698_}}}}}}} != (25'b0000000000000000000000000));
  assign _zz_87_ = _zz_364_[0];
  assign _zz_157_ = _zz_149_[2 : 1];
  assign _zz_86_ = _zz_157_;
  assign _zz_158_ = _zz_149_[4 : 3];
  assign _zz_85_ = _zz_158_;
  assign _zz_84_ = _zz_365_[0];
  assign _zz_159_ = _zz_149_[7 : 6];
  assign _zz_83_ = _zz_159_;
  assign _zz_82_ = _zz_366_[0];
  assign _zz_81_ = _zz_367_[0];
  assign _zz_80_ = _zz_368_[0];
  assign _zz_79_ = _zz_369_[0];
  assign _zz_78_ = _zz_370_[0];
  assign _zz_77_ = _zz_371_[0];
  assign _zz_76_ = _zz_372_[0];
  assign _zz_75_ = _zz_373_[0];
  assign _zz_74_ = _zz_374_[0];
  assign _zz_73_ = _zz_375_[0];
  assign _zz_72_ = _zz_376_[0];
  assign _zz_71_ = _zz_377_[0];
  assign _zz_160_ = _zz_149_[22 : 20];
  assign _zz_70_ = _zz_160_;
  assign _zz_69_ = _zz_378_[0];
  assign _zz_68_ = _zz_379_[0];
  assign _zz_161_ = _zz_149_[27 : 26];
  assign _zz_67_ = _zz_161_;
  assign _zz_162_ = _zz_149_[29 : 28];
  assign _zz_66_ = _zz_162_;
  assign _zz_65_ = _zz_380_[0];
  assign _zz_64_ = _zz_381_[0];
  assign _zz_63_ = _zz_382_[0];
  assign _zz_163_ = _zz_149_[34 : 33];
  assign _zz_62_ = _zz_163_;
  assign _zz_61_ = _zz_383_[0];
  assign decodeExceptionPort_valid = ((decode_arbitration_isValid && decode_INSTRUCTION_READY) && (! decode_LEGAL_INSTRUCTION));
  assign decodeExceptionPort_payload_code = (4'b0010);
  assign decodeExceptionPort_payload_badAddr = decode_INSTRUCTION;
  assign decode_RegFilePlugin_regFileReadAddress1 = decode_INSTRUCTION_ANTICIPATED[19 : 15];
  assign decode_RegFilePlugin_regFileReadAddress2 = decode_INSTRUCTION_ANTICIPATED[24 : 20];
  assign decode_RegFilePlugin_rs1Data = _zz_265_;
  assign decode_RegFilePlugin_rs2Data = _zz_266_;
  assign _zz_60_ = decode_RegFilePlugin_rs1Data;
  assign _zz_59_ = decode_RegFilePlugin_rs2Data;
  always @ (*) begin
    lastStageRegFileWrite_valid = (_zz_57_ && writeBack_arbitration_isFiring);
    if(_zz_164_)begin
      lastStageRegFileWrite_valid = 1'b1;
    end
  end

  assign lastStageRegFileWrite_payload_address = _zz_56_[11 : 7];
  assign lastStageRegFileWrite_payload_data = _zz_90_;
  always @ (*) begin
    case(execute_ALU_BITWISE_CTRL)
      `AluBitwiseCtrlEnum_defaultEncoding_AND_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 & execute_SRC2);
      end
      `AluBitwiseCtrlEnum_defaultEncoding_OR_1 : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 | execute_SRC2);
      end
      default : begin
        execute_IntAluPlugin_bitwise = (execute_SRC1 ^ execute_SRC2);
      end
    endcase
  end

  always @ (*) begin
    case(execute_ALU_CTRL)
      `AluCtrlEnum_defaultEncoding_BITWISE : begin
        _zz_165_ = execute_IntAluPlugin_bitwise;
      end
      `AluCtrlEnum_defaultEncoding_SLT_SLTU : begin
        _zz_165_ = {31'd0, _zz_384_};
      end
      default : begin
        _zz_165_ = execute_SRC_ADD_SUB;
      end
    endcase
  end

  assign _zz_54_ = _zz_165_;
  assign _zz_52_ = (decode_SRC_ADD_ZERO && (! decode_SRC_USE_SUB_LESS));
  always @ (*) begin
    case(execute_SRC1_CTRL)
      `Src1CtrlEnum_defaultEncoding_RS : begin
        _zz_166_ = execute_RS1;
      end
      `Src1CtrlEnum_defaultEncoding_PC_INCREMENT : begin
        _zz_166_ = {29'd0, _zz_385_};
      end
      `Src1CtrlEnum_defaultEncoding_IMU : begin
        _zz_166_ = {execute_INSTRUCTION[31 : 12],(12'b000000000000)};
      end
      default : begin
        _zz_166_ = {27'd0, _zz_386_};
      end
    endcase
  end

  assign _zz_51_ = _zz_166_;
  assign _zz_167_ = _zz_387_[11];
  always @ (*) begin
    _zz_168_[19] = _zz_167_;
    _zz_168_[18] = _zz_167_;
    _zz_168_[17] = _zz_167_;
    _zz_168_[16] = _zz_167_;
    _zz_168_[15] = _zz_167_;
    _zz_168_[14] = _zz_167_;
    _zz_168_[13] = _zz_167_;
    _zz_168_[12] = _zz_167_;
    _zz_168_[11] = _zz_167_;
    _zz_168_[10] = _zz_167_;
    _zz_168_[9] = _zz_167_;
    _zz_168_[8] = _zz_167_;
    _zz_168_[7] = _zz_167_;
    _zz_168_[6] = _zz_167_;
    _zz_168_[5] = _zz_167_;
    _zz_168_[4] = _zz_167_;
    _zz_168_[3] = _zz_167_;
    _zz_168_[2] = _zz_167_;
    _zz_168_[1] = _zz_167_;
    _zz_168_[0] = _zz_167_;
  end

  assign _zz_169_ = _zz_388_[11];
  always @ (*) begin
    _zz_170_[19] = _zz_169_;
    _zz_170_[18] = _zz_169_;
    _zz_170_[17] = _zz_169_;
    _zz_170_[16] = _zz_169_;
    _zz_170_[15] = _zz_169_;
    _zz_170_[14] = _zz_169_;
    _zz_170_[13] = _zz_169_;
    _zz_170_[12] = _zz_169_;
    _zz_170_[11] = _zz_169_;
    _zz_170_[10] = _zz_169_;
    _zz_170_[9] = _zz_169_;
    _zz_170_[8] = _zz_169_;
    _zz_170_[7] = _zz_169_;
    _zz_170_[6] = _zz_169_;
    _zz_170_[5] = _zz_169_;
    _zz_170_[4] = _zz_169_;
    _zz_170_[3] = _zz_169_;
    _zz_170_[2] = _zz_169_;
    _zz_170_[1] = _zz_169_;
    _zz_170_[0] = _zz_169_;
  end

  always @ (*) begin
    case(execute_SRC2_CTRL)
      `Src2CtrlEnum_defaultEncoding_RS : begin
        _zz_171_ = execute_RS2;
      end
      `Src2CtrlEnum_defaultEncoding_IMI : begin
        _zz_171_ = {_zz_168_,execute_INSTRUCTION[31 : 20]};
      end
      `Src2CtrlEnum_defaultEncoding_IMS : begin
        _zz_171_ = {_zz_170_,{execute_INSTRUCTION[31 : 25],execute_INSTRUCTION[11 : 7]}};
      end
      default : begin
        _zz_171_ = _zz_47_;
      end
    endcase
  end

  assign _zz_49_ = _zz_171_;
  always @ (*) begin
    execute_SrcPlugin_addSub = _zz_389_;
    if(execute_SRC2_FORCE_ZERO)begin
      execute_SrcPlugin_addSub = execute_SRC1;
    end
  end

  assign execute_SrcPlugin_less = ((execute_SRC1[31] == execute_SRC2[31]) ? execute_SrcPlugin_addSub[31] : (execute_SRC_LESS_UNSIGNED ? execute_SRC2[31] : execute_SRC1[31]));
  assign _zz_46_ = execute_SrcPlugin_addSub;
  assign _zz_45_ = execute_SrcPlugin_addSub;
  assign _zz_44_ = execute_SrcPlugin_less;
  assign execute_FullBarrelShifterPlugin_amplitude = execute_SRC2[4 : 0];
  always @ (*) begin
    _zz_172_[0] = execute_SRC1[31];
    _zz_172_[1] = execute_SRC1[30];
    _zz_172_[2] = execute_SRC1[29];
    _zz_172_[3] = execute_SRC1[28];
    _zz_172_[4] = execute_SRC1[27];
    _zz_172_[5] = execute_SRC1[26];
    _zz_172_[6] = execute_SRC1[25];
    _zz_172_[7] = execute_SRC1[24];
    _zz_172_[8] = execute_SRC1[23];
    _zz_172_[9] = execute_SRC1[22];
    _zz_172_[10] = execute_SRC1[21];
    _zz_172_[11] = execute_SRC1[20];
    _zz_172_[12] = execute_SRC1[19];
    _zz_172_[13] = execute_SRC1[18];
    _zz_172_[14] = execute_SRC1[17];
    _zz_172_[15] = execute_SRC1[16];
    _zz_172_[16] = execute_SRC1[15];
    _zz_172_[17] = execute_SRC1[14];
    _zz_172_[18] = execute_SRC1[13];
    _zz_172_[19] = execute_SRC1[12];
    _zz_172_[20] = execute_SRC1[11];
    _zz_172_[21] = execute_SRC1[10];
    _zz_172_[22] = execute_SRC1[9];
    _zz_172_[23] = execute_SRC1[8];
    _zz_172_[24] = execute_SRC1[7];
    _zz_172_[25] = execute_SRC1[6];
    _zz_172_[26] = execute_SRC1[5];
    _zz_172_[27] = execute_SRC1[4];
    _zz_172_[28] = execute_SRC1[3];
    _zz_172_[29] = execute_SRC1[2];
    _zz_172_[30] = execute_SRC1[1];
    _zz_172_[31] = execute_SRC1[0];
  end

  assign execute_FullBarrelShifterPlugin_reversed = ((execute_SHIFT_CTRL == `ShiftCtrlEnum_defaultEncoding_SLL_1) ? _zz_172_ : execute_SRC1);
  assign _zz_42_ = _zz_397_;
  always @ (*) begin
    _zz_173_[0] = execute_SHIFT_RIGHT[31];
    _zz_173_[1] = execute_SHIFT_RIGHT[30];
    _zz_173_[2] = execute_SHIFT_RIGHT[29];
    _zz_173_[3] = execute_SHIFT_RIGHT[28];
    _zz_173_[4] = execute_SHIFT_RIGHT[27];
    _zz_173_[5] = execute_SHIFT_RIGHT[26];
    _zz_173_[6] = execute_SHIFT_RIGHT[25];
    _zz_173_[7] = execute_SHIFT_RIGHT[24];
    _zz_173_[8] = execute_SHIFT_RIGHT[23];
    _zz_173_[9] = execute_SHIFT_RIGHT[22];
    _zz_173_[10] = execute_SHIFT_RIGHT[21];
    _zz_173_[11] = execute_SHIFT_RIGHT[20];
    _zz_173_[12] = execute_SHIFT_RIGHT[19];
    _zz_173_[13] = execute_SHIFT_RIGHT[18];
    _zz_173_[14] = execute_SHIFT_RIGHT[17];
    _zz_173_[15] = execute_SHIFT_RIGHT[16];
    _zz_173_[16] = execute_SHIFT_RIGHT[15];
    _zz_173_[17] = execute_SHIFT_RIGHT[14];
    _zz_173_[18] = execute_SHIFT_RIGHT[13];
    _zz_173_[19] = execute_SHIFT_RIGHT[12];
    _zz_173_[20] = execute_SHIFT_RIGHT[11];
    _zz_173_[21] = execute_SHIFT_RIGHT[10];
    _zz_173_[22] = execute_SHIFT_RIGHT[9];
    _zz_173_[23] = execute_SHIFT_RIGHT[8];
    _zz_173_[24] = execute_SHIFT_RIGHT[7];
    _zz_173_[25] = execute_SHIFT_RIGHT[6];
    _zz_173_[26] = execute_SHIFT_RIGHT[5];
    _zz_173_[27] = execute_SHIFT_RIGHT[4];
    _zz_173_[28] = execute_SHIFT_RIGHT[3];
    _zz_173_[29] = execute_SHIFT_RIGHT[2];
    _zz_173_[30] = execute_SHIFT_RIGHT[1];
    _zz_173_[31] = execute_SHIFT_RIGHT[0];
  end

  always @ (*) begin
    _zz_174_ = 1'b0;
    if(_zz_311_)begin
      if(_zz_312_)begin
        if(_zz_180_)begin
          _zz_174_ = 1'b1;
        end
      end
    end
    if(_zz_313_)begin
      if(_zz_314_)begin
        if(_zz_182_)begin
          _zz_174_ = 1'b1;
        end
      end
    end
    if(_zz_315_)begin
      if(_zz_316_)begin
        if(_zz_184_)begin
          _zz_174_ = 1'b1;
        end
      end
    end
    if((! decode_RS1_USE))begin
      _zz_174_ = 1'b0;
    end
  end

  always @ (*) begin
    _zz_175_ = 1'b0;
    if(_zz_311_)begin
      if(_zz_312_)begin
        if(_zz_181_)begin
          _zz_175_ = 1'b1;
        end
      end
    end
    if(_zz_313_)begin
      if(_zz_314_)begin
        if(_zz_183_)begin
          _zz_175_ = 1'b1;
        end
      end
    end
    if(_zz_315_)begin
      if(_zz_316_)begin
        if(_zz_185_)begin
          _zz_175_ = 1'b1;
        end
      end
    end
    if((! decode_RS2_USE))begin
      _zz_175_ = 1'b0;
    end
  end

  assign _zz_176_ = (_zz_57_ && writeBack_arbitration_isFiring);
  assign _zz_180_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_181_ = (writeBack_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_182_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_183_ = (memory_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign _zz_184_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[19 : 15]);
  assign _zz_185_ = (execute_INSTRUCTION[11 : 7] == decode_INSTRUCTION[24 : 20]);
  assign execute_MulPlugin_a = execute_SRC1;
  assign execute_MulPlugin_b = execute_SRC2;
  always @ (*) begin
    case(_zz_317_)
      2'b01 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_aSigned = 1'b1;
      end
      default : begin
        execute_MulPlugin_aSigned = 1'b0;
      end
    endcase
  end

  always @ (*) begin
    case(_zz_317_)
      2'b01 : begin
        execute_MulPlugin_bSigned = 1'b1;
      end
      2'b10 : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
      default : begin
        execute_MulPlugin_bSigned = 1'b0;
      end
    endcase
  end

  assign execute_MulPlugin_aULow = execute_MulPlugin_a[15 : 0];
  assign execute_MulPlugin_bULow = execute_MulPlugin_b[15 : 0];
  assign execute_MulPlugin_aSLow = {1'b0,execute_MulPlugin_a[15 : 0]};
  assign execute_MulPlugin_bSLow = {1'b0,execute_MulPlugin_b[15 : 0]};
  assign execute_MulPlugin_aHigh = {(execute_MulPlugin_aSigned && execute_MulPlugin_a[31]),execute_MulPlugin_a[31 : 16]};
  assign execute_MulPlugin_bHigh = {(execute_MulPlugin_bSigned && execute_MulPlugin_b[31]),execute_MulPlugin_b[31 : 16]};
  assign _zz_39_ = (execute_MulPlugin_aULow * execute_MulPlugin_bULow);
  assign _zz_38_ = ($signed(execute_MulPlugin_aSLow) * $signed(execute_MulPlugin_bHigh));
  assign _zz_37_ = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bSLow));
  assign _zz_36_ = ($signed(execute_MulPlugin_aHigh) * $signed(execute_MulPlugin_bHigh));
  assign _zz_35_ = ($signed(_zz_399_) + $signed(_zz_407_));
  assign writeBack_MulPlugin_result = ($signed(_zz_408_) + $signed(_zz_409_));
  always @ (*) begin
    memory_DivPlugin_div_counter_willIncrement = 1'b0;
    if(_zz_290_)begin
      if(_zz_303_)begin
        memory_DivPlugin_div_counter_willIncrement = 1'b1;
      end
    end
  end

  always @ (*) begin
    memory_DivPlugin_div_counter_willClear = 1'b0;
    if(_zz_318_)begin
      memory_DivPlugin_div_counter_willClear = 1'b1;
    end
  end

  assign memory_DivPlugin_div_counter_willOverflowIfInc = (memory_DivPlugin_div_counter_value == (6'b100001));
  assign memory_DivPlugin_div_counter_willOverflow = (memory_DivPlugin_div_counter_willOverflowIfInc && memory_DivPlugin_div_counter_willIncrement);
  always @ (*) begin
    if(memory_DivPlugin_div_counter_willOverflow)begin
      memory_DivPlugin_div_counter_valueNext = (6'b000000);
    end else begin
      memory_DivPlugin_div_counter_valueNext = (memory_DivPlugin_div_counter_value + _zz_413_);
    end
    if(memory_DivPlugin_div_counter_willClear)begin
      memory_DivPlugin_div_counter_valueNext = (6'b000000);
    end
  end

  assign _zz_186_ = memory_DivPlugin_rs1[31 : 0];
  assign _zz_187_ = {memory_DivPlugin_accumulator[31 : 0],_zz_186_[31]};
  assign _zz_188_ = (_zz_187_ - _zz_414_);
  assign _zz_189_ = (memory_INSTRUCTION[13] ? memory_DivPlugin_accumulator[31 : 0] : memory_DivPlugin_rs1[31 : 0]);
  assign _zz_190_ = (execute_RS2[31] && execute_IS_RS2_SIGNED);
  assign _zz_191_ = (1'b0 || ((execute_IS_DIV && execute_RS1[31]) && execute_IS_RS1_SIGNED));
  always @ (*) begin
    _zz_192_[32] = (execute_IS_RS1_SIGNED && execute_RS1[31]);
    _zz_192_[31 : 0] = execute_RS1;
  end

  always @ (*) begin
    CsrPlugin_privilege = _zz_193_;
    if(CsrPlugin_forceMachineWire)begin
      CsrPlugin_privilege = (2'b11);
    end
  end

  assign CsrPlugin_sip_SEIP_OR = (CsrPlugin_sip_SEIP_SOFT || CsrPlugin_sip_SEIP_INPUT);
  assign _zz_194_ = (CsrPlugin_sip_STIP && CsrPlugin_sie_STIE);
  assign _zz_195_ = (CsrPlugin_sip_SSIP && CsrPlugin_sie_SSIE);
  assign _zz_196_ = (CsrPlugin_sip_SEIP_OR && CsrPlugin_sie_SEIE);
  assign _zz_197_ = (CsrPlugin_mip_MTIP && CsrPlugin_mie_MTIE);
  assign _zz_198_ = (CsrPlugin_mip_MSIP && CsrPlugin_mie_MSIE);
  assign _zz_199_ = (CsrPlugin_mip_MEIP && CsrPlugin_mie_MEIE);
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b11);
    case(CsrPlugin_exceptionPortCtrl_exceptionContext_code)
      4'b1000 : begin
        if(((1'b1 && CsrPlugin_medeleg_EU) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0010 : begin
        if(((1'b1 && CsrPlugin_medeleg_II) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0101 : begin
        if(((1'b1 && CsrPlugin_medeleg_LAF) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b1101 : begin
        if(((1'b1 && CsrPlugin_medeleg_LPF) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0100 : begin
        if(((1'b1 && CsrPlugin_medeleg_LAM) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0111 : begin
        if(((1'b1 && CsrPlugin_medeleg_SAF) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0001 : begin
        if(((1'b1 && CsrPlugin_medeleg_IAF) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b1001 : begin
        if(((1'b1 && CsrPlugin_medeleg_ES) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b1100 : begin
        if(((1'b1 && CsrPlugin_medeleg_IPF) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b1111 : begin
        if(((1'b1 && CsrPlugin_medeleg_SPF) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0110 : begin
        if(((1'b1 && CsrPlugin_medeleg_SAM) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      4'b0000 : begin
        if(((1'b1 && CsrPlugin_medeleg_IAM) && (! 1'b0)))begin
          CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped = (2'b01);
        end
      end
      default : begin
      end
    endcase
  end

  assign CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege = ((CsrPlugin_privilege < CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped) ? CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilegeUncapped : CsrPlugin_privilege);
  assign _zz_200_ = {decodeExceptionPort_valid,IBusCachedPlugin_decodeExceptionPort_valid};
  assign _zz_201_ = _zz_427_[0];
  assign _zz_202_ = {BranchPlugin_branchExceptionPort_valid,CsrPlugin_selfException_valid};
  assign _zz_203_ = _zz_429_[0];
  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_decode = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
    if(_zz_300_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b1;
    end
    if(decode_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_decode = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_execute = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
    if(_zz_302_)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b1;
    end
    if(execute_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_execute = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_memory = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
    if(memory_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_memory = 1'b0;
    end
  end

  always @ (*) begin
    CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b1;
    end
    if(writeBack_arbitration_isFlushed)begin
      CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack = 1'b0;
    end
  end

  assign CsrPlugin_exceptionPendings_0 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode;
  assign CsrPlugin_exceptionPendings_1 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute;
  assign CsrPlugin_exceptionPendings_2 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory;
  assign CsrPlugin_exceptionPendings_3 = CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack;
  assign CsrPlugin_exception = (CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack && CsrPlugin_allowException);
  always @ (*) begin
    CsrPlugin_pipelineLiberator_done = ((! ({writeBack_arbitration_isValid,{memory_arbitration_isValid,execute_arbitration_isValid}} != (3'b000))) && IBusCachedPlugin_pcValids_3);
    if(({CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack,{CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory,CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute}} != (3'b000)))begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
    if(CsrPlugin_hadException)begin
      CsrPlugin_pipelineLiberator_done = 1'b0;
    end
  end

  assign CsrPlugin_interruptJump = ((CsrPlugin_interrupt_valid && CsrPlugin_pipelineLiberator_done) && CsrPlugin_allowInterrupts);
  always @ (*) begin
    CsrPlugin_targetPrivilege = CsrPlugin_interrupt_targetPrivilege;
    if(CsrPlugin_hadException)begin
      CsrPlugin_targetPrivilege = CsrPlugin_exceptionPortCtrl_exceptionTargetPrivilege;
    end
  end

  always @ (*) begin
    CsrPlugin_trapCause = CsrPlugin_interrupt_code;
    if(CsrPlugin_hadException)begin
      CsrPlugin_trapCause = CsrPlugin_exceptionPortCtrl_exceptionContext_code;
    end
  end

  always @ (*) begin
    CsrPlugin_xtvec_mode = (2'bxx);
    case(CsrPlugin_targetPrivilege)
      2'b01 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_stvec_mode;
      end
      2'b11 : begin
        CsrPlugin_xtvec_mode = CsrPlugin_mtvec_mode;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    CsrPlugin_xtvec_base = (30'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(CsrPlugin_targetPrivilege)
      2'b01 : begin
        CsrPlugin_xtvec_base = CsrPlugin_stvec_base;
      end
      2'b11 : begin
        CsrPlugin_xtvec_base = CsrPlugin_mtvec_base;
      end
      default : begin
      end
    endcase
  end

  assign contextSwitching = CsrPlugin_jumpInterface_valid;
  assign _zz_33_ = (! (((decode_INSTRUCTION[14 : 13] == (2'b01)) && (decode_INSTRUCTION[19 : 15] == (5'b00000))) || ((decode_INSTRUCTION[14 : 13] == (2'b11)) && (decode_INSTRUCTION[19 : 15] == (5'b00000)))));
  assign _zz_32_ = (decode_INSTRUCTION[13 : 7] != (7'b0100000));
  always @ (*) begin
    execute_CsrPlugin_inWfi = 1'b0;
    if(_zz_301_)begin
      execute_CsrPlugin_inWfi = 1'b1;
    end
  end

  assign execute_CsrPlugin_blockedBySideEffects = ({writeBack_arbitration_isValid,memory_arbitration_isValid} != (2'b00));
  always @ (*) begin
    execute_CsrPlugin_illegalAccess = 1'b1;
    case(execute_CsrPlugin_csrAddress)
      12'b101111000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000011 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b111100010001 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b000101000010 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b111100010100 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b100111000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b000100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000010 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b101100000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b101110000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000101 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b000110000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b000101000001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b110011000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b101100000010 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b111100010011 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b000101000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b000100000101 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000011 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b111111000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b110000000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001100000001 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001101000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b111100010010 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b000101000011 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b110111000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b101110000010 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b000101000000 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b110010000000 : begin
        if(execute_CSR_READ_OPCODE)begin
          execute_CsrPlugin_illegalAccess = 1'b0;
        end
      end
      12'b001101000010 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      12'b000100000100 : begin
        execute_CsrPlugin_illegalAccess = 1'b0;
      end
      default : begin
      end
    endcase
    if((CsrPlugin_privilege < execute_CsrPlugin_csrAddress[9 : 8]))begin
      execute_CsrPlugin_illegalAccess = 1'b1;
    end
    if(((! execute_arbitration_isValid) || (! execute_IS_CSR)))begin
      execute_CsrPlugin_illegalAccess = 1'b0;
    end
  end

  always @ (*) begin
    execute_CsrPlugin_illegalInstruction = 1'b0;
    if((execute_arbitration_isValid && (execute_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_XRET)))begin
      if((CsrPlugin_privilege < execute_INSTRUCTION[29 : 28]))begin
        execute_CsrPlugin_illegalInstruction = 1'b1;
      end
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_valid = 1'b0;
    if(_zz_319_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
    if(_zz_320_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
    if(_zz_321_)begin
      CsrPlugin_selfException_valid = 1'b1;
    end
  end

  always @ (*) begin
    CsrPlugin_selfException_payload_code = (4'bxxxx);
    if(_zz_319_)begin
      CsrPlugin_selfException_payload_code = (4'b0010);
    end
    if(_zz_320_)begin
      case(CsrPlugin_privilege)
        2'b00 : begin
          CsrPlugin_selfException_payload_code = (4'b1000);
        end
        2'b01 : begin
          CsrPlugin_selfException_payload_code = (4'b1001);
        end
        default : begin
          CsrPlugin_selfException_payload_code = (4'b1011);
        end
      endcase
    end
    if(_zz_321_)begin
      CsrPlugin_selfException_payload_code = (4'b0011);
    end
  end

  assign CsrPlugin_selfException_payload_badAddr = execute_INSTRUCTION;
  always @ (*) begin
    execute_CsrPlugin_readData = (32'b00000000000000000000000000000000);
    case(execute_CsrPlugin_csrAddress)
      12'b101111000000 : begin
        execute_CsrPlugin_readData[31 : 0] = _zz_226_;
      end
      12'b001100000000 : begin
        execute_CsrPlugin_readData[12 : 11] = CsrPlugin_mstatus_MPP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mstatus_MPIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mstatus_MIE;
        execute_CsrPlugin_readData[8 : 8] = CsrPlugin_sstatus_SPP;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_sstatus_SPIE;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_sstatus_SIE;
        execute_CsrPlugin_readData[19 : 19] = MmuPlugin_status_mxr;
        execute_CsrPlugin_readData[18 : 18] = MmuPlugin_status_sum;
        execute_CsrPlugin_readData[17 : 17] = MmuPlugin_status_mprv;
      end
      12'b001100000011 : begin
        execute_CsrPlugin_readData[9 : 9] = CsrPlugin_mideleg_SE;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_mideleg_ST;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_mideleg_SS;
      end
      12'b111100010001 : begin
        execute_CsrPlugin_readData[0 : 0] = (1'b1);
      end
      12'b000101000010 : begin
        execute_CsrPlugin_readData[31 : 31] = CsrPlugin_scause_interrupt;
        execute_CsrPlugin_readData[3 : 0] = CsrPlugin_scause_exceptionCode;
      end
      12'b111100010100 : begin
      end
      12'b100111000000 : begin
        execute_CsrPlugin_readData[31 : 0] = _zz_228_;
      end
      12'b000100000000 : begin
        execute_CsrPlugin_readData[8 : 8] = CsrPlugin_sstatus_SPP;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_sstatus_SPIE;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_sstatus_SIE;
        execute_CsrPlugin_readData[19 : 19] = MmuPlugin_status_mxr;
        execute_CsrPlugin_readData[18 : 18] = MmuPlugin_status_sum;
        execute_CsrPlugin_readData[17 : 17] = MmuPlugin_status_mprv;
      end
      12'b001100000010 : begin
        execute_CsrPlugin_readData[8 : 8] = CsrPlugin_medeleg_EU;
        execute_CsrPlugin_readData[2 : 2] = CsrPlugin_medeleg_II;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_medeleg_LAF;
        execute_CsrPlugin_readData[13 : 13] = CsrPlugin_medeleg_LPF;
        execute_CsrPlugin_readData[4 : 4] = CsrPlugin_medeleg_LAM;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_medeleg_SAF;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_medeleg_IAF;
        execute_CsrPlugin_readData[9 : 9] = CsrPlugin_medeleg_ES;
        execute_CsrPlugin_readData[12 : 12] = CsrPlugin_medeleg_IPF;
        execute_CsrPlugin_readData[15 : 15] = CsrPlugin_medeleg_SPF;
        execute_CsrPlugin_readData[6 : 6] = CsrPlugin_medeleg_SAM;
        execute_CsrPlugin_readData[0 : 0] = CsrPlugin_medeleg_IAM;
      end
      12'b001101000001 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mepc;
      end
      12'b101100000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mcycle[31 : 0];
      end
      12'b101110000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mcycle[63 : 32];
      end
      12'b001101000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mip_MEIP;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mip_MTIP;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mip_MSIP;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_sip_STIP;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_sip_SSIP;
        execute_CsrPlugin_readData[9 : 9] = CsrPlugin_sip_SEIP_OR;
      end
      12'b001100000101 : begin
        execute_CsrPlugin_readData[31 : 2] = CsrPlugin_mtvec_base;
        execute_CsrPlugin_readData[1 : 0] = CsrPlugin_mtvec_mode;
      end
      12'b000110000000 : begin
        execute_CsrPlugin_readData[31 : 31] = MmuPlugin_satp_mode;
        execute_CsrPlugin_readData[19 : 0] = MmuPlugin_satp_ppn;
      end
      12'b000101000001 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_sepc;
      end
      12'b110011000000 : begin
        execute_CsrPlugin_readData[12 : 0] = (13'b1000000000000);
        execute_CsrPlugin_readData[25 : 20] = (6'b100000);
      end
      12'b101100000010 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_minstret[31 : 0];
      end
      12'b111100010011 : begin
        execute_CsrPlugin_readData[1 : 0] = (2'b11);
      end
      12'b000101000100 : begin
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_sip_STIP;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_sip_SSIP;
        execute_CsrPlugin_readData[9 : 9] = CsrPlugin_sip_SEIP_OR;
      end
      12'b000100000101 : begin
        execute_CsrPlugin_readData[31 : 2] = CsrPlugin_stvec_base;
        execute_CsrPlugin_readData[1 : 0] = CsrPlugin_stvec_mode;
      end
      12'b001101000011 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mtval;
      end
      12'b111111000000 : begin
        execute_CsrPlugin_readData[31 : 0] = _zz_227_;
      end
      12'b110000000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mcycle[31 : 0];
      end
      12'b001100000001 : begin
        execute_CsrPlugin_readData[31 : 30] = CsrPlugin_misa_base;
        execute_CsrPlugin_readData[25 : 0] = CsrPlugin_misa_extensions;
      end
      12'b001101000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mscratch;
      end
      12'b001100000100 : begin
        execute_CsrPlugin_readData[11 : 11] = CsrPlugin_mie_MEIE;
        execute_CsrPlugin_readData[7 : 7] = CsrPlugin_mie_MTIE;
        execute_CsrPlugin_readData[3 : 3] = CsrPlugin_mie_MSIE;
        execute_CsrPlugin_readData[9 : 9] = CsrPlugin_sie_SEIE;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_sie_STIE;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_sie_SSIE;
      end
      12'b111100010010 : begin
        execute_CsrPlugin_readData[1 : 0] = (2'b10);
      end
      12'b000101000011 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_stval;
      end
      12'b110111000000 : begin
        execute_CsrPlugin_readData[31 : 0] = _zz_229_;
      end
      12'b101110000010 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_minstret[63 : 32];
      end
      12'b000101000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_sscratch;
      end
      12'b110010000000 : begin
        execute_CsrPlugin_readData[31 : 0] = CsrPlugin_mcycle[63 : 32];
      end
      12'b001101000010 : begin
        execute_CsrPlugin_readData[31 : 31] = CsrPlugin_mcause_interrupt;
        execute_CsrPlugin_readData[3 : 0] = CsrPlugin_mcause_exceptionCode;
      end
      12'b000100000100 : begin
        execute_CsrPlugin_readData[9 : 9] = CsrPlugin_sie_SEIE;
        execute_CsrPlugin_readData[5 : 5] = CsrPlugin_sie_STIE;
        execute_CsrPlugin_readData[1 : 1] = CsrPlugin_sie_SSIE;
      end
      default : begin
      end
    endcase
  end

  assign execute_CsrPlugin_writeInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_WRITE_OPCODE);
  assign execute_CsrPlugin_readInstruction = ((execute_arbitration_isValid && execute_IS_CSR) && execute_CSR_READ_OPCODE);
  assign execute_CsrPlugin_writeEnable = ((execute_CsrPlugin_writeInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  assign execute_CsrPlugin_readEnable = ((execute_CsrPlugin_readInstruction && (! execute_CsrPlugin_blockedBySideEffects)) && (! execute_arbitration_isStuckByOthers));
  always @ (*) begin
    execute_CsrPlugin_readToWriteData = execute_CsrPlugin_readData;
    case(execute_CsrPlugin_csrAddress)
      12'b001101000100 : begin
        execute_CsrPlugin_readToWriteData[9 : 9] = CsrPlugin_sip_SEIP_SOFT;
      end
      12'b000101000100 : begin
        execute_CsrPlugin_readToWriteData[9 : 9] = CsrPlugin_sip_SEIP_SOFT;
      end
      default : begin
      end
    endcase
  end

  always @ (*) begin
    case(_zz_350_)
      1'b0 : begin
        execute_CsrPlugin_writeData = execute_SRC1;
      end
      default : begin
        execute_CsrPlugin_writeData = (execute_INSTRUCTION[12] ? (execute_CsrPlugin_readToWriteData & (~ execute_SRC1)) : (execute_CsrPlugin_readToWriteData | execute_SRC1));
      end
    endcase
  end

  assign execute_CsrPlugin_csrAddress = execute_INSTRUCTION[31 : 20];
  assign _zz_29_ = IBusCachedPlugin_decodePrediction_cmd_hadBranch;
  assign execute_BranchPlugin_eq = (execute_SRC1 == execute_SRC2);
  assign _zz_204_ = execute_INSTRUCTION[14 : 12];
  always @ (*) begin
    if((_zz_204_ == (3'b000))) begin
        _zz_205_ = execute_BranchPlugin_eq;
    end else if((_zz_204_ == (3'b001))) begin
        _zz_205_ = (! execute_BranchPlugin_eq);
    end else if((((_zz_204_ & (3'b101)) == (3'b101)))) begin
        _zz_205_ = (! execute_SRC_LESS);
    end else begin
        _zz_205_ = execute_SRC_LESS;
    end
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_INC : begin
        _zz_206_ = 1'b0;
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_206_ = 1'b1;
      end
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_206_ = 1'b1;
      end
      default : begin
        _zz_206_ = _zz_205_;
      end
    endcase
  end

  assign _zz_28_ = _zz_206_;
  assign _zz_207_ = _zz_431_[11];
  always @ (*) begin
    _zz_208_[19] = _zz_207_;
    _zz_208_[18] = _zz_207_;
    _zz_208_[17] = _zz_207_;
    _zz_208_[16] = _zz_207_;
    _zz_208_[15] = _zz_207_;
    _zz_208_[14] = _zz_207_;
    _zz_208_[13] = _zz_207_;
    _zz_208_[12] = _zz_207_;
    _zz_208_[11] = _zz_207_;
    _zz_208_[10] = _zz_207_;
    _zz_208_[9] = _zz_207_;
    _zz_208_[8] = _zz_207_;
    _zz_208_[7] = _zz_207_;
    _zz_208_[6] = _zz_207_;
    _zz_208_[5] = _zz_207_;
    _zz_208_[4] = _zz_207_;
    _zz_208_[3] = _zz_207_;
    _zz_208_[2] = _zz_207_;
    _zz_208_[1] = _zz_207_;
    _zz_208_[0] = _zz_207_;
  end

  assign _zz_209_ = _zz_432_[19];
  always @ (*) begin
    _zz_210_[10] = _zz_209_;
    _zz_210_[9] = _zz_209_;
    _zz_210_[8] = _zz_209_;
    _zz_210_[7] = _zz_209_;
    _zz_210_[6] = _zz_209_;
    _zz_210_[5] = _zz_209_;
    _zz_210_[4] = _zz_209_;
    _zz_210_[3] = _zz_209_;
    _zz_210_[2] = _zz_209_;
    _zz_210_[1] = _zz_209_;
    _zz_210_[0] = _zz_209_;
  end

  assign _zz_211_ = _zz_433_[11];
  always @ (*) begin
    _zz_212_[18] = _zz_211_;
    _zz_212_[17] = _zz_211_;
    _zz_212_[16] = _zz_211_;
    _zz_212_[15] = _zz_211_;
    _zz_212_[14] = _zz_211_;
    _zz_212_[13] = _zz_211_;
    _zz_212_[12] = _zz_211_;
    _zz_212_[11] = _zz_211_;
    _zz_212_[10] = _zz_211_;
    _zz_212_[9] = _zz_211_;
    _zz_212_[8] = _zz_211_;
    _zz_212_[7] = _zz_211_;
    _zz_212_[6] = _zz_211_;
    _zz_212_[5] = _zz_211_;
    _zz_212_[4] = _zz_211_;
    _zz_212_[3] = _zz_211_;
    _zz_212_[2] = _zz_211_;
    _zz_212_[1] = _zz_211_;
    _zz_212_[0] = _zz_211_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        _zz_213_ = (_zz_434_[1] ^ execute_RS1[1]);
      end
      `BranchCtrlEnum_defaultEncoding_JAL : begin
        _zz_213_ = _zz_435_[1];
      end
      default : begin
        _zz_213_ = _zz_436_[1];
      end
    endcase
  end

  assign execute_BranchPlugin_missAlignedTarget = (execute_BRANCH_COND_RESULT && _zz_213_);
  assign _zz_26_ = ((execute_PREDICTION_HAD_BRANCHED2 != execute_BRANCH_COND_RESULT) || execute_BranchPlugin_missAlignedTarget);
  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src1 = execute_RS1;
      end
      default : begin
        execute_BranchPlugin_branch_src1 = execute_PC;
      end
    endcase
  end

  assign _zz_214_ = _zz_437_[11];
  always @ (*) begin
    _zz_215_[19] = _zz_214_;
    _zz_215_[18] = _zz_214_;
    _zz_215_[17] = _zz_214_;
    _zz_215_[16] = _zz_214_;
    _zz_215_[15] = _zz_214_;
    _zz_215_[14] = _zz_214_;
    _zz_215_[13] = _zz_214_;
    _zz_215_[12] = _zz_214_;
    _zz_215_[11] = _zz_214_;
    _zz_215_[10] = _zz_214_;
    _zz_215_[9] = _zz_214_;
    _zz_215_[8] = _zz_214_;
    _zz_215_[7] = _zz_214_;
    _zz_215_[6] = _zz_214_;
    _zz_215_[5] = _zz_214_;
    _zz_215_[4] = _zz_214_;
    _zz_215_[3] = _zz_214_;
    _zz_215_[2] = _zz_214_;
    _zz_215_[1] = _zz_214_;
    _zz_215_[0] = _zz_214_;
  end

  always @ (*) begin
    case(execute_BRANCH_CTRL)
      `BranchCtrlEnum_defaultEncoding_JALR : begin
        execute_BranchPlugin_branch_src2 = {_zz_215_,execute_INSTRUCTION[31 : 20]};
      end
      default : begin
        execute_BranchPlugin_branch_src2 = ((execute_BRANCH_CTRL == `BranchCtrlEnum_defaultEncoding_JAL) ? {{_zz_217_,{{{_zz_716_,execute_INSTRUCTION[19 : 12]},execute_INSTRUCTION[20]},execute_INSTRUCTION[30 : 21]}},1'b0} : {{_zz_219_,{{{_zz_717_,_zz_718_},execute_INSTRUCTION[30 : 25]},execute_INSTRUCTION[11 : 8]}},1'b0});
        if(execute_PREDICTION_HAD_BRANCHED2)begin
          execute_BranchPlugin_branch_src2 = {29'd0, _zz_440_};
        end
      end
    endcase
  end

  assign _zz_216_ = _zz_438_[19];
  always @ (*) begin
    _zz_217_[10] = _zz_216_;
    _zz_217_[9] = _zz_216_;
    _zz_217_[8] = _zz_216_;
    _zz_217_[7] = _zz_216_;
    _zz_217_[6] = _zz_216_;
    _zz_217_[5] = _zz_216_;
    _zz_217_[4] = _zz_216_;
    _zz_217_[3] = _zz_216_;
    _zz_217_[2] = _zz_216_;
    _zz_217_[1] = _zz_216_;
    _zz_217_[0] = _zz_216_;
  end

  assign _zz_218_ = _zz_439_[11];
  always @ (*) begin
    _zz_219_[18] = _zz_218_;
    _zz_219_[17] = _zz_218_;
    _zz_219_[16] = _zz_218_;
    _zz_219_[15] = _zz_218_;
    _zz_219_[14] = _zz_218_;
    _zz_219_[13] = _zz_218_;
    _zz_219_[12] = _zz_218_;
    _zz_219_[11] = _zz_218_;
    _zz_219_[10] = _zz_218_;
    _zz_219_[9] = _zz_218_;
    _zz_219_[8] = _zz_218_;
    _zz_219_[7] = _zz_218_;
    _zz_219_[6] = _zz_218_;
    _zz_219_[5] = _zz_218_;
    _zz_219_[4] = _zz_218_;
    _zz_219_[3] = _zz_218_;
    _zz_219_[2] = _zz_218_;
    _zz_219_[1] = _zz_218_;
    _zz_219_[0] = _zz_218_;
  end

  assign execute_BranchPlugin_branchAdder = (execute_BranchPlugin_branch_src1 + execute_BranchPlugin_branch_src2);
  assign _zz_25_ = {execute_BranchPlugin_branchAdder[31 : 1],(1'b0)};
  assign BranchPlugin_jumpInterface_valid = ((execute_arbitration_isValid && execute_BRANCH_DO) && (! 1'b0));
  assign BranchPlugin_jumpInterface_payload = execute_BRANCH_CALC;
  always @ (*) begin
    BranchPlugin_branchExceptionPort_valid = (execute_arbitration_isValid && (execute_BRANCH_DO && execute_BRANCH_CALC[1]));
    if(1'b0)begin
      BranchPlugin_branchExceptionPort_valid = 1'b0;
    end
  end

  assign BranchPlugin_branchExceptionPort_payload_code = (4'b0000);
  assign BranchPlugin_branchExceptionPort_payload_badAddr = execute_BRANCH_CALC;
  assign IBusCachedPlugin_decodePrediction_rsp_wasWrong = BranchPlugin_jumpInterface_valid;
  assign MmuPlugin_ports_0_cacheHits_0 = ((MmuPlugin_ports_0_cache_0_valid && (MmuPlugin_ports_0_cache_0_virtualAddress_1 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_0_cache_0_superPage || (MmuPlugin_ports_0_cache_0_virtualAddress_0 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_0_cacheHits_1 = ((MmuPlugin_ports_0_cache_1_valid && (MmuPlugin_ports_0_cache_1_virtualAddress_1 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_0_cache_1_superPage || (MmuPlugin_ports_0_cache_1_virtualAddress_0 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_0_cacheHits_2 = ((MmuPlugin_ports_0_cache_2_valid && (MmuPlugin_ports_0_cache_2_virtualAddress_1 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_0_cache_2_superPage || (MmuPlugin_ports_0_cache_2_virtualAddress_0 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_0_cacheHits_3 = ((MmuPlugin_ports_0_cache_3_valid && (MmuPlugin_ports_0_cache_3_virtualAddress_1 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_0_cache_3_superPage || (MmuPlugin_ports_0_cache_3_virtualAddress_0 == DBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_0_cacheHit = ({MmuPlugin_ports_0_cacheHits_3,{MmuPlugin_ports_0_cacheHits_2,{MmuPlugin_ports_0_cacheHits_1,MmuPlugin_ports_0_cacheHits_0}}} != (4'b0000));
  assign _zz_220_ = (MmuPlugin_ports_0_cacheHits_1 || MmuPlugin_ports_0_cacheHits_3);
  assign _zz_221_ = (MmuPlugin_ports_0_cacheHits_2 || MmuPlugin_ports_0_cacheHits_3);
  assign _zz_222_ = {_zz_221_,_zz_220_};
  assign MmuPlugin_ports_0_cacheLine_valid = _zz_268_;
  assign MmuPlugin_ports_0_cacheLine_exception = _zz_269_;
  assign MmuPlugin_ports_0_cacheLine_superPage = _zz_270_;
  assign MmuPlugin_ports_0_cacheLine_virtualAddress_0 = _zz_271_;
  assign MmuPlugin_ports_0_cacheLine_virtualAddress_1 = _zz_272_;
  assign MmuPlugin_ports_0_cacheLine_physicalAddress_0 = _zz_273_;
  assign MmuPlugin_ports_0_cacheLine_physicalAddress_1 = _zz_274_;
  assign MmuPlugin_ports_0_cacheLine_allowRead = _zz_275_;
  assign MmuPlugin_ports_0_cacheLine_allowWrite = _zz_276_;
  assign MmuPlugin_ports_0_cacheLine_allowExecute = _zz_277_;
  assign MmuPlugin_ports_0_cacheLine_allowUser = _zz_278_;
  always @ (*) begin
    MmuPlugin_ports_0_entryToReplace_willIncrement = 1'b0;
    if(_zz_322_)begin
      if(_zz_323_)begin
        MmuPlugin_ports_0_entryToReplace_willIncrement = 1'b1;
      end
    end
  end

  assign MmuPlugin_ports_0_entryToReplace_willClear = 1'b0;
  assign MmuPlugin_ports_0_entryToReplace_willOverflowIfInc = (MmuPlugin_ports_0_entryToReplace_value == (2'b11));
  assign MmuPlugin_ports_0_entryToReplace_willOverflow = (MmuPlugin_ports_0_entryToReplace_willOverflowIfInc && MmuPlugin_ports_0_entryToReplace_willIncrement);
  always @ (*) begin
    MmuPlugin_ports_0_entryToReplace_valueNext = (MmuPlugin_ports_0_entryToReplace_value + _zz_442_);
    if(MmuPlugin_ports_0_entryToReplace_willClear)begin
      MmuPlugin_ports_0_entryToReplace_valueNext = (2'b00);
    end
  end

  always @ (*) begin
    MmuPlugin_ports_0_requireMmuLockup = ((1'b1 && (! DBusCachedPlugin_mmuBus_cmd_bypassTranslation)) && MmuPlugin_satp_mode);
    if(((! MmuPlugin_status_mprv) && (CsrPlugin_privilege == (2'b11))))begin
      MmuPlugin_ports_0_requireMmuLockup = 1'b0;
    end
    if((CsrPlugin_privilege == (2'b11)))begin
      if(((! MmuPlugin_status_mprv) || (CsrPlugin_mstatus_MPP == (2'b11))))begin
        MmuPlugin_ports_0_requireMmuLockup = 1'b0;
      end
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_0_requireMmuLockup)begin
      DBusCachedPlugin_mmuBus_rsp_physicalAddress = {{MmuPlugin_ports_0_cacheLine_physicalAddress_1,(MmuPlugin_ports_0_cacheLine_superPage ? DBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12] : MmuPlugin_ports_0_cacheLine_physicalAddress_0)},DBusCachedPlugin_mmuBus_cmd_virtualAddress[11 : 0]};
    end else begin
      DBusCachedPlugin_mmuBus_rsp_physicalAddress = DBusCachedPlugin_mmuBus_cmd_virtualAddress;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_0_requireMmuLockup)begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = (MmuPlugin_ports_0_cacheLine_allowRead || (MmuPlugin_status_mxr && MmuPlugin_ports_0_cacheLine_allowExecute));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_0_requireMmuLockup)begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = MmuPlugin_ports_0_cacheLine_allowWrite;
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_0_requireMmuLockup)begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = MmuPlugin_ports_0_cacheLine_allowExecute;
    end else begin
      DBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_0_requireMmuLockup)begin
      DBusCachedPlugin_mmuBus_rsp_exception = (MmuPlugin_ports_0_cacheHit && ((MmuPlugin_ports_0_cacheLine_exception || ((MmuPlugin_ports_0_cacheLine_allowUser && (CsrPlugin_privilege == (2'b01))) && (! MmuPlugin_status_sum))) || ((! MmuPlugin_ports_0_cacheLine_allowUser) && (CsrPlugin_privilege == (2'b00)))));
    end else begin
      DBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_0_requireMmuLockup)begin
      DBusCachedPlugin_mmuBus_rsp_refilling = (! MmuPlugin_ports_0_cacheHit);
    end else begin
      DBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
    end
  end

  assign DBusCachedPlugin_mmuBus_rsp_isIoAccess = (((DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1011)) || (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1110))) || (DBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1111)));
  assign MmuPlugin_ports_1_cacheHits_0 = ((MmuPlugin_ports_1_cache_0_valid && (MmuPlugin_ports_1_cache_0_virtualAddress_1 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_1_cache_0_superPage || (MmuPlugin_ports_1_cache_0_virtualAddress_0 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_1_cacheHits_1 = ((MmuPlugin_ports_1_cache_1_valid && (MmuPlugin_ports_1_cache_1_virtualAddress_1 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_1_cache_1_superPage || (MmuPlugin_ports_1_cache_1_virtualAddress_0 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_1_cacheHits_2 = ((MmuPlugin_ports_1_cache_2_valid && (MmuPlugin_ports_1_cache_2_virtualAddress_1 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_1_cache_2_superPage || (MmuPlugin_ports_1_cache_2_virtualAddress_0 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_1_cacheHits_3 = ((MmuPlugin_ports_1_cache_3_valid && (MmuPlugin_ports_1_cache_3_virtualAddress_1 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22])) && (MmuPlugin_ports_1_cache_3_superPage || (MmuPlugin_ports_1_cache_3_virtualAddress_0 == IBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12])));
  assign MmuPlugin_ports_1_cacheHit = ({MmuPlugin_ports_1_cacheHits_3,{MmuPlugin_ports_1_cacheHits_2,{MmuPlugin_ports_1_cacheHits_1,MmuPlugin_ports_1_cacheHits_0}}} != (4'b0000));
  assign _zz_223_ = (MmuPlugin_ports_1_cacheHits_1 || MmuPlugin_ports_1_cacheHits_3);
  assign _zz_224_ = (MmuPlugin_ports_1_cacheHits_2 || MmuPlugin_ports_1_cacheHits_3);
  assign _zz_225_ = {_zz_224_,_zz_223_};
  assign MmuPlugin_ports_1_cacheLine_valid = _zz_279_;
  assign MmuPlugin_ports_1_cacheLine_exception = _zz_280_;
  assign MmuPlugin_ports_1_cacheLine_superPage = _zz_281_;
  assign MmuPlugin_ports_1_cacheLine_virtualAddress_0 = _zz_282_;
  assign MmuPlugin_ports_1_cacheLine_virtualAddress_1 = _zz_283_;
  assign MmuPlugin_ports_1_cacheLine_physicalAddress_0 = _zz_284_;
  assign MmuPlugin_ports_1_cacheLine_physicalAddress_1 = _zz_285_;
  assign MmuPlugin_ports_1_cacheLine_allowRead = _zz_286_;
  assign MmuPlugin_ports_1_cacheLine_allowWrite = _zz_287_;
  assign MmuPlugin_ports_1_cacheLine_allowExecute = _zz_288_;
  assign MmuPlugin_ports_1_cacheLine_allowUser = _zz_289_;
  always @ (*) begin
    MmuPlugin_ports_1_entryToReplace_willIncrement = 1'b0;
    if(_zz_322_)begin
      if(_zz_324_)begin
        MmuPlugin_ports_1_entryToReplace_willIncrement = 1'b1;
      end
    end
  end

  assign MmuPlugin_ports_1_entryToReplace_willClear = 1'b0;
  assign MmuPlugin_ports_1_entryToReplace_willOverflowIfInc = (MmuPlugin_ports_1_entryToReplace_value == (2'b11));
  assign MmuPlugin_ports_1_entryToReplace_willOverflow = (MmuPlugin_ports_1_entryToReplace_willOverflowIfInc && MmuPlugin_ports_1_entryToReplace_willIncrement);
  always @ (*) begin
    MmuPlugin_ports_1_entryToReplace_valueNext = (MmuPlugin_ports_1_entryToReplace_value + _zz_444_);
    if(MmuPlugin_ports_1_entryToReplace_willClear)begin
      MmuPlugin_ports_1_entryToReplace_valueNext = (2'b00);
    end
  end

  always @ (*) begin
    MmuPlugin_ports_1_requireMmuLockup = ((1'b1 && (! IBusCachedPlugin_mmuBus_cmd_bypassTranslation)) && MmuPlugin_satp_mode);
    if(((! MmuPlugin_status_mprv) && (CsrPlugin_privilege == (2'b11))))begin
      MmuPlugin_ports_1_requireMmuLockup = 1'b0;
    end
    if((CsrPlugin_privilege == (2'b11)))begin
      MmuPlugin_ports_1_requireMmuLockup = 1'b0;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_1_requireMmuLockup)begin
      IBusCachedPlugin_mmuBus_rsp_physicalAddress = {{MmuPlugin_ports_1_cacheLine_physicalAddress_1,(MmuPlugin_ports_1_cacheLine_superPage ? IBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12] : MmuPlugin_ports_1_cacheLine_physicalAddress_0)},IBusCachedPlugin_mmuBus_cmd_virtualAddress[11 : 0]};
    end else begin
      IBusCachedPlugin_mmuBus_rsp_physicalAddress = IBusCachedPlugin_mmuBus_cmd_virtualAddress;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_1_requireMmuLockup)begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = (MmuPlugin_ports_1_cacheLine_allowRead || (MmuPlugin_status_mxr && MmuPlugin_ports_1_cacheLine_allowExecute));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowRead = 1'b1;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_1_requireMmuLockup)begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = MmuPlugin_ports_1_cacheLine_allowWrite;
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowWrite = 1'b1;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_1_requireMmuLockup)begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = MmuPlugin_ports_1_cacheLine_allowExecute;
    end else begin
      IBusCachedPlugin_mmuBus_rsp_allowExecute = 1'b1;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_1_requireMmuLockup)begin
      IBusCachedPlugin_mmuBus_rsp_exception = (MmuPlugin_ports_1_cacheHit && ((MmuPlugin_ports_1_cacheLine_exception || ((MmuPlugin_ports_1_cacheLine_allowUser && (CsrPlugin_privilege == (2'b01))) && (! MmuPlugin_status_sum))) || ((! MmuPlugin_ports_1_cacheLine_allowUser) && (CsrPlugin_privilege == (2'b00)))));
    end else begin
      IBusCachedPlugin_mmuBus_rsp_exception = 1'b0;
    end
  end

  always @ (*) begin
    if(MmuPlugin_ports_1_requireMmuLockup)begin
      IBusCachedPlugin_mmuBus_rsp_refilling = (! MmuPlugin_ports_1_cacheHit);
    end else begin
      IBusCachedPlugin_mmuBus_rsp_refilling = 1'b0;
    end
  end

  assign IBusCachedPlugin_mmuBus_rsp_isIoAccess = (((IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1011)) || (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1110))) || (IBusCachedPlugin_mmuBus_rsp_physicalAddress[31 : 28] == (4'b1111)));
  assign MmuPlugin_shared_dBusRsp_pte_V = _zz_445_[0];
  assign MmuPlugin_shared_dBusRsp_pte_R = _zz_446_[0];
  assign MmuPlugin_shared_dBusRsp_pte_W = _zz_447_[0];
  assign MmuPlugin_shared_dBusRsp_pte_X = _zz_448_[0];
  assign MmuPlugin_shared_dBusRsp_pte_U = _zz_449_[0];
  assign MmuPlugin_shared_dBusRsp_pte_G = _zz_450_[0];
  assign MmuPlugin_shared_dBusRsp_pte_A = _zz_451_[0];
  assign MmuPlugin_shared_dBusRsp_pte_D = _zz_452_[0];
  assign MmuPlugin_shared_dBusRsp_pte_RSW = MmuPlugin_dBusAccess_rsp_payload_data[9 : 8];
  assign MmuPlugin_shared_dBusRsp_pte_PPN0 = MmuPlugin_dBusAccess_rsp_payload_data[19 : 10];
  assign MmuPlugin_shared_dBusRsp_pte_PPN1 = MmuPlugin_dBusAccess_rsp_payload_data[31 : 20];
  assign MmuPlugin_shared_dBusRsp_exception = (((! MmuPlugin_shared_dBusRsp_pte_V) || ((! MmuPlugin_shared_dBusRsp_pte_R) && MmuPlugin_shared_dBusRsp_pte_W)) || MmuPlugin_dBusAccess_rsp_payload_error);
  assign MmuPlugin_shared_dBusRsp_leaf = (MmuPlugin_shared_dBusRsp_pte_R || MmuPlugin_shared_dBusRsp_pte_X);
  always @ (*) begin
    MmuPlugin_dBusAccess_cmd_valid = 1'b0;
    case(MmuPlugin_shared_state_1_)
      `MmuPlugin_shared_State_defaultEncoding_IDLE : begin
      end
      `MmuPlugin_shared_State_defaultEncoding_L1_CMD : begin
        MmuPlugin_dBusAccess_cmd_valid = 1'b1;
      end
      `MmuPlugin_shared_State_defaultEncoding_L1_RSP : begin
      end
      `MmuPlugin_shared_State_defaultEncoding_L0_CMD : begin
        MmuPlugin_dBusAccess_cmd_valid = 1'b1;
      end
      default : begin
      end
    endcase
  end

  assign MmuPlugin_dBusAccess_cmd_payload_write = 1'b0;
  assign MmuPlugin_dBusAccess_cmd_payload_size = (2'b10);
  always @ (*) begin
    MmuPlugin_dBusAccess_cmd_payload_address = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
    case(MmuPlugin_shared_state_1_)
      `MmuPlugin_shared_State_defaultEncoding_IDLE : begin
      end
      `MmuPlugin_shared_State_defaultEncoding_L1_CMD : begin
        MmuPlugin_dBusAccess_cmd_payload_address = {{MmuPlugin_satp_ppn,MmuPlugin_shared_vpn_1},(2'b00)};
      end
      `MmuPlugin_shared_State_defaultEncoding_L1_RSP : begin
      end
      `MmuPlugin_shared_State_defaultEncoding_L0_CMD : begin
        MmuPlugin_dBusAccess_cmd_payload_address = {{{MmuPlugin_shared_pteBuffer_PPN1[9 : 0],MmuPlugin_shared_pteBuffer_PPN0},MmuPlugin_shared_vpn_0},(2'b00)};
      end
      default : begin
      end
    endcase
  end

  assign MmuPlugin_dBusAccess_cmd_payload_data = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
  assign MmuPlugin_dBusAccess_cmd_payload_writeMask = (4'bxxxx);
  assign DBusCachedPlugin_mmuBus_busy = ((MmuPlugin_shared_state_1_ != `MmuPlugin_shared_State_defaultEncoding_IDLE) && (MmuPlugin_shared_portId == (1'b1)));
  assign IBusCachedPlugin_mmuBus_busy = ((MmuPlugin_shared_state_1_ != `MmuPlugin_shared_State_defaultEncoding_IDLE) && (MmuPlugin_shared_portId == (1'b0)));
  assign _zz_227_ = (_zz_226_ & externalInterruptArray_regNext);
  assign externalInterrupt = (_zz_227_ != (32'b00000000000000000000000000000000));
  assign _zz_229_ = (_zz_228_ & externalInterruptArray_regNext);
  assign externalInterruptS = (_zz_229_ != (32'b00000000000000000000000000000000));
  assign _zz_24_ = decode_SRC2_CTRL;
  assign _zz_22_ = _zz_67_;
  assign _zz_48_ = decode_to_execute_SRC2_CTRL;
  assign _zz_21_ = decode_ENV_CTRL;
  assign _zz_18_ = execute_ENV_CTRL;
  assign _zz_16_ = memory_ENV_CTRL;
  assign _zz_19_ = _zz_70_;
  assign _zz_31_ = decode_to_execute_ENV_CTRL;
  assign _zz_30_ = execute_to_memory_ENV_CTRL;
  assign _zz_34_ = memory_to_writeBack_ENV_CTRL;
  assign _zz_14_ = decode_SHIFT_CTRL;
  assign _zz_12_ = _zz_62_;
  assign _zz_43_ = decode_to_execute_SHIFT_CTRL;
  assign _zz_11_ = decode_BRANCH_CTRL;
  assign _zz_96_ = _zz_85_;
  assign _zz_27_ = decode_to_execute_BRANCH_CTRL;
  assign _zz_9_ = decode_ALU_BITWISE_CTRL;
  assign _zz_7_ = _zz_86_;
  assign _zz_55_ = decode_to_execute_ALU_BITWISE_CTRL;
  assign _zz_6_ = decode_ALU_CTRL;
  assign _zz_4_ = _zz_83_;
  assign _zz_53_ = decode_to_execute_ALU_CTRL;
  assign _zz_3_ = decode_SRC1_CTRL;
  assign _zz_1_ = _zz_66_;
  assign _zz_50_ = decode_to_execute_SRC1_CTRL;
  assign decode_arbitration_isFlushed = (({writeBack_arbitration_flushNext,{memory_arbitration_flushNext,execute_arbitration_flushNext}} != (3'b000)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,{execute_arbitration_flushIt,decode_arbitration_flushIt}}} != (4'b0000)));
  assign execute_arbitration_isFlushed = (({writeBack_arbitration_flushNext,memory_arbitration_flushNext} != (2'b00)) || ({writeBack_arbitration_flushIt,{memory_arbitration_flushIt,execute_arbitration_flushIt}} != (3'b000)));
  assign memory_arbitration_isFlushed = ((writeBack_arbitration_flushNext != (1'b0)) || ({writeBack_arbitration_flushIt,memory_arbitration_flushIt} != (2'b00)));
  assign writeBack_arbitration_isFlushed = (1'b0 || (writeBack_arbitration_flushIt != (1'b0)));
  assign decode_arbitration_isStuckByOthers = (decode_arbitration_haltByOther || (((1'b0 || execute_arbitration_isStuck) || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign decode_arbitration_isStuck = (decode_arbitration_haltItself || decode_arbitration_isStuckByOthers);
  assign decode_arbitration_isMoving = ((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt));
  assign decode_arbitration_isFiring = ((decode_arbitration_isValid && (! decode_arbitration_isStuck)) && (! decode_arbitration_removeIt));
  assign execute_arbitration_isStuckByOthers = (execute_arbitration_haltByOther || ((1'b0 || memory_arbitration_isStuck) || writeBack_arbitration_isStuck));
  assign execute_arbitration_isStuck = (execute_arbitration_haltItself || execute_arbitration_isStuckByOthers);
  assign execute_arbitration_isMoving = ((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt));
  assign execute_arbitration_isFiring = ((execute_arbitration_isValid && (! execute_arbitration_isStuck)) && (! execute_arbitration_removeIt));
  assign memory_arbitration_isStuckByOthers = (memory_arbitration_haltByOther || (1'b0 || writeBack_arbitration_isStuck));
  assign memory_arbitration_isStuck = (memory_arbitration_haltItself || memory_arbitration_isStuckByOthers);
  assign memory_arbitration_isMoving = ((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt));
  assign memory_arbitration_isFiring = ((memory_arbitration_isValid && (! memory_arbitration_isStuck)) && (! memory_arbitration_removeIt));
  assign writeBack_arbitration_isStuckByOthers = (writeBack_arbitration_haltByOther || 1'b0);
  assign writeBack_arbitration_isStuck = (writeBack_arbitration_haltItself || writeBack_arbitration_isStuckByOthers);
  assign writeBack_arbitration_isMoving = ((! writeBack_arbitration_isStuck) && (! writeBack_arbitration_removeIt));
  assign writeBack_arbitration_isFiring = ((writeBack_arbitration_isValid && (! writeBack_arbitration_isStuck)) && (! writeBack_arbitration_removeIt));
  assign iBusWishbone_ADR = {_zz_499_,_zz_230_};
  assign iBusWishbone_CTI = ((_zz_230_ == (3'b111)) ? (3'b111) : (3'b010));
  assign iBusWishbone_BTE = (2'b00);
  assign iBusWishbone_SEL = (4'b1111);
  assign iBusWishbone_WE = 1'b0;
  assign iBusWishbone_DAT_MOSI = (32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx);
  always @ (*) begin
    iBusWishbone_CYC = 1'b0;
    if(_zz_325_)begin
      iBusWishbone_CYC = 1'b1;
    end
  end

  always @ (*) begin
    iBusWishbone_STB = 1'b0;
    if(_zz_325_)begin
      iBusWishbone_STB = 1'b1;
    end
  end

  assign iBus_cmd_ready = (iBus_cmd_valid && iBusWishbone_ACK);
  assign iBus_rsp_valid = _zz_231_;
  assign iBus_rsp_payload_data = iBusWishbone_DAT_MISO_regNext;
  assign iBus_rsp_payload_error = 1'b0;
  assign _zz_237_ = (dBus_cmd_payload_length != (3'b000));
  assign _zz_233_ = dBus_cmd_valid;
  assign _zz_235_ = dBus_cmd_payload_wr;
  assign _zz_236_ = (_zz_232_ == dBus_cmd_payload_length);
  assign dBus_cmd_ready = (_zz_234_ && (_zz_235_ || _zz_236_));
  assign dBusWishbone_ADR = ((_zz_237_ ? {{dBus_cmd_payload_address[31 : 5],_zz_232_},(2'b00)} : {dBus_cmd_payload_address[31 : 2],(2'b00)}) >>> 2);
  assign dBusWishbone_CTI = (_zz_237_ ? (_zz_236_ ? (3'b111) : (3'b010)) : (3'b000));
  assign dBusWishbone_BTE = (2'b00);
  assign dBusWishbone_SEL = (_zz_235_ ? dBus_cmd_payload_mask : (4'b1111));
  assign dBusWishbone_WE = _zz_235_;
  assign dBusWishbone_DAT_MOSI = dBus_cmd_payload_data;
  assign _zz_234_ = (_zz_233_ && dBusWishbone_ACK);
  assign dBusWishbone_CYC = _zz_233_;
  assign dBusWishbone_STB = _zz_233_;
  assign dBus_rsp_valid = _zz_238_;
  assign dBus_rsp_payload_data = dBusWishbone_DAT_MISO_regNext;
  assign dBus_rsp_payload_error = 1'b0;
  always @ (posedge clk) begin
    if(reset) begin
      IBusCachedPlugin_fetchPc_pcReg <= externalResetVector;
      IBusCachedPlugin_fetchPc_booted <= 1'b0;
      IBusCachedPlugin_fetchPc_inc <= 1'b0;
      _zz_113_ <= 1'b0;
      _zz_115_ <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      IBusCachedPlugin_injector_decodeRemoved <= 1'b0;
      IBusCachedPlugin_rspCounter <= _zz_128_;
      IBusCachedPlugin_rspCounter <= (32'b00000000000000000000000000000000);
      _zz_129_ <= 1'b0;
      _zz_136_ <= 1'b0;
      DBusCachedPlugin_rspCounter <= _zz_143_;
      DBusCachedPlugin_rspCounter <= (32'b00000000000000000000000000000000);
      _zz_164_ <= 1'b1;
      _zz_177_ <= 1'b0;
      memory_DivPlugin_div_counter_value <= (6'b000000);
      _zz_193_ <= (2'b11);
      CsrPlugin_misa_base <= (2'b01);
      CsrPlugin_misa_extensions <= (26'b00000000000000000000000000);
      CsrPlugin_mtvec_mode <= (2'b00);
      CsrPlugin_mtvec_base <= (30'b000000000000000000000000000000);
      CsrPlugin_mstatus_MIE <= 1'b0;
      CsrPlugin_mstatus_MPIE <= 1'b0;
      CsrPlugin_mstatus_MPP <= (2'b11);
      CsrPlugin_mie_MEIE <= 1'b0;
      CsrPlugin_mie_MTIE <= 1'b0;
      CsrPlugin_mie_MSIE <= 1'b0;
      CsrPlugin_medeleg_IAM <= 1'b0;
      CsrPlugin_medeleg_IAF <= 1'b0;
      CsrPlugin_medeleg_II <= 1'b0;
      CsrPlugin_medeleg_LAM <= 1'b0;
      CsrPlugin_medeleg_LAF <= 1'b0;
      CsrPlugin_medeleg_SAM <= 1'b0;
      CsrPlugin_medeleg_SAF <= 1'b0;
      CsrPlugin_medeleg_EU <= 1'b0;
      CsrPlugin_medeleg_ES <= 1'b0;
      CsrPlugin_medeleg_IPF <= 1'b0;
      CsrPlugin_medeleg_LPF <= 1'b0;
      CsrPlugin_medeleg_SPF <= 1'b0;
      CsrPlugin_mideleg_ST <= 1'b0;
      CsrPlugin_mideleg_SE <= 1'b0;
      CsrPlugin_mideleg_SS <= 1'b0;
      CsrPlugin_sstatus_SIE <= 1'b0;
      CsrPlugin_sstatus_SPIE <= 1'b0;
      CsrPlugin_sstatus_SPP <= (1'b1);
      CsrPlugin_sip_SEIP_SOFT <= 1'b0;
      CsrPlugin_sip_STIP <= 1'b0;
      CsrPlugin_sip_SSIP <= 1'b0;
      CsrPlugin_sie_SEIE <= 1'b0;
      CsrPlugin_sie_STIE <= 1'b0;
      CsrPlugin_sie_SSIE <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= 1'b0;
      CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      CsrPlugin_interrupt_valid <= 1'b0;
      CsrPlugin_lastStageWasWfi <= 1'b0;
      CsrPlugin_hadException <= 1'b0;
      execute_CsrPlugin_wfiWake <= 1'b0;
      MmuPlugin_status_sum <= 1'b0;
      MmuPlugin_status_mxr <= 1'b0;
      MmuPlugin_status_mprv <= 1'b0;
      MmuPlugin_satp_mode <= 1'b0;
      MmuPlugin_ports_0_cache_0_valid <= 1'b0;
      MmuPlugin_ports_0_cache_1_valid <= 1'b0;
      MmuPlugin_ports_0_cache_2_valid <= 1'b0;
      MmuPlugin_ports_0_cache_3_valid <= 1'b0;
      MmuPlugin_ports_0_entryToReplace_value <= (2'b00);
      MmuPlugin_ports_1_cache_0_valid <= 1'b0;
      MmuPlugin_ports_1_cache_1_valid <= 1'b0;
      MmuPlugin_ports_1_cache_2_valid <= 1'b0;
      MmuPlugin_ports_1_cache_3_valid <= 1'b0;
      MmuPlugin_ports_1_entryToReplace_value <= (2'b00);
      MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_IDLE;
      _zz_226_ <= (32'b00000000000000000000000000000000);
      _zz_228_ <= (32'b00000000000000000000000000000000);
      execute_arbitration_isValid <= 1'b0;
      memory_arbitration_isValid <= 1'b0;
      writeBack_arbitration_isValid <= 1'b0;
      execute_to_memory_IS_DBUS_SHARING <= 1'b0;
      memory_to_writeBack_IS_DBUS_SHARING <= 1'b0;
      memory_to_writeBack_REGFILE_WRITE_DATA <= (32'b00000000000000000000000000000000);
      memory_to_writeBack_INSTRUCTION <= (32'b00000000000000000000000000000000);
      _zz_230_ <= (3'b000);
      _zz_231_ <= 1'b0;
      _zz_232_ <= (3'b000);
      _zz_238_ <= 1'b0;
    end else begin
      IBusCachedPlugin_fetchPc_booted <= 1'b1;
      if((IBusCachedPlugin_fetchPc_corrected || IBusCachedPlugin_fetchPc_pcRegPropagate))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_output_valid && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b1;
      end
      if(((! IBusCachedPlugin_fetchPc_output_valid) && IBusCachedPlugin_fetchPc_output_ready))begin
        IBusCachedPlugin_fetchPc_inc <= 1'b0;
      end
      if((IBusCachedPlugin_fetchPc_booted && ((IBusCachedPlugin_fetchPc_output_ready || IBusCachedPlugin_fetcherflushIt) || IBusCachedPlugin_fetchPc_pcRegPropagate)))begin
        IBusCachedPlugin_fetchPc_pcReg <= IBusCachedPlugin_fetchPc_pc;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_113_ <= 1'b0;
      end
      if(_zz_111_)begin
        _zz_113_ <= IBusCachedPlugin_iBusRsp_stages_0_output_valid;
      end
      if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
        _zz_115_ <= IBusCachedPlugin_iBusRsp_stages_1_output_valid;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        _zz_115_ <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_stages_1_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_0 <= 1'b1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if((! (! IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready)))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= IBusCachedPlugin_injector_nextPcCalc_valids_0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_1 <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if((! execute_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= IBusCachedPlugin_injector_nextPcCalc_valids_1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_2 <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= IBusCachedPlugin_injector_nextPcCalc_valids_2;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_3 <= 1'b0;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if((! writeBack_arbitration_isStuck))begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= IBusCachedPlugin_injector_nextPcCalc_valids_3;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_nextPcCalc_valids_4 <= 1'b0;
      end
      if(decode_arbitration_removeIt)begin
        IBusCachedPlugin_injector_decodeRemoved <= 1'b1;
      end
      if(IBusCachedPlugin_fetcherflushIt)begin
        IBusCachedPlugin_injector_decodeRemoved <= 1'b0;
      end
      if(iBus_rsp_valid)begin
        IBusCachedPlugin_rspCounter <= (IBusCachedPlugin_rspCounter + (32'b00000000000000000000000000000001));
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        _zz_129_ <= 1'b0;
      end
      if(_zz_326_)begin
        _zz_129_ <= dataCache_1__io_mem_cmd_valid;
      end
      if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
        _zz_136_ <= dataCache_1__io_mem_cmd_s2mPipe_valid;
      end
      if(dBus_rsp_valid)begin
        DBusCachedPlugin_rspCounter <= (DBusCachedPlugin_rspCounter + (32'b00000000000000000000000000000001));
      end
      _zz_164_ <= 1'b0;
      _zz_177_ <= _zz_176_;
      memory_DivPlugin_div_counter_value <= memory_DivPlugin_div_counter_valueNext;
      if((! decode_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= 1'b0;
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_decode <= CsrPlugin_exceptionPortCtrl_exceptionValids_decode;
      end
      if((! execute_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= (CsrPlugin_exceptionPortCtrl_exceptionValids_decode && (! decode_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_execute <= CsrPlugin_exceptionPortCtrl_exceptionValids_execute;
      end
      if((! memory_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= (CsrPlugin_exceptionPortCtrl_exceptionValids_execute && (! execute_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_memory <= CsrPlugin_exceptionPortCtrl_exceptionValids_memory;
      end
      if((! writeBack_arbitration_isStuck))begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= (CsrPlugin_exceptionPortCtrl_exceptionValids_memory && (! memory_arbitration_isStuck));
      end else begin
        CsrPlugin_exceptionPortCtrl_exceptionValidsRegs_writeBack <= 1'b0;
      end
      CsrPlugin_interrupt_valid <= 1'b0;
      if(_zz_327_)begin
        if(_zz_328_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_329_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_330_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      if(_zz_331_)begin
        if(_zz_332_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_333_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_334_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_335_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_336_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
        if(_zz_337_)begin
          CsrPlugin_interrupt_valid <= 1'b1;
        end
      end
      CsrPlugin_lastStageWasWfi <= (writeBack_arbitration_isFiring && (writeBack_ENV_CTRL == `EnvCtrlEnum_defaultEncoding_WFI));
      CsrPlugin_hadException <= CsrPlugin_exception;
      if(_zz_304_)begin
        _zz_193_ <= CsrPlugin_targetPrivilege;
        case(CsrPlugin_targetPrivilege)
          2'b01 : begin
            CsrPlugin_sstatus_SIE <= 1'b0;
            CsrPlugin_sstatus_SPIE <= CsrPlugin_sstatus_SIE;
            CsrPlugin_sstatus_SPP <= CsrPlugin_privilege[0 : 0];
          end
          2'b11 : begin
            CsrPlugin_mstatus_MIE <= 1'b0;
            CsrPlugin_mstatus_MPIE <= CsrPlugin_mstatus_MIE;
            CsrPlugin_mstatus_MPP <= CsrPlugin_privilege;
          end
          default : begin
          end
        endcase
      end
      if(_zz_305_)begin
        case(_zz_306_)
          2'b11 : begin
            CsrPlugin_mstatus_MPP <= (2'b00);
            CsrPlugin_mstatus_MIE <= CsrPlugin_mstatus_MPIE;
            CsrPlugin_mstatus_MPIE <= 1'b1;
            _zz_193_ <= CsrPlugin_mstatus_MPP;
          end
          2'b01 : begin
            CsrPlugin_sstatus_SPP <= (1'b0);
            CsrPlugin_sstatus_SIE <= CsrPlugin_sstatus_SPIE;
            CsrPlugin_sstatus_SPIE <= 1'b1;
            _zz_193_ <= {(1'b0),CsrPlugin_sstatus_SPP};
          end
          default : begin
          end
        endcase
      end
      execute_CsrPlugin_wfiWake <= ({_zz_199_,{_zz_198_,{_zz_197_,{_zz_196_,{_zz_195_,_zz_194_}}}}} != (6'b000000));
      MmuPlugin_ports_0_entryToReplace_value <= MmuPlugin_ports_0_entryToReplace_valueNext;
      if(contextSwitching)begin
        if(MmuPlugin_ports_0_cache_0_exception)begin
          MmuPlugin_ports_0_cache_0_valid <= 1'b0;
        end
        if(MmuPlugin_ports_0_cache_1_exception)begin
          MmuPlugin_ports_0_cache_1_valid <= 1'b0;
        end
        if(MmuPlugin_ports_0_cache_2_exception)begin
          MmuPlugin_ports_0_cache_2_valid <= 1'b0;
        end
        if(MmuPlugin_ports_0_cache_3_exception)begin
          MmuPlugin_ports_0_cache_3_valid <= 1'b0;
        end
      end
      MmuPlugin_ports_1_entryToReplace_value <= MmuPlugin_ports_1_entryToReplace_valueNext;
      if(contextSwitching)begin
        if(MmuPlugin_ports_1_cache_0_exception)begin
          MmuPlugin_ports_1_cache_0_valid <= 1'b0;
        end
        if(MmuPlugin_ports_1_cache_1_exception)begin
          MmuPlugin_ports_1_cache_1_valid <= 1'b0;
        end
        if(MmuPlugin_ports_1_cache_2_exception)begin
          MmuPlugin_ports_1_cache_2_valid <= 1'b0;
        end
        if(MmuPlugin_ports_1_cache_3_exception)begin
          MmuPlugin_ports_1_cache_3_valid <= 1'b0;
        end
      end
      case(MmuPlugin_shared_state_1_)
        `MmuPlugin_shared_State_defaultEncoding_IDLE : begin
          if(_zz_338_)begin
            MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L1_CMD;
          end
          if(_zz_339_)begin
            MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L1_CMD;
          end
        end
        `MmuPlugin_shared_State_defaultEncoding_L1_CMD : begin
          if(MmuPlugin_dBusAccess_cmd_ready)begin
            MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L1_RSP;
          end
        end
        `MmuPlugin_shared_State_defaultEncoding_L1_RSP : begin
          if(MmuPlugin_dBusAccess_rsp_valid)begin
            MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L0_CMD;
            if((MmuPlugin_shared_dBusRsp_leaf || MmuPlugin_shared_dBusRsp_exception))begin
              MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_IDLE;
            end
            if(MmuPlugin_dBusAccess_rsp_payload_redo)begin
              MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L1_CMD;
            end
          end
        end
        `MmuPlugin_shared_State_defaultEncoding_L0_CMD : begin
          if(MmuPlugin_dBusAccess_cmd_ready)begin
            MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L0_RSP;
          end
        end
        default : begin
          if(MmuPlugin_dBusAccess_rsp_valid)begin
            MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_IDLE;
            if(MmuPlugin_dBusAccess_rsp_payload_redo)begin
              MmuPlugin_shared_state_1_ <= `MmuPlugin_shared_State_defaultEncoding_L0_CMD;
            end
          end
        end
      endcase
      if(_zz_322_)begin
        if(_zz_323_)begin
          if(_zz_340_)begin
            MmuPlugin_ports_0_cache_0_valid <= 1'b1;
          end
          if(_zz_341_)begin
            MmuPlugin_ports_0_cache_1_valid <= 1'b1;
          end
          if(_zz_342_)begin
            MmuPlugin_ports_0_cache_2_valid <= 1'b1;
          end
          if(_zz_343_)begin
            MmuPlugin_ports_0_cache_3_valid <= 1'b1;
          end
        end
        if(_zz_324_)begin
          if(_zz_344_)begin
            MmuPlugin_ports_1_cache_0_valid <= 1'b1;
          end
          if(_zz_345_)begin
            MmuPlugin_ports_1_cache_1_valid <= 1'b1;
          end
          if(_zz_346_)begin
            MmuPlugin_ports_1_cache_2_valid <= 1'b1;
          end
          if(_zz_347_)begin
            MmuPlugin_ports_1_cache_3_valid <= 1'b1;
          end
        end
      end
      if((writeBack_arbitration_isValid && writeBack_IS_SFENCE_VMA))begin
        MmuPlugin_ports_0_cache_0_valid <= 1'b0;
        MmuPlugin_ports_0_cache_1_valid <= 1'b0;
        MmuPlugin_ports_0_cache_2_valid <= 1'b0;
        MmuPlugin_ports_0_cache_3_valid <= 1'b0;
        MmuPlugin_ports_1_cache_0_valid <= 1'b0;
        MmuPlugin_ports_1_cache_1_valid <= 1'b0;
        MmuPlugin_ports_1_cache_2_valid <= 1'b0;
        MmuPlugin_ports_1_cache_3_valid <= 1'b0;
      end
      if((! memory_arbitration_isStuck))begin
        execute_to_memory_IS_DBUS_SHARING <= execute_IS_DBUS_SHARING;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_IS_DBUS_SHARING <= memory_IS_DBUS_SHARING;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_REGFILE_WRITE_DATA <= _zz_40_;
      end
      if((! writeBack_arbitration_isStuck))begin
        memory_to_writeBack_INSTRUCTION <= memory_INSTRUCTION;
      end
      if(((! execute_arbitration_isStuck) || execute_arbitration_removeIt))begin
        execute_arbitration_isValid <= 1'b0;
      end
      if(((! decode_arbitration_isStuck) && (! decode_arbitration_removeIt)))begin
        execute_arbitration_isValid <= decode_arbitration_isValid;
      end
      if(((! memory_arbitration_isStuck) || memory_arbitration_removeIt))begin
        memory_arbitration_isValid <= 1'b0;
      end
      if(((! execute_arbitration_isStuck) && (! execute_arbitration_removeIt)))begin
        memory_arbitration_isValid <= execute_arbitration_isValid;
      end
      if(((! writeBack_arbitration_isStuck) || writeBack_arbitration_removeIt))begin
        writeBack_arbitration_isValid <= 1'b0;
      end
      if(((! memory_arbitration_isStuck) && (! memory_arbitration_removeIt)))begin
        writeBack_arbitration_isValid <= memory_arbitration_isValid;
      end
      if(MmuPlugin_dBusAccess_rsp_valid)begin
        memory_to_writeBack_IS_DBUS_SHARING <= 1'b0;
      end
      case(execute_CsrPlugin_csrAddress)
        12'b101111000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            _zz_226_ <= execute_CsrPlugin_writeData[31 : 0];
          end
        end
        12'b001100000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mstatus_MPP <= execute_CsrPlugin_writeData[12 : 11];
            CsrPlugin_mstatus_MPIE <= _zz_453_[0];
            CsrPlugin_mstatus_MIE <= _zz_454_[0];
            CsrPlugin_sstatus_SPP <= execute_CsrPlugin_writeData[8 : 8];
            CsrPlugin_sstatus_SPIE <= _zz_455_[0];
            CsrPlugin_sstatus_SIE <= _zz_456_[0];
            MmuPlugin_status_mxr <= _zz_457_[0];
            MmuPlugin_status_sum <= _zz_458_[0];
            MmuPlugin_status_mprv <= _zz_459_[0];
          end
        end
        12'b001100000011 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mideleg_SE <= _zz_460_[0];
            CsrPlugin_mideleg_ST <= _zz_461_[0];
            CsrPlugin_mideleg_SS <= _zz_462_[0];
          end
        end
        12'b111100010001 : begin
        end
        12'b000101000010 : begin
        end
        12'b111100010100 : begin
        end
        12'b100111000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            _zz_228_ <= execute_CsrPlugin_writeData[31 : 0];
          end
        end
        12'b000100000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_sstatus_SPP <= execute_CsrPlugin_writeData[8 : 8];
            CsrPlugin_sstatus_SPIE <= _zz_464_[0];
            CsrPlugin_sstatus_SIE <= _zz_465_[0];
            MmuPlugin_status_mxr <= _zz_466_[0];
            MmuPlugin_status_sum <= _zz_467_[0];
            MmuPlugin_status_mprv <= _zz_468_[0];
          end
        end
        12'b001100000010 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_medeleg_EU <= _zz_469_[0];
            CsrPlugin_medeleg_II <= _zz_470_[0];
            CsrPlugin_medeleg_LAF <= _zz_471_[0];
            CsrPlugin_medeleg_LPF <= _zz_472_[0];
            CsrPlugin_medeleg_LAM <= _zz_473_[0];
            CsrPlugin_medeleg_SAF <= _zz_474_[0];
            CsrPlugin_medeleg_IAF <= _zz_475_[0];
            CsrPlugin_medeleg_ES <= _zz_476_[0];
            CsrPlugin_medeleg_IPF <= _zz_477_[0];
            CsrPlugin_medeleg_SPF <= _zz_478_[0];
            CsrPlugin_medeleg_SAM <= _zz_479_[0];
            CsrPlugin_medeleg_IAM <= _zz_480_[0];
          end
        end
        12'b001101000001 : begin
        end
        12'b101100000000 : begin
        end
        12'b101110000000 : begin
        end
        12'b001101000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_sip_STIP <= _zz_482_[0];
            CsrPlugin_sip_SSIP <= _zz_483_[0];
            CsrPlugin_sip_SEIP_SOFT <= _zz_484_[0];
          end
        end
        12'b001100000101 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mtvec_base <= execute_CsrPlugin_writeData[31 : 2];
            CsrPlugin_mtvec_mode <= execute_CsrPlugin_writeData[1 : 0];
          end
        end
        12'b000110000000 : begin
          if(execute_CsrPlugin_writeEnable)begin
            MmuPlugin_satp_mode <= _zz_485_[0];
          end
        end
        12'b000101000001 : begin
        end
        12'b110011000000 : begin
        end
        12'b101100000010 : begin
        end
        12'b111100010011 : begin
        end
        12'b000101000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_sip_STIP <= _zz_486_[0];
            CsrPlugin_sip_SSIP <= _zz_487_[0];
            CsrPlugin_sip_SEIP_SOFT <= _zz_488_[0];
          end
        end
        12'b000100000101 : begin
        end
        12'b001101000011 : begin
        end
        12'b111111000000 : begin
        end
        12'b110000000000 : begin
        end
        12'b001100000001 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_misa_base <= execute_CsrPlugin_writeData[31 : 30];
            CsrPlugin_misa_extensions <= execute_CsrPlugin_writeData[25 : 0];
          end
        end
        12'b001101000000 : begin
        end
        12'b001100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_mie_MEIE <= _zz_489_[0];
            CsrPlugin_mie_MTIE <= _zz_490_[0];
            CsrPlugin_mie_MSIE <= _zz_491_[0];
            CsrPlugin_sie_SEIE <= _zz_492_[0];
            CsrPlugin_sie_STIE <= _zz_493_[0];
            CsrPlugin_sie_SSIE <= _zz_494_[0];
          end
        end
        12'b111100010010 : begin
        end
        12'b000101000011 : begin
        end
        12'b110111000000 : begin
        end
        12'b101110000010 : begin
        end
        12'b000101000000 : begin
        end
        12'b110010000000 : begin
        end
        12'b001101000010 : begin
        end
        12'b000100000100 : begin
          if(execute_CsrPlugin_writeEnable)begin
            CsrPlugin_sie_SEIE <= _zz_496_[0];
            CsrPlugin_sie_STIE <= _zz_497_[0];
            CsrPlugin_sie_SSIE <= _zz_498_[0];
          end
        end
        default : begin
        end
      endcase
      if(_zz_325_)begin
        if(iBusWishbone_ACK)begin
          _zz_230_ <= (_zz_230_ + (3'b001));
        end
      end
      _zz_231_ <= (iBusWishbone_CYC && iBusWishbone_ACK);
      if((_zz_233_ && _zz_234_))begin
        _zz_232_ <= (_zz_232_ + (3'b001));
        if(_zz_236_)begin
          _zz_232_ <= (3'b000);
        end
      end
      _zz_238_ <= ((_zz_233_ && (! dBusWishbone_WE)) && dBusWishbone_ACK);
    end
  end

  always @ (posedge clk) begin
    if(IBusCachedPlugin_iBusRsp_stages_1_output_ready)begin
      _zz_116_ <= IBusCachedPlugin_iBusRsp_stages_1_output_payload;
    end
    if(IBusCachedPlugin_iBusRsp_stages_1_input_ready)begin
      IBusCachedPlugin_s1_tightlyCoupledHit <= IBusCachedPlugin_s0_tightlyCoupledHit;
    end
    if(IBusCachedPlugin_iBusRsp_cacheRspArbitration_input_ready)begin
      IBusCachedPlugin_s2_tightlyCoupledHit <= IBusCachedPlugin_s1_tightlyCoupledHit;
    end
    if(_zz_326_)begin
      _zz_130_ <= dataCache_1__io_mem_cmd_payload_wr;
      _zz_131_ <= dataCache_1__io_mem_cmd_payload_address;
      _zz_132_ <= dataCache_1__io_mem_cmd_payload_data;
      _zz_133_ <= dataCache_1__io_mem_cmd_payload_mask;
      _zz_134_ <= dataCache_1__io_mem_cmd_payload_length;
      _zz_135_ <= dataCache_1__io_mem_cmd_payload_last;
    end
    if(dataCache_1__io_mem_cmd_s2mPipe_ready)begin
      _zz_137_ <= dataCache_1__io_mem_cmd_s2mPipe_payload_wr;
      _zz_138_ <= dataCache_1__io_mem_cmd_s2mPipe_payload_address;
      _zz_139_ <= dataCache_1__io_mem_cmd_s2mPipe_payload_data;
      _zz_140_ <= dataCache_1__io_mem_cmd_s2mPipe_payload_mask;
      _zz_141_ <= dataCache_1__io_mem_cmd_s2mPipe_payload_length;
      _zz_142_ <= dataCache_1__io_mem_cmd_s2mPipe_payload_last;
    end
    if(_zz_176_)begin
      _zz_178_ <= _zz_56_[11 : 7];
      _zz_179_ <= _zz_90_;
    end
    if((memory_DivPlugin_div_counter_value == (6'b100000)))begin
      memory_DivPlugin_div_done <= 1'b1;
    end
    if((! memory_arbitration_isStuck))begin
      memory_DivPlugin_div_done <= 1'b0;
    end
    if(_zz_290_)begin
      if(_zz_303_)begin
        memory_DivPlugin_rs1[31 : 0] <= _zz_415_[31:0];
        memory_DivPlugin_accumulator[31 : 0] <= ((! _zz_188_[32]) ? _zz_416_ : _zz_417_);
        if((memory_DivPlugin_div_counter_value == (6'b100000)))begin
          memory_DivPlugin_div_result <= _zz_418_[31:0];
        end
      end
    end
    if(_zz_318_)begin
      memory_DivPlugin_accumulator <= (65'b00000000000000000000000000000000000000000000000000000000000000000);
      memory_DivPlugin_rs1 <= ((_zz_191_ ? (~ _zz_192_) : _zz_192_) + _zz_424_);
      memory_DivPlugin_rs2 <= ((_zz_190_ ? (~ execute_RS2) : execute_RS2) + _zz_426_);
      memory_DivPlugin_div_needRevert <= ((_zz_191_ ^ (_zz_190_ && (! execute_INSTRUCTION[13]))) && (! (((execute_RS2 == (32'b00000000000000000000000000000000)) && execute_IS_RS2_SIGNED) && (! execute_INSTRUCTION[13]))));
    end
    CsrPlugin_mip_MEIP <= externalInterrupt;
    CsrPlugin_mip_MTIP <= timerInterrupt;
    CsrPlugin_mip_MSIP <= softwareInterrupt;
    CsrPlugin_sip_SEIP_INPUT <= externalInterruptS;
    CsrPlugin_mcycle <= (CsrPlugin_mcycle + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    if(writeBack_arbitration_isFiring)begin
      CsrPlugin_minstret <= (CsrPlugin_minstret + (64'b0000000000000000000000000000000000000000000000000000000000000001));
    end
    if(_zz_300_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_201_ ? IBusCachedPlugin_decodeExceptionPort_payload_code : decodeExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_201_ ? IBusCachedPlugin_decodeExceptionPort_payload_badAddr : decodeExceptionPort_payload_badAddr);
    end
    if(_zz_302_)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= (_zz_203_ ? CsrPlugin_selfException_payload_code : BranchPlugin_branchExceptionPort_payload_code);
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= (_zz_203_ ? CsrPlugin_selfException_payload_badAddr : BranchPlugin_branchExceptionPort_payload_badAddr);
    end
    if(DBusCachedPlugin_exceptionBus_valid)begin
      CsrPlugin_exceptionPortCtrl_exceptionContext_code <= DBusCachedPlugin_exceptionBus_payload_code;
      CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr <= DBusCachedPlugin_exceptionBus_payload_badAddr;
    end
    if(_zz_327_)begin
      if(_zz_328_)begin
        CsrPlugin_interrupt_code <= (4'b0101);
        CsrPlugin_interrupt_targetPrivilege <= (2'b01);
      end
      if(_zz_329_)begin
        CsrPlugin_interrupt_code <= (4'b0001);
        CsrPlugin_interrupt_targetPrivilege <= (2'b01);
      end
      if(_zz_330_)begin
        CsrPlugin_interrupt_code <= (4'b1001);
        CsrPlugin_interrupt_targetPrivilege <= (2'b01);
      end
    end
    if(_zz_331_)begin
      if(_zz_332_)begin
        CsrPlugin_interrupt_code <= (4'b0101);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_333_)begin
        CsrPlugin_interrupt_code <= (4'b0001);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_334_)begin
        CsrPlugin_interrupt_code <= (4'b1001);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_335_)begin
        CsrPlugin_interrupt_code <= (4'b0111);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_336_)begin
        CsrPlugin_interrupt_code <= (4'b0011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
      if(_zz_337_)begin
        CsrPlugin_interrupt_code <= (4'b1011);
        CsrPlugin_interrupt_targetPrivilege <= (2'b11);
      end
    end
    if(_zz_304_)begin
      case(CsrPlugin_targetPrivilege)
        2'b01 : begin
          CsrPlugin_scause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_scause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_sepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_stval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        2'b11 : begin
          CsrPlugin_mcause_interrupt <= (! CsrPlugin_hadException);
          CsrPlugin_mcause_exceptionCode <= CsrPlugin_trapCause;
          CsrPlugin_mepc <= writeBack_PC;
          if(CsrPlugin_hadException)begin
            CsrPlugin_mtval <= CsrPlugin_exceptionPortCtrl_exceptionContext_badAddr;
          end
        end
        default : begin
        end
      endcase
    end
    if((MmuPlugin_dBusAccess_rsp_valid && (! MmuPlugin_dBusAccess_rsp_payload_redo)))begin
      MmuPlugin_shared_pteBuffer_V <= MmuPlugin_shared_dBusRsp_pte_V;
      MmuPlugin_shared_pteBuffer_R <= MmuPlugin_shared_dBusRsp_pte_R;
      MmuPlugin_shared_pteBuffer_W <= MmuPlugin_shared_dBusRsp_pte_W;
      MmuPlugin_shared_pteBuffer_X <= MmuPlugin_shared_dBusRsp_pte_X;
      MmuPlugin_shared_pteBuffer_U <= MmuPlugin_shared_dBusRsp_pte_U;
      MmuPlugin_shared_pteBuffer_G <= MmuPlugin_shared_dBusRsp_pte_G;
      MmuPlugin_shared_pteBuffer_A <= MmuPlugin_shared_dBusRsp_pte_A;
      MmuPlugin_shared_pteBuffer_D <= MmuPlugin_shared_dBusRsp_pte_D;
      MmuPlugin_shared_pteBuffer_RSW <= MmuPlugin_shared_dBusRsp_pte_RSW;
      MmuPlugin_shared_pteBuffer_PPN0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
      MmuPlugin_shared_pteBuffer_PPN1 <= MmuPlugin_shared_dBusRsp_pte_PPN1;
    end
    case(MmuPlugin_shared_state_1_)
      `MmuPlugin_shared_State_defaultEncoding_IDLE : begin
        if(_zz_338_)begin
          MmuPlugin_shared_vpn_1 <= IBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22];
          MmuPlugin_shared_vpn_0 <= IBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12];
          MmuPlugin_shared_portId <= (1'b0);
        end
        if(_zz_339_)begin
          MmuPlugin_shared_vpn_1 <= DBusCachedPlugin_mmuBus_cmd_virtualAddress[31 : 22];
          MmuPlugin_shared_vpn_0 <= DBusCachedPlugin_mmuBus_cmd_virtualAddress[21 : 12];
          MmuPlugin_shared_portId <= (1'b1);
        end
      end
      `MmuPlugin_shared_State_defaultEncoding_L1_CMD : begin
      end
      `MmuPlugin_shared_State_defaultEncoding_L1_RSP : begin
      end
      `MmuPlugin_shared_State_defaultEncoding_L0_CMD : begin
      end
      default : begin
      end
    endcase
    if(_zz_322_)begin
      if(_zz_323_)begin
        if(_zz_340_)begin
          MmuPlugin_ports_0_cache_0_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_0_cache_0_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_0_cache_0_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_0_cache_0_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_0_cache_0_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_0_cache_0_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_0_cache_0_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_0_cache_0_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_0_cache_0_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_0_cache_0_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
        if(_zz_341_)begin
          MmuPlugin_ports_0_cache_1_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_0_cache_1_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_0_cache_1_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_0_cache_1_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_0_cache_1_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_0_cache_1_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_0_cache_1_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_0_cache_1_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_0_cache_1_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_0_cache_1_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
        if(_zz_342_)begin
          MmuPlugin_ports_0_cache_2_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_0_cache_2_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_0_cache_2_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_0_cache_2_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_0_cache_2_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_0_cache_2_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_0_cache_2_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_0_cache_2_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_0_cache_2_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_0_cache_2_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
        if(_zz_343_)begin
          MmuPlugin_ports_0_cache_3_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_0_cache_3_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_0_cache_3_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_0_cache_3_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_0_cache_3_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_0_cache_3_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_0_cache_3_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_0_cache_3_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_0_cache_3_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_0_cache_3_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
      end
      if(_zz_324_)begin
        if(_zz_344_)begin
          MmuPlugin_ports_1_cache_0_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_1_cache_0_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_1_cache_0_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_1_cache_0_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_1_cache_0_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_1_cache_0_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_1_cache_0_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_1_cache_0_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_1_cache_0_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_1_cache_0_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
        if(_zz_345_)begin
          MmuPlugin_ports_1_cache_1_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_1_cache_1_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_1_cache_1_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_1_cache_1_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_1_cache_1_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_1_cache_1_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_1_cache_1_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_1_cache_1_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_1_cache_1_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_1_cache_1_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
        if(_zz_346_)begin
          MmuPlugin_ports_1_cache_2_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_1_cache_2_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_1_cache_2_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_1_cache_2_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_1_cache_2_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_1_cache_2_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_1_cache_2_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_1_cache_2_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_1_cache_2_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_1_cache_2_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
        if(_zz_347_)begin
          MmuPlugin_ports_1_cache_3_exception <= (MmuPlugin_shared_dBusRsp_exception || ((MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP) && (MmuPlugin_shared_dBusRsp_pte_PPN0 != (10'b0000000000))));
          MmuPlugin_ports_1_cache_3_virtualAddress_0 <= MmuPlugin_shared_vpn_0;
          MmuPlugin_ports_1_cache_3_virtualAddress_1 <= MmuPlugin_shared_vpn_1;
          MmuPlugin_ports_1_cache_3_physicalAddress_0 <= MmuPlugin_shared_dBusRsp_pte_PPN0;
          MmuPlugin_ports_1_cache_3_physicalAddress_1 <= MmuPlugin_shared_dBusRsp_pte_PPN1[9 : 0];
          MmuPlugin_ports_1_cache_3_allowRead <= MmuPlugin_shared_dBusRsp_pte_R;
          MmuPlugin_ports_1_cache_3_allowWrite <= MmuPlugin_shared_dBusRsp_pte_W;
          MmuPlugin_ports_1_cache_3_allowExecute <= MmuPlugin_shared_dBusRsp_pte_X;
          MmuPlugin_ports_1_cache_3_allowUser <= MmuPlugin_shared_dBusRsp_pte_U;
          MmuPlugin_ports_1_cache_3_superPage <= (MmuPlugin_shared_state_1_ == `MmuPlugin_shared_State_defaultEncoding_L1_RSP);
        end
      end
    end
    externalInterruptArray_regNext <= externalInterruptArray;
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS1_SIGNED <= decode_IS_RS1_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_CTRL <= _zz_23_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ENV_CTRL <= _zz_20_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_ENV_CTRL <= _zz_17_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_ENV_CTRL <= _zz_15_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HH <= execute_MUL_HH;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_HH <= memory_MUL_HH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_LESS_UNSIGNED <= decode_SRC_LESS_UNSIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_MANAGMENT <= decode_MEMORY_MANAGMENT;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MUL_LOW <= memory_MUL_LOW;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PC <= decode_PC;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_PC <= _zz_47_;
    end
    if(((! writeBack_arbitration_isStuck) && (! CsrPlugin_exceptionPortCtrl_exceptionValids_writeBack)))begin
      memory_to_writeBack_PC <= memory_PC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_ENABLE <= decode_MEMORY_ENABLE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ENABLE <= execute_MEMORY_ENABLE;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ENABLE <= memory_MEMORY_ENABLE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_MUL <= decode_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_MUL <= execute_IS_MUL;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_IS_MUL <= memory_IS_MUL;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_HL <= execute_MUL_HL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_SFENCE_VMA <= decode_IS_SFENCE_VMA;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_SFENCE_VMA <= execute_IS_SFENCE_VMA;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_IS_SFENCE_VMA <= memory_IS_SFENCE_VMA;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_AMO <= decode_MEMORY_AMO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_READ_OPCODE <= decode_CSR_READ_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_RS2_SIGNED <= decode_IS_RS2_SIGNED;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SHIFT_CTRL <= _zz_13_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS2 <= decode_RS2;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LH <= execute_MUL_LH;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BRANCH_CTRL <= _zz_10_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_LRSC <= decode_MEMORY_LRSC;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_REGFILE_WRITE_VALID <= decode_REGFILE_WRITE_VALID;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_VALID <= execute_REGFILE_WRITE_VALID;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_REGFILE_WRITE_VALID <= memory_REGFILE_WRITE_VALID;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_BITWISE_CTRL <= _zz_8_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_ADDRESS_LOW <= execute_MEMORY_ADDRESS_LOW;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_ADDRESS_LOW <= memory_MEMORY_ADDRESS_LOW;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_REGFILE_WRITE_DATA <= _zz_41_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_ALU_CTRL <= _zz_5_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC2_FORCE_ZERO <= decode_SRC2_FORCE_ZERO;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_FORMAL_PC_NEXT <= _zz_98_;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_FORMAL_PC_NEXT <= _zz_97_;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_FORMAL_PC_NEXT <= memory_FORMAL_PC_NEXT;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_MEMORY_WR <= decode_MEMORY_WR;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MEMORY_WR <= execute_MEMORY_WR;
    end
    if((! writeBack_arbitration_isStuck))begin
      memory_to_writeBack_MEMORY_WR <= memory_MEMORY_WR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_CSR <= decode_IS_CSR;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_EXECUTE_STAGE <= decode_BYPASSABLE_EXECUTE_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_IS_DIV <= decode_IS_DIV;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_IS_DIV <= execute_IS_DIV;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_INSTRUCTION <= decode_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_INSTRUCTION <= execute_INSTRUCTION;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_MUL_LL <= execute_MUL_LL;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_PREDICTION_HAD_BRANCHED2 <= decode_PREDICTION_HAD_BRANCHED2;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_BYPASSABLE_MEMORY_STAGE <= decode_BYPASSABLE_MEMORY_STAGE;
    end
    if((! memory_arbitration_isStuck))begin
      execute_to_memory_BYPASSABLE_MEMORY_STAGE <= execute_BYPASSABLE_MEMORY_STAGE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC1_CTRL <= _zz_2_;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_RS1 <= decode_RS1;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_CSR_WRITE_OPCODE <= decode_CSR_WRITE_OPCODE;
    end
    if((! execute_arbitration_isStuck))begin
      decode_to_execute_SRC_USE_SUB_LESS <= decode_SRC_USE_SUB_LESS;
    end
    case(execute_CsrPlugin_csrAddress)
      12'b101111000000 : begin
      end
      12'b001100000000 : begin
      end
      12'b001100000011 : begin
      end
      12'b111100010001 : begin
      end
      12'b000101000010 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_scause_interrupt <= _zz_463_[0];
          CsrPlugin_scause_exceptionCode <= execute_CsrPlugin_writeData[3 : 0];
        end
      end
      12'b111100010100 : begin
      end
      12'b100111000000 : begin
      end
      12'b000100000000 : begin
      end
      12'b001100000010 : begin
      end
      12'b001101000001 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mepc <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b101100000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mcycle[31 : 0] <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b101110000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mcycle[63 : 32] <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001101000100 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mip_MSIP <= _zz_481_[0];
        end
      end
      12'b001100000101 : begin
      end
      12'b000110000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          MmuPlugin_satp_ppn <= execute_CsrPlugin_writeData[19 : 0];
        end
      end
      12'b000101000001 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_sepc <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b110011000000 : begin
      end
      12'b101100000010 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_minstret[31 : 0] <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b111100010011 : begin
      end
      12'b000101000100 : begin
      end
      12'b000100000101 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_stvec_base <= execute_CsrPlugin_writeData[31 : 2];
          CsrPlugin_stvec_mode <= execute_CsrPlugin_writeData[1 : 0];
        end
      end
      12'b001101000011 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mtval <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b111111000000 : begin
      end
      12'b110000000000 : begin
      end
      12'b001100000001 : begin
      end
      12'b001101000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mscratch <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b001100000100 : begin
      end
      12'b111100010010 : begin
      end
      12'b000101000011 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_stval <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b110111000000 : begin
      end
      12'b101110000010 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_minstret[63 : 32] <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b000101000000 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_sscratch <= execute_CsrPlugin_writeData[31 : 0];
        end
      end
      12'b110010000000 : begin
      end
      12'b001101000010 : begin
        if(execute_CsrPlugin_writeEnable)begin
          CsrPlugin_mcause_interrupt <= _zz_495_[0];
          CsrPlugin_mcause_exceptionCode <= execute_CsrPlugin_writeData[3 : 0];
        end
      end
      12'b000100000100 : begin
      end
      default : begin
      end
    endcase
    iBusWishbone_DAT_MISO_regNext <= iBusWishbone_DAT_MISO;
    dBusWishbone_DAT_MISO_regNext <= dBusWishbone_DAT_MISO;
  end

endmodule

