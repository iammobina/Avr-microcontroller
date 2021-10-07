/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
� Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : AZ_05
Version : 
Date    : 5/30/2020
Author  : Mobina Kashanian
Company : IUST
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/
#include <mega32.h>
#include <delay.h>
// Declare your global variables here

void main(void)
{


// Declare your local variables here
int Index;
int j = 0;
char Character[30] = {0x00, 0b01111110, 0b00010001, 0b00010001, 0b01111110, 
                   0x00, 0b01111111, 0b01001001, 0b01001001, 0b00110110, 
                   0x00, 0b00111110, 0b01000001, 0b01000001, 0b00100010, 
                   0x00, 0b01111111, 0b01000001, 0b01000001, 0b00111110, 
                   0x00, 0b01111111, 0b01001001, 0b01001001, 0b01000001, 
                   0x00, 0b01111111, 0b00001001, 0b00001001, 0b00000001   
                   };
int Counter = 0;
int count=1;
// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0xFF;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;



while (1)
      {
      for(Index=0; Index < 31; Index++)
      {                          
        for(j=0;j <9 ; j++){
            for(Counter =0; Counter<8; Counter++) {
                PORTB = (1 << Counter);
                PORTC = ~(Character[(Index + Counter) % 30]);
                delay_ms(3);
                PORTD = PORTB;
                
            }
            delay_ms(10);
        } 
      }
      Index = 1;
      };
}