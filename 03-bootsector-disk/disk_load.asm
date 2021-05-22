; load DH sectors from drive DL to ES:DX
load_disk:
	push dx			; dx contains how many sectors to read
					; store this in stack

	mov ah, 0x02	; BIOS read sector function

	;mov dl, 0		; read the drive 0 (i.e. first floppy drive)
	
	mov al, dh		; read DH sectors from the starting point
	mov ch, 0x00	; select cylinder 0
	mov dh, 0x00	; select head on first side of floppy
					; since count starts at 0

	mov cl, 0x02	; select the 2nd sector from track
					; this has a base on 1, starts at 1

	

	; lastly set the address to which we would like BIO
	; to read this sectors to, BIOS expects these address in
	; ES: BX (segment register ES with offset BX)

	;mov cx, 0xa000 ;not needed as will be passed as param
	;mov es, cx
	;mov bx, 0x1234

	; based on the above, data will be loaded to 
	; 0xa0000:0x1234 = 0xa1234

	int 0x13		; BIOS interrupt to perform the actual read

	; the success or failure of these reads are available
	; in flag registers, carry flag will be set in this case

	jc disk_error1	; jump only if the carry flag is set

	pop dx
	cmp dh, al 		; compare the read sectors in AL with
					; actual expecter sectors that DH

	jne	disk_error2 	; if they are not equal, show error
						; message
	ret

disk_error1:
	mov bx, DISK_READ_ERROR
	call print_string
	jmp $

disk_error2:
	mov bx, DISK_ERROR_MSG
	call print_string
	jmp $

DISK_READ_ERROR: db "First read error!!", 0
DISK_ERROR_MSG: db "Disk read Error!", 0