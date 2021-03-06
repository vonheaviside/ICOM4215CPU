module Incrementer(output reg[9:0]Incremented,input[9:0]OutdeMux);

always@(OutdeMux)

Incremented=OutdeMux+1;

endmodule

//////////////////////////////////////////////////  Instruccion Decoder

module DecodeInstruction(output reg[9:0] MicroprogramState,input[31:0]Instruction);

//Decode instruction

always@(Instruction) begin

case(Instruction[27:25]) 

3'b000:begin//FALTA Addressing mode 3

if(Instruction[4]==1'b0)begin //Data-Processing immediate shift

// Check opcode for  Rd not updated Instruction

if(Instruction[24:21]==4'b1000 || Instruction[24:21]==4'b1001 || Instruction[24:21]==4'b1010 || Instruction[24:21]==4'b1011)begin

MicroprogramState = 16'd13;//Shift by immediate shifter operand (Rd is not affected)

end

else begin

if(Instruction[20]==1)

MicroprogramState = 8'd14;//Shift by immediate shifter operand (Rd is affected y flags)  despues ir a fetch 1 con delay

else

MicroprogramState = 8'd18;//shift by imme shifter afecta a Rd pero no a los flags necesita 2 stages

end//else

end// if bit 4

end//case 000

3'b001:begin//Data-Processing immediate

if(Instruction[24:23]==2'b10 && (Instruction[21:20]==2'b00 || Instruction[21:20]==2'b10))begin

MicroprogramState = 8'd1;//illegal instruction || not a required instruction, fetch next one.

end

// Check opcode for  Rd not updated Instruction

if(Instruction[24:21]==4'b1000 || Instruction[24:21]==4'b1001 || Instruction[24:21]==4'b1010 || Instruction[24:21]==4'b1011)begin

MicroprogramState = 8'd10;//32-bit immediate (Rd is not affected) despues de aqui ir a fetch 1

end

else begin// instruction que se escribe a Rd

//verificar bit S

if(Instruction[20]==1)

MicroprogramState = 8'd11;//32-bit immediate (Rd ,flags is affected)// despues ir a fetch 1 con delay

if(Instruction[20]==0)

MicroprogramState = 8'd16;//32-bit immediate (Rd is affected not flags)//  despues ir a fetch 1 con delay

end

end//case 001

3'b010: begin//Load Store immediate offset

if(Instruction[24]==1 & Instruction[21]==0)begin//LS immediate offset first states

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Immediate Offset Suma Calcular E.A

MicroprogramState = 8'd29;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Immediate Offset Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Immediate Offset Suma calcular E.A

MicroprogramState = 8'd19;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Immediate Offset Suma calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Immediate Offset Suma Calcular E.A

MicroprogramState = 8'd39;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Immediate Offset Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Immediate Offset Suma Calcular E.A

MicroprogramState = 8'd49;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Immediate Offset Suma Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Immediate Offset Resta Calcular E.A

MicroprogramState = 8'd20;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Immediate Offset Resta Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Immediate Offset Resta Calcular E.A 

MicroprogramState = 8'd40;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Immediate Offset Resta Calcular E.A

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Immediate Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd30;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Immediate Pre-Indexed Resta Calcular E.A 

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Immediate Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd50;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Immediate Pre-Indexed Resta Calcular E.A

end//LS immediate offset first states

else if(Instruction[24]==1 & Instruction[21]==1)begin//LS immediate pre-indexed first state

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Immediate Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd33;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Immediate Pre-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Immediate Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd23;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Immediate Pre-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Immediate Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd43;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Immediate Pre-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Immediate Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd53;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Immediate Pre-Indexed Suma Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Immediate Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd24;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Immediate Pre-Indexed Resta Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Immediate Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd44;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Immediate Pre-Indexed Resta Calcular E.A

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Immediate Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd34;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Immediate Pre-Indexed Resta Calcular E.A 

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Immediate Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd54;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Immediate Pre-Indexed Resta Calcular E.A







end//if ls imme pre index

else if(Instruction[24]==0)begin//LS immediate post-indexed first state

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Immediate Post-Indexed Suma E.A

MicroprogramState = 8'd95;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Immediate Post-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Immediate Post-Indexed Suma E.A

MicroprogramState = 8'd79;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Immediate Post-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Immediate Post-Indexed Suma E.A

MicroprogramState = 8'd111;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Immediate Post-Indexed Suma E.A

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Immediate Post-Indexed Suma E.A

MicroprogramState = 8'd127;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Immediate Post-Indexed Suma E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Immediate Post-Indexed Resta E.A

MicroprogramState = 8'd83;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Immediate Post-Indexed Resta E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Immediate Post-Indexed Resta E.A

MicroprogramState = 8'd115;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Immediate Post-Indexed Resta E.A

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Immediate Post-Indexed Resta E.A

MicroprogramState = 8'd99;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Immediate Post-Indexed Resta E.A 

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Immediate Post-Indexed Resta E.A

MicroprogramState = 8'd130;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Immediate Post-Indexed Resta E.A

end//if ls imme post indexed

end// case 010




3'b011: begin//Load Store Register offset



if(Instruction[24]==1 & Instruction[21]==0)begin//LS register offset first states


if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Register Offset Suma Calcular E.A

MicroprogramState = 8'd31;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Register Offset Suma Calcular E.A


if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Register Offset Suma calcular E.A

MicroprogramState = 8'd21;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Register Offset Suma calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Register Offset Suma Calcular E.A
MicroprogramState = 8'd41;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Register Offset Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Register Offset Suma Calcular E.A

MicroprogramState = 8'd51;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Register Offset Suma Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Register Offset Resta Calcular E.A

MicroprogramState = 8'd22;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Register Offset Resta Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Register Offset Resta Calcular E.A 

MicroprogramState = 8'd42;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Register Offset Resta Calcular E.A

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Register Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd32;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Register Pre-Indexed Resta Calcular E.A 

if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Register Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd52;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Register Pre-Indexed Resta Calcular E.A


end//LS regster offset first states



else if(Instruction[24]==1 & Instruction[21]==1)begin//LS register pre-indexed first state

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Register Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd35;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Register Pre-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Register Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd25;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Register Pre-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Register Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd45;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Register Pre-Indexed Suma Calcular E.A

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Register Pre-Indexed Suma Calcular E.A

MicroprogramState = 8'd55;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Register Pre-Indexed Suma Calcular E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Register Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd26;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Register Pre-Indexed Resta Calcular E.A


if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Register Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd46;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Register Pre-Indexed Resta Calcular E.A


if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Register Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd36;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Register Pre-Indexed Resta Calcular E.A 


if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Register Pre-Indexed Resta Calcular E.A

MicroprogramState = 8'd56;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Register Pre-Indexed Resta Calcular E.A



end//if ls register pre index



else if(Instruction[24]==0)begin//LS register post-indexed first state

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Register Post-Indexed Suma E.A

MicroprogramState = 8'd103;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Register Post-Indexed Suma E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Register Post-Indexed Suma E.A

MicroprogramState = 8'd87;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Register Post-Indexed Suma E.A

if(Instruction[23]==1 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Register Post-Indexed Suma E.A

MicroprogramState = 8'd117;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Register Post-Indexed Suma E.A

if(Instruction[23]==1 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Register Post-Indexed Suma E.A

MicroprogramState = 8'd125;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Register Post-Indexed Suma E.A

if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==1)begin//Load Word Register Post-Indexed Resta E.A

MicroprogramState = 8'd91;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Word Register Post-Indexed Resta E.A


if(Instruction[23]==0 & Instruction[22]==0 & Instruction[20]==0)begin//Store Word Register Post-Indexed Resta E.A

MicroprogramState = 8'd123;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Word Register Post-Indexed Resta E.A


if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==1)begin//Load Byte Register Post-Indexed Resta E.A

MicroprogramState = 8'd107;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Load Byte Register Post-Indexed Resta E.A 


if(Instruction[23]==0 & Instruction[22]==1 & Instruction[20]==0)begin//Store Byte Register Post-Indexed Resta E.A

MicroprogramState = 8'd139;//Microstore state es unico por el hecho de calcular el EA despues los estados de L/S bytes o words se repiten

end//Store Byte Register Post-Indexed Resta E.A


end//if ls register post indexed



end// case 011





3'b101: begin//branch & branch with link

if(Instruction[24]==0)begin

MicroprogramState = 10'd70;//Branch necesita 2 stages

end

else begin

MicroprogramState = 10'd72;//Branch with link necesita 4 stages

end

end//case branch

endcase

end//always

endmodule







module MultiplexerCU4to1#(parameter WIDTH =32)(Out,a,b,c,d,sel);

 input [WIDTH-1:0] a,b,c,d;

 input [1:0]sel;
 
 output reg [WIDTH-1:0]Out;

always @(sel,a,b,c)

begin

case(sel)

2'b00: Out=a;

2'b01: Out=b;

2'b10: Out=c;

2'b11: Out=d;

endcase    

end

endmodule





module Condition_Checker(output reg COND,input[3:0]StatusRegister_Output,input[31:0]Instruction);//Status Register Out wire[3:0] SR_Out={N,Z,C0,V};//N Z C V

always@(Instruction)begin

COND = 1'b1;

case(Instruction[31:28])

4'b0000://EQ (Equal)

if(StatusRegister_Output[2]==0) COND = 1'b0;// Z flag

4'b0001://NE (Not Equal)

if(StatusRegister_Output[2]==1) COND = 1'b0;//Z flag

4'b0010://CS/HS (Unsigned higher or same)

if(StatusRegister_Output[1]==0) COND = 1'b0;//C flag

4'b0011://CC/LO (Unsigned lower)

if(StatusRegister_Output[1]==1) COND = 1'b0;// C flag

4'b0100://MI (Minus)

if(StatusRegister_Output[3]==0) COND = 1'b0;//N flag

4'b0101://PL (Positive or zero)

if(StatusRegister_Output[3]==1) COND = 1'b0;//N_flag

4'b0110://VS (Overflow)

if(StatusRegister_Output[0]==0) COND = 1'b0;// V flag

4'b0111://VC (No Overflow)

if(StatusRegister_Output[0]==1) COND = 1'b0;// V flag

4'b1000://HI (Unsigned Higher)

if(StatusRegister_Output[1]==0 || StatusRegister_Output[2]==1) COND = 1'b0;//C flag || Z flag

4'b1001://LS (Unsigned Lower or same)

if(StatusRegister_Output[1]==1 && StatusRegister_Output[2]==0) COND = 1'b0;//C Flag && Z Flag

4'b1010://GE (Greater or equal)

if(StatusRegister_Output[3]==StatusRegister_Output[0]) COND = 1'b0;//N flag == V flag

4'b1011://LT (Less than)

if(StatusRegister_Output[3]!=StatusRegister_Output[0]) COND = 1'b0;// N flag != V Flag

4'b1100://GT (Greater than)

if(StatusRegister_Output[2]==1 || StatusRegister_Output[3]!=StatusRegister_Output[0]) COND = 1'b0;//Z_flag==1 || N_flag!=V_flag

4'b1101://LE (Less than or equal)

if(StatusRegister_Output[2]==0 && StatusRegister_Output[3]==StatusRegister_Output[0]) COND = 1'b0;//Z_flag==0 && N_flag==V_flag

4'b1110://AL (Always)

begin COND = 1'b1; end 

default:

COND = 1'b0;

endcase

end//always

endmodule



module NextAddressSelector(input [2:0] Pipeline, input MFC, Condition, output reg[1:0] Next_Select);

always@(Pipeline,MFC,Condition)

case(Pipeline)

3'b000: begin //FECTH

Next_Select = 2'b11;

end

3'b001: begin //CHECK CONDITION

if(Condition == 1)

Next_Select = 2'b00;

else Next_Select = 2'b01;

end

3'b010: begin //Ejecutando Instruccion Pipeline

Next_Select = 2'b10;

end

3'b011: begin //Ejecutando Instruccion Incrementer

Next_Select = 2'b11;

end

3'b100: begin //Instruccion Termino

Next_Select = 2'b01;

end

3'b101: begin //Instruccion Load

//$display("Entre a always de Next Address Selector: %b", Condition);

if(MFC==1)begin

Next_Select = 2'b11;

end

else Next_Select = 2'b10;

end

3'b110: begin //Instruccion Store Address Final (Ultima parte de la instruccion)

if (MFC==1)

Next_Select = 2'b01;

else Next_Select = 2'b10;

end

3'b111: begin //Instruccion Store Address No Final (No es la ultima parte de la instruccion

if (MFC==1)begin

Next_Select = 2'b11;

end

else Next_Select = 2'b10;

end

3'bxxx:begin

//$display("Entre a always de Next Address Selector: %b", Condition);

Next_Select = 2'b01;

end

default:begin

Next_Select = 2'b01;

end

endcase

endmodule 



module Microstore(output reg[57:0]Out,input[9:0]State);

reg[57:0]ROM[0:255];

initial begin
//Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3 
 

ROM[1]=58'b000_0000000010_000_01_x_xxx_011_011_10_10_11_1_0_0_0_1_0_x_xx_0_11_xxxx_xxxx_1111;//sacar PC

ROM[2]=58'b000_0000000011_000_01_x_xxx_011_011_10_10_01_0_0_0_0_0_0_x_xx_0_11_xxxx_1111_xxxx;//apago el MAR sumo PC=4

ROM[3]=58'b000_0000000100_000_01_x_011_011_011_10_10_01_0_0_0_1_0_0_x_xx_0_11_1111_xxxx_xxxx;// Prendo RF Enable

ROM[4]=58'b000_0000000101_000_01_x_xxx_011_011_10_10_01_0_0_0_0_0_0_x_xx_0_11_xxxx_xxxx_xxxx;// Apago RF Enable

ROM[5]=58'b101_0000000101_000_01_x_xxx_011_011_10_10_01_0_0_0_0_0_1_1_10_0_11_1111_1111_1111;// Leer del RAM @ MAR Wait MFC==1

ROM[6]=58'b000_0000000111_000_01_x_xxx_011_011_10_10_01_0_0_1_0_0_1_1_10_0_11_xxxx_xxxx_xxx1;//Prender IR

ROM[7]=58'b001_0000001000_000_01_x_xxx_011_011_10_10_01_0_0_0_0_0_1_1_10_0_11_1xxx_xxxx_1xxx;//Apagar IR IR is Loaded || Check Condition to select  Output de Instruction decode

//DATA PROCESSING.

ROM[10]=58'b100_0000000001_001_00_0_000_000_010_01_01_00_0_0_0_0_1_0_0_xx_1_11_xxxx_xxxx_xxxx;//Data processing immediate operaciones que no afectan Rd. Despues de esto hacer fetch 1

ROM[11]=58'b100_0000000001_001_00_0_000_000_010_01_01_00_0_0_0_1_1_0_0_xx_1_11_xxxx_xxxx_xxxx;//Data processing immediate operaciones que afectan Rd y flags. Despues de esto fetch 1 pero con un delay para que escriba al RF

ROM[13]=58'b100_0000000001_000_00_0_000_001_010_00_00_00_0_0_0_0_1_0_0_xx_1_xx_xxxx_xxxx_xxxx;//Data processing shift by immediate shifter operaciones que no afectan Rd. Despues de esto fetch 1

ROM[14]=58'b100_0000000001_000_00_0_000_001_010_00_00_00_0_0_0_1_1_0_0_xx_1_xx_xxxx_xxxx_xxxx;//Data processing shift by immediate shifter operaciones que afectan Rd y flags. Despues de esto fetch 1 pero con delay para que escriba al RF

ROM[16]=58'b100_0000000001_001_00_0_000_000_010_01_01_00_0_0_0_1_1_0_0_xx_0_11_xxxx_xxxx_xxxx;//Data processing immediate operaciones que afectan Rd y no flags. Despues de esto fetch 1 pero con un delay para que escriba.

//Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3 
 

ROM[18]=58'b100_0000000001_000_00_0_000_001_010_00_00_00_0_0_0_1_1_0_0_xx_0_xx_xxxx_xxxx_xxxx;//Data processing shift by immediate shifter operaciones que afectan Rd y no flags. Despues de esto fetch 1 pero con delay para que escriba al RF

// FIN DE DATA PROCESSING


///////////PRINCIPIO DE ADDRESSING MODE 2 Offset and Pre-Indexed///////////

////Output Control Signals::  NextStateSelectorInput_PipeLine_Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3  

ROM[19]=58'b010_0000011011_001_00_x_000_xxx_xxx_10_10_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Immediate Offset Suma calcular E.A

ROM[20]=58'b010_0000011011_001_00_x_000_xxx_xxx_10_10_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Immediate Offset Resta Calcular E.A

ROM[21]=58'b010_0000011011_000_00_x_000_001_xxx_00_00_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Register Offset Suma Calcular E.A

ROM[22]=58'b010_0000011011_000_00_x_000_001_xxx_00_00_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Register Offset Resta Calcular E.A

ROM[23]=58'b010_0000011011_001_00_x_000_xxx_000_10_10_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Immediate Pre-Indexed Suma Calcular E.A

ROM[24]=58'b010_0000011011_001_00_x_000_xxx_000_10_10_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Immediate Pre-Indexed Resta Calcular E.A

ROM[25]=58'b010_0000011011_000_00_x_000_001_000_00_00_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Register Pre-Indexed Suma Calcular E.A

ROM[26]=58'b010_0000011011_000_00_x_000_001_000_00_00_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Register Pre-Indexed Resta Calcular E.A

ROM[27]=58'b101_0000011011_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_x_1_1_10_0_11_xxxx_xxxx_xxxx; //Load Word Stage 2 (Cargar MDR con RAM)

ROM[28]=58'b100_0000000010_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_0_xx_0_xx_xxxx_xxxx_xxxx; //Load Word Stage 3 (Pasar el MAR al Registro Rd)

ROM[29]=58'b010_0000100101_001_00_x_000_xxx_xxx_10_10_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Immediate Offset Suma calcular E.A

ROM[30]=58'b010_0000100101_001_00_x_000_xxx_xxx_10_10_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Immediate Offset Resta Calcular E.A

ROM[31]=58'b010_0000100101_000_00_x_000_001_xxx_00_00_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Register Offset Suma Calcular E.A

ROM[32]=58'b010_0000100101_000_00_x_000_001_xxx_00_00_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Register Offset Resta Calcular E.A

ROM[33]=58'b010_0000100101_001_00_x_000_xxx_000_10_10_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Immediate Pre-Indexed Suma Calcular E.A

ROM[34]=58'b010_0000100101_001_00_x_000_xxx_000_10_10_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Immediate Pre-Indexed Resta Calcular E.A

ROM[35]=58'b010_0000100101_000_00_x_000_001_000_00_00_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Register Pre-Indexed Suma Calcular E.A

ROM[36]=58'b010_0000100101_000_00_x_000_001_000_00_00_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Register Pre-Indexed Resta Calcular E.A

ROM[37]=58'b101_0000100101_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_x_1_1_00_0_11_xxxx_xxxx_xxxx; //Load Byte Stage 2 (Cargar MDR con RAM)

ROM[38]=58'b100_0000000010_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_0_xx_0_xx_xxxx_xxxx_xxxx; //Load Byte Stage 3 (Pasar el MAR al Registro Rd)

ROM[39]=58'b010_0000101111_001_00_x_000_xxx_xxx_10_10_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Immediate Offset Suma calcular E.A

ROM[40]=58'b010_0000101111_001_00_x_000_xxx_xxx_10_10_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Immediate Offset Resta Calcular E.A

ROM[41]=58'b010_0000101111_000_00_x_000_001_xxx_00_00_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Register Offset Suma Calcular E.A

ROM[42]=58'b010_0000101111_000_00_x_000_001_xxx_00_00_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Register Offset Resta Calcular E.A

ROM[43]=58'b010_0000101111_001_00_x_000_xxx_000_10_10_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Immediate Pre-Indexed Suma Calcular E.A

ROM[44]=58'b010_0000101111_001_00_x_000_xxx_000_10_10_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Immediate Pre-Indexed Resta Calcular E.A

ROM[45]=58'b010_0000101111_000_00_x_000_001_000_00_00_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Register Pre-Indexed Suma Calcular E.A

ROM[46]=58'b010_0000101111_000_00_x_000_001_000_00_00_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Register Pre-Indexed Resta Calcular E.A

ROM[47]=58'b011_0000101111_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Word Stage 2 (Cargar MDR con Rd)

ROM[48]=58'b110_0000000010_xxx_xx_x_xxx_xxx_xxx_10_10_xx_0_0_0_0_0_1_0_10_0_xx_xxxx_xxxx_xxxx; //Store Word Stage 3 (Cargar RAM con MDR)

ROM[49]=58'b010_0000111001_001_00_x_000_xxx_xxx_10_10_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Immediate Offset Suma calcular E.A

ROM[50]=58'b010_0000111001_001_00_x_000_xxx_xxx_10_10_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Immediate Offset Resta Calcular E.A

ROM[51]=58'b010_0000111001_000_00_x_000_001_xxx_00_00_01_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Register Offset Suma Calcular E.A

ROM[52]=58'b010_0000111001_000_00_x_000_001_xxx_00_00_10_1_0_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Register Offset Resta Calcular E.A

ROM[53]=58'b010_0000111001_001_00_x_000_xxx_000_10_10_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Immediate Pre-Indexed Suma Calcular E.A

ROM[54]=58'b010_0000111001_001_00_x_000_xxx_000_10_10_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Immediate Pre-Indexed Resta Calcular E.A

ROM[55]=58'b010_0000111001_000_00_x_000_001_000_00_00_01_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Register Pre-Indexed Suma Calcular E.A

ROM[56]=58'b010_0000111001_000_00_x_000_001_000_00_00_10_1_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Register Pre-Indexed Resta Calcular E.A

ROM[57]=58'b011_0000111001_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx; //Store Byte Stage 2 (Cargar MDR con Rd)

ROM[58]=58'b110_0000000010_xxx_xx_x_xxx_xxx_xxx_10_10_xx_0_0_0_0_0_1_0_00_0_xx_xxxx_xxxx_xxxx; //Store Byte Stage 3 (Cardar RAM con MDR)
//FIN DE LOAD/STORE ADDRESSING MODE 2 PRE-INDEXED Y OFFSET

// BRANCH Y BRANCH AND LINK

ROM[70]=58'b011_0000000001_010_00_x_011_xxx_011_xx_xx_01_0_0_0_0_0_0_x_xx_0_11_xxxx_xxxx_xxxx;// Branch No link 2 stages ASelect==1SALE Lo que entra en B de ALU si Select9 es 11b  A_Select==0SALE Lo que entra en A de ALU si Select9 es 11b 

ROM[71]=58'b100_0000000001_010_00_x_011_xxx_011_xx_xx_01_0_0_0_1_0_0_x_xx_0_11_xxxx_xxxx_xxxx;// Branch No link Prendo RF. Despues de esto ir a fetch 1

ROM[72]=58'b011_0000000001_000_00_x_011_xxx_100_xx_xx_11_0_0_0_0_0_0_x_xx_0_11_xxxx_xxxx_xxxx;//Branch and Link Stage 1

ROM[73]=58'b011_0000000010_000_00_x_011_xxx_100_xx_xx_11_0_0_0_1_0_0_x_xx_0_11_xxxx_xxxx_xxxx;//Branch and Link Stage 2

ROM[74]=58'b011_0000000011_010_00_x_011_xxx_011_xx_xx_01_0_0_0_0_0_0_x_xx_0_11_xxxx_xxxx_xxxx;// Branch and Link Stage 3

ROM[75]=58'b100_0000000100_010_00_x_011_xxx_011_xx_xx_01_0_0_0_1_0_0_x_xx_0_11_xxxx_xxxx_xxxx;//Branch and Link Stage 4 despues ir a fetch 1

//FIN DE BRANCH Y BRANCH AND LINK

//LOAD STORE ADDRESSING MODE 2 POST INDEXED ADDRESSING
////Output Control Signals::  NextStateSelectorInput_PipeLine_Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3 

ROM[79]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Word Immediate Post-Indexed Suma E.A

ROM[80]=58'b101_0001010000_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_10_0_11_xxxx_xxxx_xxxx;//Load Word Immediate Post-Indexed Suma Stage 2 Cargar MDR con RAM

ROM[81]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Immediate Post-Indexed Suma Stage 3 Pasar de MDR a Rd

ROM[82]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Immediate Post-Indexed Suma Update Rn

ROM[83]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Word Immediate Post-Indexed Resta E.A

ROM[84]=58'b101_0001010100_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_10_0_11_xxxx_xxxx_xxxx;//Load Word Immediate Post-Indexed Resta Stage 2 Cargar MDR con RAM

ROM[85]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Immediate Post-Indexed Resta Stage 3 Pasar de MDR a Rd

ROM[86]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Immediate Post-Indexed Resta Update Rn

ROM[87]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Word Register Post-Indexed Suma E.A

ROM[88]=58'b101_0001011000_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_10_0_11_xxxx_xxxx_xxxx;//Load Word Register Post-Indexed Suma Stage 2 Cargar MDR con RAM

ROM[89]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Register Post-Indexed Suma Stage 3 Pasar de MDR a Rd

ROM[90]=58'b100_0000000100_000_00_x_000_001_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Register Post-Indexed Suma Update Rn

ROM[91]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Word Register Post-Indexed Resta E.A

ROM[92]=58'b101_0001011100_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_10_0_11_xxxx_xxxx_xxxx;//Load Word Register Post-Indexed Resta Stage 2 Cargar MDR con RAM

ROM[93]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Register Post-Indexed Resta Stage 3 Pasar de MDR a Rd

ROM[94]=58'b100_0000000100_000_00_x_000_001_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Word Register Post-Indexed Resta Update Rn

ROM[95]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Byte Immediate Post-Indexed Suma E.A

ROM[96]=58'b101_0001100000_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_00_0_11_xxxx_xxxx_xxxx;//Load Byte Immediate Post-Indexed Suma Stage 2 Cargar MDR con RAM

ROM[97]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Immediate Post-Indexed Suma Stage 3 Pasar de MDR a Rd

ROM[98]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Immediate Post-Indexed Suma Update Rn

ROM[99]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Byte Immediate Post-Indexed Resta E.A

ROM[100]=58'b101_0001100100_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_00_0_11_xxxx_xxxx_xxxx;//Load Byte Immediate Post-Indexed Resta Stage 2 Cargar MDR con RAM

ROM[101]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Immediate Post-Indexed Resta Stage 3 Pasar de MDR a Rd

ROM[102]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Immediate Post-Indexed Resta Update Rn

ROM[103]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Byte Register Post-Indexed Suma E.A

ROM[104]=58'b101_0001101000_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_00_0_11_xxxx_xxxx_xxxx;//Load Byte Register Post-Indexed Suma Stage 2 Cargar MDR con RAM

ROM[105]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Register Post-Indexed Suma Stage 3 Pasar de MDR a Rd

ROM[106]=58'b100_0000000100_000_00_x_000_001_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Register Post-Indexed Suma Update Rn

ROM[107]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Load Byte Register Post-Indexed Resta E.A

ROM[108]=58'b101_0001101100_000_00_1_xxx_xxx_xxx_10_10_xx_0_1_0_0_0_1_1_00_0_11_xxxx_xxxx_xxxx;//Load Byte Register Post-Indexed Resta Stage 2 Cargar MDR con RAM

ROM[109]=58'b011_0000000011_011_00_x_xxx_xxx_010_10_10_11_0_0_0_1_1_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Register Post-Indexed Resta Stage 3 Pasar de MDR a Rd

ROM[110]=58'b100_0000000100_000_00_x_000_001_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Load Byte Register Post-Indexed Resta Update Rn

ROM[111]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Word Immediate Post-Indexed Suma E.A

ROM[112]=58'b011_0001110000_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Immediate Post-Indexed Suma Stage 2 Cargar MDR con Rd

ROM[113]=58'b111_0001110001_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_10_0_xx_xxxx_xxxx_xxxx;//Store Word Immediate Post-Indexed Suma Stage 3 Pasar de MDR a RAM

ROM[114]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Immediate Post-Indexed Suma Update Rn

ROM[115]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Word Immediate Post-Indexed Resta E.A

ROM[116]=58'b011_0001110100_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Immediate Post-Indexed Resta Stage 2 Cargar MDR con Rd

ROM[117]=58'b111_0001110101_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_10_0_xx_xxxx_xxxx_xxxx;//Store Word Immediate Post-Indexed Resta Stage 3 Pasar de MDR a RAM

ROM[118]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Immediate Post-Indexed Resta Update Rn

ROM[119]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Word Register Post-Indexed Suma E.A

ROM[120]=58'b011_0001111000_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Register Post-Indexed Suma Stage 2 Cargar MDR con Rd

ROM[121]=58'b111_0001111001_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_10_0_xx_xxxx_xxxx_xxxx;//Store Word Register Post-Indexed Suma Stage 3 Pasar de MDR a RAM

ROM[122]=58'b100_0000000100_001_00_x_000_001_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Register Post-Indexed Suma Update Rn

ROM[123]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Word Register Post-Indexed Resta E.A

ROM[124]=58'b011_0001111100_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Register Post-Indexed Resta Stage 2 Cargar MDR con Rd

ROM[125]=58'b111_0001111101_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_10_0_xx_xxxx_xxxx_xxxx;//Store Word Register Post-Indexed Resta Stage 3 Pasar de MDR a RAM

ROM[126]=58'b100_0000000100_001_00_x_000_001_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Word Register Post-Indexed Resta Update Rn

ROM[127]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Byte Immediate Post-Indexed Suma E.A

ROM[128]=58'b011_0010000000_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Immediate Post-Indexed Suma Stage 2 Cargar MDR con Rd

ROM[129]=58'b111_0010000001_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_00_0_xx_xxxx_xxxx_xxxx;//Store Byte Immediate Post-Indexed Suma Stage 3 Pasar de MDR a RAM

ROM[130]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Immediate Post-Indexed Suma Update Rn

ROM[131]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Byte Immediate Post-Indexed Resta E.A

ROM[132]=58'b011_0010000100_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Immediate Post-Indexed Resta Stage 2 Cargar MDR con Rd

ROM[133]=58'b111_0010000101_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_00_0_xx_xxxx_xxxx_xxxx;//Store Byte Immediate Post-Indexed Resta Stage 3 Pasar de MDR a RAM

ROM[134]=58'b100_0000000100_001_00_x_000_xxx_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Immediate Post-Indexed Resta Update Rn

ROM[135]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Byte Register Post-Indexed Suma E.A

ROM[136]=58'b011_0010001000_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Register Post-Indexed Suma Stage 2 Cargar MDR con Rd

ROM[137]=58'b111_0010001001_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_00_0_xx_xxxx_xxxx_xxxx;//Store Byte Register Post-Indexed Suma Stage 3 Pasar de MDR a RAM

ROM[138]=58'b100_0000000100_001_00_x_000_001_000_10_10__01_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Register Post-Indexed Suma Update Rn

ROM[139]=58'b011_0000000001_000_00_x_000_xxx_xxx_10_10_11_1_0_0_0_0_0_x_xx_0_xx_XXXX_XXXX_XXXX;//Store Byte Register Post-Indexed Resta E.A

ROM[140]=58'b011_0010001100_000_00_0_010_xxx_xxx_10_10_11_0_1_0_0_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Register Post-Indexed Resta Stage 2 Cargar MDR con Rd

ROM[141]=58'b111_0010001101_000_00_0_xxx_xxx_xxx_10_10_11_0_0_0_0_0_1_0_00_0_xx_xxxx_xxxx_xxxx;//Store Byte Register Post-Indexed Resta Stage 3 Pasar de MDR a RAM

ROM[142]=58'b100_0000000100_001_00_x_000_001_000_10_10_10_0_0_0_1_0_0_x_xx_0_xx_xxxx_xxxx_xxxx;//Store Byte Register Post-Indexed Resta Update Rn

end

always@(State)begin
//$display("ARM Microstore State:%d",State);

Out=ROM[State];
if(State == 142 || State == 138 || State == 134 || State == 130 || State == 126 || State == 122 || State == 118 || State == 114 || State == 110 || State == 106 || State == 102 || State == 98 || State == 94 || State == 90 || State == 86 || State == 82) begin
$display("Updating Rn");
end
//$display("ARM CU Signal Output:%b",Out[44:0]);
end

endmodule

module ControlUnit(output reg[44:0]Signals,input MFC,Clk,input[3:0]StatusRegister_Output,input[31:0]Instruction);

//Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3  

//44:42_41:40_39_38:36_35:33_32:30_29:28_27:26_25:24_23_22_21_20_19_18_17_16:15_14_13:12_11:8_7:4_3:0

reg[2:0]Pipeline;

wire Condition;

wire[1:0]Select;

reg[1:0] sel;

reg[31:0]a,b,c,d;

wire[9:0]OutMux;

wire[31:0]Incremented;

wire[9:0]MicroprogramState;

reg[44:0]ControlSignals;

wire[57:0]uStore;

NextAddressSelector Selector(Pipeline,MFC,Condition,Select);

DecodeInstruction Decoder(MicroprogramState,Instruction);

Condition_Checker Cond(Condition,StatusRegister_Output,Instruction);//Status Register Out wire[3:0] SR_Out={N,Z,C0,V};//N Z C V

reg[1:0] Mem[0:255];

Incrementer In(Incremented,OutMux);

MultiplexerCU4to1 DUT(OutMux,MicroprogramState,1,c,Incremented,Select);//c es pipeline del microstore

Microstore Store(uStore,OutMux);







always@(posedge Clk) begin

Pipeline<=uStore[57:55];

//$display("Always de CU Pipeline:%b",Pipeline);

//#3$display("Initial de CU Select:%b",Select);

c<=uStore[54:45];

ControlSignals=uStore[44:0];

//#1$display("Always de CU ControlSignals:%b",ControlSignals);

#2Signals<=ControlSignals;

end



endmodule

/*
 * 
 * 
 * Fin Control Unit
 * 
 * 
 */
module Registro(output reg [31:0] Q, input [31:0] DataIn,input Enable,Clr,Clk);//prende con enable ==1 // clear ==0

always@(posedge Clk or negedge Clr) begin

if(!Clr)

Q<=32'h00000000;

if(Enable)

Q<=DataIn;

end//always

endmodule

module decoder4x16(decoder_out,address3,decenable);

input [3:0]address3;

input decenable;

output reg [15:0] decoder_out;

always @ (address3 or decenable) begin

    decoder_out = 0;

    if(decenable) begin//active high

    case (address3)

      4'h0 : decoder_out = 16'h0001;

      4'h1 : decoder_out = 16'h0002;

      4'h2 : decoder_out = 16'h0004;

      4'h3 : decoder_out = 16'h0008;

      4'h4 : decoder_out = 16'h0010;

      4'h5 : decoder_out = 16'h0020;

      4'h6 : decoder_out = 16'h0040;

      4'h7 : decoder_out = 16'h0080;

      4'h8 : decoder_out = 16'h0100;

      4'h9 : decoder_out = 16'h0200;

      4'hA : decoder_out = 16'h0400;

      4'hB : decoder_out = 16'h0800;

      4'hC : decoder_out = 16'h1000;

      4'hD : decoder_out = 16'h2000;

      4'hE : decoder_out = 16'h4000;

      4'hF : decoder_out = 16'h8000;
     endcase
  end//if decenable
end//always
endmodule
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module  SixteenToOneMux#(parameter WIDTH =32)(output reg[WIDTH-1:0]Output,input[WIDTH-1:0] in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,input[3:0]select);

always @(select,in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16)

    begin
        case(select)

            4'b0000: Output=in1;

            4'b0001: Output=in2;

            4'b0010: Output=in3;

            4'b0011: Output=in4;

            4'b0100: Output=in5;

            4'b0101: Output=in6;

            4'b0110: Output=in7;

            4'b0111: Output=in8;

            4'b1000: Output=in9;

            4'b1001: Output=in10;

            4'b1010: Output=in11;

            4'b1011: Output=in12;

            4'b1100: Output=in13;

            4'b1101: Output=in14;

            4'b1110: Output=in15;

            4'b1111: Output=in16;
        endcase   
    end
endmodule
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module RegisterFile(OUT1,OUT2,Clk,Clr,LoadEnable,DataInput,Address1,Address2,Address3);//DecEnable con High| DATAINPUT 32 bits| Con address 3 se selecciona a que registro se va a escribir | Con address 1 y address 2 cuales se van a leer

    output reg[31:0] OUT1,OUT2;

    input Clk,Clr,LoadEnable;

    input [31:0] DataInput;

    input [3:0] Address1,Address2,Address3;

    wire[31:0] OutputsDeRegistros[15:0];

    wire[15:0] OutdeDec; 

    wire [31:0] Outtemporero1,Outtemporero2; 
 //module  SixteenToOneMux#(parameter WIDTH =32)(output reg[WIDTH-1:0]Output,input[WIDTH-1:0] in1,in2,in3,in4,in5,in6,in7,in8,in9,in10,in11,in12,in13,in14,in15,in16,input[3:0]select);

    SixteenToOneMux Mux1(Outtemporero1,OutputsDeRegistros[0],OutputsDeRegistros[1],OutputsDeRegistros[2],OutputsDeRegistros[3],OutputsDeRegistros[4],OutputsDeRegistros[5],OutputsDeRegistros[6],OutputsDeRegistros[7],OutputsDeRegistros[8],OutputsDeRegistros[9],OutputsDeRegistros[10],OutputsDeRegistros[11],OutputsDeRegistros[12],OutputsDeRegistros[13],OutputsDeRegistros[14],OutputsDeRegistros[15],Address1);

    SixteenToOneMux Mux2(Outtemporero2,OutputsDeRegistros[0],OutputsDeRegistros[1],OutputsDeRegistros[2],OutputsDeRegistros[3],OutputsDeRegistros[4],OutputsDeRegistros[5],OutputsDeRegistros[6],OutputsDeRegistros[7],OutputsDeRegistros[8]
        ,OutputsDeRegistros[9],OutputsDeRegistros[10],OutputsDeRegistros[11],OutputsDeRegistros[12],OutputsDeRegistros[13],OutputsDeRegistros[14],OutputsDeRegistros[15],Address2);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//module decoder4x16(decoder_out,address1,decenable);

    decoder4x16 Decoder(OutdeDec,Address3,LoadEnable);//OutDec es el enable de los registros // DECENABLE HIGH

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////       

//module Registro(output reg [31:0] Q, input [31:0] DataIn,input Enable,Clr,Clk);//prende con enable ==1 // clear ==0 // enable output de decoder

    Registro Reg0(OutputsDeRegistros[0],DataInput,OutdeDec[0],Clr,Clk);//Decoder.decoder_out[0] ES ENABLE HIGH

    Registro Reg1(OutputsDeRegistros[1],DataInput,OutdeDec[1],Clr,Clk);

    Registro Reg2(OutputsDeRegistros[2],DataInput,OutdeDec[2],Clr,Clk);

    Registro Reg3(OutputsDeRegistros[3],DataInput,OutdeDec[3],Clr,Clk);

    Registro Reg4(OutputsDeRegistros[4],DataInput,OutdeDec[4],Clr,Clk);

    Registro Reg5(OutputsDeRegistros[5],DataInput,OutdeDec[5],Clr,Clk);

    Registro Reg6(OutputsDeRegistros[6],DataInput,OutdeDec[6],Clr,Clk);

    Registro Reg7(OutputsDeRegistros[7],DataInput,OutdeDec[7],Clr,Clk);

    Registro Reg8(OutputsDeRegistros[8],DataInput,OutdeDec[8],Clr,Clk);

    Registro Reg9(OutputsDeRegistros[9],DataInput,OutdeDec[9],Clr,Clk);

    Registro Reg10(OutputsDeRegistros[10],DataInput,OutdeDec[10],Clr,Clk);

    Registro Reg11(OutputsDeRegistros[11],DataInput,OutdeDec[11],Clr,Clk);

    Registro Reg12(OutputsDeRegistros[12],DataInput,OutdeDec[12],Clr,Clk);

    Registro Reg13(OutputsDeRegistros[13],DataInput,OutdeDec[13],Clr,Clk);

    Registro Reg14(OutputsDeRegistros[14],DataInput,OutdeDec[14],Clr,Clk);

    Registro Reg15(OutputsDeRegistros[15],DataInput,OutdeDec[15],Clr,Clk); 

    always@(*) begin 

    OUT1<=Outtemporero1;

    OUT2<=Outtemporero2;
    end   
endmodule
///////////////////////////////////////////////////////////////


module RAM(output reg [63:0] DataOut,output reg MFC, input MFA, ReadWrite, input [7:0] Address, input [31:0] DataIn,input [1:0] DataType);

reg [7:0] Memory[0:255]; //

reg [7:0]tempBYTE;

reg [15:0]tempHALFWORD;

reg [31:0]tempWORD;

reg [63:0]tempDOUBLEWORD;

reg [7:0]RealAddress;

always @ (MFA, ReadWrite,DataIn,Address,DataType)

if (MFA) begin

if (ReadWrite) begin MFC=1'b0;


    case(DataType) 

     2'b00: begin  tempBYTE= Memory[Address]; DataOut=tempBYTE; end

     2'b01: begin  RealAddress = Address & (8'hFE); tempHALFWORD= {Memory[RealAddress],Memory[RealAddress+1]};  DataOut=tempHALFWORD; end

     2'b10: begin  RealAddress = Address & (8'hFC); tempWORD= {Memory[RealAddress],Memory[RealAddress+1],Memory[RealAddress+2],Memory[RealAddress+3]};  DataOut=tempWORD; end

     2'b11: begin  RealAddress = Address & (8'hFC); tempDOUBLEWORD= {Memory[RealAddress],Memory[RealAddress+1],Memory[RealAddress+2],Memory[RealAddress+3],Memory[RealAddress+4],Memory[RealAddress+5],Memory[RealAddress+6],Memory[RealAddress+7]}; DataOut=tempDOUBLEWORD;   end

    endcase
    
    MFC=1'b1;

