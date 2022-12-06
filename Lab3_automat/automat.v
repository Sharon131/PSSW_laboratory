`timescale 1ns/10ps

// definicja automatu
module automat_mp (input a, b, reset, clk,
		    output reg w, m);

    reg [2:0] state, next_state;	// tylko jedna zmienna do prechowywania stanu
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
            begin
                w <= a;
                m <= b;
            end
            else if (a==0 && b==1)
            begin
                w <= b;
                m <= a;
            end
            else
            begin
                w <= a;
                m <= b;
            end
        else if (state==S1 || state==S4)
        begin
            w <= b;
            m <= a;
        end
        else if (state==S3 || state==S6)
        begin
            w <= a;
            m <= b;
        end

endmodule

// urealnienie ukladu i testowanie
module  automat_mp_test;
	
	reg we1, we2, reset, zegar;
	wire w, m;
	
	automat_mp automat(we1, we2, reset, zegar, w, m);

// definicja sygnalow wymuszajacych

always
	#10 zegar=~zegar;

initial
    begin
	$dumpfile("automat.vcd");
  	$dumpvars;//(0, we1, we2, reset, zegar, w, m);
	$monitor($time,": reset=%b we1=%b we2=%bclk=%b | w=%b m=%b", reset, we1, we2, zegar, w, m);

    zegar=1'b0; reset=1'b0; we1=1'b0; we2=1'b0;
    #15 we1=1'b0;
    #20 reset=1'b1;
    #20 we1=1'b1;
    #30 we1=1'b0;
    #20 we1=1'b0;
    #30 we1=1'b1;
    #20 we1=1'b0;
    #20 we1=1'b1;
    #20 we1=1'b1;
    #30 we1=1'b0;
    #20 we1=1'b1;
    #20 we1=1'b0;
    #20 we1=1'b1;
    #20 we1=1'b0;
    #10 $finish;
    end
endmodule
