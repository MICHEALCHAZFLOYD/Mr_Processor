
module ALU(rs2, zero, imm12, opcode,funct7, funct3, a, b, out);


  input         [31:0]         a , b;
  input          [6:0]         funct7, opcode;
  input          [2:0]         funct3;
  input         [11:0]         imm12;
  input          [4:0]         rs2;

  output reg    [31:0]         out;
  output reg                   zero; 
  
  reg           [31:0]         imm12_ext;
  reg signed    [31:0]         sra_input;

  always @(funct7 or funct3 or b or a or imm12) begin    
    zero = 1;
    if(opcode == 51) imm12_ext = b;
    if(opcode == 19  || opcode == 3 || opcode == 35 || opcode == 103) imm12_ext = { {20{imm12[11]}}, imm12[11:0] };
    case(opcode)
      51, 19,103: begin
        sra_input = a;
          case(funct3)
            0:begin
              if(funct7 == 0 || opcode == 19) out = a + imm12_ext;
	      else out = a - imm12_ext;                            
       	     end
            1: out = a << imm12_ext[4:0]; 
            2:begin
              if (~( a[31] ^ imm12_ext[31])) begin
                if (a < imm12_ext) out = 1;
                else out = 0;
              end
              else begin
                if (a < imm12_ext) out = 0;
                else out = 1;
              end
            end
            3:begin
              if(a < imm12_ext) out = 1;                            
              else out = 0;                                 
            end                          
            4: out = a ^ imm12_ext;                                                 
            5: begin
              if (funct7 == 0) out = a >> imm12_ext[4:0];
              else out = sra_input >>> imm12_ext[4:0]; 
            end                             
            6:out = a | imm12_ext;                                                 
            7: out = a & imm12_ext; 
            default:begin
            end
          endcase
      end
      99: begin                               
        case(funct3)
          0:begin
            if(a == b) zero = 0;
          end
          1:begin
            if(a != b) zero = 0;
          end                                                  
          4:begin
            if (~( a[31] ^ b[31])) begin
              if (a < b) zero = 0;
            end
            else begin
              if (a > b) zero = 0;
            end                                 
          end
          5:begin
            if (~( a[31] ^ b[31])) begin
	      if (a >= b) zero = 0;
	    end
            if (a[31] ^ b[31])  begin
	      if (a < b) zero = 0;
            end
          end
          6:begin
            if(a < b) zero = 0;                            
          end 
          7:begin
            if(a > b || a == b) zero = 0;                            
          end
          default:begin
          end
        endcase
      end
      35,3: begin
        out = imm12_ext + a;
      end
      default begin
      end
    endcase
   end
endmodule
