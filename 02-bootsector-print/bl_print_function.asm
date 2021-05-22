;
; A simple boot sector that prints message to the screen using bios routine
;

[org 0x7c00]		; tell the assembler where this code should be loaded to 
mov ah, 0x0e

mov bx, HELLO_MSG
call print_string

call print_nl

mov bx, GOODBYE_MSG
call print_string

call print_nl

mov dx, 0x12AF
call print_hex


jmp $  ; jump to current address (infinite loop)

%include 'print_string.asm'
%include 'print_hex.asm'

HELLO_MSG:
	db 'Hello, World', 0 	; 0 is the ending marker, helps the function identify when to stop printing

GOODBYE_MSG:
	db 'Good Bye', 0


;
; padding the magic number
;

times 510-($-$$) db 0
dw 0xaa55 ; last two bytes for magic number
		  ; so that BIOS knows we are a boot sector


