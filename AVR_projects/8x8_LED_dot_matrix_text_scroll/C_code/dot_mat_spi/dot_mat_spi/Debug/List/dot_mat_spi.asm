
;CodeVisionAVR C Compiler V3.37 Evaluation
;(C) Copyright 1998-2019 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega32
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 512 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Mode 2
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

	.MACRO __POINTD2M
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
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
	.DEF _message_size=R4
	.DEF _message_size_msb=R5

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x16,0x0

_0x3:
	.DB  0x20,0x41,0x6D,0x69,0x74,0x20,0x4D,0x61
	.DB  0x7A,0x75,0x6D,0x64,0x65,0x72,0x20,0x53
	.DB  0x68,0x75,0x76,0x6F,0x20
_0x4:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x4F
	.DB  0x0,0x0,0x0,0x7,0x0,0x7,0x0,0x14
	.DB  0x7F,0x14,0x7F,0x14,0x24,0x2A,0x7F,0x2A
	.DB  0x12,0x23,0x13,0x8,0x64,0x62,0x36,0x49
	.DB  0x55,0x22,0x50,0x0,0x5,0x3,0x0,0x0
	.DB  0x0,0x1C,0x22,0x41,0x0,0x0,0x41,0x22
	.DB  0x1C,0x0,0x14,0x8,0x3E,0x8,0x14,0x8
	.DB  0x8,0x3E,0x8,0x8,0x0,0x50,0x30,0x0
	.DB  0x0,0x0,0x8,0x8,0x8,0x8,0x0,0x60
	.DB  0x60,0x0,0x0,0x20,0x10,0x8,0x4,0x2
	.DB  0x3E,0x51,0x49,0x45,0x3E,0x0,0x42,0x7F
	.DB  0x40,0x0,0x42,0x61,0x51,0x49,0x46,0x21
	.DB  0x41,0x45,0x4B,0x31,0x18,0x14,0x12,0x7F
	.DB  0x10,0x27,0x45,0x45,0x45,0x39,0x3C,0x4A
	.DB  0x49,0x49,0x30,0x3,0x71,0x9,0x5,0x3
	.DB  0x36,0x49,0x49,0x49,0x36,0x6,0x49,0x49
	.DB  0x29,0x1E,0x0,0x6C,0x6C,0x0,0x0,0x0
	.DB  0x56,0x36,0x0,0x0,0x8,0x14,0x22,0x41
	.DB  0x0,0x14,0x14,0x14,0x14,0x14,0x0,0x41
	.DB  0x22,0x14,0x8,0x2,0x1,0x51,0x9,0x6
	.DB  0x32,0x49,0x79,0x41,0x3E,0x7E,0x11,0x11
	.DB  0x11,0x7E,0x7F,0x49,0x49,0x49,0x3E,0x3E
	.DB  0x41,0x41,0x41,0x22,0x7F,0x41,0x41,0x41
	.DB  0x3E,0x7F,0x49,0x49,0x49,0x49,0x7F,0x9
	.DB  0x9,0x9,0x1,0x3E,0x41,0x49,0x49,0x3A
	.DB  0x7F,0x8,0x8,0x8,0x7F,0x41,0x41,0x7F
	.DB  0x41,0x41,0x30,0x41,0x41,0x3F,0x1,0x7F
	.DB  0x8,0x14,0x22,0x41,0x7F,0x40,0x40,0x40
	.DB  0x40,0x7F,0x2,0xC,0x2,0x7F,0x7F,0x4
	.DB  0x8,0x10,0x7F,0x3E,0x41,0x41,0x41,0x3E
	.DB  0x7F,0x9,0x9,0x9,0x6,0x3E,0x41,0x51
	.DB  0x21,0x5E,0x7F,0x9,0x9,0x19,0x66,0x46
	.DB  0x49,0x49,0x49,0x31,0x1,0x1,0x7F,0x1
	.DB  0x1,0x3F,0x40,0x40,0x40,0x3F,0xF,0x30
	.DB  0x40,0x30,0xF,0x3F,0x40,0x38,0x40,0x3F
	.DB  0x63,0x14,0x8,0x14,0x63,0x3,0x4,0x78
	.DB  0x4,0x3,0x61,0x51,0x49,0x45,0x43,0x7F
	.DB  0x41,0x41,0x0,0x0,0x2,0x4,0x8,0x10
	.DB  0x20,0x0,0x0,0x41,0x41,0x7F,0x4,0x2
	.DB  0x1,0x2,0x4,0x40,0x40,0x40,0x40,0x40
	.DB  0x0,0x1,0x2,0x4,0x0,0x20,0x54,0x54
	.DB  0x54,0x78,0x7F,0x48,0x44,0x44,0x38,0x38
	.DB  0x44,0x44,0x44,0x20,0x38,0x44,0x44,0x48
	.DB  0x7F,0x38,0x54,0x54,0x54,0x18,0x8,0x7E
	.DB  0x9,0x1,0x2,0xC,0x52,0x52,0x52,0x3E
	.DB  0x7F,0x8,0x4,0x4,0x78,0x0,0x44,0x7D
	.DB  0x40,0x0,0x20,0x40,0x44,0x3D,0x0,0x7F
	.DB  0x10,0x28,0x44,0x0,0x0,0x41,0x7F,0x40
	.DB  0x0,0x78,0x4,0x8,0x4,0x78,0x7C,0x8
	.DB  0x4,0x4,0x78,0x38,0x44,0x44,0x44,0x38
	.DB  0x7C,0x14,0x14,0x14,0x8,0x8,0x14,0x14
	.DB  0x7C,0x0,0x7C,0x8,0x4,0x4,0x8,0x48
	.DB  0x54,0x54,0x54,0x20,0x4,0x3F,0x44,0x40
	.DB  0x20,0x3C,0x40,0x40,0x20,0x7C,0x1C,0x20
	.DB  0x40,0x20,0x1C,0x3C,0x40,0x30,0x40,0x3C
	.DB  0x44,0x28,0x10,0x28,0x44,0xC,0x50,0x50
	.DB  0x50,0x3C,0x44,0x64,0x54,0x4C,0x44,0x0
	.DB  0x8,0x36,0x41,0x0,0x0,0x0,0x7F,0x0
	.DB  0x0,0x0,0x41,0x36,0x8,0x0,0x8,0x4
	.DB  0x4,0x8,0x4
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x15
	.DW  _message
	.DW  _0x3*2

	.DW  0x1DB
	.DW  _characters
	.DW  _0x4*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

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
	.ORG 0x00

	.DSEG
	.ORG 0x260

	.CSEG
