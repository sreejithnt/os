;
; A simple boot sector that prints message to the screen using bios routine
;

mov ah, 0x0e ; 0eh --> scrolling tele type mode

mov al, 'S'
int 0x10 ; raising an interrupt to write char to screen
mov al, 'r'
int 0x10
mov al, 'e'
int 0x10
mov al, 'e'
int 0x10
mov al, 'j'
int 0x10
mov al, 'i'
int 0x10
mov al, 't'
int 0x10
mov al, 'h'
int 0x10
mov al, '''
int 0x10
mov al, 's'
int 0x10
mov al, ' '
int 0x10
mov al, 'O'
int 0x10
mov al, 'S'
int 0x10
mov al, '!'
int 0x10

jmp $  ; jump to current address (infinite loop)

;
; padding the magic number
;

times 510-($-$$) db 0
dw 0xaa55 ; last two bytes for magic number
		  ; so that BIOS knows we are a boot sector


