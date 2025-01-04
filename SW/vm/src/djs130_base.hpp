// DJS-130X C++ Simulator Base Library
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
#ifndef _DJS130_BASE_HPP_
#define _DJS130_BASE_HPP_

#include <iostream>
#include <fstream>
#include <cstdint>
#include <map>
#include <memory>
#include <string>
#include <queue>
#include <conio.h>
#include <cstring>
#include <thread>

void PrintMsg(std::string s) { std::cout << s; }
void PrintErr(std::string s) { std::cout << s; system("pause");}
#ifdef DJS130_SHOWINT
void PrintTTO(char c) { if (c) std::cout << c << "<" << (int)c << ">"; }
#else
void PrintTTO(char c) { if (c) std::cout << c; }
#endif

//Device base class
class Device
{
public:
    virtual bool GetBusy() {return false;}
    virtual bool GetDone() {return false;}
    virtual void SetS() {}
    virtual void SetC() {}
    virtual void SetP() {}
    virtual uint16_t GetJa() {return 0;}
    virtual uint16_t GetJb() {return 0;}
    virtual uint16_t GetJc() {return 0;}
    virtual void SetJa(uint16_t val) {}
    virtual void SetJb(uint16_t val) {}
    virtual void SetJc(uint16_t val) {}
    virtual void Reset() {}
    virtual void Update() {}
    //Interrupt
    virtual bool GetInterrupt() {return false;}
    //DMA
    virtual bool GetDma() {return false;}
    virtual void SetDma(uint16_t* nc) {}
};

std::string disassemble(uint16_t inst) {
    std::string da = "";
    int is_slzl = inst & 0x8000;
    if (is_slzl) {  //is Arithemetic & Logical Instruction
        int funct = (inst & 0x700) >> 8;
        int acs = (inst & 0x6000) >> 13;
        int acd = (inst & 0x1800) >> 11;
        int shift = (inst & 0xc0) >> 6;
        int carry = (inst & 0x30) >> 4;
        bool noload = (inst & 0x8);
        int skip = inst & 0x7;
        int res = 0;
        switch (funct) {
            case 0 : da = "COM";    break;  //COM
            case 1 : da = "NEG";    break;  //NEG
            case 2 : da = "MOV";    break;  //MOV
            case 3 : da = "INC";    break;  //INC
            case 4 : da = "ADC";    break;  //ADC
            case 5 : da = "SUB";    break;  //SUB
            case 6 : da = "ADD";    break;  //ADD
            case 7 : da = "AND";    break;  //AND
        } 
        switch (carry) {
            case 0 :                break;  //
            case 1 : da += "Z";     break;  //Z
            case 2 : da += "O";     break;  //O
            case 3 : da += "C";     break;  //C
        }
        switch (shift) {
            case 0 :                break;  //
            case 1 : da += "L";     break;  //L
            case 2 : da += "R";     break;  //R
            case 3 : da += "S";     break;  //S
        }
        if (noload) da += "#";
        da += "\t";
        da += std::to_string(acs)+","+std::to_string(acd);
        switch (skip) {
            case 0 :                  break;  //
            case 1 : da += ",SKP";    break;  //SKP
            case 2 : da += ",SZC";    break;  //SZC
            case 3 : da += ",SNC";    break;  //SNC
            case 4 : da += ",SZR";    break;  //SZR
            case 5 : da += ",SNR";    break;  //SNR
            case 6 : da += ",SEZ";    break;  //SEZ
            case 7 : da += ",SBN";    break;  //SBN
        }
    } else {
        int op12 = (inst & 0x6000) >> 13;
        bool I = (inst & 0x400);
        int X = (inst & 0x300) >> 8;
        int D = (inst & 0xff);
        int acn = (inst & 0x1800) >> 11;
        if (op12 <= 2) {
            if (op12 == 1) da = "LDA";         //LDA
            else if (op12 == 2) da = "STA";    //STA
            else if (op12 == 0) {
                switch (acn) {
                case 0: da = "JMP";break;   //JMP
                case 1: da = "JSR";break;   //JSR
                case 2: da = "ISZ";break;   //ISZ
                case 3: da = "DSZ";break;   //DSZ
                }
            }
            da += "\t";
            if (op12) da += std::to_string(acn)+",";
            if (I) da += "@";
            switch (X) {
            case 0: da += std::to_string(D);    break;                      //page 0
            case 1: da += std::to_string((D^0x80)-128)+"(PC)";   break;     //PC relative
            case 2: da += std::to_string((D^0x80)-128)+"(2)";   break;    //AC2
            case 3: da += std::to_string((D^0x80)-128)+"(3)";   break;    //AC3
            }
        } else {
            int dev_idx = inst & 0x3f;
            int funct = (inst & 0x700) >> 8;
            int ctrl = (inst & 0xc0) >> 6;
            if (dev_idx == 1) { //MUL / DIV
                if (ctrl == 1) da = "DIV";
                else if (ctrl == 3) da = "MUL";
            } 
            else if (dev_idx == 63 && funct == 0 && ctrl == 1) da = "INTEN";    //NIOS CPU
            else if (dev_idx == 63 && funct == 0 && ctrl == 2) da = "INTDS";    //NIOC CPU
            else if (dev_idx == 63 && funct == 1 && ctrl == 0) da = "READS\t"+std::to_string(acn);   //DIA -,CPU
            else if (dev_idx == 63 && funct == 3 && ctrl == 0) da = "INTA\t"+std::to_string(acn);    //DIB -,CPU
            else if (dev_idx == 63 && funct == 4 && ctrl == 0) da = "MSKO\t"+std::to_string(acn);    //DOB -,CPU
            else if (dev_idx == 63 && funct == 5 && ctrl == 2 && acn == 0) da = "IORST";   //DICC 0,CPU
            else if (dev_idx == 63 && funct == 6 && ctrl == 0 && acn == 0) da = "HALT";    //DOC 0,CPU
            else {  //I/O instruction
            if (funct == 0) da = "NIO";                             //NIO
            else if (funct == 1) da = "DIA";                        //DIA
            else if (funct == 2) da = "DOA";                        //DOA
            else if (funct == 3) da = "DIB";                        //DIB
            else if (funct == 4) da = "DOB";                        //DOB
            else if (funct == 5) da = "DIC";                        //DIC
            else if (funct == 6) da = "DOC";                        //DOC
            if (funct != 7) {
                switch (ctrl) {
                    case 0:             break;  //
                    case 1: da += "S";  break;  //S
                    case 2: da += "C";  break;  //C
                    case 3: da += "P";  break;  //P
                }
                da += "\t";
                if (funct != 0) da += std::to_string(acn)+",";
            } else {
                switch (ctrl) {
                    case 0: da = "SKPBN"; break;    //SKPBN
                    case 1: da = "SKPBZ"; break;    //SKPBZ
                    case 2: da = "SKPDN"; break;    //SKPDN
                    case 3: da = "SKPDZ"; break;    //SKPDZ
                }
                da += "\t";
            }
            switch (dev_idx) {
            case 010: da += "TTI"; break;
            case 011: da += "TTO"; break;
            case 012: da += "PTR"; break;
            case 013: da += "PTP"; break;
            case 014: da += "RTC"; break;
            case 017: da += "LPT"; break;
            case 033: da += "DKP"; break;
            case 077: da += "CPU"; break;
            default: da += std::to_string(dev_idx); break;
            }
            }     
        }
    }
    return da;
}

#endif