;/*
; *
; * dot_mat_spi.c
; * Created: 10/14/2019 1:53:44 PM
; * Author: Amit Mazumder Shuvo
; * Version 1.0
; *
; */
;
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
;#include <stdio.h>
;#include <stdlib.h>
;
;#define SS PORTB4
;#define MOSI PORTB5
;#define MISO PORTB6
;#define SCK PORTB7
;#define DEVICE_NUM 2
;#define DELAY 50
;
;#define SLAVE_SEL PORTB &= ~(1<<SS) //Slave Select(Active Low)
;#define SLAVE_DESEL PORTB |= (1<<SS)//SLave Deselect(Active High)
;
;unsigned char buffer[DEVICE_NUM*8]; // buffer for text scrolling
;//const char message[] = " Institute of Information & Communication Technology, BUET, Dhaka-1211 "; // message to be dis ...
;const char message[] = " Amit Mazumder Shuvo "; // message to be displayed

	.DSEG
;//const char message[] = "Tahsin Mostafiz has nailed the professors of the USA."; // message to be displayed
;unsigned int message_size = sizeof(message); // size of message array
;
;const char characters[96][5] = {
;	{0b00000000,0b00000000,0b00000000,0b00000000,0b00000000}, // space
;	{0b00000000,0b00000000,0b01001111,0b00000000,0b00000000}, // !
;	{0b00000000,0b00000111,0b00000000,0b00000111,0b00000000}, // "
;	{0b00010100,0b01111111,0b00010100,0b01111111,0b00010100}, // #
;	{0b00100100,0b00101010,0b01111111,0b00101010,0b00010010}, // $
;	{0b00100011,0b00010011,0b00001000,0b01100100,0b01100010}, // %
;	{0b00110110,0b01001001,0b01010101,0b00100010,0b01010000}, // &
;	{0b00000000,0b00000101,0b00000011,0b00000000,0b00000000}, // '
;	{0b00000000,0b00011100,0b00100010,0b01000001,0b00000000}, // (
;	{0b00000000,0b01000001,0b00100010,0b00011100,0b00000000}, // )
;	{0b00010100,0b00001000,0b00111110,0b00001000,0b00010100}, // *
;	{0b00001000,0b00001000,0b00111110,0b00001000,0b00001000}, // +
;	{0b00000000,0b01010000,0b00110000,0b00000000,0b00000000}, // ,
;	{0b00000000,0b00001000,0b00001000,0b00001000,0b00001000}, // -
;	{0b00000000,0b01100000,0b01100000,0b00000000,0b00000000}, // .
;	{0b00100000,0b00010000,0b00001000,0b00000100,0b00000010}, // /
;	{0b00111110,0b01010001,0b01001001,0b01000101,0b00111110}, // 0
;	{0b00000000,0b01000010,0b01111111,0b01000000,0b00000000}, // 1
;	{0b01000010,0b01100001,0b01010001,0b01001001,0b01000110}, // 2
;	{0b00100001,0b01000001,0b01000101,0b01001011,0b00110001}, // 3
;	{0b00011000,0b00010100,0b00010010,0b01111111,0b00010000}, // 4
;	{0b00100111,0b01000101,0b01000101,0b01000101,0b00111001}, // 5
;	{0b00111100,0b01001010,0b01001001,0b01001001,0b00110000}, // 6
;	{0b00000011,0b01110001,0b00001001,0b00000101,0b00000011}, // 7
;	{0b00110110,0b01001001,0b01001001,0b01001001,0b00110110}, // 8
;	{0b00000110,0b01001001,0b01001001,0b00101001,0b00011110}, // 9
;	{0b00000000,0b01101100,0b01101100,0b00000000,0b00000000}, // :
;	{0b00000000,0b01010110,0b00110110,0b00000000,0b00000000}, // ;
;	{0b00001000,0b00010100,0b00100010,0b01000001,0b00000000}, // <
;	{0b00010100,0b00010100,0b00010100,0b00010100,0b00010100}, // =
;	{0b00000000,0b01000001,0b00100010,0b00010100,0b00001000}, // >
;	{0b00000010,0b00000001,0b01010001,0b00001001,0b00000110}, // ?
;	{0b00110010,0b01001001,0b01111001,0b01000001,0b00111110}, // @
;	{0b01111110,0b00010001,0b00010001,0b00010001,0b01111110}, // A
;	{0b01111111,0b01001001,0b01001001,0b01001001,0b00111110}, // B
;	{0b00111110,0b01000001,0b01000001,0b01000001,0b00100010}, // C
;	{0b01111111,0b01000001,0b01000001,0b01000001,0b00111110}, // D
;	{0b01111111,0b01001001,0b01001001,0b01001001,0b01001001}, // E
;	{0b01111111,0b00001001,0b00001001,0b00001001,0b00000001}, // F
;	{0b00111110,0b01000001,0b01001001,0b01001001,0b00111010}, // G
;	{0b01111111,0b00001000,0b00001000,0b00001000,0b01111111}, // H
;	{0b01000001,0b01000001,0b01111111,0b01000001,0b01000001}, // I
;	{0b00110000,0b01000001,0b01000001,0b00111111,0b00000001}, // J
;	{0b01111111,0b00001000,0b00010100,0b00100010,0b01000001}, // K
;	{0b01111111,0b01000000,0b01000000,0b01000000,0b01000000}, // L
;	{0b01111111,0b00000010,0b00001100,0b00000010,0b01111111}, // M
;	{0b01111111,0b00000100,0b00001000,0b00010000,0b01111111}, // N
;	{0b00111110,0b01000001,0b01000001,0b01000001,0b00111110}, // O
;	{0b01111111,0b00001001,0b00001001,0b00001001,0b00000110}, // P
;	{0b00111110,0b01000001,0b01010001,0b00100001,0b01011110}, // Q
;	{0b01111111,0b00001001,0b00001001,0b00011001,0b01100110}, // R
;	{0b01000110,0b01001001,0b01001001,0b01001001,0b00110001}, // S
;	{0b00000001,0b00000001,0b01111111,0b00000001,0b00000001}, // T
;	{0b00111111,0b01000000,0b01000000,0b01000000,0b00111111}, // U
;	{0b00001111,0b00110000,0b01000000,0b00110000,0b00001111}, // V
;	{0b00111111,0b01000000,0b00111000,0b01000000,0b00111111}, // W
;	{0b01100011,0b00010100,0b00001000,0b00010100,0b01100011}, // X
;	{0b00000011,0b00000100,0b01111000,0b00000100,0b00000011}, // Y
;	{0b01100001,0b01010001,0b01001001,0b01000101,0b01000011}, // Z
;	{0b01111111,0b01000001,0b01000001,0b00000000,0b00000000}, // [
;	{0b00000010,0b00000100,0b00001000,0b00010000,0b00100000}, // '\'
;	{0b00000000,0b00000000,0b01000001,0b01000001,0b01111111}, // ]
;	{0b00000100,0b00000010,0b00000001,0b00000010,0b00000100}, // ^
;	{0b01000000,0b01000000,0b01000000,0b01000000,0b01000000}, // _
;	{0b00000000,0b00000001,0b00000010,0b00000100,0b00000000}, // `
;	{0b00100000,0b01010100,0b01010100,0b01010100,0b01111000}, // a
;	{0b01111111,0b01001000,0b01000100,0b01000100,0b00111000}, // 0b
;	{0b00111000,0b01000100,0b01000100,0b01000100,0b00100000}, // c
;	{0b00111000,0b01000100,0b01000100,0b01001000,0b01111111}, // d
;	{0b00111000,0b01010100,0b01010100,0b01010100,0b00011000}, // e
;	{0b00001000,0b01111110,0b00001001,0b00000001,0b00000010}, // f
;	{0b00001100,0b01010010,0b01010010,0b01010010,0b00111110}, // g
;	{0b01111111,0b00001000,0b00000100,0b00000100,0b01111000}, // h
;	{0b00000000,0b01000100,0b01111101,0b01000000,0b00000000}, // i
;	{0b00100000,0b01000000,0b01000100,0b00111101,0b00000000}, // j
;	{0b01111111,0b00010000,0b00101000,0b01000100,0b00000000}, // k
;	{0b00000000,0b01000001,0b01111111,0b01000000,0b00000000}, // l
;	{0b01111000,0b00000100,0b00001000,0b00000100,0b01111000}, // m
;	{0b01111100,0b00001000,0b00000100,0b00000100,0b01111000}, // n
;	{0b00111000,0b01000100,0b01000100,0b01000100,0b00111000}, // o
;	{0b01111100,0b00010100,0b00010100,0b00010100,0b00001000}, // p
;	{0b00001000,0b00010100,0b00010100,0b01111100,0b00000000}, // q
;	{0b01111100,0b00001000,0b00000100,0b00000100,0b00001000}, // r
;	{0b01001000,0b01010100,0b01010100,0b01010100,0b00100000}, // s
;	{0b00000100,0b00111111,0b01000100,0b01000000,0b00100000}, // t
;	{0b00111100,0b01000000,0b01000000,0b00100000,0b01111100}, // u
;	{0b00011100,0b00100000,0b01000000,0b00100000,0b00011100}, // v
;	{0b00111100,0b01000000,0b00110000,0b01000000,0b00111100}, // w
;	{0b01000100,0b00101000,0b00010000,0b00101000,0b01000100}, // x
;	{0b00001100,0b01010000,0b01010000,0b01010000,0b00111100}, // y
;	{0b01000100,0b01100100,0b01010100,0b01001100,0b01000100}, // z
;	{0b00000000,0b00001000,0b00110110,0b01000001,0b00000000}, // {
;	{0b00000000,0b00000000,0b01111111,0b00000000,0b00000000}, // |
;	{0b00000000,0b01000001,0b00110110,0b00001000,0b00000000}, // }
;	{0b00001000,0b00000100,0b00000100,0b00001000,0b00000100} // ~
;};
;
;/**********************************EXTERNAL INTERRUPT INITIALIZATION FUNCTION**********************************/
;void init_interrupt(void)
; 0000 0083 {

	.CSEG
_init_interrupt:
; .FSTART _init_interrupt
; 0000 0084 	GICR |= (0<<INT1) | (1<<INT0) | (1<<INT2); //Enabling external interrupt0
	IN   R30,0x3B
	ORI  R30,LOW(0x60)
	OUT  0x3B,R30
; 0000 0085 	MCUCR |= (1<<ISC01) | (0<<ISC00); //falling edge triggered interrupt
	IN   R30,0x35
	ORI  R30,2
	OUT  0x35,R30
; 0000 0086 	#asm("sei"); //global interrupt enable
	SEI
; 0000 0087 }
	RET
