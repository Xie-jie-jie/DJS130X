// DJS-130X C++ Simulator Peripheral Library
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
#ifndef _DJS130_PERIPH_HPP_
#define _DJS130_PERIPH_HPP_

#include "djs130_base.hpp"

//TTI TeleType Input
//Special Function: void Input(char c)
class TTI : Device
{
    static const int TTI_DELAY = 10;
    std::queue<char> buffer;
    bool busy = 0;
    bool done = 0;
    int delay_cnt = 0;
public:
    void Input(char c) {
        if (done) return;
        char k = c & 0x7f;
        if (buffer.size() == 0) delay_cnt = TTI_DELAY;
        buffer.push(k);
    }
    bool GetBusy() override {return busy;}
    bool GetDone() override {return done;}
    bool GetInterrupt() override {return done;}
    void Reset() override {
        std::queue<char> empty;
        std::swap(empty, buffer);
        busy = 0;
        done = 0;
        delay_cnt = 0;
    }
    uint16_t GetJa() override {
        uint16_t temp = 0;
        //std::cout<<"Buffer size: "<<buffer.size()<<std::endl;
        if (buffer.size() > 0) {
            temp = buffer.front();
            buffer.pop();
        }
        return temp;
    }
    void SetS() override {
        busy = 1;
        done = 0;
    }
    void SetC() override {
        busy = 0;
        done = 0;
    }
    void Update() override {
        if (delay_cnt > 0) {
            delay_cnt--;
            if (delay_cnt <= 0 && buffer.size() > 0) {
                busy = 0;
                done = 1;
                delay_cnt = TTI_DELAY;
            }
        }
    }
};

//TTO TeleType Output
class TTO : Device
{
    static const int TTO_DELAY = 5;
    std::queue<char> buffer;
    bool busy = 0;
    bool done = 0;
    char data = 0;
    int delay_cnt = 0;
public:
    bool Output(char& c) {
        if (buffer.size() > 0) {
            c = buffer.front();
            buffer.pop();
            return true;
        } else return false;
    }
    bool GetBusy() override {return busy;}
    bool GetDone() override {return done;}
    bool GetInterrupt() override {return done;}
    void Reset() override {
        busy = 0;
        done = 0;
        delay_cnt = 0;
    }
    void SetS() override {
        busy = 1;
        done = 0;
        delay_cnt = TTO_DELAY;
    }
    void SetC() override {
        busy = 0;
        done = 0;
        delay_cnt = 0;
    }
    void SetJa(uint16_t val) override { data = val & 0x7f; }
    void Update() override {
        if (delay_cnt > 0) {
            delay_cnt--;
            if (delay_cnt <= 0) {
                buffer.push(data);
                // if (data == 25) PrintTTO(8);    //<25>EM ---> <8>Backspace
                // else if (data != 7 && data != 17 && data != 19) PrintTTO(data);
                busy = 0;
                done = 1;
            }
        }
    }
};

//RTC Real Time Clock
class RTC : Device
{
    const int span[4] = {20000, 100000, 10000, 1000};   //time span (insts)     //20003, 100003, 10003, 1003
    bool busy = 0;
    bool done = 0;
    int rate = 0;   //0=50Hz 1=10Hz 2=100Hz 3=1000Hz
    int cnt = 0;
public:
    bool GetBusy() override {return busy;}
    bool GetDone() override {return done;}
    bool GetInterrupt() override {return done;}
    void Update() override {
        if (busy)
        {
            if (cnt > 0) {
                cnt--;
                if (cnt <= 0) {
                    busy = 0;
                    done = 1;
                }
            }
        }
    }
    void Reset() override {
        rate = 0;
        busy = 0;
        done = 0;
        cnt = 0;
    }
    void SetJa(uint16_t val) override { rate = val & 0x3; }
    void SetS() override {
        if (busy == 0)
        {
            busy = 1;
            done = 0;
            cnt = span[rate];
        }
    }
    void SetC() override {
        busy = 0;
        done = 0;
        cnt = 0;
    }
};

