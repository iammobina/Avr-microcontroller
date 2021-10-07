
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 1.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _sec=R5
	.DEF _minute=R4
	.DEF _hour=R7
	.DEF _tenth=R6
	.DEF _day=R9
	.DEF _month=R8
	.DEF _year=R11
	.DEF _control_menu=R10
	.DEF _left_menu=R13

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x32,0x0,0x0,0x4
	.DB  0x7,0xB,0x0,0x4D
	.DB  0x0,0x0

_0x55:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;
;
;//-------in ghesmat bargerefte az code mohandes mashhoun baraye az rizpar mibashad---------
;#define KEYPAD_R1 PORTD.0
;#define KEYPAD_R2 PORTD.1
;#define KEYPAD_R3 PORTD.2
;#define KEYPAD_R4 PORTD.3
;#define KEYPAD_C1 PIND.4
;#define KEYPAD_C2 PIND.5
;#define KEYPAD_C3 PIND.6
;#define KEYPAD_C4 PIND.7
;
;#define KEYPAD_NUM0 0
;#define KEYPAD_NUM1 1
;#define KEYPAD_NUM2 2
;#define KEYPAD_NUM3 3
;#define KEYPAD_NUM4 4
;#define KEYPAD_NUM5 5
;#define KEYPAD_NUM6 6
;#define KEYPAD_NUM7 7
;#define KEYPAD_NUM8 8
;#define KEYPAD_NUM9 9
;#define KEYPAD_DIV  10
;#define KEYPAD_MUL  11
;#define KEYPAD_PLS  12
;#define KEYPAD_MNS  13
;#define KEYPAD_EQU  14
;#define KEYPAD_ON   15
;
;void delay()
; 0000 0022 {

	.CSEG
_delay:
; .FSTART _delay
; 0000 0023     TCCR0 = (1 << CS02) | (1 << CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0024     TCNT0 = 231;
	LDI  R30,LOW(231)
	OUT  0x32,R30
; 0000 0025     while ((TIFR & (1 << TOV0)) == 0);
_0x3:
	IN   R30,0x38
	SBRS R30,0
	RJMP _0x3
; 0000 0026     TIFR = (1 << TOV0);
	LDI  R30,LOW(1)
	OUT  0x38,R30
; 0000 0027 }
	RET
; .FEND
;
;unsigned char keypad_scan()
; 0000 002A {
_keypad_scan:
; .FSTART _keypad_scan
; 0000 002B unsigned char result=255;
; 0000 002C ////////////////////////  ROW1 ////////////////////////
; 0000 002D KEYPAD_R1 = 1; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row1 for Keypad
	ST   -Y,R17
;	result -> R17
	LDI  R17,255
	SBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
; 0000 002E delay();
	RCALL _delay
; 0000 002F if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0xE
; 0000 0030 result = KEYPAD_NUM7;
	LDI  R17,LOW(7)
; 0000 0031 else if (KEYPAD_C2)
	RJMP _0xF
_0xE:
	SBIS 0x10,5
	RJMP _0x10
; 0000 0032 result = KEYPAD_NUM8;
	LDI  R17,LOW(8)
; 0000 0033 else if (KEYPAD_C3)
	RJMP _0x11
_0x10:
	SBIS 0x10,6
	RJMP _0x12
; 0000 0034 result = KEYPAD_NUM9;
	LDI  R17,LOW(9)
; 0000 0035 else if (KEYPAD_C4)
	RJMP _0x13
_0x12:
	SBIC 0x10,7
; 0000 0036 result = KEYPAD_DIV;
	LDI  R17,LOW(10)
; 0000 0037 
; 0000 0038 ////////////////////////  ROW2 ////////////////////////
; 0000 0039 KEYPAD_R1 = 0; KEYPAD_R2 = 1;  KEYPAD_R3 = 0;  KEYPAD_R4 = 0; //set Row2 for Keypad
_0x13:
_0x11:
_0xF:
	CBI  0x12,0
	SBI  0x12,1
	CBI  0x12,2
	CBI  0x12,3
; 0000 003A delay();
	RCALL _delay
; 0000 003B if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x1D
; 0000 003C result = KEYPAD_NUM4;
	LDI  R17,LOW(4)
; 0000 003D else if (KEYPAD_C2)
	RJMP _0x1E
_0x1D:
	SBIS 0x10,5
	RJMP _0x1F
; 0000 003E result = KEYPAD_NUM5;
	LDI  R17,LOW(5)
; 0000 003F else if (KEYPAD_C3)
	RJMP _0x20
_0x1F:
	SBIS 0x10,6
	RJMP _0x21
; 0000 0040 result = KEYPAD_NUM6;
	LDI  R17,LOW(6)
; 0000 0041 else if (KEYPAD_C4)
	RJMP _0x22
_0x21:
	SBIC 0x10,7
; 0000 0042 result = KEYPAD_MUL;
	LDI  R17,LOW(11)
; 0000 0043 
; 0000 0044 ////////////////////////  ROW3 ////////////////////////
; 0000 0045 KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 1;  KEYPAD_R4 = 0; //set Row3 for Keypad
_0x22:
_0x20:
_0x1E:
	CBI  0x12,0
	CBI  0x12,1
	SBI  0x12,2
	CBI  0x12,3
; 0000 0046 delay();
	RCALL _delay
; 0000 0047 if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x2C
; 0000 0048 result = KEYPAD_NUM1;
	LDI  R17,LOW(1)
; 0000 0049 else if (KEYPAD_C2)
	RJMP _0x2D
_0x2C:
	SBIS 0x10,5
	RJMP _0x2E
; 0000 004A result = KEYPAD_NUM2;
	LDI  R17,LOW(2)
; 0000 004B else if (KEYPAD_C3)
	RJMP _0x2F
_0x2E:
	SBIS 0x10,6
	RJMP _0x30
; 0000 004C result = KEYPAD_NUM3;
	LDI  R17,LOW(3)
; 0000 004D else if (KEYPAD_C4)
	RJMP _0x31
_0x30:
	SBIC 0x10,7
; 0000 004E result = KEYPAD_MNS;
	LDI  R17,LOW(13)
; 0000 004F 
; 0000 0050 ////////////////////////  ROW4 ////////////////////////
; 0000 0051 KEYPAD_R1 = 0; KEYPAD_R2 = 0;  KEYPAD_R3 = 0;  KEYPAD_R4 = 1; //set Row4 for Keypad
_0x31:
_0x2F:
_0x2D:
	CBI  0x12,0
	CBI  0x12,1
	CBI  0x12,2
	SBI  0x12,3
; 0000 0052 delay();
	RCALL _delay
; 0000 0053 if (KEYPAD_C1)
	SBIS 0x10,4
	RJMP _0x3B
; 0000 0054 result = KEYPAD_ON;
	LDI  R17,LOW(15)
; 0000 0055 else if (KEYPAD_C2)
	RJMP _0x3C
_0x3B:
	SBIS 0x10,5
	RJMP _0x3D
; 0000 0056 result = KEYPAD_NUM0;
	LDI  R17,LOW(0)
; 0000 0057 else if (KEYPAD_C3)
	RJMP _0x3E
_0x3D:
	SBIS 0x10,6
	RJMP _0x3F
; 0000 0058 result = KEYPAD_EQU;
	LDI  R17,LOW(14)
; 0000 0059 else if (KEYPAD_C4)
	RJMP _0x40
_0x3F:
	SBIC 0x10,7
; 0000 005A result = KEYPAD_PLS;
	LDI  R17,LOW(12)
; 0000 005B 
; 0000 005C return result;
_0x40:
_0x3E:
_0x3C:
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 005D }
; .FEND
;
;char sec=0,minute=50,hour=04,tenth=0;
;char day=11,month=07,year=77;
;char control_menu=0, left_menu=0;
;
;//flash char display[2]={0x3f,0x2d};
;
;int convert_to_hex(int n)
; 0000 0066 {
_convert_to_hex:
; .FSTART _convert_to_hex
; 0000 0067     switch(n){
	ST   -Y,R27
	ST   -Y,R26
;	n -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 0068         case 0:
	SBIW R30,0
	BRNE _0x45
; 0000 0069             return 0X3F;
	LDI  R30,LOW(63)
	LDI  R31,HIGH(63)
	RJMP _0x2000001
; 0000 006A         case 1:
_0x45:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x46
; 0000 006B             return 0X06;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RJMP _0x2000001
; 0000 006C         case 2:
_0x46:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x47
; 0000 006D             return 0X5B;
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RJMP _0x2000001
; 0000 006E         case 3:
_0x47:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x48
; 0000 006F             return 0X4F;
	LDI  R30,LOW(79)
	LDI  R31,HIGH(79)
	RJMP _0x2000001
; 0000 0070         case 4:
_0x48:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x49
; 0000 0071             return 0X66;
	LDI  R30,LOW(102)
	LDI  R31,HIGH(102)
	RJMP _0x2000001
; 0000 0072         case 5:
_0x49:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x4A
; 0000 0073             return 0X6D;
	LDI  R30,LOW(109)
	LDI  R31,HIGH(109)
	RJMP _0x2000001
; 0000 0074         case 6:
_0x4A:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x4B
; 0000 0075             return 0X7D;
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP _0x2000001
; 0000 0076         case 7:
_0x4B:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x4C
; 0000 0077             return 0X07;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x2000001
; 0000 0078         case 8:
_0x4C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x4D
; 0000 0079             return 0X7F;
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	RJMP _0x2000001
; 0000 007A         case 9:
_0x4D:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x44
; 0000 007B             return 0X6F;
	LDI  R30,LOW(111)
	LDI  R31,HIGH(111)
; 0000 007C     }
_0x44:
; 0000 007D }
_0x2000001:
	ADIW R28,2
	RET
; .FEND
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 007F {
_ext_int0_isr:
; .FSTART _ext_int0_isr
; 0000 0080 
; 0000 0081 }
	RETI
; .FEND
;
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 0084 //{{
; 0000 0085 {
_timer0_comp_isr:
; .FSTART _timer0_comp_isr
; 0000 0086 //  tenth++;
; 0000 0087 //  if(tenth ==10){
; 0000 0088 //   PORTD ^= (1<<0);
; 0000 0089 //  }
; 0000 008A }
	RETI
; .FEND
;
;
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 008E {
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 008F 
; 0000 0090 sec++;
	INC  R5
; 0000 0091 if(sec ==60)
	LDI  R30,LOW(60)
	CP   R30,R5
	BRNE _0x4F
; 0000 0092 {
; 0000 0093 minute++;
	INC  R4
; 0000 0094 sec=0;
	CLR  R5
; 0000 0095 }
; 0000 0096 if(minute ==60){
_0x4F:
	LDI  R30,LOW(60)
	CP   R30,R4
	BRNE _0x50
; 0000 0097 hour++;
	INC  R7
; 0000 0098 minute=0;
	CLR  R4
; 0000 0099 }
; 0000 009A if(hour==24)
_0x50:
	LDI  R30,LOW(24)
	CP   R30,R7
	BRNE _0x51
; 0000 009B {
; 0000 009C hour=0;
	CLR  R7
; 0000 009D day++;
	INC  R9
; 0000 009E }
; 0000 009F if(day == 30)
_0x51:
	LDI  R30,LOW(30)
	CP   R30,R9
	BRNE _0x52
; 0000 00A0 {
; 0000 00A1 month++;
	INC  R8
; 0000 00A2 day=1;
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 00A3 }
; 0000 00A4 if(month == 12){
_0x52:
	LDI  R30,LOW(12)
	CP   R30,R8
	BRNE _0x53
; 0000 00A5 year++;
	INC  R11
; 0000 00A6 month=1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 00A7 }
; 0000 00A8 if ( year == 99)
_0x53:
	LDI  R30,LOW(99)
	CP   R30,R11
	BRNE _0x54
; 0000 00A9 {
; 0000 00AA year = 0;
	CLR  R11
; 0000 00AB }
; 0000 00AC }
_0x54:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 00AF {
_main:
; .FSTART _main
; 0000 00B0 int minute0=0,minute1=0;
; 0000 00B1 int hour0=0,hour1=0;
; 0000 00B2 int sec1=0,sec0=0;
; 0000 00B3 int day0=0,day1=0;
; 0000 00B4 int month0=0,month1=0;
; 0000 00B5 int year0=0,year1=0;
; 0000 00B6 unsigned char key_res;
; 0000 00B7 //DDRA=(1<<DDA7) | (1<<DDA6) | (1<<DDA5) | (1<<DDA4) | (1<<DDA3) | (1<<DDA2) | (1<<DDA1) | (1<<DDA0);
; 0000 00B8 //
; 0000 00B9 //PORTA=(0<<PORTA7) | (0<<PORTA6) | (0<<PORTA5) | (0<<PORTA4) | (0<<PORTA3) | (0<<PORTA2) | (0<<PORTA1) | (0<<PORTA0);
; 0000 00BA //
; 0000 00BB //DDRB=(1<<DDB7) | (1<<DDB6) | (1<<DDB5) | (1<<DDB4) | (1<<DDB3) | (1<<DDB2) | (1<<DDB1) | (1<<DDB0);
; 0000 00BC //PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);
; 0000 00BD //
; 0000 00BE //
; 0000 00BF //DDRC=(1<<DDC7) | (1<<DDC6) | (1<<DDC5) | (1<<DDC4) | (1<<DDC3) | (1<<DDC2) | (1<<DDC1) | (1<<DDC0);
; 0000 00C0 //PORTC=(1<<PORTC7) | (1<<PORTC6) | (1<<PORTC5) | (1<<PORTC4) | (1<<PORTC3) | (1<<PORTC2) | (1<<PORTC1) | (1<<PORTC0);
; 0000 00C1 //
; 0000 00C2 //DDRD=(0<<DDD7) | (0<<DDD6) | (0<<DDD5) | (0<<DDD4) | (1<<DDD3) | (1<<DDD2) | (1<<DDD1) | (1<<DDD0);
; 0000 00C3 //PORTD=(1<<PORTD7) | (1<<PORTD6) | (1<<PORTD5) | (1<<PORTD4) | (1<<PORTD3) | (1<<PORTD2) | (1<<PORTD1) | (1<<PORTD0);
; 0000 00C4 DDRC=0xFF;
	SBIW R28,19
	LDI  R24,18
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	LDI  R30,LOW(_0x55*2)
	LDI  R31,HIGH(_0x55*2)
	CALL __INITLOCB
;	minute0 -> R16,R17
;	minute1 -> R18,R19
;	hour0 -> R20,R21
;	hour1 -> Y+17
;	sec1 -> Y+15
;	sec0 -> Y+13
;	day0 -> Y+11
;	day1 -> Y+9
;	month0 -> Y+7
;	month1 -> Y+5
;	year0 -> Y+3
;	year1 -> Y+1
;	key_res -> Y+0
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 00C5 DDRD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 00C6 PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00C7 PORTB=0xFF;
	OUT  0x18,R30
; 0000 00C8 DDRA=0xFF;
	OUT  0x1A,R30
; 0000 00C9 DDRB=0xFF;
	OUT  0x17,R30
; 0000 00CA 
; 0000 00CB // Timer/Counter 1 initialization
; 0000 00CC // Clock source: System Clock
; 0000 00CD // Clock value: 31.250 kHz
; 0000 00CE // Mode: CTC top=OCR1A
; 0000 00CF // OC1A output: Discon.
; 0000 00D0 // OC1B output: Discon.
; 0000 00D1 // Noise Canceler: Off
; 0000 00D2 // Input Capture on Falling Edge
; 0000 00D3 // Timer1 Overflow Interrupt: Off
; 0000 00D4 // Input Capture Interrupt: Off
; 0000 00D5 // Compare A Match Interrupt: On
; 0000 00D6 // Compare B Match Interrupt: Off
; 0000 00D7 TCCR1A = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00D8 TCCR1B = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 00D9 TCNT1H = 0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 00DA TCNT1L = 0x00;
	OUT  0x2C,R30
; 0000 00DB ICR1H = 0x00;
	OUT  0x27,R30
; 0000 00DC ICR1L = 0x00;
	OUT  0x26,R30
; 0000 00DD OCR1AH = 0x7A;
	LDI  R30,LOW(122)
	OUT  0x2B,R30
; 0000 00DE OCR1AL = 0x12;
	LDI  R30,LOW(18)
	OUT  0x2A,R30
; 0000 00DF OCR1BH = 0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 00E0 OCR1BL = 0x00;
	OUT  0x28,R30
; 0000 00E1 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00E2 TIMSK = 0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 00E3 
; 0000 00E4 
; 0000 00E5 // Timer/Counter 0 initialization
; 0000 00E6 // Clock source: System Clock
; 0000 00E7 // Clock value: 0.977 kHz
; 0000 00E8 // Mode: Normal top=0xFF
; 0000 00E9 // OC0 output: Disconnected
; 0000 00EA // Timer Period: 0.26214 s
; 0000 00EB TCCR0=(0<<WGM00) | (0<<COM01) | (0<<COM00) | (0<<WGM01) | (1<<CS02) | (0<<CS01) | (1<<CS00);
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00EC TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 00ED OCR0=0x60;
	LDI  R30,LOW(96)
	OUT  0x3C,R30
; 0000 00EE 
; 0000 00EF // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00F0 TIMSK=(0<<OCIE2) | (0<<TOIE2) | (0<<TICIE1) | (0<<OCIE1A) | (0<<OCIE1B) | (0<<TOIE1) | (1<<OCIE0) | (0<<TOIE0);
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 00F1 
; 0000 00F2 
; 0000 00F3 
; 0000 00F4 #asm("sei")
	sei
; 0000 00F5 
; 0000 00F6 while (1)
_0x56:
; 0000 00F7       {
; 0000 00F8     sec0=sec%10;
	MOV  R26,R5
	RCALL SUBOPT_0x0
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 00F9     sec1=sec/10;
	MOV  R26,R5
	RCALL SUBOPT_0x1
	STD  Y+15,R30
	STD  Y+15+1,R31
; 0000 00FA     minute0=minute%10;
	MOV  R26,R4
	RCALL SUBOPT_0x0
	MOVW R16,R30
; 0000 00FB     minute1=minute/10;
	MOV  R26,R4
	RCALL SUBOPT_0x1
	MOVW R18,R30
; 0000 00FC     hour0=hour %10;
	MOV  R26,R7
	RCALL SUBOPT_0x0
	MOVW R20,R30
; 0000 00FD     hour1=hour /10;
	MOV  R26,R7
	RCALL SUBOPT_0x1
	STD  Y+17,R30
	STD  Y+17+1,R31
; 0000 00FE     day0=day %10;
	MOV  R26,R9
	RCALL SUBOPT_0x0
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 00FF     day1=day /10;
	MOV  R26,R9
	RCALL SUBOPT_0x1
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 0100     month0=month %10;
	MOV  R26,R8
	RCALL SUBOPT_0x0
	STD  Y+7,R30
	STD  Y+7+1,R31
; 0000 0101     month1=month /10;
	MOV  R26,R8
	RCALL SUBOPT_0x1
	STD  Y+5,R30
	STD  Y+5+1,R31
; 0000 0102     year0=year %10;
	MOV  R26,R11
	RCALL SUBOPT_0x0
	STD  Y+3,R30
	STD  Y+3+1,R31
; 0000 0103     year1=year /10;
	MOV  R26,R11
	RCALL SUBOPT_0x1
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 0104 
; 0000 0105 
; 0000 0106         PORTB = 0b11111110;
	LDI  R30,LOW(254)
	OUT  0x18,R30
; 0000 0107         PORTA = 0b11101111;
	LDI  R30,LOW(239)
	OUT  0x1B,R30
; 0000 0108     PORTC = convert_to_hex(hour1);
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	RCALL SUBOPT_0x2
; 0000 0109     delay();
; 0000 010A 
; 0000 010B         PORTB = 0b11111101;
	LDI  R30,LOW(253)
	OUT  0x18,R30
; 0000 010C         PORTA = 0b11101111;
	LDI  R30,LOW(239)
	OUT  0x1B,R30
; 0000 010D     PORTC = convert_to_hex(hour0);
	MOVW R26,R20
	RCALL SUBOPT_0x2
; 0000 010E     delay();
; 0000 010F 
; 0000 0110 
; 0000 0111         PORTB = 0b11111011;
	LDI  R30,LOW(251)
	OUT  0x18,R30
; 0000 0112         PORTA = 0b11101111;
	LDI  R30,LOW(239)
	OUT  0x1B,R30
; 0000 0113     PORTC = convert_to_hex(minute1);
	MOVW R26,R18
	RCALL SUBOPT_0x2
; 0000 0114     delay();
; 0000 0115 
; 0000 0116 
; 0000 0117         PORTB = 0b11110111;
	LDI  R30,LOW(247)
	OUT  0x18,R30
; 0000 0118         PORTA = 0b11101111;
	LDI  R30,LOW(239)
	OUT  0x1B,R30
; 0000 0119     PORTC = convert_to_hex(minute0) ;
	MOVW R26,R16
	RCALL SUBOPT_0x2
; 0000 011A     delay();
; 0000 011B 
; 0000 011C 
; 0000 011D         PORTB = 0b11101111;
	LDI  R30,LOW(239)
	OUT  0x18,R30
; 0000 011E         PORTA = 0b11101111;
	OUT  0x1B,R30
; 0000 011F     PORTC = convert_to_hex(day1);
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	RCALL SUBOPT_0x2
; 0000 0120     delay();
; 0000 0121 
; 0000 0122         PORTB = 0b11011111;
	LDI  R30,LOW(223)
	OUT  0x18,R30
; 0000 0123     PORTC = convert_to_hex(day0) ;
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	RCALL SUBOPT_0x2
; 0000 0124     delay();
; 0000 0125 
; 0000 0126         PORTA = 0b11111110;
	LDI  R30,LOW(254)
	OUT  0x1B,R30
; 0000 0127         PORTB = 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0128     PORTC = convert_to_hex(month1);
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	RCALL SUBOPT_0x2
; 0000 0129     delay();
; 0000 012A 
; 0000 012B         PORTA = 0b01111101;
	LDI  R30,LOW(125)
	OUT  0x1B,R30
; 0000 012C         PORTB = 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 012D     PORTC = convert_to_hex(month0);
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	RCALL SUBOPT_0x2
; 0000 012E     delay();
; 0000 012F 
; 0000 0130         PORTA = 0b11111011;
	LDI  R30,LOW(251)
	OUT  0x1B,R30
; 0000 0131         PORTB = 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0132     PORTC = convert_to_hex(year1);
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL SUBOPT_0x2
; 0000 0133     delay();
; 0000 0134 
; 0000 0135 
; 0000 0136         PORTA = 0b11110111;
	LDI  R30,LOW(247)
	OUT  0x1B,R30
; 0000 0137         PORTB = 0b11111111;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0138     PORTC = convert_to_hex(year0);
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL SUBOPT_0x2
; 0000 0139     delay();
; 0000 013A 
; 0000 013B       key_res = keypad_scan();
	RCALL _keypad_scan
	ST   Y,R30
; 0000 013C       if(key_res != 255)
	LD   R26,Y
	CPI  R26,LOW(0xFF)
	BRNE PC+2
	RJMP _0x59
; 0000 013D       {
; 0000 013E       while(keypad_scan() != 255);
_0x5A:
	RCALL _keypad_scan
	CPI  R30,LOW(0xFF)
	BRNE _0x5A
; 0000 013F       delay();
	RCALL _delay
; 0000 0140       delay();
	RCALL _delay
; 0000 0141       delay();
	RCALL _delay
; 0000 0142       delay();
	RCALL _delay
; 0000 0143       if (key_res == KEYPAD_NUM1)
	LD   R26,Y
	CPI  R26,LOW(0x1)
	BRNE _0x5D
; 0000 0144       {
; 0000 0145         left_menu++;
	INC  R13
; 0000 0146         if (left_menu == 2)
	LDI  R30,LOW(2)
	CP   R30,R13
	BRNE _0x5E
; 0000 0147         {
; 0000 0148             left_menu = 0;
	CLR  R13
; 0000 0149         }
; 0000 014A       }
_0x5E:
; 0000 014B       else if (key_res == KEYPAD_NUM2)
	RJMP _0x5F
_0x5D:
	LD   R26,Y
	CPI  R26,LOW(0x2)
	BREQ PC+2
	RJMP _0x60
; 0000 014C       {
; 0000 014D          if (left_menu == 1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BREQ PC+2
	RJMP _0x61
; 0000 014E          {
; 0000 014F             if (control_menu == 1)
	CP   R30,R10
	BRNE _0x62
; 0000 0150             {
; 0000 0151             if (hour1 == 0 && hour0 > 4)
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SBIW R26,0
	BRNE _0x64
	__CPWRN 20,21,5
	BRGE _0x65
_0x64:
	RJMP _0x63
_0x65:
; 0000 0152             {
; 0000 0153             hour = 0;
	CLR  R7
; 0000 0154             }
; 0000 0155             else if (hour1 == 1 | hour0 == 2)
	RJMP _0x66
_0x63:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL __EQW12
	MOV  R0,R30
	MOVW R26,R20
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __EQW12
	OR   R30,R0
	BREQ _0x67
; 0000 0156             {
; 0000 0157             hour = ((hour1 - 1) * 10) + hour0;
	LDD  R30,Y+17
	RCALL SUBOPT_0x3
	ADD  R30,R20
	RJMP _0x103
; 0000 0158             }
; 0000 0159             else {
_0x67:
; 0000 015A              hour = 20 + hour0;
	MOV  R30,R20
	SUBI R30,-LOW(20)
_0x103:
	MOV  R7,R30
; 0000 015B               }
_0x66:
; 0000 015C             }
; 0000 015D 
; 0000 015E 
; 0000 015F             else if (control_menu == 2)
	RJMP _0x69
_0x62:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0x6A
; 0000 0160             {
; 0000 0161             if ( hour1 == 0 && hour0 == 0)
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SBIW R26,0
	BRNE _0x6C
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BREQ _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
; 0000 0162              {
; 0000 0163              hour = (hour1 * 10) + 9;
	LDD  R30,Y+17
	RCALL SUBOPT_0x4
	MOV  R7,R30
; 0000 0164              }
; 0000 0165             else if ( hour1 == 2 && hour0 == 0 )
	RJMP _0x6E
_0x6B:
	LDD  R26,Y+17
	LDD  R27,Y+17+1
	SBIW R26,2
	BRNE _0x70
	CLR  R0
	CP   R0,R20
	CPC  R0,R21
	BREQ _0x71
_0x70:
	RJMP _0x6F
_0x71:
; 0000 0166             {
; 0000 0167             hour = 23;
	LDI  R30,LOW(23)
	MOV  R7,R30
; 0000 0168             }
; 0000 0169             else
	RJMP _0x72
_0x6F:
; 0000 016A             {
; 0000 016B             hour = hour - 1;
	DEC  R7
; 0000 016C             }
_0x72:
_0x6E:
; 0000 016D             }
; 0000 016E 
; 0000 016F 
; 0000 0170             else if (control_menu == 3)
	RJMP _0x73
_0x6A:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0x74
; 0000 0171             {
; 0000 0172             if ( minute1 == 0)
	MOV  R0,R18
	OR   R0,R19
	BRNE _0x75
; 0000 0173             {
; 0000 0174              minute = 50 + minute0;
	MOV  R30,R16
	SUBI R30,-LOW(50)
	MOV  R4,R30
; 0000 0175              }
; 0000 0176             else if (1 <= minute1 <= 5)
	RJMP _0x76
_0x75:
	MOVW R30,R18
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x6)
	BRSH _0x77
; 0000 0177             {
; 0000 0178              minute = ((minute1 - 1) * 10) + minute0;
	MOV  R30,R18
	RCALL SUBOPT_0x3
	ADD  R30,R16
	MOV  R4,R30
; 0000 0179             }
; 0000 017A             else {}
_0x77:
_0x76:
; 0000 017B             }
; 0000 017C 
; 0000 017D 
; 0000 017E 
; 0000 017F             else if (control_menu == 4)
	RJMP _0x79
_0x74:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0x7A
; 0000 0180             {
; 0000 0181             if ( minute0 == 0)
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x7B
; 0000 0182             {
; 0000 0183              minute = ((minute1) * 10) + 9;
	LDI  R26,LOW(10)
	MULS R18,R26
	MOVW R30,R0
	SUBI R30,-LOW(9)
	MOV  R4,R30
; 0000 0184             }
; 0000 0185             else
	RJMP _0x7C
_0x7B:
; 0000 0186             {
; 0000 0187             minute = minute - 1;
	DEC  R4
; 0000 0188             }
_0x7C:
; 0000 0189             }
; 0000 018A 
; 0000 018B 
; 0000 018C             else if (control_menu == 5)
	RJMP _0x7D
_0x7A:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0x7E
; 0000 018D             {
; 0000 018E             if ( day1 == 0)
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	SBIW R30,0
	BRNE _0x7F
; 0000 018F             {
; 0000 0190              day = 30;
	LDI  R30,LOW(30)
	MOV  R9,R30
; 0000 0191              }
; 0000 0192             else if ( 1 <= day0 <= 3 )
	RJMP _0x80
_0x7F:
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x4)
	BRSH _0x81
; 0000 0193             {
; 0000 0194              day = ((day1 - 1) * 10) + day0;
	LDD  R30,Y+9
	RCALL SUBOPT_0x3
	LDD  R26,Y+11
	ADD  R30,R26
	MOV  R9,R30
; 0000 0195             }
; 0000 0196             else {
_0x81:
; 0000 0197             }
_0x80:
; 0000 0198             }
; 0000 0199 
; 0000 019A 
; 0000 019B             else if (control_menu == 6)
	RJMP _0x83
_0x7E:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0x84
; 0000 019C             {
; 0000 019D             if ( day0 == 0)
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	SBIW R30,0
	BRNE _0x85
; 0000 019E             {
; 0000 019F              day = (day1 * 10) + 9;
	LDD  R30,Y+9
	RCALL SUBOPT_0x4
	MOV  R9,R30
; 0000 01A0             }
; 0000 01A1             else if ( day1 == 0 && day0 == 1)
	RJMP _0x86
_0x85:
	LDD  R26,Y+9
	LDD  R27,Y+9+1
	SBIW R26,0
	BRNE _0x88
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	SBIW R26,1
	BREQ _0x89
_0x88:
	RJMP _0x87
_0x89:
; 0000 01A2             {
; 0000 01A3              day = 9;
	LDI  R30,LOW(9)
	MOV  R9,R30
; 0000 01A4             }
; 0000 01A5             else
	RJMP _0x8A
_0x87:
; 0000 01A6             {
; 0000 01A7              day = day - 1;
	DEC  R9
; 0000 01A8              }
_0x8A:
_0x86:
; 0000 01A9             }
; 0000 01AA 
; 0000 01AB 
; 0000 01AC 
; 0000 01AD             else if (control_menu == 7)
	RJMP _0x8B
_0x84:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0x8C
; 0000 01AE             {
; 0000 01AF             if ( month0 > 2)
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SBIW R26,3
	BRLT _0x8D
; 0000 01B0             {
; 0000 01B1              month = 12;
	LDI  R30,LOW(12)
	MOV  R8,R30
; 0000 01B2              }
; 0000 01B3             else if ( month1 == 1 && 1 <= month0 <= 2)
	RJMP _0x8E
_0x8D:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,1
	BRNE _0x90
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x3)
	BRLO _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 01B4             {
; 0000 01B5              month = (((month1) - 1) * 10) + month0;
	LDD  R30,Y+5
	RCALL SUBOPT_0x3
	LDD  R26,Y+7
	ADD  R30,R26
	MOV  R8,R30
; 0000 01B6             }
; 0000 01B7             else if ( month1 == 0 && 1 <= month0 <= 2)
	RJMP _0x92
_0x8F:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BRNE _0x94
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x3)
	BRLO _0x95
_0x94:
	RJMP _0x93
_0x95:
; 0000 01B8             {
; 0000 01B9              month =  10 + month0;
	LDD  R30,Y+7
	SUBI R30,-LOW(10)
	MOV  R8,R30
; 0000 01BA             }
; 0000 01BB             else {}
_0x93:
_0x92:
_0x8E:
; 0000 01BC             }
; 0000 01BD 
; 0000 01BE 
; 0000 01BF 
; 0000 01C0             else if (control_menu == 8)
	RJMP _0x97
_0x8C:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x98
; 0000 01C1             {
; 0000 01C2             if ( month0 == 0)
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	SBIW R30,0
	BRNE _0x99
; 0000 01C3             {
; 0000 01C4              month = (month1 * 10) + 2;
	LDD  R30,Y+5
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(2)
	MOV  R8,R30
; 0000 01C5             }
; 0000 01C6             else if ( month1 == 0 && month0 == 1)
	RJMP _0x9A
_0x99:
	LDD  R26,Y+5
	LDD  R27,Y+5+1
	SBIW R26,0
	BRNE _0x9C
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	SBIW R26,1
	BREQ _0x9D
_0x9C:
	RJMP _0x9B
_0x9D:
; 0000 01C7             {
; 0000 01C8             month = 9;
	LDI  R30,LOW(9)
	MOV  R8,R30
; 0000 01C9             }
; 0000 01CA             else
	RJMP _0x9E
_0x9B:
; 0000 01CB             {
; 0000 01CC              month = month - 1;
	DEC  R8
; 0000 01CD             }
_0x9E:
_0x9A:
; 0000 01CE             }
; 0000 01CF 
; 0000 01D0 
; 0000 01D1             else if (control_menu == 9)
	RJMP _0x9F
_0x98:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0xA0
; 0000 01D2             {
; 0000 01D3             if ( 1 <= year1 <=9)
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0xA)
	BRSH _0xA1
; 0000 01D4             {
; 0000 01D5              year = ((year1 - 1) * 10) + year0;
	LDD  R30,Y+1
	RCALL SUBOPT_0x3
	LDD  R26,Y+3
	ADD  R30,R26
	MOV  R11,R30
; 0000 01D6             }
; 0000 01D7             else if ( year1 == 0)
	RJMP _0xA2
_0xA1:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	SBIW R30,0
	BRNE _0xA3
; 0000 01D8             {
; 0000 01D9              year = 90 + year0;
	LDD  R30,Y+3
	SUBI R30,-LOW(90)
	MOV  R11,R30
; 0000 01DA             }
; 0000 01DB             else {}
_0xA3:
_0xA2:
; 0000 01DC             }
; 0000 01DD 
; 0000 01DE 
; 0000 01DF 
; 0000 01E0             else if (control_menu == 10)
	RJMP _0xA5
_0xA0:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0xA6
; 0000 01E1             {
; 0000 01E2             if ( year0 == 0 )
	LDD  R30,Y+3
	LDD  R31,Y+3+1
	SBIW R30,0
	BRNE _0xA7
; 0000 01E3             {
; 0000 01E4              year = (year1 * 10) + 9;
	LDD  R30,Y+1
	RCALL SUBOPT_0x4
	MOV  R11,R30
; 0000 01E5             }
; 0000 01E6             else
	RJMP _0xA8
_0xA7:
; 0000 01E7             {
; 0000 01E8             year = year - 1;
	DEC  R11
; 0000 01E9             }
_0xA8:
; 0000 01EA             }
; 0000 01EB 
; 0000 01EC         }
_0xA6:
_0xA5:
_0x9F:
_0x97:
_0x8B:
_0x83:
_0x7D:
_0x79:
_0x73:
_0x69:
; 0000 01ED         else {}
_0x61:
; 0000 01EE       }
; 0000 01EF       else if (key_res == KEYPAD_NUM3)
	RJMP _0xAA
