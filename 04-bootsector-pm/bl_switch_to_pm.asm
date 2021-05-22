; A boot sector that starts in 16 bit and switch to 32 bit Protected Mode
[org 0x7c00]		; tell the assembler where this code
					; should be loaded to 

mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string

call switch_to_pm		; never return from here

jmp $

%include 'print_string.asm'
%include 'print_hex.asm'
%include 'disk_load.asm'
%include 'print_string_pm.asm'
%include 'gdt.asm'
%include 'switch_to_pm.asm'

; this is where we arrive after switching to PM
BEGIN_PM:
	mov ebx, MSG_PROT_MODE
	call print_string_pm
	jmp $

MSG_REAL_MODE db "Started in 16 bit real mode", 0
MSG_PROT_MODE db "Successfully landed in 32-bit protected mode", 0

;
; padding the magic number
;

times 510-($-$$) db 0
dw 0xaa55 ; last two bytes for magic number
		  ; so that BIOS knows we are a boot sector