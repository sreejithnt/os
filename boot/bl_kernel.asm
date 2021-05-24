; a boot loader that boots C Kernel in 32-bit protected mode
[org 0x7c00]

KERNEL_OFFSET equ 0x1000	; this is the address to which kernel
							; will be loaded

mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE		; print_string expects 0 delimited message in BX
call print_string

call load_kernel

call switch_to_pm

jmp $

%include 'print/print_string.asm'
%include 'print/print_hex.asm'
%include 'disk/disk_load.asm'
%include 'pm/print_string_pm.asm'
%include 'pm/gdt.asm'
%include 'pm/switch_to_pm.asm'

[bits 16]
load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string

	mov bx, KERNEL_OFFSET		; memory offset to where kernel is to be loaded
	mov dh, 15					; read 15 sectors
	mov dl, [BOOT_DRIVE]		; set the correct device
	call load_disk

	ret

[bits 32]
BEGIN_PM:
	mov bx, MSG_PROT_MODE
	call print_string_pm

	call KERNEL_OFFSET			; every call is a call to the corresponding
								; address

	jmp $


BOOT_DRIVE db 0
MSG_REAL_MODE db 'Started in 16-bit real mode', 0
MSG_LOAD_KERNEL db ' Loading Kernel to memory', 0
MSG_PROT_MODE db 'Successfully landed in 32-bit protected mode', 0

; Bootsector padding
times 510 -( $ - $$ ) db 0
dw 0xaa55