end//read

else begin //write

    case(DataType)

     2'b00: begin //BYTE
      //$display("Storing Byte");

      MFC=1'b0;

      Memory[Address]<=DataIn[7:0];

      MFC=1'b1;

      end//BYTE

     2'b01: begin//HALFWORD

      RealAddress = Address & (8'hFE);

      MFC=1'b0;

      Memory[RealAddress]<=DataIn[15:8];

      Memory[RealAddress+1]<=DataIn[7:0];

      MFC=1'b1;

     end//HALFWORD

     2'b10: begin  //WORD

      RealAddress = Address & (8'hFC);

      MFC=1'b0;

      Memory[RealAddress]<=DataIn[31:24];

      Memory[RealAddress+1]<=DataIn[23:16];

      Memory[RealAddress+2]<=DataIn[15:8];

      Memory[RealAddress+3]<=DataIn[7:0];

      MFC=1'b1;
      end//WORD

     2'b11: begin  

     end

    endcase

    end

end//enable    

else begin 

DataOut = 64'bz;

MFC = 1'b0;

end

endmodule

//////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module ALU (output reg [31:0] Y, output reg V, C0, Z, N, input [31:0] A, B, SH, input [3:0] S, input [1:0] S_O, input C, input SELECT);

reg [32:0] Y0;

wire [31:0] Outdeshifter;

wire CO;

SHIFT shifter (B, SH, S_O, C, Outdeshifter, CO);

always @ (S, A, Outdeshifter, SELECT)

case (S)

4'b0000: begin //Operador Logico AND


Y = A & Outdeshifter;

V = 0;

C0 = (Y != 0)? 1:0;

N = Y[31];

Z = (Y == 0)? 1:0;

end

4'b0001: begin 

Y = A ^ Outdeshifter; //Operador Logico XOR

V = 0;

C0 = (Y != 0)? 1:0;

N = Y[31];

Z = (Y == 0)? 1:0;
end

4'b0010: begin //Operador Aritmetico A - B

Y0 = A - Outdeshifter;

Y = Y0 & (32'hFFFFFFFF);

C0 = (Y0[32] == 1)? 0:1;

N = Y[31];

Z = (Y == 0)? 1:0;

if (A[31] != Outdeshifter[31])

begin if (Y[31] == Outdeshifter[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b0011: begin //Operador Ariemteico B - A

Y0 = Outdeshifter - A;

Y = Y0 & (32'hFFFFFFFF);

C0 = (Y0[32] == 1)? 0:1;

N = Y[31];

Z = (Y == 0)? 1:0;

if (A[31] != Outdeshifter[31])

begin if (Y[31] == A[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b0100: begin //Operador Aritmetico A + B

Y0 = A + Outdeshifter;

Y = Y0 & (32'hFFFFFFFF);

C0 = (Y0[32] == 1)? 1:0;

N = Y[31];

Z = (Y == 0)? 1:0;

if (A[31] == Outdeshifter[31])

begin if (Y[31] != Outdeshifter[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b0101: begin //Operador Aritmetico A + B + Carry

Y0 = A + Outdeshifter + CO;

Y = Y0 & (32'hFFFFFFFF);

C0 = (Y0[32] == 1)? 1:0;

N = Y[31];

Z = (Y == 0)? 1:0;

if (A[31] == Outdeshifter[31])

begin if (Y[31] != Outdeshifter[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b0110: begin //Operador Aritmetico A - B + Carry

Y0 = A - Outdeshifter + CO;

Y = Y0 & (32'hFFFFFFFF);

C0 = (Y0[32] == 1)? 0:1;

N = Y[31];

Z = (Y == 0)? 1:0;

if (A[31] != Outdeshifter[31])

begin if (Y[31] == Outdeshifter[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b0111: begin //Operador Aritmetico B - A + Carry

Y0 = Outdeshifter - A + CO;

Y = Y0 & (32'hFFFFFFFF);

C0 = (Y0[32] == 1)? 0:1;

N = Y[31];

Z = (Y == 0)? 1:0;

if (A[31] != Outdeshifter[31])

begin if (Y[31] == A[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b1000: begin //Operador Logico AND sin afectar salida

Y0 = A & Outdeshifter;

V = 0;

C0 = (Y != 0)? 1:0;

N = Y[31];

Z = (Y == 0)? 0:1;

end

4'b1001: begin //Operador Logico XOR sin afectar salida

Y0 = A ^ Outdeshifter;

V = 0;

C0 = (Y != 0)? 1:0;

N = Y[31];

Z = (Y == 0)? 0:1;

end

4'b1010: begin //Operador Aritmetico A - B sin afectar salida

Y0 = A - Outdeshifter;

N = Y0[31];

C0 = (Y0[32] == 1)? 0:1;

Z = (Y == 0)? 1:0;

if (A[31] != Outdeshifter[31])

begin if (Y[31] == Outdeshifter[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b1011: begin //Operador Aritmetioo A + B sin afectar salida

Y0 = A + Outdeshifter;

N = Y0[31];

C0 = (Y0[32] == 1)? 1:0;

Z = (Y == 0)? 1:0;

if (A[31] == Outdeshifter[31])

begin if (Y[31] != Outdeshifter[31])

V = 1;

else V = 0;

end

else V = 0;

end

4'b1100: begin //Operador Aritmetico OR

Y = A | Outdeshifter;

V = 0;

C0 = (Y != 0)? 1:0;

N = Y[31];

Z = (Y == 0)? 1:0;

end

4'b1101: begin //Operador MOV

Y = (SELECT == 0)? A:Outdeshifter;

V = 0;

C0 = CO;

N = Y[31];

Z = (Y == 0)? 1:0;

end

4'b1110: begin //Operador BIT CLEAR

Y = A & ~(Outdeshifter);

V = 0;

C0 = (Y != 0)? 1:0;

N = Y[31];

Z = (Y == 0)? 1:0;

end

4'b1111: begin //Operador MOV NOT

Y = (SELECT == 0)? ~(A):~(Outdeshifter);

V = 0;

C0 = CO;

N = Y[31];

Z = (Y == 0)? 1:0;

end

endcase

endmodule



module SHIFT (input [31:0] A, SH, input [1:0] S_O, input C, output reg [31:0] AO, output reg CO);
reg D;
integer index;

always @ (A,SH,S_O)



case (S_O)

2'b00: begin //Logical Shift Left

CO = C;

AO = A;

for(index = 0; index < SH; index = index +1) begin

CO = AO[31];

AO = AO << 1;


end


end





2'b01: begin //Logical Shift RIght

CO = C;


AO = A;


for(index = 0; index < SH; index = index +1) begin



CO = AO[0];



AO = AO >> 1;

end

end



2'b10: begin //Aritmetic Shift Right

CO = C;

AO = A;

for(index = 0; index < SH; index = index +1) begin

CO = AO[0];

AO = $signed(AO) >>> 1;



end



end



2'b11: begin //Rotate Right

CO = C;

AO = A;

if(SH == 0) begin //Rotate Right with Extend

D = CO;

CO = AO[0];

AO = AO >> 1;

AO[31] = D;

end

else begin

for(index = 0; index < SH; index = index +1) begin

CO = AO[0];
AO = AO >> 1;
AO[31] = CO;

end

end

end


default: begin

CO = C;

AO = A;


end



endcase


endmodule





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







module Multiplexer4to1#(parameter WIDTH =32)(Out,a,b,c,d,sel);

 input [WIDTH-1:0] a,b,c,d;

 input [1:0]sel;

output reg [WIDTH-1:0]Out;

always @(sel or a or b or c or d)begin

case(sel)

2'b00: Out=a;

2'b01: Out=b;

2'b10: Out=c;

2'b11: Out=d;

endcase    

end

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module  Multiplexer2to1#(parameter WIDTH=32)(Out,a,b,sel);

 input [WIDTH-1:0]a,b;

 input sel;

 output reg [WIDTH-1:0]Out;

 always @(sel or a or b)begin//begin always

case(sel)

1'b0: Out=a;

1'b1: Out=b;

endcase

  end//end always

endmodule


module  Multiplexer8to1#(parameter WIDTH=32)(Out,in0,in1,in2,in3,in4,in5,in6,in7,select);

 input [WIDTH-1:0]in0,in1,in2,in3,in4,in5,in6,in7;

 input [2:0]select;

 output reg [WIDTH-1:0]Out;

 always @(select, in0,in1,in2,in3,in4,in5,in6,in7)begin//begin always

case(select)

3'b000: Out=in0;

3'b001: Out=in1;

3'b010: Out=in2;

3'b011: Out=in3;

3'b100: Out=in4;

3'b101: Out=in5;

3'b110: Out=in6;

3'b111: Out=in7;

endcase

end//end always

endmodule
//////////////////////

module BranchExtender(Result,A);

input [23:0] A;

output [31:0] Result;

assign Result={{7{A[23]}} ,A}<<2;

endmodule

////////////////////////////////////////

module LoadExtender(Result,A, Sign_Extend);

input [1:0] Sign_Extend;

input [31:0] A;

output reg[31:0] Result;

reg[7:0]tempbyte;

reg[15:0]tempword;

always@(A, Sign_Extend)

case(Sign_Extend)

2'b00: begin

tempbyte = A[7:0];

assign Result = {{24{tempbyte[7]}}, tempbyte};

end

2'b01: begin

tempword = A[15:0];

assign Result = {{16{tempword[15]}}, tempword};

end

default: begin

assign Result = A;

end

endcase

endmodule
/*
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 */
module DataPathConCU(input Clk,Clr);

wire[44:0]Signals;

wire MFC;

wire[3:0]SROut;

wire[31:0] IR_Out;

ControlUnit CU(Signals,MFC,Clk,SROut,IR_Out);

//Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3  

//44:42_41:40_39_38:36_35:33_32:30_29:28_27:26_25:24_23_22_21_20_19_18_17_16:15_14_13:12_11:8_7:4_3:0

reg LoadEnable;

reg[3:0] CUSlave1,CUSlave2,CUSlave3;

reg MFA,ReadWrite;

wire[31:0] Output_De_ALU;

wire[31:0] MDR_Out;

wire[31:0] Output_De_RAM;

wire[31:0] RFOut1,RFOut2;

wire[3:0] OutMuxAddress1,OutMuxAddress2,OutMuxAddress3;

//reg[2:0]SELECT4,SELECT5,SELECT6;

wire [31:0] BranchExtResult;

BranchExtender BranchExtender(BranchExtResult,IR_Out[23:0]);

/////// MUX De Register File

///	Select4

Multiplexer8to1 MUXDeAddress1(OutMuxAddress1,IR_Out[19:16],IR_Out[3:0],IR_Out[15:12],4'd15,Signals[11:8],IR_Out[15:12]+1,IR_Out[15:12]&4'hE,,Signals[38:36]);

///	Select5

Multiplexer8to1 MUXDeAddress2(OutMuxAddress2,IR_Out[19:16],IR_Out[3:0],IR_Out[15:12],4'd15,Signals[7:4],IR_Out[15:12]+1,IR_Out[15:12]&4'hE,,Signals[35:33]);

///	Select6

Multiplexer8to1 MUXDeAddress3(OutMuxAddress3,IR_Out[19:16],IR_Out[3:0],IR_Out[15:12],4'b1111,4'b1110,Signals[3:0],IR_Out[15:12]+1,IR_Out[15:12]&4'hE,Signals[32:30]);

////////////////REGISTER FILE//////////////////////////////////////////////

//module RegisterFile(OUT1,OUT2,Clk,Clr,LoadEnable,DataInput,Address1,Address2,Address3);//DecEnable con High| DATAINPUT 32 bits| Con address 3 se selecciona a que registro se va a escribir | Con address 1 y address 2 cuales se van a leer

RegisterFile RegisterFile(RFOut1,RFOut2,Clk,Clr,Signals[20],Output_De_ALU,OutMuxAddress1,OutMuxAddress2,OutMuxAddress3);//DecEnable con High| DATAINPUT 32 bits| Con address 3 se selecciona a que registro se va a escribir | Con address 1 y address 2 cuales se van a leer

///////////////////////////////////////////////////////////////////////////



////////////////////////////////4 TO 1 MUX ENTRADA B DEL ALU///////////////////////////////////////////////////////////

wire [31:0] OUT_MUX_IN_B_ALU;

//reg [2:0]SELECT1;

//	Select1

Multiplexer8to1 Multiplexer_de_Entrada_B_ALU(OUT_MUX_IN_B_ALU,RFOut2,IR_Out[11:0],BranchExtResult,MDR_Out,CUSlave2,{IR_Out[11:8],IR_Out[3:0]},,,Signals[44:42]);

/////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////4 TO 1 MUX ENTRADA A DEL ALU///////////////////////////////////////////////////////////

wire [31:0] OUT_MUX_IN_A_ALU;

//reg [2:0]SELECT2;

//	  Select2

Multiplexer8to1 Multiplexer_de_Entrada_A_ALU(OUT_MUX_IN_A_ALU,RFOut1,4,IR_Out[7:0],IR_Out[11:0],CUSlave1,,,,Signals[41:40]);

/////////////////////////////////////////////////////////////////////////////////



/////////////////////////////////2 TO 1 MUX OUT ES ENTRADA DE MDR///////////////////////////////////////////////////////////

//reg[1:0] Sign_Extend;

wire[31:0] Out_Sign_Extend;

LoadExtender LoadExtender(Out_Sign_Extend,Output_De_RAM,Signals[13:12]);

//reg SELECT3;

wire[31:0] OUT_MUX_De_MDR;

//	Select3

Multiplexer2to1 MUX_De_MDR(OUT_MUX_De_MDR,Output_De_ALU,Out_Sign_Extend,Signals[39]);

//////////////////////////////////////////////////////////////////

//////////////////////////////////   REGISTROS MDR || MAR || IR  ///////////////////////////////////////

reg MDR_Enable;

Registro MDR(MDR_Out,OUT_MUX_De_MDR,Signals[22],Clr,Clk);

wire[7:0] MAR_Out;

//reg MAR_Enable;

Registro MAR(MAR_Out,Output_De_ALU,Signals[23],Clr,Clk);

reg IR_Enable;

Registro IR(IR_Out,Output_De_RAM,Signals[21],Clr,Clk);

/////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////MUX DE ALU SELECT/////////////

wire[3:0] Out_MUX_IN_ALU_Select;

//reg[1:0] SELECT9;

///	  Select9

Multiplexer4to1 MUXDeALUSELECT(Out_MUX_IN_ALU_Select,IR_Out[24:21],4'b0100,4'b0010,4'b1101,Signals[25:24]);

///////////////////////////// MUXS PARA SHIFTER/////////////

wire [2:0] OUT_Shifer_Operation_Select;

//reg [1:0] SELECT7,SELECT8;

reg [2:0] ROR = 3'b001;

reg [2:0] LSL = 3'b000;

reg [2:0] InputBuffer = 3'bxxx;
///	Select7

Multiplexer4to1 MUX_Shifter_Operation_Select(OUT_Shifer_Operation_Select,IR_Out[6:5],ROR,LSL,CUSlave6,Signals[29:28]);

wire [31:0] OUT_Shifter_Amount_Select;

wire [4:0] DOUBLE_IR_OUT = IR_Out[11:8]<<1;

///	Select8

Multiplexer4to1 MUX_Shifter_Amount_Select(OUT_Shifter_Amount_Select,IR_Out[11:7],DOUBLE_IR_OUT,0,InputBuffer,Signals[27:26]);


///////////////////////////////////////   ALU  ///////////////////////////////////////////////////////////

wire V, C0, Z, N;

reg[31:0] Shift_Amount;

reg[3:0] ALU_Select;

reg[2:0] Shifter_Operation;

reg C;

//reg A_SELECT;

//module ALU (output reg [31:0] Y, output reg V, C0, Z, N, input [31:0] A, B, SH, input [3:0] S, input [2:0] S_O, input C, input SELECT);

ALU ALU(Output_De_ALU, V, C0, Z, N, OUT_MUX_IN_A_ALU, OUT_MUX_IN_B_ALU,OUT_Shifter_Amount_Select,Out_MUX_IN_ALU_Select,OUT_Shifer_Operation_Select,C,Signals[19]);

reg SREnable;

Registro SR(SROut,{N,Z,C0,V},Signals[14],Clr,Clk);//SR_Out={N,Z,C0,V};//N Z C V

/////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////          RAM      ///////////////////////////////////////////////////

reg[1:0] DataType;

RAM ram1(Output_De_RAM,MFC,Signals[18],Signals[17],MAR_Out,MDR_Out,Signals[16:15]);//Address es MAR_OUT SELECCIONA QUE DIRECCION DE MEMORIA || MDR OUT ES DATA IN


//PARA LLENAR RAM
integer               data_file    ; // file handler
integer               scan_file    ; // file handler
integer captured_data;
integer i=0;
reg[7:0] temp=0;
integer j;

/////////////////////////////////////////////////////////////////////////////////////

/////////////Control Unit

//module ControlUnit(output reg[44:0]Signals,input MFC,Clk,input[3:0]StatusRegister_Output,input[31:0]Instruction);

//Select1_Select2_Select3_Select4_Select5_Select6_Select7_Select8_Select9_MAREnable_MDREnable_IREnable_LoadEnable_ASelect_MFA_RAMReadWrite_DataType_SREnable_SignExtend_CUSlave1_CUSlave2_CUSlave3  

//44:42_41:40_39_38:36_35:33_32:30_29:28_27:26_25:24_23_22_21_20_19_18_17_16:15_14_13:12_11:8_7:4_3:0

`define NULL 0    

initial begin
  $display("Llenando RAM");
  i = 0;
  data_file = $fopen("/Users/CristianJuan/Desktop/WORKSPACE_Verilog/testcode_arm2.txt", "r");
  if (data_file == `NULL) begin
    $display("data_file handle was NULL");
    $finish;
  end
  while(!$feof(data_file)) begin  
     scan_file = $fscanf(data_file, "%b\n", captured_data);
   
     //if (!$feof(data_file)) begin
     	//$display("%h", captured_data);
     	ram1.Memory[i] = captured_data;
     	//$display("%h", ram1.Memory[i]);
     	i = i+1;
       //use captured_data as you would any other wire or reg value;
     //end
 end
 $display("Ha terminado de llenar el RAM");
end

endmodule



module test;

reg Clk,Clr;

DataPathConCU ARM(Clk,Clr);

integer j;

initial begin

#1Clr=1;

#2Clr=0;

#1Clr=1;

#100Clk=0;
$monitor("MAR Out: %h Entrada A ALU: %h, Entrada B ALU: %h", ARM.MAR_Out,ARM.OUT_MUX_IN_A_ALU, ARM.OUT_MUX_IN_B_ALU);
repeat(3500)begin// 90/18 == 5 5 instrucciones
	#3Clk=~Clk;
/*$display("Entrada A ALU: %h", ARM.OUT_MUX_IN_A_ALU);
	$display("Entrada B ALU: %h", ARM.OUT_MUX_IN_B_ALU);
	$display("Operacion del ALU: %h", ARM.Out_MUX_IN_ALU_Select);
	$display("Output del ALU: %h", ARM.Output_De_ALU);
	$display("MAR Out: %h", ARM.MAR_Out);
	$display("Shifter Operation: %h", ARM.OUT_Shifer_Operation_Select);
	$display("Shifter Amount: %h", ARM.OUT_Shifter_Amount_Select);
	$display("Memory location 40: %h", ARM.ram1.Memory[40]);
	$display("Output of RAM: %h", ARM.Output_De_RAM);*/	
	
	end


/*$display("Registro R0:%d",ARM.RegisterFile.OutputsDeRegistros[0]);// Se tuvo que hacer Clk=~Clk 18 veces para ver el resultado de la op en el registro

$display("Registro R1:%d",ARM.RegisterFile.OutputsDeRegistros[1]);//

$display("Registro R2:%d",ARM.RegisterFile.OutputsDeRegistros[2]);

$display("Registro R3:%d",ARM.RegisterFile.OutputsDeRegistros[3]);

$display("Registro R4:%d",ARM.RegisterFile.OutputsDeRegistros[4]);

$display("Registro R5:%d",ARM.RegisterFile.OutputsDeRegistros[5]);

$display("Registro R6:%d",ARM.RegisterFile.OutputsDeRegistros[6]);

$display("Registro R7:%d",ARM.RegisterFile.OutputsDeRegistros[7]);

$display("Registro R8:%d",ARM.RegisterFile.OutputsDeRegistros[8]);

$display("Registro R9:%d",ARM.RegisterFile.OutputsDeRegistros[9]);

$display("Registro R10:%d",ARM.RegisterFile.OutputsDeRegistros[10]);

$display("Registro R11:%d",ARM.RegisterFile.OutputsDeRegistros[11]);

$display("Registro R12:%d",ARM.RegisterFile.OutputsDeRegistros[12]);

$display("Registro R13:%d",ARM.RegisterFile.OutputsDeRegistros[13]);

$display("Registro R14:%d",ARM.RegisterFile.OutputsDeRegistros[14]);

$display("Registro R15:%d",ARM.RegisterFile.OutputsDeRegistros[15]);*/

j = 0;

repeat(200) begin
	
	$display("Address = %d: RAM OUT = %h",j,ARM.ram1.Memory[j]);
	j = j+1;
end

end//initial


endmodule