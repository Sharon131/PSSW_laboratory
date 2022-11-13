`timescale 1ns/10ps

module or3(input a, b, c,
			output y);
	wire temp_wire;
	or g1(temp_wire, a, b);
	or g2(y, temp_wire, c);
endmodule

/* Unsigned addition */
module sum(input [7:0] a, b,
	   output cout,
	   output [7:0] y);

	assign {cout,y} = a + b;
endmodule

/* Unsigned substraction */
module diff(input [7:0] a, b,
	    output negative,
	    output [7:0] y);
	assign y = a - b;
	assign negative = b > a;
endmodule

/* Unsigned multiplication */
module mult(input [7:0] a, b,
			output overfl,
			output [7:0] y);
	wire temp;
	wire [7:0] y_overflow;

	assign {y_overflow, y} = a * b;
	assign overfl = y_overflow != 0;

endmodule

/* Unsigned division */
module div(input [7:0] a, b,
	   output zero,
	   output [7:0] y);
	assign zero = (b == 0);
	assign y = a / b;
endmodule

/* Bitwise AND */
module bit_and(input [7:0] a, b,
	       	   output [7:0] y);
	assign y = a & b;
endmodule

/* Bitwise OR */
module bit_or(input [7:0] a, b,
	      	  output [7:0] y);
	assign y = a | b;
endmodule

/* Bitwise XOR */
module bit_xor(input [7:0] a, b,
	       	   output [7:0] y);
	assign y = a ^ b;
endmodule

/* Bitwise negation */
module bit_neg(input [7:0] a,
	       	   output [7:0] y);
	assign y = ~a;
endmodule

/* Logical shift right */
module shift_right(input [7:0] a,
		   		   output carry,
	           	   output [7:0] y);
	assign {y, carry} = a;
endmodule

/* Logical shift left */
module shift_left(input [7:0] a,
		  output carry,
	          output [7:0] y);
	assign {carry, y} = a << 1;
endmodule

/* Equal comparison */
module is_equal(input [7:0] a, b,
	        output y);
	assign y = (a == b);
endmodule

/* Greater comparison */
module is_greater(input [7:0] a, b,
	          output y);
	assign y = (a > b);
endmodule

/* Less comparison */
module is_less(input [7:0] a, b,
	       output y);
	assign y = (a < b);
endmodule

/* Not equal comparison */
module not_equal(input [7:0] a, b,
	         output y);
	assign y = a != b;
endmodule

/* Setting b's bit in a */
module bit_on(input [7:0] a, b,
	      	  output [7:0] y);
	assign y = a | (1 << b);
endmodule

/* Clearing b's bit in a */
module bit_off(input [7:0] a, b,
	       	   output [7:0] y);
	assign y = a & !(1 << b);
endmodule

module ALU(input  [7:0] a,
			input  [7:0] b,
			input  [3:0] op,
			output reg [7:0] result,
			output reg carry,
			output reg negative,
			output reg overflow,
			output reg zero);

	wire [7:0] results [15:0];

	wire sum_carry;
	wire shift_right_carry;
	wire shift_left_carry;
	wire carry_wire;
	wire negative_wire;
	wire overflow_wire;
	wire zero_wire;

	or3 g3(carry_wire, sum_carry, shift_left_carry, shift_right_carry);

	sum  		sum_of(a, b, sum_carry, results[0]);
	diff 		difference(a, b, negative_wire, results[1]);
	mult 		multiply(a, b, overflow_wire, results[2]);
	div 		divide(a, b, zero_wire, results[3]);
	bit_and 	bitwise_and(a, b, results[4]);
	bit_or		bitwise_or(a, b, results[5]);
	bit_xor 	bitwise_xor(a, b, results[6]);
	bit_neg 	bitwise_negation(a, results[7]);
	shift_right	shift_one_right(a, shift_right_carry, results[8]);
	shift_left	shift_one_left(a, shift_left_carry, results[9]);
	is_equal	is_equal_to(a, b, results[10][0]);
	is_greater	is_greater_than(a, b, results[11][0]);
	is_less		is_less_than(a, b, results[12][0]);
	not_equal	is_not_equal(a, b, results[13][0]);
	bit_on		set_bit(a, b, results[14]);
	bit_off		clear_bit(a, b, results[15]);

	/* Multiplexer & decoder */
	always @(*)
		case(op)
		0: begin
			result = results[0];
			carry = carry_wire;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		1: begin
			result = results[1];
			carry = 0;
			negative = negative_wire;
			overflow = 0;
			zero = 0;
		end
		2: begin
			result = results[2];
			carry = 0;
			negative = 0;
			overflow = overflow_wire;
			zero = 0;
		end
		3: begin 
			result = results[3];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = zero_wire;
		end
		4: begin
			result = results[4];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		5: begin
			result = results[5];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		6: begin
			result = results[6];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		7: begin
			result = results[7];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		8: begin
			result = results[8];
			carry = carry_wire;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		9: begin
			result = results[9];
			carry = carry_wire;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		10: begin
			result = {7'b0000000, results[10][0]};
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		11: begin
			result = {7'b0000000, results[11][0]};
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		12: begin
			result = {7'b0000000, results[12][0]};
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		13: begin
			result = {7'b0000000, results[13][0]};
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		14: begin
			result = results[14];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
		15: begin
			result = results[15];
			carry = 0;
			negative = 0;
			overflow = 0;
			zero = 0;
		end
	endcase

endmodule

// urealnienie ALU i jednostka testowa
module alu_test;
	
	reg [7:0] a,b;
	reg [3:0] op;
	wire carry;
	wire negative;
	wire overflow;
	wire zero;
	wire [7:0] y;

	ALU alu1(a, b, op, y, carry, negative, overflow, zero);

initial
	begin
		$dumpfile("alu.vcd");
	  	$dumpvars(0, a, b, op, y, carry, zero, negative, overflow);
		$monitor($time,": a=%d b=%d op=%d | y=%d, c=%b, z=%b, n=%b, o=%b", a, b, op, y, carry, zero, negative, overflow);

	/* Test addition */ 
	#5; a = 20; b = 10; op = 0;  	/* 20 + 10 */
	#10; a = 250;					/* 250 + 10 */
	#10; a = 20; op = 1;			/* 20 - 10 */
	#10; a = 5;						/* 5 - 10 */
	#10; op = 2;					/* 5 * 10 */
	#10; a = 50;					/* 50 * 10 */
	#10; op = 3;					/* 50 / 10 */
	#10; b = 0;						/* 50 / 0 */
	#10; a = 'b100; b = 'b110; op = 4; /* a & b */
	#10; op = 5;					/* a | b */
	#10; op = 6;					/* a ^ b */
	#10; op = 7;					/* !a */
	#10; op = 8;					/* a >> 1 */
	#10; op = 9;					/* a << 1 */
	#10; op = 10;					/* 4 == 6*/
	#10; a = 10; b = 10;			/* 10 == 10 */
	#10; op = 11;					/* 10 > 10 */
	#10; a = 12;					/* 12 > 10 */
	#10; op = 12;					/* 12 < 10 */
	#10; a = 8;						/* 8 < 10 */
	#10; op = 13;					/* 8 != 10 */
	#10; a = 0; b = 2; op = 14;		/* b0100*/
	#10; a = 'b11111111; b = 3; op = 15; /* b*0111 */

	#10; $finish;

	end
endmodule
