// licznik - licznik synchroniczny N-bitowy

`timescale 1ns/10ps

// definicja licznika N-bitowego
module licznik (input clk, rst,
		input in,
		output reg [3:0] OUT);

	reg [3:0] prev_out = 0;

	// initial OUT=0;

	always@(posedge clk)
	begin
		if (rst == 1)
			OUT = 0;
		else if (in == 0)
			OUT = OUT + 1;
		else if (OUT == 1)
			OUT = 4;
		else
			OUT = 1;
	end
endmodule

// urealnienie uk�adu i testowanie
module  licznik_test;
	
	reg clk, rst;
	reg in;
	wire [3:0] out;
	
	licznik licz(clk, rst, in, out);

// definicja sygna��w wymuszaj�cych

always
	#10 clk=~clk;

initial
	begin
		$dumpfile("licznik.vcd");
	  	$dumpvars(0, clk, rst, in, out);
		$monitor($time,": Clk=%b, rst=%b, in=%b | Q=%d", clk, rst, in, out);
	in = 0;
	clk = 1'b0; 
	rst = 0;

	#5; rst = 1;
	#10; rst = 0;
	#5;
	#320; in = 1;
	#60; in = 0; 
	#40
	#10; $finish;

	end
endmodule


