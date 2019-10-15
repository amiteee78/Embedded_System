/*
 *
 * dot_mat_spi.c
 * Created: 10/14/2019 1:53:44 PM
 * Author: Amit Mazumder Shuvo
 * Version 1.0
 * 
 */ 

#include <mega32.h>
#include <delay.h>
#include <stdio.h>
#include <stdlib.h>

#define SS PORTB4
#define MOSI PORTB5
#define MISO PORTB6
#define SCK PORTB7
#define DEVICE_NUM 2
#define DELAY 50

#define SLAVE_SEL PORTB &= ~(1<<SS) //Slave Select(Active Low)
#define SLAVE_DESEL PORTB |= (1<<SS)//SLave Deselect(Active High)

unsigned char buffer[DEVICE_NUM*8]; // buffer for text scrolling
//const char message[] = " Institute of Information & Communication Technology, BUET, Dhaka-1211 "; // message to be displayed
const char message[] = " Amit Mazumder Shuvo "; // message to be displayed
//const char message[] = "Tahsin Mostafiz has nailed the professors of the USA."; // message to be displayed
unsigned int message_size = sizeof(message); // size of message array
	
const char characters[96][5] = {
	{0b00000000,0b00000000,0b00000000,0b00000000,0b00000000}, // space
	{0b00000000,0b00000000,0b01001111,0b00000000,0b00000000}, // !
	{0b00000000,0b00000111,0b00000000,0b00000111,0b00000000}, // "
	{0b00010100,0b01111111,0b00010100,0b01111111,0b00010100}, // #
	{0b00100100,0b00101010,0b01111111,0b00101010,0b00010010}, // $
	{0b00100011,0b00010011,0b00001000,0b01100100,0b01100010}, // %
	{0b00110110,0b01001001,0b01010101,0b00100010,0b01010000}, // &
	{0b00000000,0b00000101,0b00000011,0b00000000,0b00000000}, // '
	{0b00000000,0b00011100,0b00100010,0b01000001,0b00000000}, // (
	{0b00000000,0b01000001,0b00100010,0b00011100,0b00000000}, // )
	{0b00010100,0b00001000,0b00111110,0b00001000,0b00010100}, // *
	{0b00001000,0b00001000,0b00111110,0b00001000,0b00001000}, // +
	{0b00000000,0b01010000,0b00110000,0b00000000,0b00000000}, // ,
	{0b00000000,0b00001000,0b00001000,0b00001000,0b00001000}, // -
	{0b00000000,0b01100000,0b01100000,0b00000000,0b00000000}, // .
	{0b00100000,0b00010000,0b00001000,0b00000100,0b00000010}, // /
	{0b00111110,0b01010001,0b01001001,0b01000101,0b00111110}, // 0
	{0b00000000,0b01000010,0b01111111,0b01000000,0b00000000}, // 1
	{0b01000010,0b01100001,0b01010001,0b01001001,0b01000110}, // 2
	{0b00100001,0b01000001,0b01000101,0b01001011,0b00110001}, // 3
	{0b00011000,0b00010100,0b00010010,0b01111111,0b00010000}, // 4
	{0b00100111,0b01000101,0b01000101,0b01000101,0b00111001}, // 5
	{0b00111100,0b01001010,0b01001001,0b01001001,0b00110000}, // 6
	{0b00000011,0b01110001,0b00001001,0b00000101,0b00000011}, // 7
	{0b00110110,0b01001001,0b01001001,0b01001001,0b00110110}, // 8
	{0b00000110,0b01001001,0b01001001,0b00101001,0b00011110}, // 9
	{0b00000000,0b01101100,0b01101100,0b00000000,0b00000000}, // :
	{0b00000000,0b01010110,0b00110110,0b00000000,0b00000000}, // ;
	{0b00001000,0b00010100,0b00100010,0b01000001,0b00000000}, // <
	{0b00010100,0b00010100,0b00010100,0b00010100,0b00010100}, // =
	{0b00000000,0b01000001,0b00100010,0b00010100,0b00001000}, // >
	{0b00000010,0b00000001,0b01010001,0b00001001,0b00000110}, // ?
	{0b00110010,0b01001001,0b01111001,0b01000001,0b00111110}, // @
	{0b01111110,0b00010001,0b00010001,0b00010001,0b01111110}, // A
	{0b01111111,0b01001001,0b01001001,0b01001001,0b00111110}, // B
	{0b00111110,0b01000001,0b01000001,0b01000001,0b00100010}, // C
	{0b01111111,0b01000001,0b01000001,0b01000001,0b00111110}, // D
	{0b01111111,0b01001001,0b01001001,0b01001001,0b01001001}, // E
	{0b01111111,0b00001001,0b00001001,0b00001001,0b00000001}, // F
	{0b00111110,0b01000001,0b01001001,0b01001001,0b00111010}, // G
	{0b01111111,0b00001000,0b00001000,0b00001000,0b01111111}, // H
	{0b01000001,0b01000001,0b01111111,0b01000001,0b01000001}, // I
	{0b00110000,0b01000001,0b01000001,0b00111111,0b00000001}, // J
	{0b01111111,0b00001000,0b00010100,0b00100010,0b01000001}, // K
	{0b01111111,0b01000000,0b01000000,0b01000000,0b01000000}, // L
	{0b01111111,0b00000010,0b00001100,0b00000010,0b01111111}, // M
	{0b01111111,0b00000100,0b00001000,0b00010000,0b01111111}, // N
	{0b00111110,0b01000001,0b01000001,0b01000001,0b00111110}, // O
	{0b01111111,0b00001001,0b00001001,0b00001001,0b00000110}, // P
	{0b00111110,0b01000001,0b01010001,0b00100001,0b01011110}, // Q
	{0b01111111,0b00001001,0b00001001,0b00011001,0b01100110}, // R
	{0b01000110,0b01001001,0b01001001,0b01001001,0b00110001}, // S
	{0b00000001,0b00000001,0b01111111,0b00000001,0b00000001}, // T
	{0b00111111,0b01000000,0b01000000,0b01000000,0b00111111}, // U
	{0b00001111,0b00110000,0b01000000,0b00110000,0b00001111}, // V
	{0b00111111,0b01000000,0b00111000,0b01000000,0b00111111}, // W
	{0b01100011,0b00010100,0b00001000,0b00010100,0b01100011}, // X
	{0b00000011,0b00000100,0b01111000,0b00000100,0b00000011}, // Y
	{0b01100001,0b01010001,0b01001001,0b01000101,0b01000011}, // Z
	{0b01111111,0b01000001,0b01000001,0b00000000,0b00000000}, // [
	{0b00000010,0b00000100,0b00001000,0b00010000,0b00100000}, // '\'
	{0b00000000,0b00000000,0b01000001,0b01000001,0b01111111}, // ]
	{0b00000100,0b00000010,0b00000001,0b00000010,0b00000100}, // ^
	{0b01000000,0b01000000,0b01000000,0b01000000,0b01000000}, // _
	{0b00000000,0b00000001,0b00000010,0b00000100,0b00000000}, // `
	{0b00100000,0b01010100,0b01010100,0b01010100,0b01111000}, // a
	{0b01111111,0b01001000,0b01000100,0b01000100,0b00111000}, // 0b
	{0b00111000,0b01000100,0b01000100,0b01000100,0b00100000}, // c
	{0b00111000,0b01000100,0b01000100,0b01001000,0b01111111}, // d
	{0b00111000,0b01010100,0b01010100,0b01010100,0b00011000}, // e
	{0b00001000,0b01111110,0b00001001,0b00000001,0b00000010}, // f
	{0b00001100,0b01010010,0b01010010,0b01010010,0b00111110}, // g
	{0b01111111,0b00001000,0b00000100,0b00000100,0b01111000}, // h
	{0b00000000,0b01000100,0b01111101,0b01000000,0b00000000}, // i
	{0b00100000,0b01000000,0b01000100,0b00111101,0b00000000}, // j
	{0b01111111,0b00010000,0b00101000,0b01000100,0b00000000}, // k
	{0b00000000,0b01000001,0b01111111,0b01000000,0b00000000}, // l
	{0b01111000,0b00000100,0b00001000,0b00000100,0b01111000}, // m
	{0b01111100,0b00001000,0b00000100,0b00000100,0b01111000}, // n
	{0b00111000,0b01000100,0b01000100,0b01000100,0b00111000}, // o
	{0b01111100,0b00010100,0b00010100,0b00010100,0b00001000}, // p
	{0b00001000,0b00010100,0b00010100,0b01111100,0b00000000}, // q
	{0b01111100,0b00001000,0b00000100,0b00000100,0b00001000}, // r
	{0b01001000,0b01010100,0b01010100,0b01010100,0b00100000}, // s
	{0b00000100,0b00111111,0b01000100,0b01000000,0b00100000}, // t
	{0b00111100,0b01000000,0b01000000,0b00100000,0b01111100}, // u
	{0b00011100,0b00100000,0b01000000,0b00100000,0b00011100}, // v
	{0b00111100,0b01000000,0b00110000,0b01000000,0b00111100}, // w
	{0b01000100,0b00101000,0b00010000,0b00101000,0b01000100}, // x
	{0b00001100,0b01010000,0b01010000,0b01010000,0b00111100}, // y
	{0b01000100,0b01100100,0b01010100,0b01001100,0b01000100}, // z
	{0b00000000,0b00001000,0b00110110,0b01000001,0b00000000}, // {
	{0b00000000,0b00000000,0b01111111,0b00000000,0b00000000}, // |
	{0b00000000,0b01000001,0b00110110,0b00001000,0b00000000}, // }
	{0b00001000,0b00000100,0b00000100,0b00001000,0b00000100} // ~
};

