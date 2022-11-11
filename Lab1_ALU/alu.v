`timescale 1ns/10ps

module sum(input [7:0] a, b,
	   output cout,
	   output [7:0] y);

	assign {cout,y} = a + b;
endmodule

module diff(input [7:0] a, b,
	    output cout,
	    output [7:0] y);
	assign y = a - b;
endmodule

module mult(input [7:0] a, b,
			output overfl,
			output [7:0] y);
	wire temp;
	wire [7:0] y_overflow;

	assign {y_overflow, y} = a * b;
	assign overfl = y_overflow != 0;

endmodule

module div(input [7:0] a, b,
	   output zero,
	   output [7:0] y);

endmodule

module bit_and(input [7:0] a, b,
	       output [7:0] y);
	assign y = a & b;
endmodule

module bit_or(input [7:0] a, b,
	      output [7:0] y);
	assign y = a | b;
endmodule

module bit_xor(input [7:0] a, b,
	       output [7:0] y);
	assign y = a ^ b;
endmodule

module bit_neg(input [7:0] a,
	       output [7:0] y);
	assign y = ~a;
endmodule

module shift_right(input [7:0] a,
		   output carry,
	           output [7:0] y);
	assign {y, carry} = a >> 1;
endmodule

module shift_left(input [7:0] a,
		  output carry,
	          output [7:0] y);
	assign {carry, y} = a << 1;
endmodule

module is_equal(input [7:0] a, b,
	        output y);
	assign y = (a == b);
endmodule

module is_greater(input [7:0] a, b,
	          output y);
	assign y = (a > b);
endmodule

module is_less(input [7:0] a, b,
	       output y);
	assign y = (a < b);
endmodule

module not_equal(input [7:0] a, b,
	         output y);
	assign y = a != b;
endmodule


module bit_on(input [7:0] a, b,
	      	  output [7:0] y);
	assign y = a | (1 << b);
endmodule

module bit_off(input [7:0] a, b,
	       	   output [7:0] y);
	assign y = a & !(1 << b);
endmodule

module ALU(input  [7:0] a,
			input  [7:0] b,
			input  [3:0] op,
			output reg [7:0] result,
			output carry,
			output zero,
			output parity,
			output overflow);

	wire [7:0] results [15:0];

	sum  		sum_of(a, b, carry, results[0]);
	diff 		difference(a, b, carry, results[1]);
	mult 		multiply(a, b, overflow, results[2]);
	div 		divide(a, b, zero, results[3]);
	bit_and 	bitwise_and(a, b, results[4]);
	bit_or		bitwise_or(a, b, results[5]);
	bit_xor 	bitwise_xor(a, b, results[6]);
	bit_neg 	bitwise_negation(a, results[7]);
	shift_right	shift_one_right(a, carry, results[8]);
	shift_left	shift_one_left(a, carry, results[9]);
	is_equal	is_equal_to(a, b, results[10][0]);
	is_greater	is_greater_than(a, b, results[11][0]);
	is_less		is_less_than(a, b, results[12][0]);
	not_equal	is_not_equal(a, b, results[13][0]);
	bit_on		set_bit(a, b, results[14]);
	bit_off		clear_bit(a, b, results[15]);

	always @(a, b, op)
		case(op)
		0: result = results[0];
		1: result = results[1];
		2: result = results[2];
		3: result = results[3];
		4: result = results[4];
		5: result = results[5];
		6: result = results[6];
		7: result = results[7];
		8: result = results[8];
		9: result = results[9];
		10: result = results[10];
		11: result = results[11];
		12: result = results[12];
		13: result = results[13];
		14: result = results[14];
		15: result = results[15];
	endcase

endmodule

// urealnienie ALU i jednostka testowa
module alu_test;
	
	reg [7:0] a,b;
	reg [3:0] op;
	wire carry;
	wire zero;
	wire parity;
	wire overflow;
	wire [7:0] y;

	ALU alu1(a, b, op, y, carry, zero, parity, overflow);

// // definicja sygnalow wymuszajacych
// integer i,j,k;
// initial
// 	begin
// 		$dumpfile("alu.vcd");
// 	  	$dumpvars(0, a, b, op, y, carry, zero, parity, overflow);
// 		$monitor($time,": a=%d b=%d sel=%b | y=%d",a,b,y);
	
// 	k=2**roz;
// 	for (i=0;i<k;i=i+1)
// 		for (j=0;j<k;j=j+1)
// 			begin
// 			#10; a=i; b=j; s=0;
// 			#10; s=1;
// 			end
// 		#10 $finish;
// 	end
endmodule
