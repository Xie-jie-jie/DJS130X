// DJS-130X C++ Simulator Library
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
#ifndef _DJS130_SIM_HPP_
#define _DJS130_SIM_HPP_

#include "djs130_periph.hpp"
#include "djs130_core.hpp"
#include "windows.h"
#include "conio.h"

#define NOTATION "Sim>"

class Simulator
{
    enum OUTPUT_STATE {
        NORMAL = 0,
        SETCURSOR1 = 1,
        SETCURSOR2 = 2,
        SETCOLOR1 = 3,
        SETCOLOR2 = 4,
    };
    std::map<uint16_t, std::string> input_conv;
    std::map<char, std::string> output_conv;
    DJS130X djsx;
    bool is_hit = false;
    bool is_exit = false;
    uint16_t key = 0;
    uint16_t key2 = 0;
    uint16_t cmdkey = 15104;
    HANDLE handle = GetStdHandle(STD_OUTPUT_HANDLE);
    OUTPUT_STATE output_state = NORMAL;
    COORD output_cursor;
    uint16_t output_color;
    uint16_t con_color = 0x06;
    
    void Input(uint16_t ch) {
        if (input_conv.find(ch) != input_conv.end()) {
            std::string s = input_conv[ch];
            for (int i=0; i<s.length(); i++) djsx.SR(s[i]);
        }
        else if (ch < 128) djsx.SR(ch);
    }
    void Output(char ch) {
        std::string s = "";
        if (output_state == NORMAL && output_conv.find(ch) != output_conv.end()) s = output_conv[ch];
        else s += ch;
        for (int i=0; i<s.length(); i++) {
            switch (output_state) {
            case NORMAL:    if (s[i] == 16) output_state = SETCURSOR1;
                            else if (s[i] == 15) output_state = SETCOLOR1; 
                            else PrintTTO(s[i]); break;
            case SETCURSOR1:output_cursor.X = s[i] & 0x7f;
                            output_state = SETCURSOR2; break;
            case SETCURSOR2:output_cursor.Y = s[i] & 0x1f;
                            SetConsoleCursorPosition(handle, output_cursor);
                            output_state = NORMAL; break;
            case SETCOLOR1: output_color = s[i] & 0xf;
                            output_state = SETCOLOR2; break;
            case SETCOLOR2: output_color |= (s[i] & 0xf) << 4;
                            con_color = output_color;
                            SetConsoleTextAttribute(handle, con_color);
                            output_state = NORMAL; break;
            default:        output_state = NORMAL; break;
            }
        }
    }
    bool Command(std::istream& si, bool in_file, bool& will_run) {
        uint16_t past_con_color = con_color;
        SetConsoleTextAttribute(handle, 0x07); //Fore: White  Back: Black  
        will_run = false;
        while (true) {
            if (in_file && si.peek() == EOF) break;
            if (!in_file) PrintMsg(NOTATION);
            std::string s;
            si >> s;
            if (s == "boot") {  //boot
                if (in_file) PrintMsg(NOTATION+s+"\n"); 
                djsx.YD(); 
                djsx.QDZ(); 
            }    
            else if (s == "halt") { //halt
                if (in_file) PrintMsg(NOTATION+s+"\n");
                djsx.TJ(); 
            }    
            else if (s == "run") { //go on
                will_run = true;
                if (in_file) PrintMsg(NOTATION+s+"\n");
                else break; 
            }
            else if (s == "end") { //end file (no effect for console)
                if (in_file) break;
            }
            else if (s == "load") { //load disk
                std::string s1,s2;
                si>>s1>>s2;
                if (in_file) PrintMsg(NOTATION+s+" "+s1+" "+s2+"\n");
                if (s1 == "dp0") djsx.JZ(s2, 0);
                else if (s1 == "dp1") djsx.JZ(s2, 1);
                else if (s1 == "dp2") djsx.JZ(s2, 2);
                else if (s1 == "dp3") djsx.JZ(s2, 3);
                else PrintErr("[Error]: Invalid parameter for 'load'.\n"); 
            }
            else if (s == "save") { //save disk
                std::string s1,s2;
                si>>s1>>s2;
                if (in_file) PrintMsg(NOTATION+s+" "+s1+" "+s2+"\n");
                if (s1 == "dp0") djsx.BC(s2, 0);
                else if (s1 == "dp1") djsx.BC(s2, 1);
                else if (s1 == "dp2") djsx.BC(s2, 2);
                else if (s1 == "dp3") djsx.BC(s2, 3);
                else PrintErr("[Error]: Invalid parameter for 'save'.\n"); 
            }
            else if (s == "exit") {
                if (in_file) PrintMsg(NOTATION+s+"\n");
                return true;
            }
            else if (s == "refresh") {
                if (in_file) PrintMsg(NOTATION+s+"\n");
                djsx.SX();
            }
            else if (s == "debug") {
                std::string s1;
                si>>s1;
                if (in_file) PrintMsg(NOTATION+s+" "+s1+"\n");
                if (s1 == "on") djsx.DEBUG(true);
                else if (s1 == "off") djsx.DEBUG(false);
                else PrintErr("[Error]: Invalid parameter for 'debug'.\n");
            }
            else if (s == "do") {
                std::string fname;
                si>>fname;
                if (in_file) PrintMsg(NOTATION+s+" "+fname+"\n");
                std::ifstream file(fname);
                if (file.is_open()) {
                    bool exec_res = Command(file, true, will_run);
                    file.close();
                    if (exec_res) return true;
                    if (will_run && (!in_file)) break;
                }
                else PrintErr("[Error]: Cannot open file: "+fname+"\n");
            }
            else if (s == "rem") {  //code annotation
                char c;
                while (true) {
                    si.get(c);
                    if (c == '\r' || c == '\n' || si.peek() == EOF) break;
                }
            }
            else if (s == "key") {
                uint16_t key_code;
                std::string conv = "";
                std::string cons = "";
                si>>key_code>>conv;
                if (in_file) PrintMsg(NOTATION+s+" "+std::to_string(key_code)+" "+conv+"\n");
                if (conv == "cmd") cmdkey = key_code;
                else {
                    std::string temp = "";
                    for (int i=0; i<conv.length(); i++) {
                        if (conv[i] == ',') { 
                            if (temp.size() > 0) cons += (char)std::stoi(temp); 
                            temp = ""; 
                        }
                        else temp += conv[i];
                    }
                    if (temp != "") cons += (char)std::stoi(temp);
                    input_conv[key_code] = cons;
                }
            }
            else if (s == "show") {
                uint16_t show_code;
                std::string conv = "";
                std::string cons = "";
                si>>show_code>>conv;
                if (in_file) PrintMsg(NOTATION+s+" "+std::to_string(show_code)+" "+conv+"\n");
                if (show_code >= 256) PrintErr("[Error]: Ascii code cannot be greater than 255.\n");
                else {
                    std::string temp = "";
                    for (int i=0; i<conv.length(); i++) {
                        if (conv[i] == ',') { 
                            if (temp.size() > 0) cons += (char)std::stoi(temp); 
                            temp = ""; 
                        }
                        else temp += conv[i];
                    }
                    if (temp != "") cons += (char)std::stoi(temp);
                    output_conv[show_code] = cons;
                }
            }
            else if (s == "input") {
                std::string fname;
                si>>fname;
                if (in_file) PrintMsg(NOTATION+s+" "+fname+"\n");
                std::ifstream file(fname);
                if (file.is_open()) {
                    while (true) {
                        char c;
                        file.get(c);
                        if (file.peek() == EOF) break;
                        Input(c);
                    }
                    file.close();
                }
                else PrintErr("[Error]: Cannot open file: "+fname+"\n");
            }
            else if (s == "output") {
                std::string fname;
                si>>fname;
                if (in_file) PrintMsg(NOTATION+s+" "+fname+"\n");
                djsx.DY(fname);
            }
            else if (s == "reset") {
                if (in_file) PrintMsg(NOTATION+s+"\n");
                djsx.DEBUG(false);
                input_conv.clear();
                output_conv.clear();
            }
            else PrintErr("[Error]: Invalid command: "+s+"\n");
        }
        con_color = past_con_color;
        SetConsoleTextAttribute(handle, con_color); //Fore: White  Back: Black  
        return false;
    }
    void KeyListen() {
        while (true) {
            if (is_exit) return;
            if (_kbhit() && is_hit == false) {
                key = _getch();
                key2 = (key == 0 || key >= 128) ? _getch() : 0;
                is_hit = true;
            }
            std::this_thread::sleep_for(std::chrono::milliseconds(5));
        }
    }
public:
    Simulator() {is_hit = false; key = 0;}
    void Exec() {
        bool in_command = true;
        bool will_run = false;
        std::thread key_listen(&Simulator::KeyListen, this);
        while (true) {
#ifdef DJS130_LOWSPEED
        auto syst = std::chrono::system_clock::now();
        for (int i=0; i<1000000; i++) {
#endif
            if (in_command) { 
                if (Command(std::cin, false, will_run)) {
                    is_exit = true;
                    key_listen.join();
                    return; 
                }
                in_command = false; 
            }
            if (is_hit) {
                uint16_t ch = ((key&0xff)|((key2&0xff)<<8));
                if (ch == cmdkey) in_command = true;
                else Input(ch);
                is_hit = false;
            }
            djsx.Update();
            char c;
            if (djsx.SC(c)) Output(c);
#ifdef DJS130_LOWSPEED
        }
        std::this_thread::sleep_until(syst + std::chrono::milliseconds(50));
#endif
        }
    }
};

#endif
