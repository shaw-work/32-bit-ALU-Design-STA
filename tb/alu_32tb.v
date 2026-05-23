`timescale 1ns/1ps

module alu_32bit_tb;

reg  [31:0] A;
reg  [31:0] B;
reg  [3:0]  ALU_Sel;
reg [31:0] expected;
reg expected_carry;
reg expected_zero;
reg expected_overflow;

wire [31:0] ALU_Out;
wire CarryOut;
wire Zero;
wire Overflow;


// Instantiate ALU
alu_32bit #(.WIDTH(32)) uut  (
    .A(A),
    .B(B),
    .ALU_Sel(ALU_Sel),
    .ALU_Out(ALU_Out),
    .CarryOut(CarryOut),
    .Zero(Zero),
    .Overflow(Overflow)
);
    task check_result;

begin

    if ((ALU_Out  == expected) &&
        (CarryOut == expected_carry) &&
        (Zero     == expected_zero) &&
        (Overflow == expected_overflow))

        $display("PASS : SEL=%b | OUT=%h",
                  ALU_Sel, ALU_Out);

    else begin

        $display("FAIL : SEL=%b", ALU_Sel);

        $display("OUTPUTS:");
        $display("OUT=%h | CARRY=%b | ZERO=%b | OVERFLOW=%b",
                  ALU_Out, CarryOut, Zero, Overflow);

        $display("EXPECTED:");
        $display("OUT=%h | CARRY=%b | ZERO=%b | OVERFLOW=%b",
                  expected,
                  expected_carry,
                  expected_zero,
                  expected_overflow);
    end

end

endtask

initial begin
        $dumpfile("alu_32bit.vcd");
        $dumpvars(0, alu_32bit_tb);
        end
initial begin
    $display("========================================");
    $display("        32-BIT ALU TEST START");
    $display("========================================");

    // ADDITION
    A = 32'd15;
B = 32'd10;
ALU_Sel = 4'b0000;

expected = 32'd25;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;

    // SUBTRACTION
   A = 32'd20;
B = 32'd5;
ALU_Sel = 4'b0001;

expected = 32'd15;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;

    // AND
    A = 32'hF0F0F0F0;
B = 32'h0F0F0F0F;
ALU_Sel = 4'b0010;

expected = 32'h00000000;
expected_carry = 0;
expected_zero = 1;
expected_overflow = 0;

#10;
check_result;

    // OR
    A = 32'hF0F0F0F0;
B = 32'h0F0F0F0F;
ALU_Sel = 4'b0011;

expected = 32'hFFFFFFFF;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;
    // NOR
    A = 32'hFFFFFFFF;
B = 32'h00000000;
ALU_Sel = 4'b1001;

expected = 32'h00000000;
expected_carry = 0;
expected_zero = 1;
expected_overflow = 0;

#10;
check_result;
    // XOR
    A = 32'hAAAA5555;
B = 32'h5555AAAA;
ALU_Sel = 4'b0100;

expected = 32'hFFFFFFFF;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;

    // NOT
   A = 32'hFFFFFFFF;
B = 32'd0;
ALU_Sel = 4'b0101;

expected = 32'h00000000;
expected_carry = 0;
expected_zero = 1;
expected_overflow = 0;

#10;
check_result;

    // SHIFT LEFT
    A = 32'd8;
B = 32'd2;
ALU_Sel = 4'b0110;

expected = 32'd32;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;

    // SHIFT RIGHT
A = 32'd16;
B = 32'd2;
ALU_Sel = 4'b0111;

expected = 32'd4;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;
    // COMPARE A > B
    A = 32'd25;
B = 32'd10;
ALU_Sel = 4'b1000;

expected = 32'd1;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;

    // COMPARE A < B
   A = 32'd5;
B = 32'd10;
ALU_Sel = 4'b1000;

expected = 32'd1;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 0;

#10;
check_result;

    // OVERFLOW TEST
   A = 32'h7FFFFFFF;
B = 32'd1;
ALU_Sel = 4'b0000;

expected = 32'h80000000;
expected_carry = 0;
expected_zero = 0;
expected_overflow = 1;

#10;
check_result;
    //CARRY TEST
    A = 32'hFFFFFFFF;
B = 32'd1;
ALU_Sel = 4'b0000;

expected = 32'h00000000;
expected_carry = 1;
expected_zero = 1;
expected_overflow = 0;

#10;
check_result;
    $display("========================================");
    $display("        TEST COMPLETED");
    $display("========================================");

    $finish;

end


initial begin
    $monitor("TIME=%0t | A=%h | B=%h | SEL=%b | OUT=%h | CARRY=%b | ZERO=%b | OVERFLOW=%b",
              $time, A, B, ALU_Sel, ALU_Out, CarryOut, Zero, Overflow);
end

endmodule