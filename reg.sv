module register(clk, load_flag, reg_flag, resetn, funct3, imm20, addr_cur, opcode, rs1, rs2, rd, reg_rs1, reg_rs2, reg_save, reg_load, reg_store);

  input                   [19:0]              imm20;
  input                    [6:0]              opcode;
  input                    [4:0]              rs1, rs2, rd;
  input                    [2:0]              funct3;
  input                                       clk, resetn, reg_flag, load_flag;
  input                   [31:0]              reg_store, reg_load, addr_cur;
  output reg              [31:0]              reg_rs1, reg_rs2, reg_save;
  reg                     [31:0]              temp;
 
  
  reg[31:0] register[31:0]; 
 
  
  always @(posedge clk) begin
//Test Output Begin-------------------------------------
//     if (opcode == 111 || opcode == 103 || opcode == 35) begin
	$display ("RS1_data:     0x%8x", register[rs1]);
	$display ("RS2_data:     0x%8x", register[rs2]);
	$display ("RD_data:      0x%8x", register[rd]);
//     end

//Test Output End---------------------------------------
    temp = addr_cur;     
    temp[1:0] = 0; 

    register[0] <= 0;    
 
    case(opcode) 
      55: begin
	if(reg_flag == 1) begin
        	register[rd][31:12] <= imm20;
        	register[rd][11:0] <= 0; 
	end
      end
      23: begin
	if(reg_flag == 1) begin
        	register[rd][31:12] = imm20;
        	register[rd][11:0] = 0;
        	register[rd] <= register[rd] + addr_cur;
	end
      end
      51: begin
        reg_rs1 <= register[rs1];
        reg_rs2 <= register[rs2];
	if(reg_flag == 1) begin
        	register[rd] <= reg_store; 
	end
      end
      19: begin
        reg_rs1 <= register[rs1];
	if(reg_flag == 1) begin
        	register[rd] <= reg_store;
	end
      end

      99: begin
        reg_rs1 <= register[rs1];
        reg_rs2 <= register[rs2];
      end
      3: begin
        reg_rs1 <= register[rs1];
	if(load_flag == 1) begin
           case(funct3) 
          	0:begin
            		register[rd] <= { {24{reg_load[7]}}, reg_load[7:0] };
          	end
          	1:begin
            		register[rd] <= { {16{reg_load[15]}}, reg_load[15:0] };
          	end
          	2:begin
            		register[rd] <= reg_load;
          	end
          	4:begin
            		register[rd][7:0] <= reg_load[7:0];
            		register[rd][31:8] <= 0;
          	end
          	5:begin
            		register[rd][15:0] <= reg_load[15:0];
            		register[rd][31:16] <= 0;
          	end 
          	default begin
          	end
           endcase 
	end
      end
      35: begin
        
        reg_rs1 <= register[rs1];
        
        case(funct3)
          0:begin
            reg_save <= { {24{register[rs2][7]}}, register[rs2][7:0] };
          end
          1:begin
            reg_save <= { {16{register[rs2][15]}}, register[rs2][15:0] };
          end
          2:begin
            reg_save <= register[rs2];
          end
          default begin
          end
        endcase
      end
      111: begin
          if(reg_flag == 1 && rd != 0) begin
	    register[rd] <= temp + 4;
          end
      end
      
      103: begin
          if (reg_flag == 1 && rd != 0) begin
            register[rd] <= temp + 4;
          end
          reg_rs1 <= register[rs1];
      end




      default begin
      end
    endcase
  end

  always @ (posedge clk) begin
    if(resetn) begin
	register[0] <= 0;
	register[1] <= 0;
	register[2] <= 0;
        register[3] <= 0;
        register[4] <= 0;
        register[5] <= 0;
        register[6] <= 0;
        register[7] <= 0;
        register[8] <= 0;
        register[9] <= 0;
        register[10] <= 0;
        register[11] <= 0;
        register[12] <= 0;
        register[13] <= 0;
        register[14] <= 0;
        register[15] <= 0;
        register[16] <= 0;
        register[17] <= 0;
        register[18] <= 0;
        register[19] <= 0;
        register[20] <= 0;
        register[21] <= 0;
        register[22] <= 0;
        register[23] <= 0;
        register[24] <= 0;
        register[25] <= 0;
        register[26] <= 0;
        register[27] <= 0;
        register[28] <= 0;
        register[29] <= 0;
        register[30] <= 0;
        register[31] <= 0;
	
    end
  end
  
endmodule
