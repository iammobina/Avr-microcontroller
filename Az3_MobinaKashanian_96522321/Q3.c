#include <mega32.h>


//-------in ghesmat bargerefte az code mohandes mashhoun baraye az rizpar mibashad---------
#define KEYPAD_R1 PORTD.0
#define KEYPAD_R2 PORTD.1
#define KEYPAD_R3 PORTD.2
#define KEYPAD_R4 PORTD.3
#define KEYPAD_C1 PIND.4
#define KEYPAD_C2 PIND.5
#define KEYPAD_C3 PIND.6
#define KEYPAD_C4 PIND.7

#define KEYPAD_NUM0 0
#define KEYPAD_NUM1 1
#define KEYPAD_NUM2 2
#define KEYPAD_NUM3 3
#define KEYPAD_NUM4 4
#define KEYPAD_NUM5 5
#define KEYPAD_NUM6 6
#define KEYPAD_NUM7 7
#define KEYPAD_NUM8 8
#define KEYPAD_NUM9 9
#define KEYPAD_DIV  10
#define KEYPAD_MUL  11
#define KEYPAD_PLS  12
#define KEYPAD_MNS  13
#define KEYPAD_EQU  14
#define KEYPAD_ON   15

void delay()
{
TCCR0 = (1 << CS02) | (1 << CS00);
TCNT0 = 231;
while ((TIFR & (1 << TOV0)) == 0);
TIFR = (1 << TOV0);
}

unsigned char keypad_scan()
{
unsigned char result=255;
////////////////////////  ROW1 ////////////////////////
KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row1 for Keypad
delay();
if (KEYPAD_C1)
result = KEYPAD_NUM7;
else if (KEYPAD_C2)
result = KEYPAD_NUM8;
else if (KEYPAD_C3)
result = KEYPAD_NUM9;
else if (KEYPAD_C4)
result = KEYPAD_DIV;

////////////////////////  ROW2 ////////////////////////
KEYPAD_R1 = 0; KEYPAD_R2 = 1;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row2 for Keypad
delay();
if (KEYPAD_C1)
result = KEYPAD_NUM4;
else if (KEYPAD_C2)
result = KEYPAD_NUM5;
else if (KEYPAD_C3)
result = KEYPAD_NUM6;
else if (KEYPAD_C4)
result = KEYPAD_MUL;

////////////////////////  ROW3 ////////////////////////
KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 1;  KEYPAD_R4 = 0; //set Row3 for Keypad
delay();
if (KEYPAD_C1)
result = KEYPAD_NUM1;
else if (KEYPAD_C2)
result = KEYPAD_NUM2;
else if (KEYPAD_C3)
result = KEYPAD_NUM3;
else if (KEYPAD_C4)
result = KEYPAD_MNS;

////////////////////////  ROW4 ////////////////////////
KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 1; //set Row4 for Keypad
delay();
if (KEYPAD_C1)
result = KEYPAD_ON;
else if (KEYPAD_C2)
result = KEYPAD_NUM0;
else if (KEYPAD_C3)
result = KEYPAD_EQU;
else if (KEYPAD_C4)
result = KEYPAD_PLS;

return result;
} 

char sec=0,minute=50,hour=04,tenth=0;
char day=11,month=07,year=77;
char control_menu=0, left_menu=0;

//flash char display[2]={0x3f,0x2d};

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
interrupt [EXT_INT0] void ext_int0_isr(void)
{

}

interrupt [TIM0_COMP] void timer0_comp_isr(void)
//{{
{
//  tenth++;
//  if(tenth ==10){
//   PORTD ^= (1<<0);
//  }
}


interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{

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
if(hour==24)
{
hour=0;
day++;
}
if(day == 30)
{
month++;
day=1;
}
if(month == 12){
year++;
month=1;
}
if ( year == 99)
{
year = 0;
}
}