; .FEND
;
;/**********************************SPI INITIALIZATION FUNCTION**********************************/
;void init_spi(void)
; 0000 008B {
_init_spi:
; .FSTART _init_spi
; 0000 008C 	DDRB |= (1<<MOSI) | (1<<SCK) | (1<<SS); //Set MOSI,SCK & SS pin as output
	IN   R30,0x17
	ORI  R30,LOW(0xB0)
	OUT  0x17,R30
; 0000 008D 	PORTB |= (1<<SS); // SS pin unselected
	SBI  0x18,4
; 0000 008E 	SPCR |= (1<< MSTR) | (1<< SPE) | (1<<SPR0); // Set AVR SPI as master, SPI enable & clock Focs/4
	IN   R30,0xD
	ORI  R30,LOW(0x51)
	OUT  0xD,R30
; 0000 008F }
	RET
; .FEND
;
;/*************************COMMAND & DATA TRANSFER FUNCTION**************************/
;void write_word (unsigned char cmd, unsigned char data)
; 0000 0093 {
_write_word:
; .FSTART _write_word
; 0000 0094 
; 0000 0095 	SPDR = cmd;
	ST   -Y,R17
	ST   -Y,R16
	MOV  R17,R26
	LDD  R16,Y+2
;	cmd -> R16
;	data -> R17
	OUT  0xF,R16
; 0000 0096 	while (!(SPSR & (1<< SPIF)));
_0x5:
	SBIS 0xE,7
	RJMP _0x5
; 0000 0097 
; 0000 0098 	SPDR = data;
	OUT  0xF,R17
; 0000 0099 	while (!(SPSR & (1<< SPIF)));
_0x8:
	SBIS 0xE,7
	RJMP _0x8
; 0000 009A 
; 0000 009B }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,3
	RET
