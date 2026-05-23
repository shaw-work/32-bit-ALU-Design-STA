module alu_32bit #(parameter WIDTH = 32)(
    input  [WIDTH-1:0] A,
    input  [WIDTH-1:0] B,
    input  [3:0]  ALU_Sel,

    output reg [WIDTH-1:0] ALU_Out,
    output reg CarryOut,
    output reg Zero,
    output reg Overflow
);

reg [WIDTH:0] temp;

always @(*) begin

    // Default values
     ALU_Out = {WIDTH{1'b0}};
    CarryOut = 1'b0;
    Overflow = 1'b0;
    temp = {(WIDTH+1){1'b0}};

    case(ALU_Sel)

        // ADDITION
        4'b0000: begin
            temp      = A + B;
            ALU_Out   = temp [WIDTH-1:0];
            CarryOut  = temp[WIDTH];;

            Overflow = (~A[WIDTH-1] & ~B[WIDTH-1] & ALU_Out[WIDTH-1]) |
                       ( A[WIDTH-1] &  B[WIDTH-1] & ~ALU_Out[WIDTH-1]);
        end

        // SUBTRACTION
        4'b0001: begin
            temp      = A - B;
            ALU_Out   = temp[WIDTH-1:0];
            CarryOut  = temp[WIDTH];;

            Overflow = (~A[WIDTH-1] & B[WIDTH-1] & ALU_Out[WIDTH-1]) |
                       ( A[WIDTH-1] & ~B[WIDTH-1] & ~ALU_Out[WIDTH-1]);
        end

        // AND
        4'b0010: begin
            ALU_Out = A & B;
        end

        // OR
        4'b0011: begin
            ALU_Out = A | B;
        end
        //NOR
        4'b1001: begin
            ALU_Out = ~(A | B);
        end
        // XOR
        4'b0100: begin
            ALU_Out = A ^ B;
        end

        // NOT
        4'b0101: begin
            ALU_Out = ~A;
        end

        // SHIFT LEFT
        4'b0110: begin
            ALU_Out = A << B[$clog2(WIDTH)-1:0];
        end

        // SHIFT RIGHT
        4'b0111: begin
            ALU_Out = A >> B[$clog2(WIDTH)-1:0];
        end

        // COMPARE
        4'b1000: begin
            if ($signed(A) > $signed(B))
    ALU_Out = {{(WIDTH-1){1'b0}},1'b1};

else if ($signed(A) == $signed(B))
    ALU_Out = {WIDTH{1'b0}};

else
    ALU_Out = {WIDTH{1'b1}};
        end

        default: begin
            ALU_Out = 32'b0;
        end

    endcase

    // ZERO FLAG
    if(ALU_Out == {WIDTH{1'b0}})
        Zero = 1'b1;
    else
        Zero = 1'b0;

end

endmodule