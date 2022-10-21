#include <intrins.h>

// This code compiles but it will not work!
// It requires STC specific loader asm (TODO)

#define DECLARE_REG(_addr, _name) sfr _name = _addr

DECLARE_REG(0x8A, IT1);
DECLARE_REG(0xAA, EX1);
DECLARE_REG(0xAF, EA);

DECLARE_REG(0xB0, RXD);
DECLARE_REG(0xB1, TXD);
DECLARE_REG(0xB2, INT0);
DECLARE_REG(0xB3, INT1);

DECLARE_REG(0xB0, P3_0);
DECLARE_REG(0xB1, P3_1);
DECLARE_REG(0xB2, P3_2);
DECLARE_REG(0xB3, P3_3);

DECLARE_REG(0xCA, P5M0);
DECLARE_REG(0xCD, P5_5);

void set_rx()
{
	RXD = 1;
	TXD = 0;
}

void set_tx()
{
	RXD = 0;
	TXD = 1;
}

void delay(unsigned short time)
{
	register unsigned short counter;
	while(time--)
	{
		_nop_(); _nop_(); _nop_();
		counter = 3006;
		while(--counter);
	}
}

void t0int() interrupt 1
{
	if (INT1 != 0) return;
	delay(50);
	if (INT1 != 0) return;

	P5_5 = 1;
	set_rx();
	while(1) {}
}

void initialize()
{
	P5_5 = 0;
	RXD = 0;
	TXD = 0;
	INT0 = 1;

	set_tx();
}

void initialize_interrupts()
{
	IT1 = 1;
	EA  = 1;
	EX1 = 1;
}

int main()
{
	P5M0 = 0xff;

	initialize();
	initialize_interrupts();

	delay(7500);

	while(1)
	{
		if (INT0 == 0) continue;
		delay(7500);
		if (INT0 == 0) continue;

		P5_5 = 1;
		set_rx();
	}
}
