// DJS-130X C++ Simulator Core Library
// 2024.9.20
// Copyright 2024 H.J.Xie
// Permission is hereby granted, free of charge, 
// to any person obtaining a copy of this software and associated documentation files (the “Software”), 
// to deal in the Software without restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
// and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#ifndef _DJS130_CORE_HPP_
#define _DJS130_CORE_HPP_

#include "djs130_base.hpp"
#include "djs130_periph.hpp"

#define IDX_DKP  033
#define IDX_LPT  017
#define IDX_RTC  014
#define IDX_TTO  011
#define IDX_TTI  010
#define INT_DKP  0x0100
#define INT_LPT  0x0008
#define INT_RTC  0x0004
#define INT_TTI  0x0002
#define INT_TTO  0x0001

class DJS130X
{
    //Peripherals
    TTI tti;
    TTO tto;
    LPT lpt;
    RTC rtc;
    DKP dkp;
    std::map<uint16_t, Device*> device_tree;
    //Core
    struct STATUS {
        static const int TJ = 0;    //halt
        static const int QZZT = 1;  //fetch
    };
    static const unsigned int MEM_SIZE = 32 * 1024;
    static const unsigned int MEM_MASK = 0x7fff;
    static const unsigned int CARRY_BIT = 0x10000;
    static const unsigned int INDIRECT_MAX = 65536;
    static const uint16_t BOOT_SWITCH = 0100033; //boot from disk
    int state = STATUS::TJ;
    uint16_t NC[MEM_SIZE];           //memory
    uint16_t AC[4] = {0, 0, 0, 0};   //accumulators
    uint32_t CARRY = 0;          //carry 0 or 0x10000
    uint16_t PC = 0;
    bool INT_ENABLE = false;
    bool INT_TO_ENABLE = false;
    bool DEBUG_TRACE = false;
    uint16_t INT_DEV_IDX = 0;
    uint16_t INT_DEV_MASK = 0;
    uint16_t CalMaddr(bool I, int X, int D) {
        X = X & 0x03;
        D = D & 0xff;
        uint16_t Ds = ((D&0200)?0177400:0) + D;
        uint16_t maddr;
        switch (X) {
            case 0: maddr = D;		            break;	//Page 0
            case 1: maddr = PC + Ds;		    break;	//PC relative
            case 2: maddr = AC[2] + Ds;	        break;  //AC2
            case 3: maddr = AC[3] + Ds;	        break;	//AC3
        }
        maddr &= 0x7fff;
        if (I) {
            unsigned int icnt = 0;
            while (true) {
                if (maddr >= 16 && maddr <= 23) NC[maddr] += 1;
                else if (maddr >= 24 && maddr <= 31) NC[maddr] -= 1;
                maddr = NC[maddr];
                if (maddr <= 0x7fff) break;  //test on original contents
                maddr &= 0x7fff;
                icnt++;
                if (icnt >= INDIRECT_MAX) {
                    PrintErr("[Error]: JZZT out of time!\n");
                    TJ();
                    return 0;
                }
            }
        }
        return maddr;
    }
    uint16_t ReadNC(bool I, int X, int D) {
        uint16_t maddr = CalMaddr(I, X, D);
        if (DEBUG_TRACE) std::cout << "ReadNC: [" << maddr << "] " << NC[maddr] << std::endl;
        return NC[maddr];
    }
    void WriteNC(bool I, int X, int D, uint16_t data) {
        uint16_t maddr = CalMaddr(I, X, D);
        if (DEBUG_TRACE) std::cout << "WriteNC: [" << maddr << "] " << data << std::endl;
        NC[maddr] = data;
    }
public:
    DJS130X() {
        device_tree[IDX_TTI] = (Device*)&tti;
        device_tree[IDX_TTO] = (Device*)&tto;
        device_tree[IDX_RTC] = (Device*)&rtc;
        device_tree[IDX_LPT] = (Device*)&lpt;
        device_tree[IDX_DKP] = (Device*)&dkp;
    }
    void YD() {
        NC[ 0] = 0062677;   //      IORST           ;reset all I/O
        NC[ 1] = 0020037;   //      LDA 0,37        ;read boot code into AC0
        NC[ 2] = 0024026;   //      LDA 1,C77       ;get dev mask
		NC[ 3] = 0107400;	//	    AND 0,1         ;isolate dev code
		NC[ 4] = 0124000;	//	    COM 1,1		    ;-device code-1
		NC[ 5] = 0010014;	//LOOP: ISZ OP1		    ;device code to all
		NC[ 6] = 0010030;	//	    ISZ OP2		    ;I/O instructions
		NC[ 7] = 0010032;	//	    ISZ OP3
		NC[ 8] = 0125404;	//	    INC 1,1,SZR	    ;done?
		NC[ 9] = 0000005;	//	    JMP LOOP	    ;no, increment again
		NC[10] = 0030016;	//	    LDA 2,C377	    ;place JMP 377 into
		NC[11] = 0050377;	//	    STA 2,377	    ;location 377
		NC[12] = 0060077;	// OP1: NIOS 77		    ;start device (NIOS 0)
		NC[13] = 0101102;	//	    MOVL 0,0,SZC	;test switch 0, 'low speed'?
		NC[14] = 0000377;	//C377: JMP 377	        ;no - jmp 377 & wait
		NC[15] = 0004030;	//LOOP2:JSR GET+1	    ;get a frame
		NC[16] = 0101065;	//	    MOVC 0,0,SNR	;is it non-zero?
		NC[17] = 0000017;	//	    JMP LOOP2	    ;no, ignore
		NC[18] = 0004027;	//LOOP4:JSR GET	        ;yes, get full word
		NC[19] = 0046026;	//	    STA 1,@C77	    ;store starting at 100, 2's complement of word ct
		NC[20] = 0010100;	// 	    ISZ 100		    ;done?
		NC[21] = 0000022;	//	    JMP LOOP4	    ;no, get another
		NC[22] = 0000077;	// C77: JMP 77		    ;yes location ctr and jmp to last word
		NC[23] = 0126420;	// GET: SUBZ 1,1	    ; clr AC1, set carry
							// OP2:
		NC[24] = 0063577;	//LOOP3:SKPDN 77	    ;done?
		NC[25] = 0000030;	//	    JMP LOOP3	    ;no, wait
		NC[26] = 0060477;	// OP3: DIAS 0,77	    ;yes, read in ac0
		NC[27] = 0107363;	//	    ADDCS 0,1,SNC	;add 2 frames swapped - got 2nd?
		NC[28] = 0000030;	//	    JMP LOOP3	    ;no go back after it
		NC[29] = 0125300;	//	    MOVS 1,1	    ;yes swap them
		NC[30] = 0001400;	//	    JMP 0,3	        ;return with full word
		NC[31] = 0100033;   //	    0100033		    ;code for boot from disk
    }
    void TJ() {
        state = STATUS::TJ;
        AC[0] = 0;
        AC[1] = 0;
        AC[2] = 0;
        AC[3] = 0;
        CARRY = 0;
        PC = 0;
        INT_ENABLE = false;
        INT_TO_ENABLE = false;
        INT_DEV_IDX = 0;
        INT_DEV_MASK = 0;
        PrintMsg("[Info]: TJ is pressed!\n");
    }
    void JZ(std::string path, int dpn) { dkp.LoadBin(path, dpn); }  //Load
    void BC(std::string path, int dpn) { dkp.SaveBin(path, dpn); }  //Save
    void SR(char c) { tti.Input(c); }   //Input
    bool SC(char& c) { return tto.Output(c); }  //Output
    void DY(std::string path) { lpt.Open(path); }   //printer output file
    void SX() { lpt.Refresh(); }    //Refresh the printer
    void QDZ() { state = STATUS::QZZT; for(const auto& pair : device_tree) pair.second->Reset();}
    void DEBUG(bool on) {DEBUG_TRACE = on;}
    void Update() {
    	if (DEBUG_TRACE) std::cout << "PC: " << PC << " Inst: " << NC[PC] << "\t" << disassemble(NC[PC]) << "\tAC0: " << AC[0] << " AC1: " << AC[1] << " AC2: " << AC[2]<< " AC3: " << AC[3] << std::endl;
        if (INT_TO_ENABLE) {INT_ENABLE = true; INT_TO_ENABLE = false;}
        if (state == STATUS::TJ) return;
        uint16_t inst = NC[PC];
        bool is_slzl = inst & 0x8000;
        if (is_slzl) {  //is Arithemetic & Logical Instruction
            int funct = (inst & 0x700) >> 8;
            int acs = (inst & 0x6000) >> 13;
            int acd = (inst & 0x1800) >> 11;
            int shift = (inst & 0xc0) >> 6;
            int carry = (inst & 0x30) >> 4;
            bool noload = (inst & 0x8);
            int skip = inst & 0x7;
            uint32_t res = 0;
            switch (carry) {
                case 0 : res = AC[acs] | CARRY;             break;  //
                case 1 : res = AC[acs];                     break;  //Z
                case 2 : res = AC[acs] | CARRY_BIT;         break;  //O
                case 3 : res = AC[acs] | (CARRY^CARRY_BIT); break;  //C
            }
            uint32_t acd_val = AC[acd];
            switch (funct) {
                case 0 : res = res ^ 0xffff;                    break;  //COM
                case 1 : res = ((res^0xffff) + 1) & 0x1ffff;    break;  //NEG
                case 2 :                                        break;  //MOV
                case 3 : res = (res+1) & 0x1ffff;               break;  //INC
                case 4 : res = ((res^0xffff)+acd_val) & 0x1ffff;break;  //ADC
                case 5 : res = ((res^0xffff)+acd_val+1)&0x1ffff;break;  //SUB
                case 6 : res = (res + acd_val) & 0x1ffff;       break;  //ADD
                case 7 : res = res & (acd_val | CARRY_BIT);     break;  //AND
            } 
            switch (shift) {
                case 0 :                                        break;  //
                case 1 : res = ((res<<1)|(res>>16))&0x1ffff;    break;  //L
                case 2 : res = ((res>>1)|(res<<16))&0x1ffff;    break;  //R
                case 3 : res = ((res&0xff)<<8) | ((res>>8)&0xff) | (res&CARRY_BIT); break;  //S
            }
            switch (skip) {
                case 0 :                                            break;  //
                case 1 : PC = (PC+1)&MEM_MASK;                      break;  //SKP
                case 2 : if (res < CARRY_BIT)PC = (PC+1)&MEM_MASK;  break;  //SZC
                case 3 : if (res >= CARRY_BIT)PC = (PC+1)&MEM_MASK; break;  //SNC
                case 4 : if((res&0xffff) == 0)PC = (PC+1)&MEM_MASK; break;  //SZR
                case 5 : if((res&0xffff) != 0)PC = (PC+1)&MEM_MASK; break;  //SNR
                case 6 : if(res <= CARRY_BIT)PC = (PC+1)&MEM_MASK;  break;  //SEZ
                case 7 : if (res > CARRY_BIT)PC = (PC+1)&MEM_MASK;  break;  //SBN
            }
            if (!noload) {
                AC[acd] = res & 0xffff;
                CARRY = res & CARRY_BIT;
            }
            PC = (PC+1)&MEM_MASK;
        } else {
            int op12 = (inst & 0x6000) >> 13;
            bool I = (inst & 0x400);
            int X = (inst & 0x300) >> 8;
            int D = (inst & 0xff);
            int acn = (inst & 0x1800) >> 11;
            if (op12 == 1) { AC[acn] = ReadNC(I, X, D); PC = (PC+1)&MEM_MASK; }         //LDA
            else if (op12 == 2) { WriteNC(I, X, D, AC[acn]); PC = (PC+1)&MEM_MASK; }    //STA
            else if (op12 == 0) {
                int funct = acn;
                uint16_t temp;
                switch (funct) {
                case 0: //JMP
                    PC = CalMaddr(I,X,D);
                    break;  
                case 1: //JSR
                    temp = (PC+1)&MEM_MASK; 
                    PC = CalMaddr(I,X,D);
                    AC[3] = temp;   
                    break;  
                case 2: //ISZ
                    temp = (ReadNC(I,X,D) + 1) & 0xffff;
                    WriteNC(I,X,D,temp);
                    if (temp == 0) PC = (PC+1)&MEM_MASK;
                    PC = (PC+1)&MEM_MASK;
                    break;
                case 3: //DSZ
                    temp = (ReadNC(I,X,D) - 1) & 0xffff;
                    WriteNC(I,X,D,temp);
                    if (temp == 0) PC = (PC+1)&MEM_MASK;
                    PC = (PC+1)&MEM_MASK;
                    break;
                }
            } else {
                int dev_idx = inst & 0x3f;
                int funct = (inst & 0x700) >> 8;
                int ctrl = (inst & 0xc0) >> 6;
                if (dev_idx == 1) { //MUL / DIV
                if (ctrl == 1) {    //DIV - S
                    CARRY = CARRY_BIT;
                    if (AC[0] < AC[2]) {
                        CARRY = 0;
                        uint32_t dividend = (((uint32_t)AC[0])<<16) | AC[1];
                        AC[0] = dividend % AC[2];
                        AC[1] = dividend / AC[2];
                    }
                }
                else if (ctrl == 3) {   //MUL - P
                    uint32_t res = (uint32_t)AC[0] + (uint32_t)AC[1]*AC[2];
                    AC[0] = (res>>16) & 0xffff;
                    AC[1] = (res    ) & 0xffff;
                }
                } else if (dev_idx == 63) {   //CPU Instructions
                if (funct == 1) AC[acn] = BOOT_SWITCH;                                          //READS - DIA
                else if (funct == 3) AC[acn] = INT_DEV_IDX;                                     //INTA - DIB
                else if (funct == 4) INT_DEV_MASK = AC[acn];                                    //MASKO - DOB
                else if (funct == 5) for(const auto& pair : device_tree) pair.second->Reset();  //IORST - DIC
                else if (funct == 6) TJ();                                                      //HALT - DOC
                if (funct != 7) {
                    switch (ctrl) {
                        case 0:                                 break;  //
                        case 1: INT_TO_ENABLE = true;           break;  //S
                        case 2: INT_ENABLE = false;             break;  //C
                        case 3:                                 break;  //P
                    }
                } else {
                    switch (ctrl) {
                        case 0: if (INT_ENABLE) PC = (PC+1)&MEM_MASK;   break;  //SKPBN CPU
                        case 1: if (!INT_ENABLE) PC = (PC+1)&MEM_MASK;  break;  //SKPBZ CPU
                        case 2:                                         break;  //SKPDN CPU never skip, because no power failure
                        case 3: PC = (PC+1)&MEM_MASK;                   break;  //SKPDZ CPU always skip, because no power failure
                    }
                }
                } else {  //I/O instruction
                if (device_tree.find(dev_idx) == device_tree.end()) {
                    //why NIOS 4 ?
                    if (funct == 5) AC[acn] = 0;
                    else if (funct == 7 && (ctrl&0x1)) PC = (PC+1)&MEM_MASK;
                } else {
                    if (funct == 1) AC[acn] = device_tree[dev_idx]->GetJa();                      //DIA
                    else if (funct == 2) device_tree[dev_idx]->SetJa(AC[acn]);                    //DOA
                    else if (funct == 3) AC[acn] = device_tree[dev_idx]->GetJb();                 //DIB
                    else if (funct == 4) device_tree[dev_idx]->SetJb(AC[acn]);                    //DOB
                    else if (funct == 5) AC[acn] = device_tree[dev_idx]->GetJc();                 //DIC
                    else if (funct == 6) device_tree[dev_idx]->SetJc(AC[acn]);                    //DOC
                    if (funct != 7) {
                        switch (ctrl) {
                            case 0:                                break;  //
                            case 1: device_tree[dev_idx]->SetS();  break;  //S
                            case 2: device_tree[dev_idx]->SetC();  break;  //C
                            case 3: device_tree[dev_idx]->SetP();  break;  //P
                        }
                    } else {
                        switch (ctrl) {
                            case 0: if (device_tree[dev_idx]->GetBusy()) PC = (PC+1)&MEM_MASK; break;       //SKPBN
                            case 1: if (!(device_tree[dev_idx]->GetBusy())) PC = (PC+1)&MEM_MASK; break;    //SKPBZ
                            case 2: if (device_tree[dev_idx]->GetDone()) PC = (PC+1)&MEM_MASK; break;       //SKPDN
                            case 3: if (!(device_tree[dev_idx]->GetDone())) PC = (PC+1)&MEM_MASK; break;    //SKPDZ
                        }
                    }
                }    
                } 
                PC = (PC+1)&MEM_MASK;
            }
        }
        //before this line, PC += 1 or PC = val should be done
        //DMA
        if (dkp.GetDma()) dkp.SetDma(NC);
        //INT
        if (INT_ENABLE) {
            uint16_t int_dev = 0;
            if (tto.GetInterrupt() && (INT_TTO &~INT_DEV_MASK)) int_dev = IDX_TTO;
            if (tti.GetInterrupt() && (INT_TTI &~INT_DEV_MASK)) int_dev = IDX_TTI;
            if (rtc.GetInterrupt() && (INT_RTC &~INT_DEV_MASK)) int_dev = IDX_RTC;
            if (lpt.GetInterrupt() && (INT_LPT &~INT_DEV_MASK)) int_dev = IDX_LPT;
            if (dkp.GetInterrupt() && (INT_DKP &~INT_DEV_MASK)) int_dev = IDX_DKP;
            if (int_dev > 0) {
                INT_DEV_IDX = int_dev;
                INT_ENABLE = false;
                INT_TO_ENABLE = false;  //---Important!---
                WriteNC(false, 0, 0, PC);
                PC = CalMaddr(true, 0, 1);
            }
        }
        //update devices
        tto.Update();
        tti.Update();
        rtc.Update();
        lpt.Update();
        dkp.Update();
    }
    ~DJS130X() {}
};

#endif
