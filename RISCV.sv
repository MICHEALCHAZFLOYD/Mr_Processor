module RISCV(resetn, clk, mem_addr, mem_wdata, mem_wstrb, mem_rdata, mem_instr, trap);
  
  input                         resetn,  clk;
  input          [31: 0]        mem_rdata;
  
  output reg       [3:0]        mem_wstrb;
  output reg                    mem_instr, trap;
  output reg      [31:0]        mem_addr, mem_wdata;
  
  reg                           reg_flag, load_flag;
  reg              [2:0]        count;
  reg             [31:0]        instruction, reg_load;
  reg             [20:0]        imm21;
  reg             [31:0]        extended, addr_cur;
  
  
  wire             [6:0]        opcode, funct7;
  wire             [4:0]        rd, rs1, rs2;
  wire             [2:0]        funct3;
  wire            [11:0]        imm12;
  wire            [19:0]        imm20;
  wire            [31:0]        reg_store, reg_save, reg_rs1, reg_rs2;
  wire                          zero;
 

//------------------------------------------------------------------------------------------------------------------------------------------------------------//MODULE CALLS


  register  reg1 (.load_flag(load_flag), .reg_flag(reg_flag), .imm20(imm20), .addr_cur(addr_cur), .clk(clk), .funct3(funct3),.opcode(opcode),.rs1(rs1),.rs2(rs2),.rd(rd),.reg_rs1(reg_rs1),.reg_rs2(reg_rs2),.reg_save(reg_save),.reg_load(reg_load),.reg_store(reg_store));

  decoder decode(.instruction(instruction),.imm20(imm20),.opcode(opcode),.rd(rd),.funct3(funct3),.rs1(rs1),.rs2(rs2),.funct7(funct7),.imm12(imm12));

  ALU  alu(.rs2(rs2),.zero(zero),.imm12(imm12),.opcode(opcode),.funct7(funct7),.funct3(funct3),.a(reg_rs1),.b(reg_rs2),.out(reg_store));
    

//------------------------------------------------------------------------------------------------------------------------------------------------------------//PC OPERATIONS

  always @(posedge clk) begin
    count <= count + 1;
    imm21[0] = 0;
    imm21[20:1] = imm20;
   if (opcode == 4) begin
      trap = 1;
   end
   case(count)
      1: begin
        instruction <= mem_rdata;
      end
      3: begin
	reg_flag <= 1;
        if(opcode == 35  && resetn ==0) begin
          case(funct3)
              0: begin
                 mem_wstrb <= 1;
              end
              1: begin
                 mem_wstrb <= 4'b0011;
              end
              2: begin
                 mem_wstrb <= 4'b1111;
              end
          endcase
        end
        if(opcode == 35  && resetn ==0) begin
          mem_addr <= reg_store;
          mem_wdata <= reg_save;
        end
        if(opcode == 3 && resetn == 0) begin
          mem_addr <= reg_store;
        end
      end
      4: begin
	load_flag <= 1;
	reg_flag <= 0;
        if (opcode == 3 && resetn ==0) begin
          if(reg_store%4 == 0)                                 reg_load       <=    mem_rdata;
          if(reg_store%4 == 1 && (funct3 == 0 || funct3 == 4)) reg_load [7:0] <=    mem_rdata[15:8];
          if(reg_store%4 == 2 && (funct3 == 0 || funct3 == 4)) reg_load [7:0] <=    mem_rdata[23:16];
          if(reg_store%4 == 3 && (funct3 == 0 || funct3 == 4)) reg_load [7:0] <=    mem_rdata[31:24];
          if(reg_store%4 == 2 && (funct3 == 1 || funct3 == 5)) reg_load[15:0] <=    mem_rdata[31:16];
          mem_addr <= addr_cur;
        end
        mem_wstrb <= 0;
        if (opcode == 35 && resetn == 0) begin
          mem_addr <= addr_cur;
        end
      end
      5: begin	
	load_flag <= 0;
        if(opcode != 111 && opcode != 103 && zero == 1 && resetn == 0) begin
          mem_addr <= mem_addr + 4;
          addr_cur <= mem_addr + 4;
        end
        if(opcode == 111 && resetn == 0) begin
          mem_addr <= {{11{imm21[20]}}, imm21[20:0]};
          addr_cur <= {{11{imm21[20]}}, imm21[20:0]};
        end
        if(opcode == 103 && resetn == 0) begin
          mem_addr <= reg_store;
          addr_cur <= reg_store;
        end
        if(opcode == 99 && zero == 0) begin
          extended = { {20{imm12[11]}}, imm12[11:0] };
          extended = extended << 1;
          mem_addr <= mem_addr + (extended);
          addr_cur <= mem_addr + (extended);
        end
        count <= 0;
      end
   endcase
 end
 always @(posedge clk) begin
   if (resetn) begin
     load_flag <= 0;
     reg_flag <= 0;
     count <= 0;
     mem_addr <= 0;
     instruction <= 0;
     mem_wstrb <= 0;
   end
 end  
endmodule
