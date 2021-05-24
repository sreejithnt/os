[bits 16]
; switch to protected mode

switch_to_pm:
	cli				; switch off all interrupts, until the switch is complete


	lgdt [gdt_descriptor]	; load global descriptor table, which defines
							; the protected mode segments

	mov eax, cr0			; to make the switch set the first bit of
	or eax, 0x1				; control register (again can be done only)
	mov cr0, eax			; indirectly

	jmp CODE_SEG:init_pm	; make a far jump
							; to clear any pre-fetched instructions, or decode
							; cycles due to pipeline execution

[bits 32]
; Initialize the registers and stack in protected mode

init_pm:
	mov ax, DATA_SEG		; in PM re-define the old segments to point to 
	mov ds, ax				; data segment in gdt
	mov ss, ax				; in PM segment registers will be indexes to gdt
	mov es, ax				; here all are initialized to data_segment in gdt
	mov fs, ax
	mov gs, ax

	mov ebp, 0x90000
	mov esp, ebp

	call BEGIN_PM


