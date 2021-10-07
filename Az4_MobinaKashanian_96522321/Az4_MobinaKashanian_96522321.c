
#include <mega32.h>
#include <delay.h>
// Declare your global variables here
char minute=58;
char hour=23;
char sec=0;
//int index=0;
//int i=0;
flash char display[10]={0x3f,0x06,0x5b,0x4f,0x66,0x6d,0x7d,0x07,0x7f,0x6f};
unsigned char led_counter=1;

int convert_to_hex(int n)
{   
    switch(n){
        case 0:
            return 0X3F; 
        case 1:
            return 0X06;
        case 2:
            return 0X5B;            
        case 3:
            return 0X4F;            
        case 4:
            return 0X66;            
        case 5:
            return 0X6D;            
        case 6:
            return 0X7D;            
        case 7:
            return 0X07;            
        case 8:
            return 0X7F;            
        case 9:
            return 0X6F;            
    }    
}
// Timer1 output compare A interrupt service routine
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
// Place your code here
sec++;
if(sec ==60)
{
minute++;
sec=0;
}
if(minute ==60){
hour++;
minute=0;
}
if(hour==60)
{
hour=0;
}
    led_counter = led_counter << 1;
    if (led_counter == 0) led_counter = 1;

}

void main(void)
{
// Declare your local variables here
int minute0=0;
int hour0=0;
int sec0=0;
int minute1=0;
int hour1=0;
int sec1=0;
int dot=0x80;
// Input/Output Ports initialization
// Port A initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRA=(0<<DDA7) | (0<<DDA6) | (0<<DDA5) | (0<<DDA4) | (0<<DDA3) | (0<<DDA2) | (0<<DDA1) | (0<<DDA0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);

// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTC=(0<<PORTC7) | (0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (0<<PORTC0);

// Port D initialization
// Function: Bit7=Out Bit6=Out Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=Out Bit0=Out 
DDRD=(1<<DDD7) | (1<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
// State: Bit7=0 Bit6=0 Bit5=0 Bit4=0 Bit3=0 Bit2=0 Bit1=0 Bit0=0 
PORTD=(0<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: CTC top=OCR1A
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 1 s
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (1<<WGM12) | (1<<CS12) | (0<<CS11) | (0<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x7A;
OCR1AL=0x12;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (1<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (0<<OCIE0) | (0<<TOIE0);
// Global enable interrupts
#asm("sei")

while (1)
{
    PORTB =led_counter;
    sec0=sec%10;
    sec1=sec/10;
    minute0=minute%10;
    minute1=minute/10; 
    hour0=hour %10;
    hour1=hour /10;
    
    if(sec0 %2 ==0)   
        dot=0x80;
    else
        dot=0;
    
    
    PORTD = 0B11111110;
    PORTC = convert_to_hex(hour1);
    delay_ms(5);
    
    PORTD = 0B11111101;
    PORTC = convert_to_hex(hour0) | dot; 
    delay_ms(5);  
                 
            
    PORTD = 0B11111011;
    PORTC = convert_to_hex(minute1);
    delay_ms(5); 
        
             
    PORTD = 0B11110111;
    PORTC = convert_to_hex(minute0) | dot;
    delay_ms(5);
        
            
    PORTD = 0B11101111;
    PORTC = convert_to_hex(sec1);
    delay_ms(5);
                                                          
        
    PORTD = 0B11011111;
    PORTC = convert_to_hex(sec0) | dot; 
    delay_ms(5);
        
      
}
}