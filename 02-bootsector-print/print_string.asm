print_string:
	pusha         ; save the stack

start:
	mov al, [bx]  ; move the base addess of the string to al
	cmp al, 0
	je stop

	mov ah, 0x0e  ; tele-type mode
	int 0x10      ; interrupt to print values in al

	add bx, 1	  ; increment bx to the next character
	jmp start


stop:
	popa		  ; re-store the stack
	ret 		  ; return to the calling function

print_nl:
	pusha

	mov ah, 0x0e  ; tele-type mode

	mov al, 0x0a ; new line character
	int 0x10

	mov al, 0x0d ; carriage return
	int 0x10

	popa
	ret

