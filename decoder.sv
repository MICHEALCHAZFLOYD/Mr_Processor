
module decoder (imm20, instruction, opcode, rd, funct3, rs1, rs2, funct7, imm12);                      
  
  input               [31:0]             instruction;          
  output reg           [6:0]             opcode, funct7;
  output reg           [4:0]             rd, rs1, rs2;
  output reg           [2:0]             funct3;
  output reg          [11:0]             imm12;
  output reg          [19:0]             imm20;
 
  assign opcode = instruction[6:0];
  always @(opcode) begin                  
    case(opcode)
      51: begin          
        rd = instruction[11:7];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        funct7 = instruction[31:25];
      end
      19: begin                 
        imm12[11:0] = instruction[31:20];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rd = instruction[11:7];
        funct7 = instruction[31:25]; 
      end
      35: begin                  
        imm12[11:5] = instruction[31:25];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
        imm12[4:0] = instruction[11:7];
      end
      55: begin       
        rd = instruction[11:7];
        imm20 = instruction[31:12];
      end
      23: begin       
        rd = instruction[11:7];
        imm20[19:0] = instruction[31:12];
      end
      111: begin
        imm20[19] = instruction[31];
        imm20[9:0] = instruction[30:21];
        imm20[10] = instruction[20];
        imm20[18:11] = instruction[19:12];
        rd = instruction[11:7];
      end
      115: begin
        rs1 = 0;
      end
      103: begin
	funct7 = 0;
        imm12[11:0] = instruction[31:20];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rd = instruction[11:7];
      end
      3: begin
        imm12[11:0] = instruction[31:20];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rd = instruction[11:7];
      end
      99: begin
        imm12[11] = instruction[31];
        imm12[9:4] = instruction[30:25];
        imm12[3:0] = instruction[11:8];
        imm12[10] = instruction[7];
        funct3 = instruction[14:12];
        rs1 = instruction[19:15];
        rs2 = instruction[24:20];
      end
      0: begin
	imm12 = 0;
	imm20 = 0;
        funct3 = 0;
	funct7 = 0;
        rs1 = 0;
	rs2 = 0;
        rd = 0;
      end
      default: begin
      end
    endcase
  end 
endmodule