/**********************************EXTERNAL INTERRUPT INITIALIZATION FUNCTION**********************************/
void init_interrupt(void)
{
	GICR |= (0<<INT1) | (1<<INT0) | (1<<INT2); //Enabling external interrupt0
	MCUCR |= (1<<ISC01) | (0<<ISC00); //falling edge triggered interrupt
	#asm("sei"); //global interrupt enable
}

/**********************************SPI INITIALIZATION FUNCTION**********************************/
void init_spi(void)
{
	DDRB |= (1<<MOSI) | (1<<SCK) | (1<<SS); //Set MOSI,SCK & SS pin as output
	PORTB |= (1<<SS); // SS pin unselected
	SPCR |= (1<< MSTR) | (1<< SPE) | (1<<SPR0); // Set AVR SPI as master, SPI enable & clock Focs/4
}

/*************************COMMAND & DATA TRANSFER FUNCTION**************************/
void write_word (unsigned char cmd, unsigned char data)
{
	
	SPDR = cmd;
	while (!(SPSR & (1<< SPIF)));

	SPDR = data;
	while (!(SPSR & (1<< SPIF)));
	
}

/*************************8x8 LED DOT MATRIX INITIALIZATION FUNCTION**************************/
void init_matrix(void)
{
	unsigned short int m;
	
	SLAVE_SEL;
	for (m=0;m<DEVICE_NUM;m++)
	{
		write_word(0x0A, 0x0F); // set intensity for all devices
	}
	SLAVE_DESEL;
	SLAVE_SEL;
	for (m=0;m<DEVICE_NUM;m++)
	{
		write_word(0x09, 0x00); // set no decoding mode for all devices
	}
	SLAVE_DESEL;
	SLAVE_SEL;
	for (m=0;m<DEVICE_NUM;m++)
	{
		write_word(0x0B, 0x07); // set scan limit (0-7) for 1-8 dots for all devices
	}
	SLAVE_DESEL;
	SLAVE_SEL;
	for (m=0;m<DEVICE_NUM;m++)
	{
		write_word(0x0C, 0x01); // turn display on for all devices
	}
	SLAVE_DESEL;
	SLAVE_SEL;
	for (m=0;m<DEVICE_NUM;m++)
	{
		write_word(0x0F, 0x00); // disable display test for all devices
	}		
	SLAVE_DESEL;
}

