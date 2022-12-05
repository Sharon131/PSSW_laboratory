// automat2_2mo - automat wykrywaj�cy sekwencj� "101",
//		  opis z 2 procesami, automat Moor'a
 
`timescale 1ns/10ps

// definicja automatu
module automat_2mo (input a, b, reset, clk,
		    output reg w, m);

    reg [2:0] state;	// tylko jedna zmienna do prechowywania stanu
    parameter [2:0] S0=3'd0,S1=3'd1,S2=3'd2,S3=3'd3,S4=3'd4,S5=3'd5,S6=3'd6;

    always @(a, b, state)
        case (state)
        S0: if (a==0 && b==1) next_state <= S1;
        else if (a==1 && b==0) next_state <= S3;
        else next_state <= S2;
        S1: next_state<=S4;
        S2: if (a==0 && b==1) next_state <= S4;
        else if (a==1 && b==0) next_state <= S6;
        else next_state <= S5;
        S3: next_state <= S6;
        S4: next_state <= S0;
        S5: next_state <= S0;
        S6: next_state <= S0;
        endcase

    always @(posedge clk)	// Proced drugi - blok przerzutnikow 
        if (!reset) state<=0;
        else state<=next_state;

    always @(a, b, state)		// Proces trzeci - funkcja wyjsc
        if (state==S0 || state==S2 || state==S5)
            if(a==1 && b==0)
                w <= a;
                m <= b;
            else if (a==0 && b==1)
                w <= b;
                m <= a;
            else
                w <= a;
                m <= b;
        else if (state==S1 || state==S4)
            w <= b;
            m <= a;
        else if (state==S3 || state==S6)
            w <= a;
            m <= b;

endmodule

// urealnienie uk�adu i testowanie
module  automat_2mo_test;
	
	reg we, reset, zegar;
	wire wy;
	
	automat_2mo automat(we,reset,zegar,wy);

// definicja sygna��w wymuszaj�cych

always
	#10 zegar=~zegar;

initial
    begin
	$dumpfile("automat2_2mo.vcd");
  	$dumpvars;//(0, we, reset, zegar, wy);
	$monitor($time,": reset=%b we=%b clk=%b | wy=%b",reset,we,zegar,wy);

        zegar=1'b0; reset=1'b0; we=1'b0;
    #15 we=1'b0;
    #20 reset=1'b1;
    #20 we=1'b1;
    #30 we=1'b0;
    #20 we=1'b0;
    #30 we=1'b1;
    #20 we=1'b0;
    #20 we=1'b1;
    #20 we=1'b1;
    #30 we=1'b0;
    #20 we=1'b1;
    #20 we=1'b0;
    #20 we=1'b1;
    #20 we=1'b0;
    #10 $finish;
    end
endmodule
