module ROM (
    input wire [4:0] rom_addr,
    output wire[15:0] rom_YD
);
    wire [15:0] NC [31:0];
    assign NC[0] = 16'o0000000000062677;   //      IORST           ;reset all I/O
    assign NC[1] = 16'o0000000000020037;   //      LDA 0,37        ;read boot code into AC0
    assign NC[2] = 16'o0000000000024026;   //      LDA 1,C77       ;get dev mask
	assign NC[3] = 16'o0000000000107400;	//	    AND 0,1         ;isolate dev code
	assign NC[4] = 16'o0000000000124000;	//	    COM 1,1		    ;-device code-1
	assign NC[5] = 16'o0000000000010014;	//LOOP: ISZ OP1		    ;device code to all
	assign NC[6] = 16'o0000000000010030;	//	    ISZ OP2		    ;I/O instructions
	assign NC[7] = 16'o0000000000010032;	//	    ISZ OP3
	assign NC[8] = 16'o0000000000125404;	//	    INC 1,1,SZR	    ;done?
	assign NC[9] = 16'o0000000000000005;	//	    JMP LOOP	    ;no, increment again
	assign NC[10] = 16'o0000000000030016;	//	    LDA 2,C377	    ;place JMP 377 into
	assign NC[11] = 16'o0000000000050377;	//	    STA 2,377	    ;location 377
	assign NC[12] = 16'o0000000000060077;	// OP1: NIOS 77		    ;start device (NIOS 0)
	assign NC[13] = 16'o0000000000101102;	//	    MOVL 0,0,SZC	;test switch 0, 'low speed'?
	assign NC[14] = 16'o0000000000000377;	//C377: JMP 377	        ;no - jmp 377 & wait
	assign NC[15] = 16'o0000000000004030;	//LOOP2:JSR GET+1	    ;get a frame
	assign NC[16] = 16'o0000000000101065;	//	    MOVC 0,0,SNR	;is it non-zero?
	assign NC[17] = 16'o0000000000000017;	//	    JMP LOOP2	    ;no, ignore
	assign NC[18] = 16'o0000000000004027;	//LOOP4:JSR GET	        ;yes, get full word
	assign NC[19] = 16'o0000000000046026;	//	    STA 1,@C77	    ;store starting at 100, 2's complement of word ct
	assign NC[20] = 16'o0000000000010100;	// 	    ISZ 100		    ;done?
	assign NC[21] = 16'o0000000000000022;	//	    JMP LOOP4	    ;no, get another
	assign NC[22] = 16'o0000000000000077;	// C77: JMP 77		    ;yes location ctr and jmp to last word
	assign NC[23] = 16'o0000000000126420;	// GET: SUBZ 1,1	    ; clr AC1, set carry
							// OP2:
	assign NC[24] = 16'o0000000000063577;	//LOOP3:SKPDN 77	    ;done?
	assign NC[25] = 16'o0000000000000030;	//	    JMP LOOP3	    ;no, wait
	assign NC[26] = 16'o0000000000060477;	// OP3: DIAS 0,77	    ;yes, read in ac0
	assign NC[27] = 16'o0000000000107363;	//	    ADDCS 0,1,SNC	;add 2 frames swapped - got 2nd?
	assign NC[28] = 16'o0000000000000030;	//	    JMP LOOP3	    ;no go back after it
	assign NC[29] = 16'o0000000000125300;	//	    MOVS 1,1	    ;yes swap them
	assign NC[30] = 16'o0000000000001400;	//	    JMP 0,3	        ;return with full word
	assign NC[31] = 16'o0000000000100033;   //	    0100033		    ;code for boot from disk  
    assign rom_YD = NC[rom_addr];  
endmodule