//LPT Line Printer
class LPT : Device
{
    std::ofstream os;
    std::string filepath;
    bool busy = 0;
    bool done = 0;
    char data = 0;
public:
    LPT() {}
    bool GetBusy() override {return busy;}
    bool GetDone() override {return done;}
    bool GetInterrupt() override {return done;}
    void Open(std::string fp) {
        filepath = fp;
        if (os.is_open()) os.close();
        os.open(filepath, std::ios::trunc);
        if(!os.is_open())PrintErr("[Error]: Cannot open LPT output file: "+filepath+"\n");
    }
    void Refresh() {
        os.close();
        os.open(filepath, std::ios::app);
        if(!os.is_open())PrintErr("[Error]: Cannot open LPT output file: "+filepath+"\n");
    }
    void Reset() override {
        busy = 0;
        done = 0;
        data = 0;
    }
    void SetJa(uint16_t val) override { data = val & 0x7f; }
    uint16_t GetJa() override { return 0x1; }
    void SetS() override {
        busy = 1;
        done = 0;
        if (data != 0 && os.is_open()) os<<data;
        busy = 0;
        done = 1;
    }
    void SetC() override {
        busy = 0;
        done = 0;
    }
    void Update() override {}
    ~LPT() {os.close();}
};

//DKP DG 'classic' disk drivers
//Model 4048
//1 sector = 256 word = 512 Byte
//1 surface = 6 sector
//1 cylinder = 10 surface
//1 disk = 203 cylinder
class DKP : Device
{
    struct STATUS {
        static const uint16_t RWDONE    = 0x8000;
        static const uint16_t SEEKDONE0 = 0x4000;
        static const uint16_t SEEKDONE1 = 0x2000;
        static const uint16_t SEEKDONE2 = 0x1000;
        static const uint16_t SEEKDONE3 = 0x0800;
        static const uint16_t SEEKING0  = 0x0400;
        static const uint16_t SEEKING1  = 0x0200;
        static const uint16_t SEEKING2  = 0x0100;
        static const uint16_t SEEKING3  = 0x0080;
        static const uint16_t READY     = 0x0040;
        static const uint16_t SEEKERR   = 0x0020;
        static const uint16_t ENDERR    = 0x0010;
        static const uint16_t ADDRERR   = 0x0008;
        static const uint16_t CHECKERR  = 0x0004;
        static const uint16_t DATALATE  = 0x0002;
        static const uint16_t ERROR     = 0x0001;
        static const uint16_t DN_FLAGS  = (RWDONE | SEEKDONE0 | SEEKDONE1 | SEEKDONE2 | SEEKDONE3);
        static const uint16_t ERR_FLAGS = (ERROR | DATALATE | CHECKERR | ADDRERR | ENDERR | SEEKERR);
    };
    static const int DISK_SIZE = 4 * 1024 * 1024;   //4MW = 8MB, enough for 6.2MB DKP 4048 driver
    static const int DISK_CYL = 203;
    static const int DISK_SURF = 10;
    static const int DISK_SECT = 6;
    static const int DISK_RW_DELAY = 10;
    bool busy = 0;
    bool done = 0;
    uint16_t command = 0;
    uint16_t status = STATUS::READY;
    uint16_t status_address = 0;
    uint16_t nc_addr = 0;       //nc address
    int16_t sect_cnt = 0;      //sector count, -16~-1, if 0 then done
    int mode = 0;               //0 read 1 write 2 seek 3 recalibrate-position
    int drive = 0;              //0 ~ 3
    bool dma_start = false;
    int rw_delay_cnt = 0;
    uint16_t dp[4][DISK_SIZE];
    void SetCurrentCnt(int c) {
        status_address &= ~0x000f;
        status_address |= (c&0xf);
    }
    int GetCurrentSect() { return ((status_address & 0x00f0) >> 4); }
    void SetCurrentSect(int s) {
        status_address &= ~0x00f0;
        status_address |= ((s&0xf) << 4);
    }
    int GetCurrentSurf() { return ((status_address & 0x1f00) >> 8); }
    void SetCurrentSurf(int s) {
        status_address &= ~0x1f00;
        status_address |= ((s&0x1f) << 8);
    }
public:
    bool GetBusy() override { return busy; }
    bool GetDone() override { return done; }
    bool GetInterrupt() override { return done; }
    void Reset() override {
        command = 0;
        busy = 0;
        done = 0;
        status = STATUS::READY;
        status_address = 0;
        nc_addr = 0;
        sect_cnt = 0;
        mode = 0;
        drive = 0;
        dma_start = false;
        rw_delay_cnt = 0;
    }
    uint16_t GetJa() override { return status; }
    uint16_t GetJb() override { return nc_addr; }
    uint16_t GetJc() override { return status_address; }
    void SetJa(uint16_t val) override {
        command = val;
        status &= ~(STATUS::DN_FLAGS|STATUS::ERR_FLAGS);
    }
    void SetJb(uint16_t val) override { nc_addr = val & 0x7fff; }
    void SetJc(uint16_t val) override { status_address = val; }
    void SetS() override {
        sect_cnt = (-16) | (status_address & 0xf);
        drive = ((status_address & 0xc000) >> 14);
        mode = ((command & 0x300) >> 8);
        busy = 1;
        done = 0;
        rw_delay_cnt = DISK_RW_DELAY;
    }
    void SetC() override {
        status = STATUS::READY;
        busy = 0;
        done = 0;
        dma_start = false;
    }
    void SetP() override {
        status = STATUS::READY;
        status |= (STATUS::SEEKDONE0>>drive);
        done = 1;
        if ((command & 0xff) >= DISK_CYL) status |= STATUS::SEEKERR | STATUS::ENDERR | STATUS::ERROR;
    }
    bool GetDma() override { return dma_start; }
    void Update() override {
        if (rw_delay_cnt > 0) {
            rw_delay_cnt--;
            if (rw_delay_cnt <= 0) dma_start = true;
        }
    }
    void SetDma(uint16_t* nc) override {
        int temp_sect = GetCurrentSect();
        int temp_surf = GetCurrentSurf();
        int temp_cyl = command & 0xff;
        if (mode == 0) {
            for (; sect_cnt < 0; sect_cnt++) {
                int disk_addr = (temp_cyl << 14) | ((temp_surf*DISK_SECT+temp_sect) << 8);
                if (nc_addr < 0x7fff-256) {
                    memcpy(nc+nc_addr, (dp[drive]+disk_addr), 256*sizeof(uint16_t));
                    nc_addr += 256;
                } else for (int i=0; i<256; i++) { nc[nc_addr] = dp[drive][disk_addr+i]; nc_addr = (nc_addr + 1) & 0x7fff; }
                temp_sect++;
                if (temp_sect >= DISK_SECT) {
                    temp_sect = 0;
                    temp_surf++;
                    if (temp_surf >= DISK_SURF) temp_surf = 0;
                }
            }
        }
        else if (mode == 1) {
            for (; sect_cnt < 0; sect_cnt++) {
                int disk_addr = (temp_cyl << 14) | ((temp_surf*DISK_SECT+temp_sect) << 8);
                for (int i=0; i<256; i++) {
                    dp[drive][disk_addr+i] = nc[nc_addr];
                    nc_addr = (nc_addr + 1) & 0x7fff;
                }
                temp_sect++;
                if (temp_sect >= DISK_SECT) {
                    temp_sect = 0;
                    temp_surf++;
                    if (temp_surf >= DISK_SURF) temp_surf = 0;
                }
            }
        }
        SetCurrentSurf(temp_surf);
        SetCurrentSect(temp_sect);
        SetCurrentCnt(sect_cnt);
        status |= STATUS::RWDONE;
        dma_start = false;
        busy = 0;
        done = 1;
    }
    void LoadBin(std::string filepath, int dpn) {   //Note: .bin file is big-endian !!!
        std::ifstream bin_file(filepath, std::ios::binary);
        if (!bin_file) {
            PrintErr("[Error]: Cannot load from bin file: "+filepath+"\n");
            return;
        }
        uint16_t read_temp = 0;
        int disk_addr = 0;
        while (!bin_file.eof()) {
            bin_file.read(reinterpret_cast<char*>(&read_temp), sizeof(read_temp));
            dp[dpn][disk_addr] = read_temp;
            disk_addr++;
            if (disk_addr >= DISK_SIZE) break;
        }
        bin_file.close();
    }
    void SaveBin(std::string filepath, int dpn) {    //Note: .bin file is big-endian !!!
        std::ofstream bin_file(filepath, std::ios::binary);
        if (!bin_file) {
            PrintErr("[Error]: Cannot save to bin file: "+filepath+"\n");
            return;
        }
        uint16_t write_temp = 0;
        for (int i=0; i<DISK_SIZE; i++) {
            write_temp = dp[dpn][i];
            bin_file.write(reinterpret_cast<char*>(&write_temp), sizeof(write_temp));
        }
        bin_file.close();
    }
};

#endif