_0x60:
	LD   R26,Y
	CPI  R26,LOW(0x3)
	BREQ PC+2
	RJMP _0xAB
; 0000 01F0       {
; 0000 01F1          if (left_menu == 1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BREQ PC+2
	RJMP _0xAC
; 0000 01F2          {
; 0000 01F3             if (control_menu == 1)
	CP   R30,R10
	BRNE _0xAD
; 0000 01F4             {
; 0000 01F5             if (hour / 10 == 1 && hour % 10 > 4) hour = 23;
	MOV  R26,R7
	RCALL SUBOPT_0x1
	SBIW R30,1
	BRNE _0xAF
	MOV  R26,R7
	RCALL SUBOPT_0x0
	SBIW R30,5
	BRGE _0xB0
_0xAF:
	RJMP _0xAE
_0xB0:
	LDI  R30,LOW(23)
	RJMP _0x104
; 0000 01F6             else if ( hour / 10 == 2) hour = hour % 10;
_0xAE:
	MOV  R26,R7
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB2
	MOV  R26,R7
	RCALL SUBOPT_0x0
	RJMP _0x104
; 0000 01F7             else { hour = ((hour / 10) + 1) * 10 + hour % 10; }
_0xB2:
	MOV  R26,R7
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	MOV  R26,R7
	RCALL SUBOPT_0x0
	ADD  R30,R22
_0x104:
	MOV  R7,R30
; 0000 01F8             }
; 0000 01F9             else if (control_menu == 2)
	RJMP _0xB4
_0xAD:
	LDI  R30,LOW(2)
	CP   R30,R10
	BRNE _0xB5
; 0000 01FA             {
; 0000 01FB             if ( hour / 10 == 2 && hour % 10 == 3) hour = 20;
	MOV  R26,R7
	RCALL SUBOPT_0x1
	SBIW R30,2
	BRNE _0xB7
	MOV  R26,R7
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ _0xB8
_0xB7:
	RJMP _0xB6
_0xB8:
	LDI  R30,LOW(20)
	MOV  R7,R30
; 0000 01FC             else if ( (hour / 10 == 0 || hour / 10 == 1 ) && hour % 10 == 9 ) hour = ((hour / 10) * 10);
	RJMP _0xB9
_0xB6:
	MOV  R26,R7
	RCALL SUBOPT_0x1
	SBIW R30,0
	BREQ _0xBB
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xBD
_0xBB:
	MOV  R26,R7
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ _0xBE
_0xBD:
	RJMP _0xBA
_0xBE:
	MOV  R26,R7
	RCALL SUBOPT_0x1
	LDI  R26,LOW(10)
	MULS R30,R26
	MOV  R7,R0
; 0000 01FD             else hour = hour + 1;
	RJMP _0xBF
_0xBA:
	INC  R7
; 0000 01FE             }
_0xBF:
_0xB9:
; 0000 01FF             else if (control_menu == 3)
	RJMP _0xC0
_0xB5:
	LDI  R30,LOW(3)
	CP   R30,R10
	BRNE _0xC1
; 0000 0200             {
; 0000 0201             if ( minute / 10 == 5) minute =  minute % 10;
	MOV  R26,R4
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xC2
	MOV  R26,R4
	RCALL SUBOPT_0x0
	MOV  R4,R30
; 0000 0202             else if (0 <= minute / 10 <= 4 ) minute = (((minute / 10) + 1) * 10) + minute % 10;
	RJMP _0xC3
_0xC2:
	MOV  R26,R4
	RCALL SUBOPT_0x1
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __LEW12
	CPI  R30,LOW(0x5)
	BRSH _0xC4
	MOV  R26,R4
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	MOV  R26,R4
	RCALL SUBOPT_0x0
	ADD  R30,R22
	MOV  R4,R30
; 0000 0203             else {}
_0xC4:
_0xC3:
; 0000 0204             }
; 0000 0205             else if (control_menu == 4)
	RJMP _0xC6
_0xC1:
	LDI  R30,LOW(4)
	CP   R30,R10
	BRNE _0xC7
; 0000 0206             {
; 0000 0207             if ( minute % 10 == 9) minute = ((minute / 10) * 10);
	MOV  R26,R4
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xC8
	MOV  R26,R4
	RCALL SUBOPT_0x1
	LDI  R26,LOW(10)
	MULS R30,R26
	MOV  R4,R0
; 0000 0208             else minute = minute + 1;
	RJMP _0xC9
_0xC8:
	INC  R4
; 0000 0209             }
_0xC9:
; 0000 020A             else if (control_menu == 5)
	RJMP _0xCA
_0xC7:
	LDI  R30,LOW(5)
	CP   R30,R10
	BRNE _0xCB
; 0000 020B             {
; 0000 020C             if ( day / 10 == 3 ) day = 1;
	MOV  R26,R9
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xCC
	LDI  R30,LOW(1)
	RJMP _0x105
; 0000 020D             else if ( day / 10 == 2 && day % 10 > 0 ) day = 30;
_0xCC:
	MOV  R26,R9
	RCALL SUBOPT_0x1
	SBIW R30,2
	BRNE _0xCF
	MOV  R26,R9
	RCALL SUBOPT_0x0
	CALL __CPW01
	BRLT _0xD0
_0xCF:
	RJMP _0xCE
_0xD0:
	LDI  R30,LOW(30)
	RJMP _0x105
; 0000 020E             else { day = (((day / 10) + 1) * 10) + day % 10; }
_0xCE:
	MOV  R26,R9
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	MOV  R26,R9
	RCALL SUBOPT_0x0
	ADD  R30,R22
_0x105:
	MOV  R9,R30
; 0000 020F             }
; 0000 0210             else if (control_menu == 6)
	RJMP _0xD2
_0xCB:
	LDI  R30,LOW(6)
	CP   R30,R10
	BRNE _0xD3
; 0000 0211             {
; 0000 0212             if ( day % 10 == 9 && day / 10 == 0) day = 1;
	MOV  R26,R9
	RCALL SUBOPT_0x0
	SBIW R30,9
	BRNE _0xD5
	MOV  R26,R9
	RCALL SUBOPT_0x1
	SBIW R30,0
	BREQ _0xD6
_0xD5:
	RJMP _0xD4
_0xD6:
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0213             else if ( day / 10 == 3) day = 30;
	RJMP _0xD7
_0xD4:
	MOV  R26,R9
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xD8
	LDI  R30,LOW(30)
	MOV  R9,R30
; 0000 0214             else if ( day / 10 == 1 && day % 10 == 9) day = (((day / 10) + 1) * 10) + 9;
	RJMP _0xD9
_0xD8:
	MOV  R26,R9
	RCALL SUBOPT_0x1
	SBIW R30,1
	BRNE _0xDB
	MOV  R26,R9
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ _0xDC
_0xDB:
	RJMP _0xDA
_0xDC:
	MOV  R26,R9
	RCALL SUBOPT_0x1
	SUBI R30,-LOW(1)
	RCALL SUBOPT_0x4
	MOV  R9,R30
; 0000 0215             else day = day + 1;
	RJMP _0xDD
_0xDA:
	INC  R9
; 0000 0216             }
_0xDD:
_0xD9:
_0xD7:
; 0000 0217             else if (control_menu == 7)
	RJMP _0xDE
_0xD3:
	LDI  R30,LOW(7)
	CP   R30,R10
	BRNE _0xDF
; 0000 0218             {
; 0000 0219             if ( month % 10 > 2) month = 12;
	MOV  R26,R8
	RCALL SUBOPT_0x0
	SBIW R30,3
	BRLT _0xE0
	LDI  R30,LOW(12)
	MOV  R8,R30
; 0000 021A             else if ( month / 10 == 1 && 1 <= month % 10 <= 2) month =  month % 10;
	RJMP _0xE1
_0xE0:
	MOV  R26,R8
	RCALL SUBOPT_0x1
	SBIW R30,1
	BRNE _0xE3
	MOV  R26,R8
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x3)
	BRLO _0xE4
_0xE3:
	RJMP _0xE2
_0xE4:
	MOV  R26,R8
	RCALL SUBOPT_0x0
	MOV  R8,R30
; 0000 021B             else if ( month / 10 == 0 && 1 <= month % 10 <= 2) month =  10 + month % 10;
	RJMP _0xE5
_0xE2:
	MOV  R26,R8
	RCALL SUBOPT_0x1
	SBIW R30,0
	BRNE _0xE7
	MOV  R26,R8
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x5
	CPI  R30,LOW(0x3)
	BRLO _0xE8
_0xE7:
	RJMP _0xE6
_0xE8:
	MOV  R26,R8
	RCALL SUBOPT_0x0
	SUBI R30,-LOW(10)
	MOV  R8,R30
; 0000 021C             else {}
_0xE6:
_0xE5:
_0xE1:
; 0000 021D             }
; 0000 021E             else if (control_menu == 8)
	RJMP _0xEA
_0xDF:
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0xEB
; 0000 021F             {
; 0000 0220             if ( month == 12 ) month = 10;
	LDI  R30,LOW(12)
	CP   R30,R8
	BRNE _0xEC
	LDI  R30,LOW(10)
	MOV  R8,R30
; 0000 0221             else if ( month / 10 == 0 && month % 10 == 9) month = 1;
	RJMP _0xED
_0xEC:
	MOV  R26,R8
	RCALL SUBOPT_0x1
	SBIW R30,0
	BRNE _0xEF
	MOV  R26,R8
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BREQ _0xF0
_0xEF:
	RJMP _0xEE
_0xF0:
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0222             else month = month + 1;
	RJMP _0xF1
_0xEE:
	INC  R8
; 0000 0223             }
_0xF1:
_0xED:
; 0000 0224             else if (control_menu == 9)
	RJMP _0xF2
_0xEB:
	LDI  R30,LOW(9)
	CP   R30,R10
	BRNE _0xF3
; 0000 0225             {
; 0000 0226             if ( 0 <= year / 10 <= 8) year = (((year / 10) + 1) * 10) + year % 10;
	MOV  R26,R11
	RCALL SUBOPT_0x1
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	CALL __LEW12
	CPI  R30,LOW(0x9)
	BRSH _0xF4
	MOV  R26,R11
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	MOV  R26,R11
	RCALL SUBOPT_0x0
	ADD  R30,R22
	MOV  R11,R30
; 0000 0227             else if ( year / 10 == 9) year =  year % 10;
	RJMP _0xF5
_0xF4:
	MOV  R26,R11
	RCALL SUBOPT_0x1
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xF6
	MOV  R26,R11
	RCALL SUBOPT_0x0
	MOV  R11,R30
; 0000 0228             else {}
_0xF6:
_0xF5:
; 0000 0229             }
; 0000 022A             else if (control_menu == 10)
	RJMP _0xF8
_0xF3:
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0xF9
; 0000 022B             {
; 0000 022C             if ( year % 10 == 9 ) year = ((year / 10) * 10);
	MOV  R26,R11
	RCALL SUBOPT_0x0
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0xFA
	MOV  R26,R11
	RCALL SUBOPT_0x1
	LDI  R26,LOW(10)
	MULS R30,R26
	MOV  R11,R0
; 0000 022D             else year = year + 1;
	RJMP _0xFB
_0xFA:
	INC  R11
; 0000 022E             }
_0xFB:
; 0000 022F 
; 0000 0230         }
_0xF9:
_0xF8:
_0xF2:
_0xEA:
_0xDE:
_0xD2:
_0xCA:
_0xC6:
_0xC0:
_0xB4:
; 0000 0231         else {}
_0xAC:
; 0000 0232       }
; 0000 0233       else if (key_res == KEYPAD_NUM4)
	RJMP _0xFD
