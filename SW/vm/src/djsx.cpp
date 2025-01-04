// DJS-130X C++ Simulator
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

//Some Instructions:
//  boot : boot up the computer
//  halt : halt the computer
//  load : load disk from file
//  save : save disk
//  debug on : turn on debug
//  debug off : turn off debug
//  run : go on

//Step: load->boot->run->[F1]->halt->save

//define DJS130_LOWSPEED before include "djs130_sim.hpp" to limit speed
//#define DJS130_LOWSPEED
//define DJS130_SHOWINT before include "djs130_sim.hpp" to print ascii char in int number
//#define DJS130_SHOWINT

#include "djs130_sim.hpp"
int main()
{
    Simulator* sim = new Simulator();
    sim->Exec();
    delete sim;
    return 0;
}
