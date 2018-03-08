$NOMOD51
$include (c8051f020.inc)               ; Include register definition file.

Input       equ   P5
 

;-----------------------------------------------------------------------------
; RESET and INTERRUPT VECTORS
;-----------------------------------------------------------------------------

               ; Reset Vector
               cseg AT 0
               ljmp Main               ; Locate a jump to the start of code at 
                                       ; the reset vector.

;-----------------------------------------------------------------------------
; CODE SEGMENT
;-----------------------------------------------------------------------------


Blink          segment  CODE

               rseg     Blink          ; Switch to this code segment.
               using    0              ; Specify register bank for the following
                                       ; program code.

Main:          ; Disable the WDT. (IRQs not enabled at this point.)
               ; If interrupts were enabled, we would need to explicitly disable
               ; them so that the 2nd move to WDTCN occurs no more than four clock 
               ; cycles after the first move to WDTCN.

               mov   WDTCN, #0DEh
               mov   WDTCN, #0ADh

               ; Enable the Port I/O Crossbar
               mov   XBR2, #40h

               ; Set P1.6 (LED) as digital output in push-pull mode.  
               orl   P1MDIN, #40h	 
               orl   P1MDOUT,#40h 

               ; Initialize LED to OFF
               
MOV Input , #01h  //00000001

//start of loop    
LED:
CLR P1.6  //led off
MOV  A, Input  
jz press
sjmp LED

press:
SETB P1.6
CALL delay
CLR P1.6
CALL delay
sjmp LED
//end of loop

delay: MOV R5,#10
third: MOV R6,#200
second: MOV R7,#200
DJNZ R7,$
DJNZ R6,second
DJNZ R5,third
ret
end 


;-----------------------------------------------------------------------------
; End of file.

END