_0xAB:
	LD   R26,Y
	CPI  R26,LOW(0x4)
	BRNE _0xFE
; 0000 0234       {
; 0000 0235         if (left_menu == 1)
	LDI  R30,LOW(1)
	CP   R30,R13
	BRNE _0xFF
; 0000 0236         {
; 0000 0237         if( control_menu == 10 ) control_menu = 0;
	LDI  R30,LOW(10)
	CP   R30,R10
	BRNE _0x100
	CLR  R10
; 0000 0238         control_menu ++;
_0x100:
	INC  R10
; 0000 0239 
; 0000 023A         }
; 0000 023B         else
_0xFF:
; 0000 023C         {
; 0000 023D         }
; 0000 023E       }
; 0000 023F 
; 0000 0240       }
_0xFE:
_0xFD:
_0xAA:
_0x5F:
; 0000 0241       }
_0x59:
	RJMP _0x56
; 0000 0242 }
_0x102:
	RJMP _0x102
; .FEND

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x0:
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:84 WORDS
SUBOPT_0x1:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x2:
	RCALL _convert_to_hex
	OUT  0x15,R30
	RJMP _delay

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	SUBI R30,LOW(1)
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(9)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(1)
	LDI  R27,HIGH(1)
	CALL __LEW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	SUBI R30,-LOW(1)
	LDI  R26,LOW(10)
	MULS R30,R26
	MOV  R22,R0
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__EQW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BREQ __EQW12T
	CLR  R30
__EQW12T:
	RET

__LEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRGE __LEW12T
	CLR  R30
__LEW12T:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__CPW01:
	CLR  R0
	CP   R0,R30
	CPC  R0,R31
	RET

__INITLOCB:
__INITLOCW:
	ADD  R26,R28
	ADC  R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
