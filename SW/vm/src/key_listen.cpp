#include <iostream>
#include <conio.h>
#include <thread>
#include <cstdint>
int main()
{
    while (true)
    {
        if (_kbhit()) {
            uint16_t c = _getch();
            uint16_t d = 0;
            if (c == 0 || c >= 128) d = _getch(); 
            std::cout << "Ascii: " << (char)c << (char)d << " Int: " << ((c&0xff)|((d&0xff)<<8)) << std::endl;
        }
        std::this_thread::sleep_for(std::chrono::milliseconds(5));
    }
	return 0;
}
