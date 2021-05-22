[bits 32]		; by the team we reach here it will be in 32-bit protected mode
[extern main]	; define the external symbol (main here) to look for

call main		; make a call to main, thus landing in the correct 
				; place in kernel

jmp $