; get the data to be printed in DX
; for e.g: DX=0x1234 will print 0x1234 HEX string

print_hex:
	pusha
	mov cx, 0		; our counter

; for ascii conversion add 0x30 for 0(0x30) - 9(0x39) chars
; for A - F add 0x40 for A (0x41) - to F (0x46)
hex_loop:
	cmp	cx, 4		; loop four times
	je end

	mov ax, dx    		; mov dx to ax
	and ax, 0x000f		; get the last byte alone
						; by masking other bytes using zero
						; during and
	add al, 0x30		; by default add 0x30 (takes care 
						; of 0-9 cases)

	cmp al, 0x39		; if > 0x39, it is A to F
	jle rotate			; jump if less <= 0x39 (number
						; cases)
	add al, 7 			; for A adding 0x30 will give 58
						; but we need 65, so add 7 more


rotate:
	mov bx, HEX_OUT + 5 ; pointing bx to correct position
						; to accomodate for 4 chars, and
						; delimiter

	sub	bx, cx			; move based on our counter to correct
						; position

	mov [bx], al   		; copy the ascii converted character

	ror dx, 4			; rotate right to 4 bits

	; increment index and loop
	add cx, 1
	jmp hex_loop


end:
	mov bx, HEX_OUT
	call print_string

	popa 
	ret

HEX_OUT:
	db '0x0000', 0	; reserve memory for the string
					; representation