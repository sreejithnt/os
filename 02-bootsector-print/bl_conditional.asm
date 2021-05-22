;
; A simple boot sector that prints message to the screen using bios routine
;



mov bx, 30
cmp bx, 4
jle print_a
cmp bx, 40
je print_b
mov al, 'C'
jmp the_end


print_a:
	mov al, 'A'
	jmp the_end

print_b:
	mov al, 'B'
	jmp the_end

the_end:


mov ah, 0x0e ; 0eh --> scrolling tele type mode
int 0x10


jmp $  ; jump to current address (infinite loop)

;
; padding the magic number
;

times 510-($-$$) db 0
dw 0xaa55 ; last two bytes for magic number
		  ; so that BIOS knows we are a boot sector


