/*******************************************************
Project : 
Version : 
Date    : 18/07/2020
Author  : Alimohammad Movahedian
*******************************************************/

#include <mega32.h>
#include <alcd.h>
#include <delay.h>
#include <stdlib.h>
#include <stdio.h>


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

unsigned char keypad_scan();

void main(void)
{

int f_num = 0;            
int s_num = 0;           
int op = 0;           
int res = 0;         

char s[4];           

unsigned char key_res;  
DDRC=0xFF;
DDRD=0x0F;
PORTC=0x00;

lcd_init(16);
lcd_clear();
lcd_gotoxy(1,0);
lcd_puts("KEYPAD AND LCD");
lcd_gotoxy(5,1);
lcd_puts("PROJECT");
delay_ms(2000);
lcd_clear();

while (1)
      {
      key_res = keypad_scan();
      if(key_res != 255)
      { 
          while(keypad_scan() != 255);
          delay_ms(20);
          
          // OPERATION ENTERED
          if(key_res > 9)
          {      
            if (key_res == KEYPAD_DIV)
              lcd_putchar('%');
            else if (key_res == KEYPAD_MUL)
              lcd_putchar('*'); 
            else if (key_res == KEYPAD_MNS)
              lcd_putchar('-');
            else if (key_res == KEYPAD_PLS)
              lcd_putchar('+');
            else if (key_res == KEYPAD_EQU){
              lcd_putchar('='); 
              switch(op){
                case KEYPAD_DIV:
                    res = f_num / s_num;
                    break;
                case KEYPAD_MUL:
                    res = f_num * s_num;
                    break;
                case KEYPAD_PLS:
                    res = f_num + s_num;
                    break;
                case KEYPAD_MNS:
                    res = f_num - s_num;
                    break;
                default:
                    f_num = 0;
                    s_num = 0;  
                    op = 0;
                    res = 0;
                    lcd_clear();
                    lcd_gotoxy(0,0);
                    break;
              }
              if(op != 0){
                sprintf(s, "%d", res);
                lcd_puts(s); 
              } 
               
            } 
             else if (key_res == KEYPAD_ON)
            {         
              f_num = (int)0;
              s_num = (int)0;  
              op = (int)0;
              res = 0;
              lcd_clear();
              lcd_gotoxy(0,0);
            }
            if(key_res != KEYPAD_ON){
                op = key_res;
            } 
          }                        
          else
          {
              lcd_putchar(key_res + 48);
              if(op == 0){
                f_num *= 10;
                f_num += key_res;
              }
              else{
                s_num *= 10;
                s_num += key_res;  
              }
                
          }    
      }
      }
}


unsigned char keypad_scan()
{
unsigned char result=255;
////////////////////////  ROW1 ////////////////////////
KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row1 for Keypad
delay_ms(5);
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
delay_ms(5);
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
delay_ms(5);
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
delay_ms(5);
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