void main(void)
{
int minute0=0,minute1=0;
int hour0=0,hour1=0;
int sec1=0,sec0=0;
int day0=0,day1=0;
int month0=0,month1=0;
int year0=0,year1=0;
unsigned char key_res; 
//DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
//
//PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
//
//DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
//PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
//
//     
//DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
//PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
//
//DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
//PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
DDRC=0xFF;
DDRD=0x0F;
PORTC=0xFF;
PORTB=0xFF;
DDRA=0xFF;
DDRB=0xFF;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 31.250 kHz
// Mode: CTC top=OCR1A
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: On
// Compare B Match Interrupt: Off
TCCR1A = 0x00;
TCCR1B = 0x0C;
TCNT1H = 0x00;
TCNT1L = 0x00;
ICR1H = 0x00;
ICR1L = 0x00;
OCR1AH = 0x7A;
OCR1AL = 0x12;
OCR1BH = 0x00;
OCR1BL = 0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK = 0x10;


// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0.977 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
// Timer Period: 0.26214 s
TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0=0x60;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);



#asm("sei")

while (1)
{
sec0=sec%10;
sec1=sec/10;
minute0=minute%10;
minute1=minute/10; 
hour0=hour %10;
hour1=hour /10;
day0=day %10;
day1=day /10;
month0=month %10;
month1=month /10;
year0=year %10;
year1=year /10;
        
            
PORTB = 0b11111110;
PORTA = 0b11101111;
PORTC = convert_to_hex(hour1);
delay();
        
PORTB = 0b11111101;
PORTA = 0b11101111;
PORTC = convert_to_hex(hour0); 
delay();  
                     
                
PORTB = 0b11111011;
PORTA = 0b11101111;
PORTC = convert_to_hex(minute1);
delay(); 
            
                 
PORTB = 0b11110111;
PORTA = 0b11101111;
PORTC = convert_to_hex(minute0) ;
delay();
            
                
PORTB = 0b11101111;
PORTA = 0b11101111;
PORTC = convert_to_hex(day1);
delay();
                                                                       
PORTB = 0b11011111;
PORTC = convert_to_hex(day0) ; 
delay();
        
PORTA = 0b11111110;
PORTB = 0b11111111;
PORTC = convert_to_hex(month1);
delay();

PORTA = 0b01111101;
PORTB = 0b11111111;
PORTC = convert_to_hex(month0);
delay();

PORTA = 0b11111011;
PORTB = 0b11111111;
PORTC = convert_to_hex(year1);
delay();


PORTA = 0b11110111;
PORTB = 0b11111111;
PORTC = convert_to_hex(year0);
delay();

key_res = keypad_scan();
if(key_res != 255)
{ 
while(keypad_scan() != 255);
delay();
delay();
delay();
delay();
if (key_res == KEYPAD_NUM1)
{
left_menu++;
if (left_menu == 2) 
{
left_menu = 0;
}  
}
else if (key_res == KEYPAD_NUM2)
{
if (left_menu == 1) 
{
if (control_menu == 1) 
{
if (hour1 == 0 && hour0 > 4) 
{
hour = 0;
}
else if (hour1 == 1 | hour0 == 2)
{ 
hour = ((hour1 - 1) * 10) + hour0;
}
else {
 hour = 20 + hour0;
  }
}
            
            
else if (control_menu == 2)
{
if ( hour1 == 0 && hour0 == 0)
 {
 hour = (hour1 * 10) + 9;
 }
else if ( hour1 == 2 && hour0 == 0 )
{ 
hour = 23;
}
else
{ 
hour = hour - 1;
}   
}
            
            
else if (control_menu == 3)
{
if ( minute1 == 0)
{
 minute = 50 + minute0;
 }
else if (1 <= minute1 <= 5)
{
 minute = ((minute1 - 1) * 10) + minute0;
}
else {}
}
            
            
            
else if (control_menu == 4)
{
if ( minute0 == 0)
{
 minute = ((minute1) * 10) + 9;
}
else 
{
minute = minute - 1;
}
}
            
            
else if (control_menu == 5)
{
if ( day1 == 0)
{
 day = 30;
 }
else if ( 1 <= day0 <= 3 )
{
 day = ((day1 - 1) * 10) + day0;
}
else {
}
}
            
            
else if (control_menu == 6)
{
if ( day0 == 0)
{
 day = (day1 * 10) + 9;
}
else if ( day1 == 0 && day0 == 1)
{
 day = 9;
}
else
{
 day = day - 1;
 }
} 
            
            
            
else if (control_menu == 7)
{
if ( month0 > 2)
{
 month = 12;
 }
else if ( month1 == 1 && 1 <= month0 <= 2)
{
 month = (((month1) - 1) * 10) + month0;
}
else if ( month1 == 0 && 1 <= month0 <= 2)
{
 month =  10 + month0;
}
else {} 
}
            
            
            
else if (control_menu == 8)
{
if ( month0 == 0)
{
 month = (month1 * 10) + 2;
}
else if ( month1 == 0 && month0 == 1) 
{
month = 9;
}
else
{
 month = month - 1;
}
}
            
            
else if (control_menu == 9)
{
if ( 1 <= year1 <=9)
{
 year = ((year1 - 1) * 10) + year0;
}
else if ( year1 == 0)
{
 year = 90 + year0;
}
else {}
}
            
            
            
else if (control_menu == 10)
{
if ( year0 == 0 )
{
 year = (year1 * 10) + 9;
}
else 
{
year = year - 1; 
}
}  
             
}
else {}
} 
else if (key_res == KEYPAD_NUM3)
{
if (left_menu == 1) 
{
if (control_menu == 1) 
{
if (hour1 == 1 && hour0 > 4)
{
 hour = 23;
}
else if ( hour1 == 2)
{
 hour = hour0;
}
else {
 hour = (hour1 + 1) * 10 + hour0;
  }
}
else if (control_menu == 2)
{
if ( hour1 == 2 && hour0 == 3)
{
 hour = 20;
}
else if ( (hour1 == 0 || hour0 == 1 ) && hour0 == 9 )
{
 hour = (hour1 * 10);
}
else 
{
hour = hour + 1;   
}
}
else if (control_menu == 3)
{
if ( minute1 == 5)
{
 minute =  minute0;
}
else if (0 <= minute1 <= 4 )
{
 minute = ((minute1 + 1) * 10) + minute0;
}
else {
}
}
else if (control_menu == 4)
{
if ( minute0 == 9)
{
 minute = (minute1 * 10);
}
else 
{
minute = minute + 1;
}
}
else if (control_menu == 5)
{
if ( day1 == 3 )
{
 day = 1;
}
else if ( day1 == 2 && day0 > 0 )
{
 day = 30;
}
else { 
day = ((day1 + 1) * 10) + day0;
 }
}
else if (control_menu == 6)
{
if ( day0 == 9 && day1 == 0)
{
 day = 1;
}
else if ( day1 == 3)
{
 day = 30;
}
else if ( day1 == 1 && day0 == 9)
{
 day = (((day1) + 1) * 10) + 9;
}
else day = day + 1;
}
else if (control_menu == 7)
{
if ( month0 > 2)
{
 month = 12;
}
else if ( month1 == 1 && 1 <= month0 <= 2)
{
 month =  month0;
}
else if ( month1 == 0 && 1 <= month0 <= 2)
{
 month =  10 + month0;
}
else {
} 
}
else if (control_menu == 8)
{
if ( month == 12 )
{
 month = 10;
}
else if ( month1 == 0 && month0 == 9)
{
 month = 1;
}
else 
{
month = month + 1;
}
}
else if (control_menu == 9)
{
if ( 0 <= year1 <= 8)
{
 year = (((year1) + 1) * 10) + year0;
}
else if ( year1 == 9)
{
 year =  year0;
}
else {
}
}
else if (control_menu == 10)
{
if ( year0 == 9 )
{
 year = ((year1) * 10);
}
else
{
 year = year + 1; 
}
}  
             
}
else {
}
}
else if (key_res == KEYPAD_NUM4)
{
if (left_menu == 1) 
{
if( control_menu == 10 ){ 
control_menu = 0;
}
control_menu ++;
            
}
else 
{
}  
}
         
}
}
}