; .FEND
;
;/*************************8x8 LED DOT MATRIX INITIALIZATION FUNCTION**************************/
;void init_matrix(void)
; 0000 009F {
_init_matrix:
; .FSTART _init_matrix
; 0000 00A0 	unsigned short int m;
; 0000 00A1 
; 0000 00A2 	SLAVE_SEL;
	RCALL SUBOPT_0x0
;	m -> R16,R17
; 0000 00A3 	for (m=0;m<DEVICE_NUM;m++)
_0xC:
	__CPWRN 16,17,2
	BRSH _0xD
; 0000 00A4 	{
; 0000 00A5 		write_word(0x0A, 0x0F); // set intensity for all devices
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R26,LOW(15)
	RCALL _write_word
; 0000 00A6 	}
	__ADDWRN 16,17,1
	RJMP _0xC
_0xD:
; 0000 00A7 	SLAVE_DESEL;
	RCALL SUBOPT_0x1
; 0000 00A8 	SLAVE_SEL;
; 0000 00A9 	for (m=0;m<DEVICE_NUM;m++)
_0xF:
	__CPWRN 16,17,2
	BRSH _0x10
; 0000 00AA 	{
; 0000 00AB 		write_word(0x09, 0x00); // set no decoding mode for all devices
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_word
; 0000 00AC 	}
	__ADDWRN 16,17,1
	RJMP _0xF
_0x10:
; 0000 00AD 	SLAVE_DESEL;
	RCALL SUBOPT_0x1
; 0000 00AE 	SLAVE_SEL;
; 0000 00AF 	for (m=0;m<DEVICE_NUM;m++)
_0x12:
	__CPWRN 16,17,2
	BRSH _0x13
; 0000 00B0 	{
; 0000 00B1 		write_word(0x0B, 0x07); // set scan limit (0-7) for 1-8 dots for all devices
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R26,LOW(7)
	RCALL _write_word
; 0000 00B2 	}
	__ADDWRN 16,17,1
	RJMP _0x12
_0x13:
; 0000 00B3 	SLAVE_DESEL;
	RCALL SUBOPT_0x1
; 0000 00B4 	SLAVE_SEL;
; 0000 00B5 	for (m=0;m<DEVICE_NUM;m++)
_0x15:
	__CPWRN 16,17,2
	BRSH _0x16
; 0000 00B6 	{
; 0000 00B7 		write_word(0x0C, 0x01); // turn display on for all devices
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _write_word
; 0000 00B8 	}
	__ADDWRN 16,17,1
	RJMP _0x15
_0x16:
; 0000 00B9 	SLAVE_DESEL;
	RCALL SUBOPT_0x1
; 0000 00BA 	SLAVE_SEL;
; 0000 00BB 	for (m=0;m<DEVICE_NUM;m++)
_0x18:
	__CPWRN 16,17,2
	BRSH _0x19
; 0000 00BC 	{
; 0000 00BD 		write_word(0x0F, 0x00); // disable display test for all devices
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_word
; 0000 00BE 	}
	__ADDWRN 16,17,1
	RJMP _0x18
_0x19:
; 0000 00BF 	SLAVE_DESEL;
	RJMP _0x20A0002
; 0000 00C0 }
; .FEND
;
;/*************************8x8 DOT MATRIX CLEAR FUNCTION**************************/
;void clear_matrix(void)
; 0000 00C4 {
_clear_matrix:
; .FSTART _clear_matrix
; 0000 00C5 	unsigned short int i,j;
; 0000 00C6 
; 0000 00C7 	for (i=0;i<8;i++)
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
	__GETWRN 16,17,0
_0x1B:
	__CPWRN 16,17,8
	BRSH _0x1C
; 0000 00C8 	{
; 0000 00C9 		SLAVE_SEL;
	CBI  0x18,4
; 0000 00CA 		for (j=0;j<DEVICE_NUM;j++)
	__GETWRN 18,19,0
_0x1E:
	__CPWRN 18,19,2
	BRSH _0x1F
; 0000 00CB 		{
; 0000 00CC 			write_word(i+1,0x00); //clear data for all devices
	MOV  R30,R16
	SUBI R30,-LOW(1)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_word
; 0000 00CD 		}
	__ADDWRN 18,19,1
	RJMP _0x1E
_0x1F:
; 0000 00CE 		SLAVE_DESEL;
	SBI  0x18,4
; 0000 00CF 	}
	__ADDWRN 16,17,1
	RJMP _0x1B
_0x1C:
; 0000 00D0 }
	RJMP _0x20A0003
