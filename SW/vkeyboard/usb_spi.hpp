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

#include	<windows.h>
#include	<stdlib.h>
#include	<stdio.h>
#include	<conio.h>
#include	<winioctl.h>
#include	"USBIOX.H"

extern unsigned char SPI_BUFFER[4096];

#define CHIP_SELECT 0x80

void SPI_SendByte00(unsigned char byte)
{
	USBIO_SetStream(0x00, 0x81);//Set SPI model;
	//USBIO_Set_D5_D0(0x00, 0xff, 0x00);//Get data feeedback
	SPI_BUFFER[0] = byte;
	SPI_BUFFER[1] = 0x0;
	SPI_BUFFER[2] = 0x0;
	if (!USBIO_StreamSPI4(0x00, CHIP_SELECT, 2, SPI_BUFFER))
	{
		printf("\nFail to SPI operation!");
		return;
	}
}