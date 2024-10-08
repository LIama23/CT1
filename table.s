; ------------------------------------------------------------------
; --  _____       ______  _____                                    -
; -- |_   _|     |  ____|/ ____|                                   -
; --   | |  _ __ | |__  | (___    Institute of Embedded Systems    -
; --   | | | '_ \|  __|  \___ \   Zurich University of             -
; --  _| |_| | | | |____ ____) |  Applied Sciences                 -
; -- |_____|_| |_|______|_____/   8401 Winterthur, Switzerland     -
; ------------------------------------------------------------------
; --
; -- table.s
; --
; -- CT1 P04 Ein- und Ausgabe von Tabellenwerten
; --
; -- $Id: table.s 800 2014-10-06 13:19:25Z ruan $
; ------------------------------------------------------------------
;Directives
        PRESERVE8
        THUMB
; ------------------------------------------------------------------
; -- Symbolic Literals
; ------------------------------------------------------------------
ADDR_DIP_SWITCH_7_0         EQU     0x60000200
ADDR_DIP_SWITCH_15_8        EQU     0x60000201
ADDR_DIP_SWITCH_31_24       EQU     0x60000203
ADDR_LED_7_0                EQU     0x60000100
ADDR_LED_15_8               EQU     0x60000101
ADDR_LED_23_16              EQU     0x60000102
ADDR_LED_31_24              EQU     0x60000103
ADDR_BUTTONS                EQU     0x60000210
	
ADDR_SEG7_BIN_DS1_DS0   	EQU      0x60000114				;selbst definiert
ADDR_SEG7_BIN_DS3_DS2		EQU      0x60000115				;selbst definiert

BITMASK_KEY_T0              EQU     0x01
BITMASK_LOWER_NIBBLE        EQU     0x0F

; ------------------------------------------------------------------
; -- Variables
; ------------------------------------------------------------------
        AREA MyAsmVar, DATA, READWRITE
; STUDENTS: To be programmed

byte_array	SPACE 16							;reserve 16 Byte. Wieso 16 byte bei 16 Halfword? Sollte es nicht 8 byte sein?
half_word_array SPACE 32						;doppelt so gross wie byte array?

; END: To be programmed
        ALIGN

; ------------------------------------------------------------------
; -- myCode
; ------------------------------------------------------------------
        AREA myCode, CODE, READONLY

main    PROC
        EXPORT main

readInput
        BL    waitForKey                    ; wait for key to be pressed and released
; STUDENTS: To be programmed

; Aufgabe 4.0

		LDR     R0, =ADDR_DIP_SWITCH_7_0        ;stores Adress of DIP_SWITCH_7_0 into RO 
        LDR     R1, [R0]						;stores VALUE of R0 in R1 
		
		LDR     R0, =ADDR_DIP_SWITCH_15_8       ;stores Adress of DIP_SWITCH_15_8 into RO 
        LDR     R2, [R0]						;stores INDEX of R0 in R1 
		
		LDR 	R7, =BITMASK_LOWER_NIBBLE		;stores BITMASK in R7		
		ANDS	R2, R2, R7
		LSLS 	R2, R2, #1						;Leftshift damit x2 gemacht wird. Weil Half-Word und nicht Byte zum speichern sind.

		LDR		R0, =half_word_array			;stores Adress of Variable byte_array in R0
		STRH	R1, [R0, R2]					;stores Value of R1 with offset of R2 in R0
												;Adress of half_word_array = 0x2000'0010

		LSRS	R2, R2, #1						;Rightshift damit AnzeigeValue in DS1,DSO wieder stimmt
		LDR		R0, =ADDR_SEG7_BIN_DS1_DS0
		STRH	R2, [R0,#0]
		LDR 	R0, =ADDR_SEG7_BIN_DS3_DS2
		STRH	R1, [R0, #0]



; END: To be programmed
        B       readInput
        ALIGN

; ------------------------------------------------------------------
; Subroutines
; ------------------------------------------------------------------

; wait for key to be pressed and released
waitForKey
        PUSH    {R0, R1, R2}
        LDR     R1, =ADDR_BUTTONS           ; laod base address of keys
        LDR     R2, =BITMASK_KEY_T0         ; load key mask T0

waitForPress
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is pressed
        BEQ     waitForPress

waitForRelease
        LDRB    R0, [R1]                    ; load key values
        TST     R0, R2                      ; check, if key T0 is released
        BNE     waitForRelease
                
        POP     {R0, R1, R2}
        BX      LR
        ALIGN

; ------------------------------------------------------------------
; End of code
; ------------------------------------------------------------------
        ENDP
        END