/*************************8x8 DOT MATRIX CLEAR FUNCTION**************************/
void clear_matrix(void)
{
	unsigned short int i,j;
	
	for (i=0;i<8;i++)
	{
		SLAVE_SEL;
		for (j=0;j<DEVICE_NUM;j++)
		{
			write_word(i+1,0x00); //clear data for all devices
		}
		SLAVE_DESEL;
	}
}

/*************************BUFFER INTIALIZATION FUNCTION**************************/
void init_buffer(void)
{
	unsigned short int i;
	for (i=0;i<DEVICE_NUM*8;i++)
	{
		buffer[i] = 0x00; //buffer initialization for all devices
	}
}

/*************************8x8 LED DOT MATRIX COLUMN BUFFERING FUNCTION**************************/
void push_buffer(unsigned char c)
{
	unsigned short int i;
	for (i=0;i<DEVICE_NUM*8-1;i++)
	{
		buffer[i] = buffer[i+1]; //shifting a column to the previous buffer element for all devices
	}
	buffer[DEVICE_NUM*8-1] = c;	//pushing the current column to the last buffer element
}

/*************************CURRENT BUFFER ELEMENT DISPLAY FUNCTION**************************/
void disp_buffer(void)
{
	unsigned short int i,j,k;
	for (i=0;i<DEVICE_NUM;i++)
	{
		for (j=0;j<8;j++)
		{
			SLAVE_SEL;
			for (k=0;k<i;k++)
			{
				write_word(0x00,0x00); //sending null character prior to buffer display for character shifting from device to device
			}
			
			write_word(j+1, buffer[j+i*8]); //sending buffer contents to all devices
			 
			for (k=DEVICE_NUM-1;k>i;k--)
			{
				write_word(0x00,0x00); //sending null character after buffer display for character shifting from device to device
			}
			SLAVE_DESEL;
		}
		
	}	
}

