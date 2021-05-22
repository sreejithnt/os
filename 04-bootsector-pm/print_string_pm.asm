[bits 32]	; now we are in 32 bit protected mode
; define constants
VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f

; prints a null terminated string pointed to by EBX
print_string_pm:
	pusha
	mov edx, VIDEO_MEMORY

print_string_pm_loop:
	mov al, [ebx]			; move the first character to AL
	mov ah, WHITE_ON_BLACK	; move the properties to AH

	cmp al, 0				; check if this is last char
	je print_string_pm_done

	mov [edx], ax			; finally move entire AX to
							; video memory

	add ebx, 1				; increment to point to next char
	add edx, 2				; increment to next video address
							; to print the next char

	jmp print_string_pm_loop	; loop to prine next char


print_string_pm_done:
	popa
	ret