; .FEND
;
;/*************************BUFFER INTIALIZATION FUNCTION**************************/
;void init_buffer(void)
; 0000 00D4 {
_init_buffer:
; .FSTART _init_buffer
; 0000 00D5 	unsigned short int i;
; 0000 00D6 	for (i=0;i<DEVICE_NUM*8;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x21:
	__CPWRN 16,17,16
	BRSH _0x22
; 0000 00D7 	{
; 0000 00D8 		buffer[i] = 0x00; //buffer initialization for all devices
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R16
	ADC  R27,R17
	LDI  R30,LOW(0)
	ST   X,R30
; 0000 00D9 	}
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 00DA }
	RJMP _0x20A0001
; .FEND
;
;/*************************8x8 LED DOT MATRIX COLUMN BUFFERING FUNCTION**************************/
;void push_buffer(unsigned char c)
; 0000 00DE {
_push_buffer:
; .FSTART _push_buffer
; 0000 00DF 	unsigned short int i;
; 0000 00E0 	for (i=0;i<DEVICE_NUM*8-1;i++)
	RCALL __SAVELOCR4
	MOV  R19,R26
;	c -> R19
;	i -> R16,R17
	__GETWRN 16,17,0
_0x24:
	__CPWRN 16,17,15
	BRSH _0x25
; 0000 00E1 	{
; 0000 00E2 		buffer[i] = buffer[i+1]; //shifting a column to the previous buffer element for all devices
	MOVW R26,R16
	SUBI R26,LOW(-_buffer)
	SBCI R27,HIGH(-_buffer)
	MOVW R30,R16
	__ADDW1MN _buffer,1
	LD   R30,Z
	ST   X,R30
; 0000 00E3 	}
	__ADDWRN 16,17,1
	RJMP _0x24
_0x25:
; 0000 00E4 	buffer[DEVICE_NUM*8-1] = c;	//pushing the current column to the last buffer element
	__PUTBMRN _buffer,15,19
; 0000 00E5 }
	RJMP _0x20A0003
; .FEND
;
;/*************************CURRENT BUFFER ELEMENT DISPLAY FUNCTION**************************/
;void disp_buffer(void)
; 0000 00E9 {
_disp_buffer:
; .FSTART _disp_buffer
; 0000 00EA 	unsigned short int i,j,k;
; 0000 00EB 	for (i=0;i<DEVICE_NUM;i++)
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
	__GETWRN 16,17,0
_0x27:
	__CPWRN 16,17,2
	BRSH _0x28
; 0000 00EC 	{
; 0000 00ED 		for (j=0;j<8;j++)
	__GETWRN 18,19,0
_0x2A:
	__CPWRN 18,19,8
	BRSH _0x2B
; 0000 00EE 		{
; 0000 00EF 			SLAVE_SEL;
	CBI  0x18,4
; 0000 00F0 			for (k=0;k<i;k++)
	__GETWRN 20,21,0
_0x2D:
	__CPWRR 20,21,16,17
	BRSH _0x2E
; 0000 00F1 			{
; 0000 00F2 				write_word(0x00,0x00); //sending null character prior to buffer display for character shifting from device to device
	RCALL SUBOPT_0x2
; 0000 00F3 			}
	__ADDWRN 20,21,1
	RJMP _0x2D
_0x2E:
; 0000 00F4 
; 0000 00F5 			write_word(j+1, buffer[j+i*8]); //sending buffer contents to all devices
	MOV  R30,R18
	SUBI R30,-LOW(1)
	ST   -Y,R30
	__MULBNWRU 16,17,8
	ADD  R30,R18
	ADC  R31,R19
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	LD   R26,Z
	RCALL _write_word
; 0000 00F6 
; 0000 00F7 			for (k=DEVICE_NUM-1;k>i;k--)
	__GETWRN 20,21,1
_0x30:
	__CPWRR 16,17,20,21
	BRSH _0x31
; 0000 00F8 			{
; 0000 00F9 				write_word(0x00,0x00); //sending null character after buffer display for character shifting from device to device
	RCALL SUBOPT_0x2
; 0000 00FA 			}
	__SUBWRN 20,21,1
	RJMP _0x30
_0x31:
; 0000 00FB 			SLAVE_DESEL;
	SBI  0x18,4
; 0000 00FC 		}
	__ADDWRN 18,19,1
	RJMP _0x2A
_0x2B:
; 0000 00FD 
; 0000 00FE 	}
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 00FF }
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
; .FEND
;
;/*************************8x8 LED DOT MATRIX CHARACTER PUSHING FUNCTION**************************/
;void push_char(unsigned int index)
; 0000 0103 {
_push_char:
; .FSTART _push_char
; 0000 0104 	unsigned short int i;
; 0000 0105 	for (i=0;i<5;i++)
	RCALL SUBOPT_0x3
;	index -> R18,R19
;	i -> R16,R17
_0x33:
	__CPWRN 16,17,5
	BRSH _0x34
; 0000 0106 	{
; 0000 0107 		push_buffer(characters[index][i]); //pushing all columns representing a particular character to the buffer
	__MULBNWRU 18,19,5
	SUBI R30,LOW(-_characters)
	SBCI R31,HIGH(-_characters)
	ADD  R30,R16
	ADC  R31,R17
	LD   R26,Z
	RCALL SUBOPT_0x4
; 0000 0108 		disp_buffer(); //displaying all columns representing a particular character
; 0000 0109 		delay_ms(DELAY);
; 0000 010A 	}
	__ADDWRN 16,17,1
	RJMP _0x33
_0x34:
; 0000 010B }
	RJMP _0x20A0003
; .FEND
;
;/*************************8x8 LED DOT MATRIX MESSAGE DISPLAYING FUNCTION**************************/
;void disp_message(unsigned int message_size)
; 0000 010F {
_disp_message:
; .FSTART _disp_message
; 0000 0110 	unsigned int i;
; 0000 0111 	for (i=0;i<message_size;i++)
	RCALL SUBOPT_0x3
;	message_size -> R18,R19
;	i -> R16,R17
_0x36:
	__CPWRR 16,17,18,19
	BRSH _0x37
; 0000 0112 	{
; 0000 0113 		push_char(message[i]-32); //pushing ascii_val-32 as the index to locate the exact position in the character array for  ...
	LDI  R26,LOW(_message)
	LDI  R27,HIGH(_message)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	LDI  R31,0
	SBIW R30,32
	MOVW R26,R30
	RCALL _push_char
; 0000 0114 		push_buffer(0x00); //pushing null character after each character
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x4
; 0000 0115 		disp_buffer(); //displaying null for each character
; 0000 0116 		delay_ms(DELAY);
; 0000 0117 	}
	__ADDWRN 16,17,1
	RJMP _0x36
_0x37:
; 0000 0118 }
_0x20A0003:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
; .FEND
;
;void disp_off(void)
; 0000 011B {
_disp_off:
; .FSTART _disp_off
; 0000 011C 		unsigned short int i;
; 0000 011D 
; 0000 011E 		SLAVE_SEL;
	RCALL SUBOPT_0x0
;	i -> R16,R17
; 0000 011F 		for (i=0;i<DEVICE_NUM;i++)
_0x39:
	__CPWRN 16,17,2
	BRSH _0x3A
; 0000 0120 		{
; 0000 0121 			write_word(0x0C, 0x00); // turn display off for all devices
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _write_word
; 0000 0122 		}
	__ADDWRN 16,17,1
	RJMP _0x39
_0x3A:
; 0000 0123 		SLAVE_DESEL;
_0x20A0002:
	SBI  0x18,4
; 0000 0124 }
_0x20A0001:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
;
;/*************************EXTERNAL INTERRUPT0 SUBROUTINE**************************/
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0128 {
_ext_int0_isr:
; .FSTART _ext_int0_isr
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0129 
; 0000 012A 	unsigned short int i;
; 0000 012B 
; 0000 012C 	init_spi();
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	RCALL _init_spi
; 0000 012D 	init_matrix();
	RCALL _init_matrix
; 0000 012E 	clear_matrix();
	RCALL _clear_matrix
; 0000 012F 	init_buffer();
	RCALL _init_buffer
; 0000 0130 
; 0000 0131 	for (i=0;i<3;i++)
	__GETWRN 16,17,0
_0x3C:
	__CPWRN 16,17,3
	BRSH _0x3D
; 0000 0132 	{
; 0000 0133 		disp_message(message_size); // displaying the massage 3 times
	MOVW R26,R4
	RCALL _disp_message
; 0000 0134 	}
	__ADDWRN 16,17,1
	RJMP _0x3C
_0x3D:
; 0000 0135 
; 0000 0136 	for (i=0;i<2;i++)
	__GETWRN 16,17,0
_0x3F:
	__CPWRN 16,17,2
	BRSH _0x40
; 0000 0137 	{
; 0000 0138 		push_buffer(0x00); // 2 final null character pushes for smoothening the scrolling completion
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x4
; 0000 0139 		disp_buffer();
; 0000 013A 		delay_ms(DELAY);
; 0000 013B 	}
	__ADDWRN 16,17,1
	RJMP _0x3F
_0x40:
; 0000 013C 
; 0000 013D 	disp_off();
	RCALL _disp_off
; 0000 013E }
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;void main(void)
; 0000 0141 {
_main:
; .FSTART _main
; 0000 0142 
; 0000 0143 	init_interrupt(); //interrupt initialization
	RCALL _init_interrupt
; 0000 0144     while(1)
_0x41:
; 0000 0145     {
; 0000 0146 		//disp_message(message_size); //displaying message for unlimited time
; 0000 0147     }
	RJMP _0x41
; 0000 0148 }
_0x44:
	RJMP _0x44
; .FEND
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_buffer:
	.BYTE 0x10
_message:
	.BYTE 0x16
_characters:
	.BYTE 0x1E0
__seed_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R17
	ST   -Y,R16
	CBI  0x18,4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	SBI  0x18,4
	CBI  0x18,4
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RJMP _write_word

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL __SAVELOCR4
	MOVW R18,R26
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	RCALL _push_buffer
	RCALL _disp_buffer
	LDI  R26,LOW(50)
	LDI  R27,0
	RJMP _delay_ms

;RUNTIME LIBRARY

	.CSEG
__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	wdr
	__DELAY_USW 0xFA0
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
