// Virtual Keyboard
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

#include "usb_spi.hpp"
#include <iostream>
#include <thread>

unsigned char SPI_BUFFER[4096];

int main()
{
    printf( "\nInitialing ......");
	printf( "\n****************************************************\n");
	printf( "Load DLL: USBIOX.DLL ......\n" );
	if (LoadLibrary(L"USBIOX.DLL") == NULL ) return 0;
	printf( "USBIO_OpenDevice: 0\n" );
	if(USBIO_OpenDevice(0) == INVALID_HANDLE_VALUE)
	{
		printf("\nfail to open device!!");
		system("pause");
		return 0;
	}
	while (true) {
		if (_kbhit()) {
			char c = _getch();
			std::cout << "Key detected: " << c << " " << "(" << (int)c << ")" << std::endl;
			SPI_SendByte00(c);
		}
		std::this_thread::sleep_for(std::chrono::milliseconds(5));
	}
    return 0;
}
