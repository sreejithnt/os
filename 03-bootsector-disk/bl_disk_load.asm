;
; A simple boot sector that reads from disk
; using BIOS
;

[org 0x7c00]		; tell the assembler where this code
					; should be loaded to 



mov [BOOT_DRIVE], dl 	; BIOS stores boot drive in dl, 
						; so store it later for retrieval

mov dx, es				; trying to see what is in es
call print_hex
call print_nl

mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 5
mov dl, [BOOT_DRIVE]
call load_disk

mov dx, [0x9000]		; print out first loaded word
call print_hex

call print_nl

mov dx, [0x9000 + 512]
call print_hex

call print_nl


jmp $  ; jump to current address (infinite loop)

%include 'print_string.asm'
%include 'print_hex.asm'
%include 'disk_load.asm'

HELLO_MSG:
	db 'Hello, World', 0 	; 0 is the ending marker, helps the function identify when to stop printing

GOODBYE_MSG:
	db 'Good Bye', 0

BOOT_DRIVE: db 0


;
; padding the magic number
;

times 510-($-$$) db 0
dw 0xaa55 ; last two bytes for magic number
		  ; so that BIOS knows we are a boot sector

; we know that BIOS only loads the 512 bytes, 
; so this remaining section has to be loaded by disk_load
; function
times 256 dw 0xdada
times 256 dw 0xface