/*************************8x8 LED DOT MATRIX CHARACTER PUSHING FUNCTION**************************/
void push_char(unsigned int index)
{
	unsigned short int i;
	for (i=0;i<5;i++)
	{
		push_buffer(characters[index][i]); //pushing all columns representing a particular character to the buffer
		disp_buffer(); //displaying all columns representing a particular character
		delay_ms(DELAY);
	}
}

/*************************8x8 LED DOT MATRIX MESSAGE DISPLAYING FUNCTION**************************/
void disp_message(unsigned int message_size)
{
	unsigned int i;
	for (i=0;i<message_size;i++)
	{
		push_char(message[i]-32); //pushing ascii_val-32 as the index to locate the exact position in the character array for each element of message array
		push_buffer(0x00); //pushing null character after each character
		disp_buffer(); //displaying null for each character
		delay_ms(DELAY);
	}
}

void disp_off(void)
{
		unsigned short int i;

		SLAVE_SEL;
		for (i=0;i<DEVICE_NUM;i++)
		{
			write_word(0x0C, 0x00); // turn display off for all devices
		}
		SLAVE_DESEL;	
}

/*************************EXTERNAL INTERRUPT0 SUBROUTINE**************************/
interrupt [EXT_INT0] void ext_int0_isr(void)
{
			
	unsigned short int i;
	
	init_spi();
	init_matrix();
	clear_matrix();
	init_buffer();
	
	for (i=0;i<3;i++)
	{
		disp_message(message_size); // displaying the massage 3 times
	}
	
	for (i=0;i<2;i++)
	{
		push_buffer(0x00); // 2 final null character pushes for smoothening the scrolling completion
		disp_buffer();
		delay_ms(DELAY);		
	}
	 
	disp_off();
}

void main(void)
{

	init_interrupt(); //interrupt initialization
    while(1)
    {
		//disp_message(message_size); //displaying message for unlimited time		
    }
}